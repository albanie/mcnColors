// @file vl_rgb2hsv.cu
// @brief RGB to HSV color space conversion
// @author Samuel Albanie
/*
Copyright (C) 2017 Samuel Albanie

All rights reserved.

This file is part of the VLFeat library and is made available under
the terms of the BSD license (see the COPYING file).
*/

#include <bits/mexutils.h>
#include <bits/datamex.hpp>
#include "bits/rgb2hsv.hpp"

#if ENABLE_GPU
#include <bits/datacu.hpp>
#endif

#include <assert.h>
#include <algorithm>

/* option codes */
enum {
  opt_reverse = 0,
  opt_verbose,
} ;

/* options */
VLMXOption  options [] = {
  {"Reverse",          1,   opt_reverse      },
  {"Verbose",          0,   opt_verbose      },
  {0,                  0,   0                }
} ;

/* ---------------------------------------------------------------- */
/*                                                          Context */
/* ---------------------------------------------------------------- */

vl::MexContext context ;

/*
 Resetting the context here resolves a crash when MATLAB quits and
 the ~Context function is implicitly called on unloading the MEX file.
 */
void atExit()
{
  context.clear() ;
}

/* ---------------------------------------------------------------- */
/*                                                       MEX driver */
/* ---------------------------------------------------------------- */

enum {
  IN_DATA = 0,IN_DEROUTPUT, IN_END
} ;

enum {
  OUT_RESULT = 0, OUT_END
} ;

void mexFunction(int nout, mxArray *out[],
                 int nin, mxArray const *in[])
{
  int verbosity = 0 ;
  int opt ;
  bool reverse = false ;
  int next = IN_END ;
  mxArray const *optarg ;

  /* -------------------------------------------------------------- */
  /*                                            Check the arguments */
  /* -------------------------------------------------------------- */

  mexAtExit(atExit) ;

  if (nin < 1) {
    vlmxError(VLMXE_IllegalArgument, "Not enough input arguments.") ;
  }
  // backwards mode is not supported
  next = 1 ;

  while ((opt = vlmxNextOption (in, nin, options, &next, &optarg)) >= 0) {
    switch (opt) {
      case opt_verbose : {
        ++ verbosity ;
        break ;
      }
      case opt_reverse : {
        if (!vlmxIsOfClass(optarg, mxLOGICAL_CLASS)) {
          vlmxError(VLMXE_IllegalArgument, "REVERSE is not a boolean.") ;
        }
        reverse = mxGetPr(optarg)[0] ;
        break ;
      }

      default:
        break ;
    }
  }

  // Load data and create output buffer
  vl::MexTensor data(context) ;
  data.init(in[IN_DATA]) ;
  vl::TensorShape dataShape = data.getShape();
  dataShape.reshape(4) ;

  if (dataShape.getDepth() != 3) {
       mexErrMsgTxt("RGB Input must have 3 channels") ;
  }

  vl::DeviceType deviceType = data.getDeviceType() ;
  vl::DataType dataType = data.getDataType() ;
  vl::MexTensor output(context) ;
  output.initWithZeros(deviceType, dataType, dataShape) ;

  if (verbosity > 0) {
    mexPrintf("vl_rgb2hsv: forward; %s", 
                (data.getDeviceType()==vl::VLDT_GPU) ? "GPU" : "CPU") ;
    vl::print("vl_rgb2hsv: output: ", output) ;
  }

  /* -------------------------------------------------------------- */
  /*                                                    Do the work */
  /* -------------------------------------------------------------- */

  vl::ErrorCode error ;
  if (!reverse) {
    error = vl::rgb2hsv_forward(context, output, data) ; 
  } else {
    error = vl::hsv2rgb_forward(context, output, data) ; 
  }

  /* -------------------------------------------------------------- */
  /*                                                         Finish */
  /* -------------------------------------------------------------- */

  if (error != vl::VLE_Success) {
    vlmxError(VLMXE_IllegalArgument, context.getLastErrorMessage().c_str()) ;
  }
  out[OUT_RESULT] = output.relinquish() ;
}

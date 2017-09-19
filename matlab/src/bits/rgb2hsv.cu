// @file rgb2hsv.cu
// @brief Multibox Detector block
// @author Samuel Albanie

/*
Copyright (C) 2017- Samuel Albanie.
All rights reserved.

This file is part of the VLFeat library and is made available under
the terms of the BSD license (see the COPYING file).
*/

#include "rgb2hsv.hpp"
#include "impl/rgb2hsv_impl.hpp"

#if ENABLE_GPU
#include <bits/datacu.hpp>
#endif

#include <cstdio>
#include <assert.h>

using namespace vl ;

/* ---------------------------------------------------------------- */
/*                                                  rgb2hsv_forward */
/* ---------------------------------------------------------------- */

#define DISPATCH(deviceType,T) \
error = vl::impl::rgb2hsv<deviceType,T>::forward \
(context, \
(T*) output.getMemory(), \
(T const*) data.getMemory(), \
data.getHeight(), \
 data.getWidth(), \
data.getSize() \
 ) ;

#define DISPATCH2(deviceType) \
switch (dataType) { \
case VLDT_Float : DISPATCH(deviceType, float) ; \
break ; \
IF_DOUBLE(case VLDT_Double : DISPATCH(deviceType, double) ; \
break ;) \
default: assert(false) ; \
return VLE_Unknown ; \
}

vl::ErrorCode
vl::rgb2hsv_forward(vl::Context& context, vl::Tensor output, vl::Tensor data)
{
  vl::ErrorCode error = VLE_Success ;
  vl::DataType dataType = output.getDataType() ;
  
  switch (output.getDeviceType())
  {
    case vl::VLDT_CPU:
      DISPATCH2(vl::VLDT_CPU) ;
      break ;

#if ENABLE_GPU
    case vl::VLDT_GPU:
      DISPATCH2(vl::VLDT_GPU) ;
    if (error == VLE_Cuda) {
      context.setError(context.getCudaHelper().catchCudaError("GPU")) ;
    }
    break;
#endif

    default:
      assert(false);
      error = vl::VLE_Unknown ;
      break ;
  }
  return context.passError(error, __func__);
}

/* ---------------------------------------------------------------- */
/*                                                  hsv2rgb_forward */
/* ---------------------------------------------------------------- */

#define DISPATCH(deviceType,T) \
error = vl::impl::hsv2rgb<deviceType,T>::forward \
(context, \
(T*) output.getMemory(), \
(T const*) data.getMemory(), \
data.getHeight(), \
 data.getWidth(), \
data.getSize() \
 ) ;

#define DISPATCH2(deviceType) \
switch (dataType) { \
case VLDT_Float : DISPATCH(deviceType, float) ; \
break ; \
IF_DOUBLE(case VLDT_Double : DISPATCH(deviceType, double) ; \
break ;) \
default: assert(false) ; \
return VLE_Unknown ; \
}

vl::ErrorCode
vl::hsv2rgb_forward(vl::Context& context, vl::Tensor output, vl::Tensor data)
{
  vl::ErrorCode error = VLE_Success ;
  vl::DataType dataType = output.getDataType() ;
  
  switch (output.getDeviceType())
  {
    case vl::VLDT_CPU:
      DISPATCH2(vl::VLDT_CPU) ;
      break ;

#if ENABLE_GPU
    case vl::VLDT_GPU:
      DISPATCH2(vl::VLDT_GPU) ;
    if (error == VLE_Cuda) {
      context.setError(context.getCudaHelper().catchCudaError("GPU")) ;
    }
    break;
#endif

    default:
      assert(false);
      error = vl::VLE_Unknown ;
      break ;
  }
  return context.passError(error, __func__);
}

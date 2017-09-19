// @file rgb2hsv_gpu.cu
// @brief RGB2HSV 
// @author Samuel Albanie

/*
Copyright (C) 2017- Samuel Albanie.
All rights reserved.

This file is part of the VLFeat library and is made available under
the terms of the BSD license (see the COPYING file).
*/

#include "rgb2hsv_impl.hpp"
#include <bits/datacu.hpp>
#include <bits/mexutils.h>
#include <bits/data.hpp>
#include <assert.h>
#include <float.h>
#include <cstdio>
#include <math.h>
#include <string.h>

/* ------------------------------------------------------------ */
/*                                                      kernels */
/* ------------------------------------------------------------ */

template<typename T> __global__ void
rgb2hsv_kernel(T* output,
              const T* data,
              const int volume,
              bool* valid_range, 
              const int height,
              const int width,
              const int size)
{
  int hsvIndex = threadIdx.x + blockIdx.x * blockDim.x;
  if (hsvIndex < volume) {
    int depth = 3 ; // RGB input
    int area = height * width ;
    int s = hsvIndex % area ;  // spatial offset
    int b = hsvIndex / (area * depth) ; // batch element
    int rIdx = (b * area * 3) + s ;
    int gIdx = rIdx + area ;
    int bIdx = rIdx + 2 * area ;
    int c = (hsvIndex / area) % depth ;

    T R = data[rIdx] ;
    T G = data[gIdx] ;
    T B = data[bIdx] ;

    // check input ranges
    bool valid_R_range = R <= 1 && R >= 0 ;
    bool valid_G_range = G <= 1 && G >= 0 ;
    bool valid_B_range = B <= 1 && B >= 0 ;
    if (!(valid_R_range && valid_G_range && valid_B_range)) {
      valid_range[0] = 1 ;
     }
   
    T out ;
    T maxRGB = max(R, max(G, B)) ;
    T minRGB = min(R, min(G, B)) ;
    T delta = maxRGB - minRGB ;
    switch (c) { // H, S or V output
      case 0: // Compute hue
        out = data[rIdx] ;
        if (R == maxRGB) {
          out = (G - B) / delta ;
        } else if (G == maxRGB) {
          out = 2 + ( B - R ) / delta ;
        } else { // B max
          out = 4 + ( R - G ) / delta ;
        } 
        out = out / 6 ; // use [0,1], rather than 360 degrees
        if (out < 0) {
          out = out + 1 ; 
        }
        break ;
      case 1: // compute saturation
        if (maxRGB == 0) {
          out = 0 ; // follow matlab convention
        } else {
          out = delta / maxRGB ;
        }
        break ;
      case 2: // compute value
        out = maxRGB ; // store value
        break ;
    }
    output[hsvIndex] = out ;
  }
}



namespace vl { namespace impl {

/* ------------------------------------------------------------ */
/*                                                      rgb2hsv */
/* ------------------------------------------------------------ */

    template<typename T>
    struct rgb2hsv<vl::VLDT_GPU,T>
    {

    static vl::ErrorCode
    forward(Context& context, 
            T* output, 
            T const* data,
            size_t height, 
            size_t width, 
            size_t size) 
{    
    int volume = height * width * 3 * size ;

    // set flag for input checking
    bool* valid_range ;
    cudaMalloc( (void **) &valid_range, sizeof(bool)) ;
    cudaMemset(valid_range, 0, sizeof(bool)) ; // init to zero

    rgb2hsv_kernel<T><<< vl::divideAndRoundUp(volume, 
      VL_CUDA_NUM_THREADS), VL_CUDA_NUM_THREADS >>>(output, data, 
        volume, valid_range, height, width, size) ;

    bool* h_valid_range = new bool[1] ;
    cudaMemcpy(h_valid_range, valid_range, sizeof(bool), cudaMemcpyDeviceToHost) ;
    cudaError_t status = cudaPeekAtLastError() ;
    // TODO: clean up error handling here
    // currently the input validation is done on the device to prevent a speed 
    // overhead, but requires a slightly ungainlly use of error codes.
    if ((status != cudaSuccess) || (h_valid_range[0] != 0)) {
        if (h_valid_range[0] != 0) {
          mexPrintf("invalid RGB input values (must lie in [0,1]) \n") ;
        }
        return vl::VLE_Cuda ;
    } else {
      return vl::VLE_Success ;
    }
   }
 } ;

/* ------------------------------------------------------------ */
/*                                                      hsv2rgb */
/* ------------------------------------------------------------ */

    template<typename T>
    struct hsv2rgb<vl::VLDT_GPU,T>
    {

    static vl::ErrorCode
    forward(Context& context, 
            T* output, 
            T const* data,
            size_t height, 
            size_t width, 
            size_t size) 
{    
    int volume = height * width * 3 * size ;

    // set flag for input checking
    bool* valid_range ;
    cudaMalloc( (void **) &valid_range, sizeof(bool)) ;
    cudaMemset(valid_range, 0, sizeof(bool)) ; // init to zero

    rgb2hsv_kernel<T><<< vl::divideAndRoundUp(volume, 
      VL_CUDA_NUM_THREADS), VL_CUDA_NUM_THREADS >>>(output, data, 
        volume, valid_range, height, width, size) ;

    bool* h_valid_range = new bool[1] ;
    cudaMemcpy(h_valid_range, valid_range, sizeof(bool), cudaMemcpyDeviceToHost) ;
    cudaError_t status = cudaPeekAtLastError() ;
    // TODO: clean up error handling here
    // currently the input validation is done on the device to prevent a speed 
    // overhead, but requires a slightly ungainlly use of error codes.
    if ((status != cudaSuccess) || (h_valid_range[0] != 0)) {
        if (h_valid_range[0] != 0) {
          mexPrintf("invalid RGB input values (must lie in [0,1]) \n") ;
        }
        return vl::VLE_Cuda ;
    } else {
      return vl::VLE_Success ;
    }
   }
 } ;
} } // namespace vl::impl

template struct vl::impl::rgb2hsv<vl::VLDT_GPU, float> ;
template struct vl::impl::hsv2rgb<vl::VLDT_GPU, float> ;

#ifdef ENABLE_DOUBLE
template struct vl::impl::rgb2hsv<vl::VLDT_GPU, double> ;
template struct vl::impl::hsv2rgb<vl::VLDT_GPU, double> ;
#endif

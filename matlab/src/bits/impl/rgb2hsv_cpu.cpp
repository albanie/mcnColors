// @file rgb2hsv_cpu.cu
// @brief RGB2HSV
// @author Samuel Albanie
//
// This implementation is based on the Illinois Robotics notes here:
// http://coecsl.ece.illinois.edu/ge423/spring05/group8/finalproject/hsv_writeup.pdf

/*
Copyright (C) 2017- Andrea Vedaldi.
All rights reserved.

This file is part of the VLFeat library and is made available under
the terms of the BSD license (see the COPYING file).
*/

#include "rgb2hsv_impl.hpp"
#include <bits/data.hpp>
#include <assert.h>
#include <float.h>
#include <cstdio>
#include <algorithm>
#include <math.h>
#include <string.h>

#include <map>
#include <vector>

namespace vl { namespace impl {

  template<typename T>
  struct rgb2hsv<vl::VLDT_CPU,T>
  {

    static vl::ErrorCode
    forward(Context& context, 
            T* output, 
            T const* data,
            size_t height, 
            size_t width, 
            size_t size) 
    {
      int depth = 3 ; // RGB input arrays
      // loop over spatial indices and batch items
      for (int bb = 0 ; bb < size ; ++bb) {
        for (int jj = 0 ; jj < width ; ++jj) {
          for (int ii = 0 ; ii < height ; ++ii) {
            int RH_offset = ii + height * (jj + width * (depth * bb)) ;
            int GS_offset = ii + height * (jj + width * (1 + (depth * bb))) ;
            int BV_offset = ii + height * (jj + width * (2 + (depth * bb))) ;
            T R = data[RH_offset] ;
            T G = data[GS_offset] ;
            T B = data[BV_offset] ;
            T max = std::max({R, G, B}) ; // compute HSV Value 
            T min = std::min({R, G, B}) ; // compute HSV Value 
            assert(min >= 0 && "invalid input RGB value (must lie in [0,1])") ;
            assert(max <= 0 && "invalid input RGB value (must lie in [0,1])") ;
            T delta = max - min ;
            T hue ; 
            T sat ; 
            T val = max ;
            if (max == 0) {
              sat = 0 ; 
              hue = 0 ;
            } else {
              sat = delta / max ;
              if (R == max) {
                hue = (G - B) / delta ;
              } else if (G == max) {
                hue = 2 + ( B - R ) / delta ;
              } else { // B max
                hue = 4 + ( R - G ) / delta ;
              } 
              hue = hue / 6 ; // use [0,1], rather than 360 degrees
              if (hue < 0) {
                hue = hue + 1 ; 
              }
            }
            output[RH_offset] = hue ;
            output[GS_offset] = sat ;
            output[BV_offset] = val ;
          }
        }
      }
      return VLE_Success ;
   }
 } ;

  template<typename T>
  struct hsv2rgb<vl::VLDT_CPU,T>
  {

    static vl::ErrorCode
    forward(Context& context, 
            T* output, 
            T const* data,
            size_t height, 
            size_t width, 
            size_t size) 
    {
      int depth = 3 ; // RGB input arrays
      // loop over spatial indices and batch items
      for (int bb = 0 ; bb < size ; ++bb) {
        for (int jj = 0 ; jj < width ; ++jj) {
          for (int ii = 0 ; ii < height ; ++ii) {
            int RH_offset = ii + height * (jj + width * (depth * bb)) ;
            int GS_offset = ii + height * (jj + width * (1 + (depth * bb))) ;
            int BV_offset = ii + height * (jj + width * (2 + (depth * bb))) ;
            T R = data[RH_offset] ;
            T G = data[GS_offset] ;
            T B = data[BV_offset] ;
            T max = std::max({R, G, B}) ; // compute HSV Value 
            T min = std::min({R, G, B}) ; // compute HSV Value 
            assert(min >= 0 && "invalid input RGB value (must lie in [0,1])") ;
            assert(max <= 0 && "invalid input RGB value (must lie in [0,1])") ;
            T delta = max - min ;
            T hue ; 
            T sat ; 
            T val = max ;
            if (max == 0) {
              sat = 0 ; 
              hue = 0 ;
            } else {
              sat = delta / max ;
              if (R == max) {
                hue = (G - B) / delta ;
              } else if (G == max) {
                hue = 2 + ( B - R ) / delta ;
              } else { // B max
                hue = 4 + ( R - G ) / delta ;
              } 
              hue = hue / 6 ; // use [0,1], rather than 360 degrees
              if (hue < 0) {
                hue = hue + 1 ; 
              }
            }
            output[RH_offset] = hue ;
            output[GS_offset] = sat ;
            output[BV_offset] = val ;
          }
        }
      }
      return VLE_Success ;
   }
 } ;
} } // namespace vl::impl

template struct vl::impl::rgb2hsv<vl::VLDT_CPU, float> ;
template struct vl::impl::hsv2rgb<vl::VLDT_CPU, float> ;

#ifdef ENABLE_DOUBLE
template struct vl::impl::rgb2hsv<vl::VLDT_CPU, double> ;
template struct vl::impl::hsv2rgb<vl::VLDT_CPU, double> ;
#endif

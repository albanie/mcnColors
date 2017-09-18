// @file rgb2hsv.hpp
// @brief RGB2HSV
// @author Samuel Albanie

/*
Copyright (C) 2017 Samuel Albanie.
All rights reserved.

This file is part of the VLFeat library and is made available under
the terms of the BSD license (see the COPYING file).
*/

#ifndef VL_RGB2HSV_H
#define VL_RGB2HSV_H

#include <bits/data.hpp>
#include <cstddef>

// defines the dispatcher for CUDA kernels:
namespace vl { namespace impl {

  template<vl::DeviceType dev, typename T>
  struct rgb2hsv {

    static vl::ErrorCode
    forward(Context& context, 
            T* output, 
            T const* data,
            size_t height, 
            size_t width, 
            size_t size) ;
  } ;

} }

#endif /* defined(VL_RGB2HSV_H) */

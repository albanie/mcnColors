// @file rgb2hsv.hpp
// @author Samuel Albanie
/*
Copyright (C) 2017 Samuel Albanie.
All rights reserved.

This file is part of the VLFeat library and is made available under
the terms of the BSD license (see the COPYING file).
*/

#ifndef __vl__rgb2hsv__
#define __vl__rgb2hsv__

#include <bits/data.hpp>
#include <stdio.h>

namespace vl {

  vl::ErrorCode
  rgb2hsv_forward(vl::Context& context, vl::Tensor output, vl::Tensor data) ;

  vl::ErrorCode
  hsv2rgb_forward(vl::Context& context, vl::Tensor output, vl::Tensor data) ;
}

#endif /* defined(__vl__rgb2hsv__) */

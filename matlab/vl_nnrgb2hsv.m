% VL_NNRGB2HSV Color space conversion.
%   Y = VL_NNRGB2HSV(X) converts a tensor of RGB images
%   of shape H x W x 3 x N and converts them to the HSV color space.
%   Each RGB value should lie in [0,1].  Following the convention used
%   in the native `rgb2hsv` MATLAB function, elements in the output
%   HSV space are also normalised to lie in [0,1].
%
% Copyright (C) 2017 Samuel Albanie 
% Licensed under The MIT License [see LICENSE.md for details]

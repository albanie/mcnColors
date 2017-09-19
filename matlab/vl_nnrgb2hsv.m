% VL_NNRGB2HSV Color space conversion.
%   Y = VL_NNRGB2HSV(X) converts a tensor of RGB images
%   of shape H x W x 3 x N and converts them to the HSV color space.
%   Each RGB value should lie in [0,1].  Following the convention used
%   in the native `rgb2hsv` MATLAB function, elements in the output
%   HSV space are also normalised to lie in [0,1].
%
%   VL_NNRGB2HSV(..., 'option', value, ...) accepts the following
%   options:
%
%   `reverse`:: false
%    The reverse flag will transform inputs in the direction i.e. from HSV
%    space to RGB space.
%
%   Notes
%   ---
%   The algorithm used to convert an RGB (with values R, G and B) at a given 
%   spatial index in the input image to corresponding values H, S and V at the 
%   same spatial index of the output image is as follows:
%
%   Define maxRGB := max(R,G,B)
%   Define minRGB := min(R,G,B)
%   Define delta := maxRGB - minRGB
%         |-  0                           if maxRGB = 0
%   H' := |-  (G - B) / delta             if maxRGB = R
%         |-  2 + (B - R) / delta         if maxRGB = G
%         |-  4 + (B - R) / delta         if maxRGB = B
%   H := (H' / 6) % 1.0                     
%
%   S := |-  0                           if maxRGB = 0
%        |-  delta / maxRGB              if maxRGB = R
%   V := delta
%
%   Here we follow the MATLAB convention of mapping H to zero for 0 input
%   images (although mathematically this value is undefined, it is more 
%   convenient to do this in practice).  We also produce H values in [0,1],
%   rather than [0,360] which is sometimes used as an alternative outupt space.
%   The use of the % (modulo) operator usage is a slight abuse of notation 
%   since the value H' is not an integer - here it performs the floating point 
%   analogue of this function (i.e. it maps into [0,1])
%
% Copyright (C) 2017 Samuel Albanie 
% Licensed under The MIT License [see LICENSE.md for details]

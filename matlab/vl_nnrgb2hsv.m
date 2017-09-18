% VL_NNRGB2HSV Color space conversion.
%   Y = VL_NNRGB2HSV(X) TODO(write docs)
%  EXPECTS [R,G,B] values to lie in [0,1].  Returns 
% [H,S,V] values in [0,360], [0,1], [0,1]
%
% We take the HSV equivalent of zero tensor RGB image to also be a
% zero tensor. Though, perhaps the hue should be undefined here (we 
% are essentially taking 0/0 = 0)

function demo_rgb2hsv(varargin)
%DEMO_RGB2HSV demonstrate a color space transformation
%   DEMO_RGB2HSV(VARARGIN) compute a color space transformations
%   with `vl_rgb2hsv`.
%
%   DEMO_RGB2HSV(..., 'option', value, ...) accepts the following
%   options:
%
%   `gpus`:: 1
%    Device on which to run network 
%
% Copyright (C) 2017 Samuel Albanie
% Licensed under The MIT License [see LICENSE.md for details]

  opts.gpus = 1 ;
  opts = vl_argparse(opts, varargin) ;

  % First, to enable comparison with the native rgb2hsv function, we must 
  % use a batch size of 1:
  batchSize = 1 ;
  x = rand(500,500,3,batchSize) ;
  if numel(opts.gpus), x = gpuArray(x) ; end
  tic ;
  y1 = rgb2hsv(x) ;
  cpuTime = toc ;

  tic 
  y2 = vl_rgb2hsv(x) ;
  gpuTime = toc ;

  diff = abs(y2 - y1) ;
  fprintf('difference: %g\n', sum(diff(:))) ;

  % print comparison on single image
  fprintf('native CPU rgb2hsv: %g\n', cpuTime) ;
  fprintf('GPU vl_rgb2hsv: %g\n', gpuTime) ;

  % large batch sizes are also supported
  batchSize = 5 ;
  x = rand(500,500,3,batchSize) ;
  tic 
  y3 = vl_rgb2hsv(x) ; %#ok
  gpuBatchTime = toc ;
  fprintf('GPU vl_rgb2hsv: %g\n', gpuBatchTime) ;

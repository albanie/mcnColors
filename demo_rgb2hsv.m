function demo_rgb2hsv(varargin)
%DEMO_RGB2HSV demonstrate a color space transformation

  opts.gpus = 1 ;
  opts = vl_argparse(opts, varargin) ;

  x = rand(500,500,3,1) ;
  if numel(opts.gpus), x = gpuArray(x) ; end
  tic ;
  y1 = rgb2hsv(x) ;
  cpuTime = toc ;

  tic 
  y2 = vl_rgb2hsv(x) ;
  gpuTime = toc ;

  diff = abs(y2 - y1) ;
  fprintf('difference: %g\n', sum(diff(:))) ;

  fprintf('native CPU rgb2hsv: %g\n', cpuTime) ;
  fprintf('GPU vl_rgb2hsv: %g\n', gpuTime) ;

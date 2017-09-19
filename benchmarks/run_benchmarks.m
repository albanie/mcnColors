function run_benchmarks(varargin)
%RUN_BENCHMARKS simple timing comparisons for color space transformations
%   RUN_BENCHMARKS(VARARGIN) performs some timed runs for the `vl_rgb2hsv`
%   function.
%
%   RUN_BENCHMARKS(..., 'option', value, ...) accepts the following
%   options:
%
%   `gpus`:: 1
%    Device on which to run network 
%
% Copyright (C) 2017 Samuel Albanie
% Licensed under The MIT License [see LICENSE.md for details]

  opts.gpus = 1 ;
  opts.imSz = 600 ;
  opts.repeats = 10 ;
  opts = vl_argparse(opts, varargin) ;

  mTimes = zeros(1, opts.repeats) ;
  mcnTimes = zeros(1, opts.repeats) ;

  batchSize = [1 10 20] ;
  for bb = batchSize
    for ii = 1:opts.repeats
      x = rand(500,500,3,bb) ;
      if numel(opts.gpus), x = gpuArray(x) ; end

      % "factor out" the effect of the for loop code
      if bb > 1
        bTimes = zeros(1, bb) ;
        for jj = 1:bb
          x_ = x(:,:,:,jj) ; 
          tic ; rgb2hsv(x_) ; bTimes(jj) = toc ;
        end
        mTimes(ii) = sum(bTimes) ;
      else
        tic ; rgb2hsv(x) ; mTimes(ii) = toc ;
      end

      tic ; vl_rgb2hsv(x) ; mcnTimes(ii) = toc ;
    end

    inSize = [opts.imSz([1 1]) 3 bb] ;
    fprintf('Statistics from %d runs\n', opts.repeats) ;
    fprintf('input image tensor size: [%d x %d x %d x %d]\n', inSize) ;
    fprintf('rgb2hsv: %f (+/-%f)\n', mean(mTimes), std(mTimes)) ;
    fprintf('vl_rgb2hsv: %f (+/-%f)\n', mean(mcnTimes), std(mcnTimes)) ;
  end

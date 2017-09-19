function run_benchmarks(varargin)
%RUN_BENCHMARKS simple timing comparisons for color space transformations
%   RUN_BENCHMARKS(VARARGIN) performs some timed runs for the `vl_rgb2hsv`
%   function.
%
%   RUN_BENCHMARKS(..., 'option', value, ...) accepts the following
%   options:
%
%   `gpus`:: 1
%    Device(s) on which to run the comparison.
%
%   `imSz`:: 600
%    Width of the square image used for testing. 
%
%   `repeats`:: 10
%    Number of times to repeat the benchmark for consistency. 
%
%   `native`:: rgb2hsv
%    Native color transformation function to be used as a baseline. 
%
%   `mcnFunc`:: vl_rgb2hsv
%    Color transformation function to be tested. 
%
%   `includeRTimes`:: false
%    Include a timing that uses reshaping, rather than a for-loop to 
%    benchmark the native function on multiple image instances. 
%
% Copyright (C) 2017 Samuel Albanie
% Licensed under The MIT License [see LICENSE.md for details]

  opts.gpus = 1 ;
  opts.imSz = 600 ;
  opts.repeats = 10 ;
  opts.native = @rgb2hsv ;
  opts.mcnFunc = @vl_rgb2hsv ;
  opts.includeRTimes = false ;
  opts = vl_argparse(opts, varargin) ;

  mTimes = zeros(1, opts.repeats) ; % for loop approach
  mcnTimes = zeros(1, opts.repeats) ;
  if opts.includeRTimes, mRTimes= zeros(1, opts.repeats) ; end

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

      if opts.includeRTimes
        % to get an optimistic timing comparison, ignore the cost of reshaping
        % and permuting and assume that the following reshape is done correctly
        x_ = reshape(x, [], 3) ;
        tic ; rgb2hsv(x_) ; mRTimes(ii) = toc ;
      end

      tic ; vl_rgb2hsv(x) ; mcnTimes(ii) = toc ;
    end

    inSize = [opts.imSz([1 1]) 3 bb] ;
    funcName = func2str(opts.native) ; mcnFuncName = func2str(opts.mcnFunc) ;
    fprintf('Statistics from %d runs\n', opts.repeats) ;
    fprintf('input image tensor size: [%d x %d x %d x %d]\n', inSize) ;
    fprintf('%s: %f (+/-%f)\n', funcName, mean(mTimes), std(mTimes)) ;
    if opts.includeRTimes
      fprintf('%s (reshaped): %f (+/-%f)\n', funcName, mean(mRTimes), std(mRTimes)) ;
    end
    fprintf('%s: %f (+/-%f)\n', mcnFuncName, mean(mcnTimes), std(mcnTimes)) ;
  end

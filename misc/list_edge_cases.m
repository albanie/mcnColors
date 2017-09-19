function list_edge_cases(varargin) 
% Determine the values of MATLAB builtin functions in undefined 
% regions (this allows the re-implementation of each function to 
% be consistent with the original).
%
% Copyright (C) 2017 Samuel Albanie
% Licensed under The MIT License [see LICENSE.md for details]

  opts.func = @hsv2rgb ;
  opts.local = @(x) vl_rgb2hsv(x, 'reverse', true) ;
  opts = vl_argparse(opts, varargin) ;

  x = zeros(1, 1, 3) ;
  name = func2str(opts.func) ;
  lname = func2str(opts.local) ;
  for rr = 0:0.5:1
    for gg = 0:0.5:1
      for bb = 0:0.5:1
        x_ = x ;
        x_(1) = rr ; x_(2) = gg ; x_(3) = bb ;
        out = opts.func(x_) ;
        local = opts.local(x_) ;
        if any(out ~= local)
          fprintf('%s: [%g,%g,%g] -> [%g,%g,%g]\n', name, squeeze(x_)', out) ;
          fprintf('%s: [%g,%g,%g] -> [%g,%g,%g]\n', lname, squeeze(x_)', local) ;
        end
      end
    end
  end

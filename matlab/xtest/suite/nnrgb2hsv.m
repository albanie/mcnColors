classdef nnrgb2hsv < nntest
  methods (Test)

    function basic(test)
      sz = [50,50,3,1] ;
      x = test.rand(sz) ;
      x = x / max(x(:)) ; % [0,1]
      official = rgb2hsv(x) ;
      y = vl_rgb2hsv(x) ;
      maxDiff = max(abs(official(:) - y(:))) ;
      %diffs = official - y ;
      assert(maxDiff < 1e-6) ;
    end

    function batched(test)
      sz = [50,50,3,3] ;
      x = test.rand(sz) ;
      x = x / max(x(:)) ; % [0,1]
      y = vl_rgb2hsv(x) ;

      % split inputs to enable checking with official matlab function
      y1 = rgb2hsv(x(:,:,:,1)) ;
      y2 = rgb2hsv(x(:,:,:,2)) ;
      y3 = rgb2hsv(x(:,:,:,3)) ;
      official = cat(4, y1, y2, y3) ;
      maxDiff = max(abs(official(:) - y(:))) ;
      assert(maxDiff < 1e-6) ;
    end
  end
end

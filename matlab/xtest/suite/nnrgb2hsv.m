classdef nnrgb2hsv < nntest
  methods (Test)

    function basic(test)
      sz = [50,50,3,1] ;
      x = test.rand(sz) ;
      x = x / max(x(:)) ; % [0,1]
      official = rgb2hsv(x) ;
      y = vl_rgb2hsv(x) ;
      maxDiff = max(abs(official(:) - y(:))) ;
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

    function basicZeros(test)
      sz = [50,50,3,1] ;
      x = test.zeros(sz) ;
      official = rgb2hsv(x) ;
      y = vl_rgb2hsv(x) ;
      maxDiff = max(abs(official(:) - y(:))) ;
      assert(maxDiff < 1e-6) ;
    end

    function basicOnes(test)
      sz = [50,50,3,1] ;
      x = test.ones(sz) ;
      official = rgb2hsv(x) ;
      y = vl_rgb2hsv(x) ;
      maxDiff = max(abs(official(:) - y(:))) ;
      assert(maxDiff < 1e-6) ;
    end

    function basicReverse(test)
      sz = [2,2,3,1] ;
      x = test.rand(sz) ;
      x = x / max(x(:)) ; % [0,1]
      official = hsv2rgb(x) ;
      y = vl_rgb2hsv(x, 'reverse', true) ;
      maxDiff = max(abs(official(:) - y(:))) ;
      assert(maxDiff < 1e-6) ;
    end

    function batchedReverse(test)
      sz = [50,50,3,3] ;
      x = test.rand(sz) ;
      x = x / max(x(:)) ; % [0,1]
      y = vl_rgb2hsv(x, 'reverse', true) ;

      % split inputs to enable checking with official matlab function
      y1 = hsv2rgb(x(:,:,:,1)) ;
      y2 = hsv2rgb(x(:,:,:,2)) ;
      y3 = hsv2rgb(x(:,:,:,3)) ;
      official = cat(4, y1, y2, y3) ;
      maxDiff = max(abs(official(:) - y(:))) ;
      assert(maxDiff < 1e-6) ;
    end

    function basicReverseZeros(test)
      sz = [50,50,3,1] ;
      x = test.zeros(sz) ;
      official = hsv2rgb(x) ;
      y = vl_rgb2hsv(x, 'reverse', true) ;
      maxDiff = max(abs(official(:) - y(:))) ;
      assert(maxDiff < 1e-6) ;
    end

    function basicReverseOnes(test)
      sz = [50,50,3,1] ;
      x = test.ones(sz) ;
      official = hsv2rgb(x) ;
      y = vl_rgb2hsv(x, 'reverse', true) ;
      maxDiff = max(abs(official(:) - y(:))) ;
      assert(maxDiff < 1e-6) ;
    end

  end
end

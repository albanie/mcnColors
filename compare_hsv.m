rng(0) ;

x = rand(4,3,3,1) ;
x = gpuArray(x) ;
tic ;
y1 = rgb2hsv(x) ;
toc 

tic 
y2 = vl_rgb2hsv(x) ;
toc

%diff = abs(y2 - y1) ;
%fprintf('difference: %g\n', mean(diff(:))) ;

x = gather(x) ;
disp(y2 - y1) ;

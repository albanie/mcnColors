### mcnColors

This directory contains efficient GPU implementations for color space transformations, designed to interface directly with MatConvNet. Each transformation is supported on batches of images (as four dimensional tensors).  

### Supported transformations

* **rgb2hsv**
* **hsv2rgb**

### Installation

The easiest way to use this module is to install it with the `vl_contrib` package manager, with the following three commands from the root directory of your MatConvNet installation:

```
vl_contrib('install', 'mcnColors') ;
vl_contrib('compile', 'mcnColors') ;
vl_contrib('setup', 'mcnColors') ;
vl_contrib('test', 'mcnColors') ; % optional
```

### Benchmarks

To give some idea of the difference in runtime, the results of simple benchmarks are given below:

```
RGB -> HSV

input image tensor size: [600 x 600 x 3 x 1]
rgb2hsv: 0.013987 (+/-0.010826)
vl_rgb2hsv: 0.000563 (+/-0.000565)

input image tensor size: [600 x 600 x 3 x 10]
rgb2hsv: 0.058536 (+/-0.007658)
vl_rgb2hsv: 0.002646 (+/-0.000284)

input image tensor size: [600 x 600 x 3 x 20]
rgb2hsv: 0.106723 (+/-0.002173)
vl_rgb2hsv: 0.005040 (+/-0.000364)

HSV -> RGB

input image tensor size: [600 x 600 x 3 x 1]
hsv2rgb: 0.012722 (+/-0.007372)
@(x)vl_rgb2hsv(x,'reverse',true): 0.000469 (+/-0.000380)

input image tensor size: [600 x 600 x 3 x 10]
hsv2rgb: 0.061080 (+/-0.005071)
@(x)vl_rgb2hsv(x,'reverse',true): 0.002647 (+/-0.000319)

input image tensor size: [600 x 600 x 3 x 20]
hsv2rgb: 0.100495 (+/-0.004921)
@(x)vl_rgb2hsv(x,'reverse',true): 0.005024 (+/-0.000355)

```

The timings above are given in seconds.  The comparison across larger batch sizes is perhaps unfair, (sizes `10` and `20` are used above) since the matlab `rgb2hsv` function is only designed to operate on a 3D tensor, and therefore requires a for-loop (although this cost has been factored out of the benchmark). An alternative approach is to use reshape/permute operations, but in practice this tends to be significantly slower.

### Notes

If you are working with MATLAB on the CPU, the native `rgb2hsv` function is reasonable.  This repo also contains a simple cpp CPU implementation for each transformation, but it is not optimised for efficiency and in cases when the CPU is to be used, the native matlab function is preferable. 

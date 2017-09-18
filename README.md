### mcnColors

This directory contains efficient GPU implementations for color space transformations, designed to interface directly with MatConvNet. Each transformation is supported on batches of images (as four dimensional tensors).  

### Supported transformations

* **rgb2hsv**

### Installation

The easiest way to use this module is to install it with the `vl_contrib` package manager, with the following three commands from the root directory of your MatConvNet installation:

```
vl_contrib('install', 'mcnColors') ;
vl_contrib('compile', 'mcnColors') ;
vl_contrib('setup', 'mcnColors') ;
vl_contrib('test', 'mcnColors') ; % optional
```

### Notes

If you are working with MATLAB on the CPU, the native `rgb2hsv` function is reasonable.  This repo also contains a simple cpp CPU implementation for each transformation, but it is not optimised for efficiency and in cases when the CPU is to be used, the native matlab function is preferable. 

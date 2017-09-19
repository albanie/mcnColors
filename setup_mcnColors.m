function setup_mcnColors()
%SETUP_MCNCOLORS Sets up mcnColors, by adding its folders 
% to the Matlab path
%
% Copyright (C) 2017 Samuel Albanie
% Licensed under The MIT License [see LICENSE.md for details]

  root = fileparts(mfilename('fullpath')) ;
  addpath(root, [root '/matlab'], [root '/misc']) ;
  addpath( [root '/matlab/mex'], [root '/benchmarks']) ;

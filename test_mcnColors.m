function test_mcnColors
% --------------------------------
% run tests for Colors module
% --------------------------------

% add tests to path
addpath(fullfile(fileparts(mfilename('fullpath')), 'matlab/xtest')) ;
addpath(fullfile(vl_rootnn, 'matlab/xtest/suite')) ;

% test network layers
run_colors_test('command', 'nn') ;

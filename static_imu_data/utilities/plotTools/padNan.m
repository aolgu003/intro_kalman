function out = padNan(data,length)
% Pad array with Nan'z
% 
% out = padNan(data,length)
% 
% Parameters:
%   data:   input mxn array
%   length: length of output array
% 
% Return values:
%   out:    output array
% 
% Reference:
% 

%  Author(s): P.F. Roysdon 10-05-2015
%  Revised: P.F. Roysdon 10-05-2015
%  email: software@aidednav.com
%  Website: http://www.aidednav.com
%  Copyright 2015 Aided Nav
%  $Revision: 0.0.29 $  $Date: 2015/10/05 10:08:15
% 
%  This program carries no warranty, not even the implied
%  warranty of merchantability or fitness for a particular purpose.
%
%  Please email bug reports or suggestions for improvements to:
%  software@aidednav.com

[m,n] = size(data);
out = NaN(length,n);
out(1:m,:) = data;
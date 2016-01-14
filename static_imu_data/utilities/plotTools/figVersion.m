function out = figVersion()
% Reply with matlab version, for figure handle properties.
%
% Syntax:
%   [out] = figVersion()
%
% Description:
%     Reply with matlab version, for figure handle properties.
% 
% Parameters:
% 
% Return values:
%   out:	matlab version
%
%  Other m-files required: none
%  Subfunctions: none
%  MAT-files required: none
%
%  See also:

%  Author(s): P.F. Roysdon 10-05-2015
%  Revised: P.F. Roysdon 10-05-2015
%  email: software@aidednav.com
%  Website: http://www.aidednav.com
%  Copyright 2015 Aided Nav
%  $Revision: 0.0.29 $  $Date: 2015/10/05 10:08:15

%  This program carries no warranty, not even the implied
%  warranty of merchantability or fitness for a particular purpose.
%
%  Please email bug reports or suggestions for improvements to:
%  software@aidednav.com


% Matlab Version
ver = regexp(version('-date'),', ','split'); 
out = str2double(ver{1,2});
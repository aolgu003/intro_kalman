function h = incFig(varargin)
% Increment the figure number and return the figure handle.
% 
% Syntax:  
%   incFig(varargin)
% 
% Description: 
%  This function will increment the figure number and pass the figure 
%  handle back as an output of the function call. this is useful when 
%  making several plots.
% 
% Parameters:
%   varargin:    - figInit - (true/false) specify the initial fig inc
%                - figName - to sepcify the figure name.
%                - figNumber - 'on', 'off'
% 
% Return Values:
%     h:        figure handle
% 
% Reference:  
% 
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none

% Author(s): P.F. Roysdon 10-05-2015
% Revised: P.F. Roysdon 10-05-2015
% email: software@aidednav.com
% Website: http://www.aidednav.com
% Copyright 2015 Aided Nav
% $Revision: 0.0.29 $  $Date: 2015/10/05 10:08:15
% 
% This program carries no warranty, not even the implied 
% warranty of merchantability or fitness for a particular purpose.  
% 
% Please email bug reports or suggestions for improvements to:
% software@aidednav.com


if nargin<3
    figNumber = 'on';
else
    figNumber = varargin{3};
end
if nargin<2
    figName = '';
else
    figName = varargin{2};
end
if nargin<1
    figInit = 0;
else
    figInit = varargin{1};
end

if (figVersion>2014)
    if figInit
        h = figure(1);clf;
    else
        hfig = gcf;
        h = figure(hfig.Number+1);clf;
    end
    set(h,'Name',figName,'NumberTitle',figNumber);
else
    if figInit
        h = figure(1);clf;
    else
        h = figure(gcf+1,figName);clf;
    end
    set(h,'Name',figName,'NumberTitle',figNumber);
end
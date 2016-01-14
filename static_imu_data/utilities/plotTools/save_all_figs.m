function save_all_figs(varargin)
% Saves all open figure windows to Matlab fig files
%
% Syntax:
%   save_all_figs   
%       saves figures to 'Figure_1.fig', 'Figure_2.fig', etc.
%
%   save_all_figs('Test')
%       saves figures to 'Test_Figure_1.fig', 'Test_Figure_2.fig', etc.
% 
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
% 
% See also:

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


if (nargin==1)
    if (ischar(varargin{1}))
        prefix = strcat(varargin{1}, '_');
    else
        error('Input argument must be a string')
    end
elseif (nargin==0)
    prefix = '';
else
    error('Too many input arguments - Zero or one input arguments allowed')
end

figs = sort(get(0, 'Children'));
for i = 1:length(figs)
    fig_no = figs(i);
    figure(fig_no)
    hgsave(sprintf('%sFigure_%d', prefix, fig_no.Number))
end

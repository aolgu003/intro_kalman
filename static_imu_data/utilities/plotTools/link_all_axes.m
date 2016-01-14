function out = link_all_axes()
% Links all open figures so x&y axes zoom/pan together.
% 
% Syntax:  
%   link_all_axes()
% 
% Description: 
%  Links all axes so the x axes zoom and pan together on all open figures
%  Note: it messes up any 3d plots but works great on things like test data
%  where all of the figures have the same x axis data (e.g., time)
% 
% Parameters:
% 
% Return Values:
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


% initialize the output.
out = 0;

% fig check, if greater than 1, dock all figures.
if (figVersion>2014)
    hfig = gcf;
    if (hfig.Number>0); 
        link_fig_axes;
        out = 1;
    end
else
    if (gcf>0); 
        link_fig_axes;
        out = 1;
    end
end
  
function link_fig_axes

linkaxes(findobj(0,'Type','Axes','-not','Tag','legend'),'x')

end


end

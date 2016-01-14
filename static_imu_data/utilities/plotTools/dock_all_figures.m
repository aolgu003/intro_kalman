function out = dock_all_figures()
% dock all figures into one window
% 
% Syntax:  
%   dock_all_figures()
% 
% Description:
%  Puts all existing figure windows in a figure group 'container' window. 
%  Use after creating a group of figure windows.  This will keep all
%  of the individual figure windows docked in the figure group window and
%  you can set the size of all figures by sizing the figure group window.
%  This also allows you to minimize all figures at once and all figures are
%  in one OS window which makes it easier to navigate between all open OS
%  windows, with Alt-Tab, for instance (perhaps the most useful reason for
%  using this feature).
% 
% Parameters:
% 
% Return Values:
%     out:  output flag
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
    if (hfig.Number>1); 
        dock_figs;
        figure(1);
        out = 1;
    end
else
    if (gcf>1); 
        dock_figs;
        figure(1);
        out = 1;
    end
end
  
function dock_figs
    % This section puts all figures into the figure group container window
    last_fig_no=length(get(0, 'Children'));

    for fig_no=1:last_fig_no
        figure(fig_no)
        set(gcf, 'WindowStyle', 'docked')
    end
    clear last_fig_no fig_no

    % This section sets the size of the figure group container window
    % Yair Altman replied on September 24th, 2007 at 3:37 pm : 
    % 
    % Here’s an undocumented/unsupported hack to programmatically resize the
    % figures group container. It works on Matlab 7.4 (R2007a) - no guaranty it
    % will continue working in future versions:

    desktop=com.mathworks.mde.desk.MLDesktop.getInstance;
    drawnow;
    desktop.setGroupDocked('Figures',false); 
    drawnow
    container=desktop.getGroupContainer('Figures').getTopLevelAncestor;
    width = 1500;
    height = 1100;
    container.setSize(width,height);

    % You can also do the following useful actions:
    % container.setAlwaysOnTop(1); % or 0 to return to normal
    % container.setMaximized(1); % or 0 to return to normal
    % container.setMinimized(1); % or 0 to return to normal
    % container.setVisible(1); % or 0 to hide - ignore the java error…
    % container.methodsview; % show full list of possible actions 

    clear container desktop height width
end

end

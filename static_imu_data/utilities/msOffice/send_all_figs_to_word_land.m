function send_all_figs_to_word_land(varargin)
% Send all open figures to Word Doc in landscape mode
% 
% Description:
% Sends all open figures to a Word document with page orientation set to
% landscape.  The figure windows are not resized before sending to the
% Word document.
% 
% Syntax:
%   [] = send_all_figs_to_word_land(varargin)
% 
% Parameters:
%   varargin:   filename
% 
% Return values:
%   none
% 
% See also:  send_all_figs_to_word, open_word, send_to_word, close_word

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

if ~isempty(varargin)
    filename = varargin{1};
end

last_fig_no=length(get(0, 'Children'));
if (~exist('filename', 'var'))
    [hWord, filespec, hOpendoc] = open_word();
else
    [hWord, filespec, hOpendoc] = open_word(filename);
end
set(hOpendoc.PageSetup, 'Orientation', 'wdOrientLandscape')
for fig_no=1:last_fig_no
    figure(fig_no)
    send_to_word(hWord, 'noresize')
end
close_word(hWord, filespec, hOpendoc)
clear last_fig_no fig_no hWord filespec hOpendoc

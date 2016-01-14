function send_to_word(hWord, varargin)
% Send current figure/model to a Word document
%
% Description:
% Function used to send the current figure or model to a Word document
% opened with the open_word function.
% 
% Syntax:
%   [] = send_to_word(hWord, varargin)
% 
% Parameters:
%   hWord:      is the ActiveX object handle for the Word 
%               application (returned by open_word)
%   varargin:   'noresize' is an optional argument which prevents this
%               function from resizing the figure before sending it to the
%            	Word document.
% 
% Return values:
% 
% See also:  send_all_figs_to_word, open_word, send_to_word, close_word
% 
% See open_word.m for acknowledgements and other info (including possible
% enhancements).

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

%    set(gcf, 'Position', [335 335 665 465]); % size that seems to work well
if (nargin<1)
    help send_to_word
    error('send_to_word:No_hword', 'Must specify ActiveX handle to Word.')
elseif (nargin == 1)
    set(gcf, 'Position', [81 141 919 659]); % size that seems to work well
elseif (nargin > 2 || ~strcmpi(varargin(1), 'noresize'))
    error('send_to_word:Invalid_Args', ...
        'Only one optional argument allowed and it must be equal to ''noresize''')
end

% Capture current figure/model into clipboard
print -dmeta

% Find end of document and make it the insertion point
end_of_doc = get(hWord.activedocument.content, 'end');
set(hWord.application.selection,'Start', end_of_doc);
set(hWord.application.selection,'End', end_of_doc);

% Paste the contents of the Clipboard
invoke(hWord.Selection,'Paste');

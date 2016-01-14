function close_word(hWord, filespec, hOpendoc)
% Close Active X connection to Word
%
% Function to close ActiveX connections to Word application and the open
% document (opened with the open_word function).
%
% [] = close_word(hWord, filespec, hOpendoc)
% 
% Parameters:
%   hWord:       is the ActiveX object handle for the Word app
%   filespec:    is the filename and path for the output doc
%   hOpendoc:    is the ActiveX object handle for the output doc
% 
% Return values:
%   none
% 
% Note: 
%	all of the input parameters to this function are returned by the
%	open_word function.
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

if ~exist(filespec,'file')
    % Save file as new
    invoke(hOpendoc,'SaveAs',filespec,1);
else
    % Save existing file
    invoke(hOpendoc,'Save');
end

% Close the document window
invoke(hOpendoc,'Close');

% Quit MS Word
invoke(hWord,'Quit');

% Terminate ActiveX connection
delete(hWord);


function [hWord, filespec, hOpendoc] = open_word(filespec)
% Open ActiveX session with Word
%
% Open ActiveX session with Word for writing plots to a document using
% the send_to_word function.  
%
%   [hWord, filespec, hOpendoc] = open_word([filename]);
% 
% Parameters:
%   filespec:       is the optional input argument containing a full or 
%                   partial filespec for the output file.
%                   If not present, a file open dialog will prompt
%                   the user for an existing or new output file.
% 
% Return values:
%	hWord:          is the ActiveX object handle for the Word app
%   filespec:       is the filename and path for the output document
%   hOpendoc:       is the object handle for the output document
% 
%   This function was inspired by the 'save2word' function from the
%   Mathworks file exchange. The reason for splitting the 'save2word'
%   function into separate functions was to allow writing many figures
%   to Word in a loop without repeatedly opening and closing the Word
%   Active X connection and the output file.
%
%   Based on 'save2word' from Mathworks File Exchange by Suresh E Joel,
%   Virginia Commonwealth University.  Modification of 'saveppt' in
%   Mathworks File Exchange and valuable suggestions by Mark W. Brown,
%   mwbrown@ieee.org.
% 
%   Possible enhancements:
%       1)  Combine open_word, send_to_word, and close_word into one
%           function using options and/or variable input arguments so only
%           one m-file needs to be maintained.
%       2)  Add capability to pass optional arguments which specify figure
%           window or Simulink model to send to Word (as in 'save2word').
%       3)  Enhance exception handling.
%       4)  Is there a way to avoid returning filespec from open_word and
%           passing it to close_word; is there a property of hWord or
%           hOpendoc that contains the filespec?

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

% Establish valid file name
if nargin<1 | isempty(filespec);
    [fname, fpath] = uiputfile('*.doc', ...
        'Select Existing File (for Append) or Enter New File Name');
    if fpath == 0
        error('No file selected/entered or unable to open file')
    end     % better exception handling?
    filespec = fullfile(fpath, fname);
else
    [fpath,fname,fext] = fileparts(filespec);
    if isempty(fpath); fpath = pwd; end
    if isempty(fext); fext = '.doc'; end
    filespec = fullfile(fpath, [fname, fext]);
end

% Start an ActiveX session with Word
hWord = actxserver('Word.Application');
%hWord.Visible = 1;  % uncomment for debugging to make sure session starts

% Get object handle for output document
if ~exist(filespec, 'file');
    % Create new document
    hOpendoc = invoke(hWord.Documents, 'Add');
else
    % Open existing document
    hOpendoc = invoke(hWord.Documents, 'Open', filespec);
end

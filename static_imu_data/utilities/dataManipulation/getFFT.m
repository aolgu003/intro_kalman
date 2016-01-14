function [domFreq,domFreqMag] = getFFT(t,sig,txt)
% Compute and plot the FFT for a given signal;
% 
% Description:
% This function finds the dominant frequency and magnitude for a given
% signal and time series  
% 
% Syntax:
%   [domFreq,domFreqMag] = getFFT(t,sig,txt)
% 
% Parameters:
%   t:          mx1 time array
%   sig:        mx1 signal array
%   txt:        text to display on the plot title
% 
% Return values:
%   domFreq:    dominant frequency
%   domFreqMag: dominant frequency magnitude
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


% Get rid of empty or nan lines
nn = 0;
for i = 1:length(t)
    if isnan(t(i)) || isnan(sig(i)) || isempty(t(i)) || isempty(sig(i))
    else
        nn = nn+1;
        t_filtered(nn) = t(i);
        sig_filtered(nn) = sig(i);
    end   
end

Fs = 1/mean(diff(t_filtered)); % Sampling frequency
L = length(t_filtered); % Length of signal

NFFT = 2^nextpow2(L); % Next power of 2 from length of Signal
Y = fft(sig_filtered,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2);

%single-sided amplitude as function of frequency
SSA = 2*abs(Y(1:NFFT/2));

%Find the dominant frequency and magitude
domFreqMag = max(SSA);
Dom_Freq_ndx = find(SSA == max(SSA),1,'first');
domFreq = f(Dom_Freq_ndx);

% Plot single-sided amplitude spectrum.
figure
plot(f,SSA) 
title([txt ': Single-Sided Amplitude Spectrum of Signal(t_{filtered})'])
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')

end
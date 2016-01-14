% Load and plot IMU realtime data.
% 
% Syntax:  
%  eval_imu_data()
% 
% Description: 
%  This file will enable the user to load a specific IMU data file, plot
%  the data contained in the file and perform an FFT on the data.
%  Additional functions like "dock_all_figures" will place all Matlab
%  figures into one window, and "link_all_axes" will link all plot axes,
%  e.g. when one plot is "zoomed", all plots "zoom" to the same span of
%  time.  A save file is also provided to save all figures in their current
%  state (zoomed or not) into a Word .doc for later reference.
% 
% Parameters:
% 
% Return Values:
% 
% Reference:


% Initialize variables
% ----------------------------------------------------------%
close all; clearvars; clearvars -global; clc;
addpath(genpath('utilities'))

% global settings
% ----------------------------------------------------------%
savePlots  = 1; % (yes/no)
plotFFT    = 1; % (yes/no)
rmStart    = 10; % seconds to remove from start of test
rmEnd      = 10; % seconds to remove from end of test

% load the data
% ----------------------------------------------------------%
[FileName,PathName] = uigetfile('*_raw.mat');
load([PathName,FileName]);

% remove the ends
%----------------------------------------------------------%
data.t  = data.t(rmStart*data.datarate+1:end-rmEnd*data.datarate,1);
data.ax = data.ax(rmStart*data.datarate+1:end-rmEnd*data.datarate,1);
data.ay = data.ay(rmStart*data.datarate+1:end-rmEnd*data.datarate,1);
data.az = data.az(rmStart*data.datarate+1:end-rmEnd*data.datarate,1);
data.gx = data.gx(rmStart*data.datarate+1:end-rmEnd*data.datarate,1);
data.gy = data.gy(rmStart*data.datarate+1:end-rmEnd*data.datarate,1);
data.gz = data.gz(rmStart*data.datarate+1:end-rmEnd*data.datarate,1);

% plot
%----------------------------------------------------------%
fprintf(1,'Plotting results.\n');
% plot raw data
raw_data = [data.ax,data.ay,data.az,data.gx,data.gy,data.gz];
raw_txt = { 'accel x [m/s^2]','accel y [m/s^2]','accel z [m/s^2]',...
        'gyro x [deg/s]','gyro y [deg/s]','gyro z [deg/s]'};
raw_titStr = [data.name ' IMU realizations (blue)'];
Fig = 1;
for i = 1:length(raw_txt)
    figure(Fig)
    plot(data.t(:,1),raw_data(:,i))
    ylabel(sprintf('%s',char(raw_txt(i)) ));
    title(raw_titStr);
    xlabel('time, t [sec]');
    Fig = Fig+1;
end
pause
% FFT
%----------------------------------------------------------%
if plotFFT
    fprintf(1,'Computing and plotting FFT.\n');
    [data.ax_Dom_Freq,data.ax_Dom_Freq_Mag] = getFFT(data.t,data.ax,'Accel-x'); h(1) = gcf;
    [data.ay_Dom_Freq,data.ay_Dom_Freq_Mag] = getFFT(data.t,data.ay,'Accel-y'); h(2) = gcf;
    [data.az_Dom_Freq,data.az_Dom_Freq_Mag] = getFFT(data.t,data.az,'Accel-z'); h(3) = gcf;
    [data.gx_Dom_Freq,data.gx_Dom_Freq_Mag] = getFFT(data.t,data.gx,'Gyro-x'); h(4) = gcf;
    [data.gy_Dom_Freq,data.gy_Dom_Freq_Mag] = getFFT(data.t,data.gy,'Gyro-y'); h(5) = gcf;
    [data.gz_Dom_Freq,data.gz_Dom_Freq_Mag] = getFFT(data.t,data.gz,'Gyro-z'); h(6) = gcf;
    for i=1:6; figure(h(i)); ylim([0 0.5]); end
end
pause
% clean-up & save
%----------------------------------------------------------%
dock_all_figures;
figure(1);
if ~plotFFT
    link_all_axes;
end
if savePlots
    fprintf(1,'Saving Results.\n');
    send_all_figs_to_word([data.name '_results']);
end
function [u]=SimpleKF_IMU_data()
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

tic
% Initialize variables
% ----------------------------------------------------------%
close all; clearvars; clearvars -global; 
addpath(genpath('utilities'))

% global settings
% ----------------------------------------------------------%
savePlots  = 1; % (yes/no)
plotFFT    = 0; % (yes/no)

toc_start = toc
% get the IMU data u and create the measurement data y with period Ty
Ty  = 30.0;
[u,tu,Tu,N,y,ty,L] = LoadIMUData(Ty);

% create the discrete time model
[Phi, Qd] = create_model(Tu);
H = [1,0,0];
R = (0.00001)^2 % m, This is variation in position due to vibration. 

toc_filter_start = toc
% implement the filter
a = zeros(1,N);
x = zeros(3,N); % preallocaate memory while initializing state: p, v, b
P = diag([0,0,0.1^2]);
Ps = zeros(4,N); % preallocate space for saving time and the diagonal of P
r  = zeros(L);  % preallocate space for residual
S  = zeros(L);  % preallocate space for covariance of residual
iy = 1;
for iu = 2:N,   %  integration
    % integrate the navigation state
    a(iu)   = u(iu-1) + x(3,iu-1);
    x(3,iu) = x(3,iu-1);
    x(2,iu) = x(2,iu-1) + a(iu)*Tu;
    x(1,iu)  = x(1,iu-1) + x(2,iu-1)*Tu + 0.5*a(iu)*Tu*Tu;
    
    % time propagate the covariance
    P = Phi*P*Phi' + Qd;
    Ps(:,iu) = [tu(iu);diag(P)];
    
    % at the measurement times, implement Kalman filter
    if iy<=L,
        if abs(tu(iu) - ty(iy)) < Tu/2,
            y  = 0;             % measured position
            yh = x(1,iu);       % position measurement
            r(iy)  = y - yh;    % residual
            S(iy)  = H*P*H' + R;% covariance of r
            A  = P*H';          % Save to reuse
            K  = A/(S(iy));         % Kalman gain
            x(:,iu) = x(:,iu) + K*r(iy);     % overwrite prior value
            P  = P - K*(A');             % Posterior covariance
            Ps(:,iu) = [tu(iu);diag(P)]; % overwrite prior value
            iy = iy+1;            
        elseif tu(iu) > ty(iy)
            [iu,iy,tu(iu), ty(iy)]
            error('time indices are misconfigured')
        end % if abs(...)
    end % if iy < = L
end % for iu
toc_filter_end = toc

% plot the results
ind = ceil(N - 10/Tu):N;
figure(1);clf;
subplot(321)
sig_p = sqrt(Ps(2,:));
plot(tu,x(1,:),'b.',Ps(1,:),sig_p,'k',Ps(1,:),-sig_p,'k');grid;axis('tight')
xlabel('Time, t, sec');
ylabel('Position, p, meters')

subplot(322)
plot(tu(ind),x(1,ind),'b.',Ps(1,ind),sig_p(ind),'k',Ps(1,ind),-sig_p(ind),'k');grid;axis('tight')
xlabel('Time, t, sec');
ylabel('Position, p, meters')

subplot(323)
sig_v = sqrt(Ps(3,:));
plot(tu,x(2,:),'.b',Ps(1,:),sig_v,'k',Ps(1,:),-sig_v,'k'); grid;axis('tight')
xlabel('Time, t, sec');
ylabel('Velocity, v, m/s')

subplot(324)
plot(tu(ind),x(2,ind),'b.',Ps(1,ind),sig_v(ind),'k',Ps(1,ind),-sig_v(ind),'k');grid;axis('tight')
xlabel('Time, t, sec');
ylabel('Velocity, v, meters')

subplot(325)
sig_b = sqrt(Ps(4,:));
bf    = x(3,N);
plot(tu,x(3,:)-bf,'.b',Ps(1,:),sig_b,'k',Ps(1,:),-sig_b,'k'); grid;axis('tight')
xlabel('Time, t, sec');
ylabel('Bias error, b, m/s/s')

subplot(326)
plot(tu(ind),x(3,ind)-bf,'b.',Ps(1,ind),sig_b(ind),'k',Ps(1,ind),-sig_b(ind),'k');grid;axis('tight')
xlabel('Time, t, sec');
ylabel('Bias error, b, meters')

%%%%%%%%%%%%%%%%%
figure(2);clf
subplot(221)
sig_r = sqrt(S);
plot(ty, r, 'b.', ty, sig_r, 'k', ty, -sig_r, 'k');grid;axis('tight')
xlabel('Time, t, sec');
ylabel('Residual, meters')

subplot(222)
[num,bin]=hist(r(10:L),10);
plot(bin,num/(L-9));grid;
title('Residual Histogram')

subplot(223)
plot(ty,r./sig_r,'b.');grid;axis('tight')
xlabel('Time, t, sec');
ylabel('Residual, normalized')

subplot(224)
[num,bin]=hist(r./sig_r,10);
plot(bin,num/L);grid;
title('Residual Histogram')
title('Residual, normalized')

%%%%%%%%%%%%%
figure(3)
plot(tu,u);grid;axis('tight')
xlabel('Time, t, s')
ylabel('specific force')


function [Phi, Qd] = create_model(Tu)
% define the discrete time model
% The state vector is x = [p, v, b]'.
% The error state model is \dot{dx} = F*dx + G1*w + G2*n
% The accelerometer model is u = a + b + n, where PSD(n) = Qn
% The model for the bias is \dot{b} = -lambda*b + w, where PSD(w)=Qw
lambda = 0.001; % reciprocal of correlation time, 1/s



F = [ 0 1 0
      0 0 1
      0 0 -lambda];

G = [ 0 0
      0 1
      1 0];
  
% See example 4.19 in Aided Navigation (p. 140)  
% Pb = (2e-2)^2;  
% Qw = Pb*2*lambda  % (m/s^2)^2/s
Qw = 8.0e-6;  
Qn = 4.4e-7;  % (m/s)^2/s
Q = diag([Qw,Qn]);

% See section 4.7.2.1 in "Aided Navigation"
C = [-F   G*Q*G'
     0*F  F'] * Tu;
U =expm(C);

Phi = U(4:6,4:6)'
Qd  = Phi*U(1:3,4:6)
  


function [u,tu,Tu,N,y,ty,L] = LoadIMUData(Ts)
% load the data from the first accelerometer into the variable u with N data
% elements.  Also save the time vector tu starting at 0, with N data
% elements indicating the measurement times for the elements of u.
% 
% Also create a vector of measurements with value zero of length L occuring
% at times ty with approximate samle rate Ts. 
% ----------------------------------------------------------%
[FileName,PathName] = uigetfile('*_raw.mat');
load([PathName,FileName]);

% See the readme file
rmStart    = 10; % seconds to remove from start of test
rmEnd      = 10; % seconds to remove from end of test

% remove the ends
%----------------------------------------------------------%
data.t  = data.t(rmStart*data.datarate+1:end-rmEnd*data.datarate,1);
data.ax = data.ax(rmStart*data.datarate+1:end-rmEnd*data.datarate,1);
data.ay = data.ay(rmStart*data.datarate+1:end-rmEnd*data.datarate,1);
data.az = data.az(rmStart*data.datarate+1:end-rmEnd*data.datarate,1);
data.gx = data.gx(rmStart*data.datarate+1:end-rmEnd*data.datarate,1);
data.gy = data.gy(rmStart*data.datarate+1:end-rmEnd*data.datarate,1);
data.gz = data.gz(rmStart*data.datarate+1:end-rmEnd*data.datarate,1);

u = data.ax;

tu = data.t - data.t(1);
if length(u)==length(tu)
    N=length(u);
else
    error('vector length mismatch while loading u and t')
end

Tu  = median(diff(tu)); % u sample period
ty = Ts:Ts:tu(N);       % desired sample times for y. No meas at t=0.
n=length(ty);
i=1;
j=1;

toc_while = toc
while tu(i)< ty(n);  % ensure y measurement times match a tu time
    if abs(tu(i)-ty(j))<Tu/2,
        ty(j) = tu(i);
        j=j+1;
        i = floor(Ts/Tu) - 3; % skip to near the next measurement time
        if j>n, 
            break
        end
    end
    i=i+1;
end
toc_end_loop = toc
    
y = 0*ty; % create measurement vector
L= length(ty);



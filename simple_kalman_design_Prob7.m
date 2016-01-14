function simple_kalman_design_Prob7
data = load('static_imu_data/data/epson_20150331_230142_1_raw');
H = [1 0 0];
R = (1e-5)^2;
lambda = .001;
Qw = 8e-6;
Qn = 4.4e-7;
Fs = data.data.datarate;
utilde = data.data.ax;
Tk = 1;
P = diag([0 0 (7.2e-2)^2]);

F = [0 1 0; 0 0 1; 0 0 -lambda];
G = [0 0; 0 1; 1 0];
Q = [Qw 0; 0 Qn];
Z = zeros([3 3]);

E = [-F G*Q*G'; Z F'].*(1/Fs);
Y = expm(E);
phi = Y(4:6, 4:6)';
Qd = phi*Y(1:3, 4:6);

i = 1;
x = [0; 0; 0];

x_vec = zeros([3 size(utilde)]);
state_std = zeros([3 size(utilde)]);
residuals = zeros([1 ceil(length(utilde)/Tk)]);

time = data.data.t;
j = 1;
for t = time' 
    x = dead_reckoning(x, utilde(i), 1/Fs);
    P = time_update(phi, P, Qd);

    if mod(t, Tk) == 0 && t ~= 0
        [P, x, r] = measurement_update(P, H, x, R, utilde(i));
        residuals(j) = r;
        j = j + 1;
    end
    
    x_vec(:,i) = x;
    state_std(:,i) = sqrt(diag(P));
    i=i+1;
end

figure(1)
subplot(4,1,1)
plot(data.data.t, utilde)
title('Accelerometer measurements vs Time')

subplot(4, 1, 2)
plot(data.data.t, x_vec(1,:))
title('Position estimates vs Time')

subplot(4, 1, 3)
plot(data.data.t, x_vec(2,:))
title('Velocity estimate')

subplot(4, 1, 4)
plot(data.data.t, x_vec(3,:))
title('Bias estimate')

figure(2)
subplot(3,1,1)
plot(data.data.t, state_std(1,:))
title('STD of Position Error')

subplot(3, 1, 2)
plot(data.data.t, state_std(2,:))
title('STD of Velocity Error')

subplot(3, 1, 3)
plot(data.data.t, state_std(3,:))
title('STD of Bias Error')

figure(3)
plot(time, residuals)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Support Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ x_update ] = dead_reckoning( xhat, utilde, T )
%UNTITLED Integrates the sensor values
%   Detailed explanation goes here

phat_update = xhat(1) + T*xhat(2); 
vhat_update = xhat(2) + T*(utilde + xhat(3));
bhat_update = xhat(3);

x_update = [phat_update; vhat_update; bhat_update];

function [P] = time_update(phi, P, Qd)
P = phi*P*phi' + Qd;

function [Pk, xk, r] = measurement_update(Pk, H, xhat, R, y)
yhat = H*xhat;
r = 0 - yhat;
Sk = H*Pk*H' + R;
K = Pk*H'*inv(Sk);
xk = xhat + K*-r;
Pk = (eye([3 3]) - K*H) * Pk;
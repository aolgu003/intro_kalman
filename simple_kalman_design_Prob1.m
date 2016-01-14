function simple_kalman_design_Prob1

T = .01; %Time step
time = 0:T:3;

x = [0; 0; 2]; % initial state: [pos; vel; bias]

x_vec = zeros([3 length(0:T:3)]);
i = 1;

utilde = zeros([1 length(0:T:3)]);
for t = time
    [x_new] = dead_reckoning(x, utilde(i), T);
    x_vec(:,i) = x_new;
    x = x_new;
%     u = accel_meass(i);
    i = i + 1;
end

subplot(4,1,1)
plot(time, utilde)
title('Accelerometer measurements vs Time')

subplot(4, 1, 2)
plot(time, x_vec(1,:))
title('Position estimates vs Time')

subplot(4, 1, 3)
plot(time, x_vec(2,:))
title('Velocity estimate')

subplot(4, 1, 4)
plot(time, x_vec(3,:))
title('Bias estimate')

function [ x_update ] = dead_reckoning( xhat, utilde, T )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

phat_update = xhat(1) + T*xhat(2); 
vhat_update = xhat(2) + T*utilde + T*xhat(3);
bhat_update = xhat(3);

x_update = [phat_update; vhat_update; bhat_update];
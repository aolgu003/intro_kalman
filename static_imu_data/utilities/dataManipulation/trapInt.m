function v = trapInt(a,dt)
% Compute Trapezoidal Integration for a given signal
% 
% Description:
% Compute the Trapezoidal Integration for a given signal based on the 
% formula  v = \sum_{t1}^{t2} 0.5*(a_i + a_i+1)*dt
% 
% Syntax:
%   v = trapInt(a,dt)
% 
% Parameters:
%   a:      mx1 signal array
%   dt:     delta time (seconds)
% 
% Return values:
%   v:      integrated signal
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

k = length(a);
v = zeros(k,1);
for j = 2:k
    v(j,1) = v(j-1,1)+0.5*(a(j-1,1)+a(j,1))*dt;
end
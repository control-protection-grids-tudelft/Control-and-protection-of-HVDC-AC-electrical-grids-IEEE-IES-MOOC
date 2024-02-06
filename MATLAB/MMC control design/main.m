%close all
clc
clear all

global occ ccc zcc power energy dc

occ = true;
ccc = true;
zcc = true;
power = true;
energy = true;
dc = false;

% input
global w Vgd Vgq Vdc_ref
global Id Iq

global Pac_ref Qac_ref

% element values
global N Carm Rarm Larm Rf Lf
global Reqac Leqac
global Cdc

N = 50;
Carm = 10e-3;
Rarm = 1.07;
Larm = 50e-3;
Rf = 0.5350;
Lf = 60e-3;
Reqac = Rf + Rarm/2;
Leqac = Lf + Larm/2;

Cdc = 6 * Carm / N;

f = 50;
w = 2*pi*f;

% operating point
% Pac = -100.25e6;
% Qac = 0;
% Pdc = -100.218e6;
% Vm = 336e3;
% theta = -0.05376;
Pac = 100e6;
Qac = 0;
Pdc = 100e6;
Vm = 100e3;
theta = 0;

Pac_ref = Pac;
Qac_ref = Qac;

Vgd = Vm*cos(theta);
Vgq = -Vm*sin(theta);
Vdc_ref = 200e3;

Id = 2/3*(Pac*Vgd + Qac*Vgq)/(Vgd^2+Vgq^2);
Iq = 2/3*(Pac*Vgq - Qac*Vgd)/(Vgd^2+Vgq^2);
num_var = 12;

if power
    global Kp_Pac Ki_Pac Kp_Qac Ki_Qac % active and reactive power control
    
    Kp_Pac = 0.1 * Id/Pac;
    Kp_Qac = Kp_Pac;
    Ki_Pac = 50 * Id/Pac;
    Ki_Qac = Ki_Pac;
    
    num_var = num_var+2;
end
if occ
    global Kp_Delta Ki_Delta % output current control
    
    if (~power) && (~dc)
        global iDeltad_ref iDeltaq_ref
        iDeltad_ref = Id;
        iDeltaq_ref = Iq;
    end
    
    zeta = 0.7;
    w0_occ = 1000;                                                              % bandwidth of the controller
    Ki_Delta = Leqac*w0_occ^2;                                                  % tuned using pole placement
    Kp_Delta = 2*zeta*sqrt(Ki_Delta * Leqac) - Reqac;                           % tuned using pole placement
    num_var = num_var+2;
end
if energy
    global Kp_wSigma Ki_wSigma % energy controller
    global wSigmaz_ref
    
    Kp_wSigma = 120;                                                            % tuning
    Ki_wSigma = 400;                                                            % 90% slower than idc control
    
    wSigmaz_ref = 3*(Carm * Vdc_ref^2)/ N;
    num_var = num_var+2;
end
if zcc
    global Kp_Sigmaz Ki_Sigmaz % zero current control
    global iSigmaz_ref
    
    w0_ccc = 300;
    zeta = 0.7;
    Ki_Sigmaz = Larm*w0_ccc^2;                                                   % tuned using pole placement
    Kp_Sigmaz = 2*zeta*sqrt(Ki_Sigmaz * Larm) - Rarm;                             % tuned using pole placement
    
    if (~energy)
        iSigmaz_ref = 3*Vgd*Id/6/Vdc_ref;
        num_var = num_var+1;
    end
end
if ccc
    global Kp_Sigma Ki_Sigma % circulating current control
    global iSigmad_ref iSigmaq_ref
    
    w0_ccc = 300;                                                               % bandwidth of the controller
    Ki_Sigma = Larm*w0_ccc^2;                                                   % tuned using pole placement
    Kp_Sigma = 2*zeta*sqrt(Ki_Sigma * Larm) - Rarm;                             % tuned using pole placement
    
    iSigmad_ref = 0;
    iSigmaq_ref = 0;
    num_var = num_var+2;
end
if dc
    global Pdc_ref
    global Kp_vdc Ki_vdc
    
%         Kp_vdc = 1e-5;
%         Ki_vdc = 4e-6;
    Kp_vdc = 0.01;
    Ki_vdc = 2;
    Pdc_ref = Pdc;
    num_var = num_var + 2;
else
    Vdc = Vdc_ref;
end

% reference values and control

global vMDeltaZd_ref vMDeltaZq_ref
vMDeltaZd_ref = 0;
vMDeltaZq_ref = 0;

x0 = 0.001 * ones(num_var,1); % initial condition
% x0(1) = Id; x0(2) = Iq;
% x0(5) = Pdc/3/Vdc_ref;
% x0(12) = Vdc_ref;
% x0(end-1) = Vdc_ref;
t0 = 0;
C = [];
T0 = 0.5; % stop simulation time

options = odeset('RelTol', 1e-1, 'AbsTol', 1e-2, 'MaxStep', 1e-3);
C1=ode45(@dxdt,[t0 T0],x0);
C=cat(1,C,[(C1.x)',(C1.y)']);

t = C(:,1);
x = C(:,2:13);

figure
subplot(221)
plot(t,x(:,1),'b')
hold on
plot(t, x(:,2),'r')
title('i^\Delta_{dq}')
legend('i^\Delta_d', 'i^\Delta_q')

subplot(222)
plot(t,x(:,3),'b')
hold on
plot(t,x(:,4),'r')
plot(t,x(:,5),'c')
title('i^\Sigma_{dqz}')
legend('i^\Sigma_d', 'i^\Sigma_q', 'i^\Sigma_z')

subplot(223)
plot(t,x(:,6),'b')
hold on
plot(t,x(:,7),'r')
plot(t,x(:,8),'c')
plot(t,x(:,9),'y')
title('v^\Delta_{CdqZ}')
legend('v^\Delta_{Cd}', 'v^\Delta_{Cq}', 'v^\Delta_{CZd}', 'v^\Delta_{CZq}')

subplot(224)
plot(t,x(:,10),'b')
hold on
plot(t,x(:,11),'r')
plot(t,x(:,12),'c')
title('v^\Sigma_{Cdqz}')
legend('v^\Sigma_{Cd}', 'v^\Sigma_{Cq}', 'v^\Sigma_{Cz}')

figure

p = (3/2)*(Vgd*x(:,1) + Vgq*x(:,2));
q = (3/2)*(-Vgd*x(:,2) + Vgq*x(:,1));
subplot(211)
plot(t,p,'b')
title('p')

subplot(212)
plot(t, q, 'b')
title('q')

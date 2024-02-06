function output = sim_jacobian(equilibrium)

global Vdc_ref w Vgd Vgq
global Id Iq

% element values
global N Carm Rarm Larm Rf Lf
global Reqac Leqac
global Cdc
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Retype state variables
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% state variables
syms iDeltad iDeltaq iSigmad iSigmaq iSigmaz vCSigmad vCSigmaq vCSigmaz vCDeltad vCDeltaq vCDeltaZd vCDeltaZq

% inputs
syms Idc_sym Vgd_sym Vgq_sym

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%
% controllers %
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%
global vMDeltaZd_ref vMDeltaZq_ref Pdc_ref
global occ ccc zcc power energy dc

if power
    global Kp_Pac Ki_Pac Kp_Qac Ki_Qac % active and reactive power control
    global Pac_ref Qac_ref 
    
    syms xiPac xiQac
    
    Pac = (3/2)*(Vgd_sym*iDeltad + Vgq_sym*iDeltaq);
    Qac = (3/2)*(-Vgd_sym*iDeltaq + Vgq_sym*iDeltad);
    iDeltad_ref = (Kp_Pac * (Pac_ref - Pac) + Ki_Pac * xiPac);
    iDeltaq_ref = -(Kp_Qac * (Qac_ref - Qac) + Ki_Qac * xiQac);
    
    dxiPac_dt = (Pac_ref - Pac);
    dxiQac_dt = (Qac_ref - Qac);
end 
if dc
    global Kp_vdc Ki_vdc
    
    syms Vdc xiVdc 
   
    Idc=Idc_sym;
    dVdc_dt=(Idc-3*iSigmaz)/Cdc;
    dxiVdc_dt = Vdc_ref - Vdc;
    iDeltad_ref = -(Kp_vdc * (Vdc_ref - Vdc) + Ki_vdc * xiVdc) ; 
    iDeltaq_ref = Iq;
else
    syms Vdc
end
if occ
    global Kp_Delta Ki_Delta % output current control
    
    if (~power) && (~dc)
        global iDeltad_ref iDeltaq_ref 
    end
    syms xiDeltad xiDeltaq
    
    dxiDeltad_dt = (iDeltad_ref -  iDeltad);
    dxiDeltaq_dt = (iDeltaq_ref -  iDeltaq);
    
    vMDeltad_ref = Ki_Delta * xiDeltad + Kp_Delta * (iDeltad_ref -  iDeltad) + w*Leqac*iDeltaq + Vgd_sym;
    vMDeltaq_ref = Ki_Delta * xiDeltaq + Kp_Delta * (iDeltaq_ref -  iDeltaq) - w*Leqac*iDeltad + Vgq_sym;
end
if energy
    global Kp_wSigma Ki_wSigma % energy controller
    global wSigmaz_ref 
    
    syms xwSigmaz
    
    Pac = (3/2)*(Vgd_sym*iDeltad + Vgq_sym*iDeltaq);
    wSigmaz = 3*(Carm * (vCDeltad^2 + vCDeltaq^2 + vCDeltaZd^2 + vCDeltaZq^2 + vCSigmad^2 + vCSigmaq^2 + 2*vCSigmaz^2))/(2*N);
    iSigmaz_ref = (Kp_wSigma * (wSigmaz_ref - wSigmaz) + Ki_wSigma * xwSigmaz + Pac) / 3 / Vdc;
    
    dxwSigmaz_dt = (wSigmaz_ref -  wSigmaz);
end
if zcc
    global Kp_Sigmaz Ki_Sigmaz % zero current control
    
    if (~energy)
        global iSigmaz_ref
    end
    
    syms xiSigmaz 

    dxiSigmaz_dt = (iSigmaz_ref -  iSigmaz);
    vMSigmaz_ref = Vdc/2 - Kp_Sigmaz*(iSigmaz_ref - iSigmaz) - Ki_Sigmaz * xiSigmaz;
else
    vMSigmaz_ref = Vdc/2;
end
if ccc
    global Kp_Sigma Ki_Sigma % circulating current control
    global iSigmad_ref iSigmaq_ref 
    
    syms xiSigmad xiSigmaq 
    
    dxiSigmad_dt = (iSigmad_ref -  iSigmad);
    dxiSigmaq_dt = (iSigmaq_ref -  iSigmaq);
    
    vMSigmad_ref = - Ki_Sigma * xiSigmad - Kp_Sigma * (iSigmad_ref -  iSigmad) + 2*w*Larm*iSigmaq;
    vMSigmaq_ref = - Ki_Sigma * xiSigmaq - Kp_Sigma * (iSigmaq_ref -  iSigmaq) - 2*w*Larm*iSigmad;
end


m = 2/Vdc * [-vMDeltad_ref; -vMDeltaq_ref; -vMDeltaZd_ref; -vMDeltaZq_ref; vMSigmad_ref; vMSigmaq_ref; vMSigmaz_ref];

mDeltad = m(1); mDeltaq = m(2); mDeltaZd = m(3); mDeltaZq = m(4);
mSigmad = m(5); mSigmaq = m(6); mSigmaz = m(7);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%
% Grid currents in SI %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Voltage vMDeltadqz
 
vMDeltad =(mDeltaq*vCSigmaq)/4 - (mDeltad*vCSigmaz)/2 - (mDeltad*vCSigmad)/4 - (mDeltaZd*vCSigmad)/4 + (mDeltaZq*vCSigmaq)/4 - (mSigmad*vCDeltad)/4 - (mSigmaz*vCDeltad)/2 + (mSigmaq*vCDeltaq)/4 - (mSigmad*vCDeltaZd)/4 + (mSigmaq*vCDeltaZq)/4;
vMDeltaq =(mDeltad*vCSigmaq)/4 + (mDeltaq*vCSigmad)/4 - (mDeltaq*vCSigmaz)/2 - (mDeltaZd*vCSigmaq)/4 - (mDeltaZq*vCSigmad)/4 + (mSigmad*vCDeltaq)/4 + (mSigmaq*vCDeltad)/4 - (mSigmaz*vCDeltaq)/2 - (mSigmad*vCDeltaZq)/4 - (mSigmaq*vCDeltaZd)/4;
vMDeltaZd =- (mDeltad*vCSigmad)/4 - (mDeltaq*vCSigmaq)/4 - (mDeltaZd*vCSigmaz)/2 - (mSigmad*vCDeltad)/4 - (mSigmaq*vCDeltaq)/4 - (mSigmaz*vCDeltaZd)/2;
vMDeltaZq =(mDeltad*vCSigmaq)/4 - (mDeltaq*vCSigmad)/4 - (mDeltaZq*vCSigmaz)/2 - (mSigmad*vCDeltaq)/4 + (mSigmaq*vCDeltad)/4 - (mSigmaz*vCDeltaZq)/2;

% AC Current dynamics
 
diDeltad_dt =-(Vgd_sym - vMDeltad + Reqac*iDeltad + Leqac*iDeltaq*w)/Leqac;
diDeltaq_dt =-(Vgq_sym - vMDeltaq + Reqac*iDeltaq - Leqac*iDeltad*w)/Leqac;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%
% Common-mode currents in SI %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
% Modulated Voltage vMSigmadqz
 
vMSigmad =(mDeltad*vCDeltad)/4 - (mDeltaq*vCDeltaq)/4 + (mDeltad*vCDeltaZd)/4 + (mDeltaZd*vCDeltad)/4 + (mDeltaq*vCDeltaZq)/4 + (mDeltaZq*vCDeltaq)/4 + (mSigmad*vCSigmaz)/2 + (mSigmaz*vCSigmad)/2;
vMSigmaq =(mDeltaq*vCDeltaZd)/4 - (mDeltaq*vCDeltad)/4 - (mDeltad*vCDeltaZq)/4 - (mDeltad*vCDeltaq)/4 + (mDeltaZd*vCDeltaq)/4 - (mDeltaZq*vCDeltad)/4 + (mSigmaq*vCSigmaz)/2 + (mSigmaz*vCSigmaq)/2;
vMSigmaz =(mDeltad*vCDeltad)/4 + (mDeltaq*vCDeltaq)/4 + (mDeltaZd*vCDeltaZd)/4 + (mDeltaZq*vCDeltaZq)/4 + (mSigmad*vCSigmad)/4 + (mSigmaq*vCSigmaq)/4 + (mSigmaz*vCSigmaz)/2;
 
% Common-mode Current dynamics
 
diSigmad_dt =-(vMSigmad + Rarm*iSigmad - 2*Larm*iSigmaq*w)/Larm;
diSigmaq_dt =-(vMSigmaq + Rarm*iSigmaq + 2*Larm*iSigmad*w)/Larm;
diSigmaz_dt =-(vMSigmaz - Vdc/2 + Rarm*iSigmaz)/Larm;
 
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%
% vC SIGMA in SI %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
dvCSigmad_dt =(N*(iSigmad*mSigmaz + iSigmaz*mSigmad + iDeltad*(mDeltad/4 + mDeltaZd/4) - iDeltaq*(mDeltaq/4 - mDeltaZq/4) + (4*Carm*vCSigmaq*w)/N))/(2*Carm);
dvCSigmaq_dt =-(N*(iDeltaq*(mDeltad/4 - mDeltaZd/4) - iSigmaz*mSigmaq - iSigmaq*mSigmaz + iDeltad*(mDeltaq/4 + mDeltaZq/4) + (4*Carm*vCSigmad*w)/N))/(2*Carm);
dvCSigmaz_dt =(N*(iDeltad*mDeltad + iDeltaq*mDeltaq + 2*iSigmad*mSigmad + 2*iSigmaq*mSigmaq + 4*iSigmaz*mSigmaz))/(8*Carm);
 
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%
% vC DELTA in SI %
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%
 
dvCDeltad_dt =(N*(iSigmaz*mDeltad - (iDeltaq*mSigmaq)/4 + iSigmad*(mDeltad/2 + mDeltaZd/2) - iSigmaq*(mDeltaq/2 + mDeltaZq/2) + iDeltad*(mSigmad/4 + mSigmaz/2) - (2*Carm*vCDeltaq*w)/N))/(2*Carm);
dvCDeltaq_dt =-(N*((iDeltad*mSigmaq)/4 - iSigmaz*mDeltaq + iSigmaq*(mDeltad/2 - mDeltaZd/2) + iSigmad*(mDeltaq/2 - mDeltaZq/2) + iDeltaq*(mSigmad/4 - mSigmaz/2) - (2*Carm*vCDeltad*w)/N))/(2*Carm);
dvCDeltaZd_dt =(N*(iDeltad*mSigmad + 2*iSigmad*mDeltad + iDeltaq*mSigmaq + 2*iSigmaq*mDeltaq + 4*iSigmaz*mDeltaZd))/(8*Carm) - 3*vCDeltaZq*w;
dvCDeltaZq_dt =3*vCDeltaZd*w + (N*(iDeltaq*mSigmad - iDeltad*mSigmaq + 2*iSigmad*mDeltaq - 2*iSigmaq*mDeltad + 4*iSigmaz*mDeltaZq))/(8*Carm);

 
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%
% Output
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%

states = [iDeltad; iDeltaq; iSigmad; iSigmaq; iSigmaz; vCDeltad; vCDeltaq; vCDeltaZd; vCDeltaZq; vCSigmad; vCSigmaq; vCSigmaz]; 

dd = [diDeltad_dt; diDeltaq_dt; diSigmad_dt; diSigmaq_dt; diSigmaz_dt; ...
    dvCDeltad_dt; dvCDeltaq_dt; dvCDeltaZd_dt; dvCDeltaZq_dt; ...
    dvCSigmad_dt; dvCSigmaq_dt; dvCSigmaz_dt]; 

if occ
    states = [states; xiDeltad; xiDeltaq];
    dd = [dd; dxiDeltad_dt; dxiDeltaq_dt]; 
end
if ccc
    states = [states; xiSigmad; xiSigmaq];
    dd = [dd; dxiSigmad_dt; dxiSigmaq_dt];
end
if zcc
    states = [states; xiSigmaz];
    dd = [dd; dxiSigmaz_dt];
end
if energy
    states = [states; xwSigmaz];
    dd = [dd; dxwSigmaz_dt]; 
end
if power
    states = [states; xiPac; xiQac];
    dd = [dd; dxiPac_dt; dxiQac_dt];
end
if dc
    states = [states; Vdc; xiVdc];
    dd = [dd; dVdc_dt; dxiVdc_dt];
    vdc_pos = length(dd) - 1;
end
    
derivatives = dd;
if dc
    inputs_sym = [Idc_sym; Vgd_sym; Vgq_sym];
    inputs = [Pdc_ref/Vdc_ref; Vgd; Vgq];
    outputs = [Vdc; iDeltad; iDeltaq];
else
    inputs_sym = [Vdc; Vgd_sym; Vgq_sym];
    inputs = [Vdc_ref; Vgd; Vgq];
    outputs = [3*iSigmaz; iDeltad; iDeltaq]; 
end
output.('states') = states;
output.('derivatives') = derivatives;
output.('inputs') = inputs_sym;

derivatives_states = subs(derivatives, inputs_sym, inputs);
derivatives_input = subs(derivatives, states, equilibrium);

output.('A') = double(subs(subs(jacobian(derivatives_states, states), states, equilibrium), inputs_sym, inputs));
output.('B') = double(subs(jacobian(derivatives_input, inputs_sym), inputs_sym, inputs));
output.('C') = double(subs(subs(jacobian(outputs, states), states, equilibrium), inputs_sym, inputs));
output.('D') = double(subs(subs(jacobian(outputs, inputs_sym), states, equilibrium), inputs_sym, inputs));

end


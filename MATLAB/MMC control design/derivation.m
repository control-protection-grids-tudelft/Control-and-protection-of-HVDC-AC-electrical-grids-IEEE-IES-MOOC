% standard equations

syms Reqac Leqac Rarm Larm N Carm
syms w
syms Vdc Vgd Vgq

syms mDeltad mDeltaq mDeltaZd mDeltaZq mSigmad mSigmaq mSigmaz
syms iDeltad iDeltaq iSigmad iSigmaq iSigmaz
syms vCDeltad vCDeltaq vCDeltaZd vCDeltaZq vCSigmad vCSigmaq vCSigmaz

% Voltage vMDeltadqz
vMDeltad =(mDeltaq*vCSigmaq)/4 - (mDeltad*vCSigmaz)/2 - (mDeltad*vCSigmad)/4 - (mDeltaZd*vCSigmad)/4 + (mDeltaZq*vCSigmaq)/4 - (mSigmad*vCDeltad)/4 - (mSigmaz*vCDeltad)/2 + (mSigmaq*vCDeltaq)/4 - (mSigmad*vCDeltaZd)/4 + (mSigmaq*vCDeltaZq)/4;
vMDeltaq =(mDeltad*vCSigmaq)/4 + (mDeltaq*vCSigmad)/4 - (mDeltaq*vCSigmaz)/2 - (mDeltaZd*vCSigmaq)/4 - (mDeltaZq*vCSigmad)/4 + (mSigmad*vCDeltaq)/4 + (mSigmaq*vCDeltad)/4 - (mSigmaz*vCDeltaq)/2 - (mSigmad*vCDeltaZq)/4 - (mSigmaq*vCDeltaZd)/4;
vMDeltaZd =- (mDeltad*vCSigmad)/4 - (mDeltaq*vCSigmaq)/4 - (mDeltaZd*vCSigmaz)/2 - (mSigmad*vCDeltad)/4 - (mSigmaq*vCDeltaq)/4 - (mSigmaz*vCDeltaZd)/2;
vMDeltaZq =(mDeltad*vCSigmaq)/4 - (mDeltaq*vCSigmad)/4 - (mDeltaZq*vCSigmaz)/2 - (mSigmad*vCDeltaq)/4 + (mSigmaq*vCDeltad)/4 - (mSigmaz*vCDeltaZq)/2;

% Modulated Voltage vMSigmadqz
vMSigmad =(mDeltad*vCDeltad)/4 - (mDeltaq*vCDeltaq)/4 + (mDeltad*vCDeltaZd)/4 + (mDeltaZd*vCDeltad)/4 + (mDeltaq*vCDeltaZq)/4 + (mDeltaZq*vCDeltaq)/4 + (mSigmad*vCSigmaz)/2 + (mSigmaz*vCSigmad)/2;
vMSigmaq =(mDeltaq*vCDeltaZd)/4 - (mDeltaq*vCDeltad)/4 - (mDeltad*vCDeltaZq)/4 - (mDeltad*vCDeltaq)/4 + (mDeltaZd*vCDeltaq)/4 - (mDeltaZq*vCDeltad)/4 + (mSigmaq*vCSigmaz)/2 + (mSigmaz*vCSigmaq)/2;
vMSigmaz =(mDeltad*vCDeltad)/4 + (mDeltaq*vCDeltaq)/4 + (mDeltaZd*vCDeltaZd)/4 + (mDeltaZq*vCDeltaZq)/4 + (mSigmad*vCSigmad)/4 + (mSigmaq*vCSigmaq)/4 + (mSigmaz*vCSigmaz)/2;
 
% AC Current dynamics
diDeltad_dt =-(Vgd - vMDeltad + Reqac*iDeltad + Leqac*iDeltaq*w)/Leqac;
diDeltaq_dt =-(Vgq - vMDeltaq + Reqac*iDeltaq - Leqac*iDeltad*w)/Leqac;

% Common-mode Current dynamics
diSigmad_dt =-(vMSigmad + Rarm*iSigmad - 2*Larm*iSigmaq*w)/Larm;
diSigmaq_dt =-(vMSigmaq + Rarm*iSigmaq + 2*Larm*iSigmad*w)/Larm;
diSigmaz_dt =-(vMSigmaz - Vdc/2 + Rarm*iSigmaz)/Larm;
 
% vC DELTA in SI % 
dvCDeltad_dt =(N*(iSigmaz*mDeltad - (iDeltaq*mSigmaq)/4 + iSigmad*(mDeltad/2 + mDeltaZd/2) - iSigmaq*(mDeltaq/2 + mDeltaZq/2) + iDeltad*(mSigmad/4 + mSigmaz/2) - (2*Carm*vCDeltaq*w)/N))/(2*Carm);
dvCDeltaq_dt =-(N*((iDeltad*mSigmaq)/4 - iSigmaz*mDeltaq + iSigmaq*(mDeltad/2 - mDeltaZd/2) + iSigmad*(mDeltaq/2 - mDeltaZq/2) + iDeltaq*(mSigmad/4 - mSigmaz/2) - (2*Carm*vCDeltad*w)/N))/(2*Carm);
dvCDeltaZd_dt =(N*(iDeltad*mSigmad + 2*iSigmad*mDeltad + iDeltaq*mSigmaq + 2*iSigmaq*mDeltaq + 4*iSigmaz*mDeltaZd))/(8*Carm) - 3*vCDeltaZq*w;
dvCDeltaZq_dt =3*vCDeltaZd*w + (N*(iDeltaq*mSigmad - iDeltad*mSigmaq + 2*iSigmad*mDeltaq - 2*iSigmaq*mDeltad + 4*iSigmaz*mDeltaZq))/(8*Carm);

% vC SIGMA 
dvCSigmad_dt =(N*(iSigmad*mSigmaz + iSigmaz*mSigmad + iDeltad*(mDeltad/4 + mDeltaZd/4) - iDeltaq*(mDeltaq/4 - mDeltaZq/4) + (4*Carm*vCSigmaq*w)/N))/(2*Carm);
dvCSigmaq_dt =-(N*(iDeltaq*(mDeltad/4 - mDeltaZd/4) - iSigmaz*mSigmaq - iSigmaq*mSigmaz + iDeltad*(mDeltaq/4 + mDeltaZq/4) + (4*Carm*vCSigmad*w)/N))/(2*Carm);
dvCSigmaz_dt =(N*(iDeltad*mDeltad + iDeltaq*mDeltaq + 2*iSigmad*mSigmad + 2*iSigmaq*mSigmaq + 4*iSigmaz*mSigmaz))/(8*Carm);
 
eqs = [diDeltad_dt; diDeltaq_dt; diSigmad_dt; diSigmaq_dt; diSigmaz_dt; ...
        dvCDeltad_dt; dvCDeltaq_dt; dvCDeltaZd_dt; dvCDeltaZq_dt; ...
        dvCSigmad_dt; dvCSigmaq_dt; dvCSigmaz_dt];
x = [iDeltad; iDeltaq; iSigmad; iSigmaq; iSigmaz; ...
        vCDeltad; vCDeltaq; vCDeltaZd; vCDeltaZq; ...
        vCSigmad; vCSigmaq; vCSigmaz];
m = [mDeltad; mDeltaq; mDeltaZd; mDeltaZq; mSigmad; mSigmaq; mSigmaz];

B = subs(eqs, x, zeros(length(x),1));
A = subs(eqs, m, zeros(length(m),1)) - B;
A = jacobian(A, x);
D = subs(eqs - A*x - B, x, zeros(length(x),1)); 
D = jacobian(D, m);
C = eqs - A*x - B - D * m; 
C = jacobian(C, x);
for i = 1:length(m)
    k = zeros(length(m), 1);
    k(i) = 1;
    subs(C, m, k)
end
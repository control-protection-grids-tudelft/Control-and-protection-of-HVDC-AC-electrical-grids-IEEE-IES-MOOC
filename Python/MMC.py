# -*- coding: utf-8 -*-
"""
Created on Fri Mar  5 14:40:09 2021

@author: alekic
"""

from pylab import *
from scipy.integrate import ode, solve_ivp, odeint


x0, t0 = [0,0,0, 0,0,0, 0,0,0, 0,0,0], 0

N = 400;
Carm = 32.55e-6;
Rarm = 1.024;
Larm = 48e-3;
Rf = 0.521;
Lf = 58.7e-3;
Reqac = Rf + Rarm/2;
Leqac = Lf + Larm/2;

Cdc = 6 * Carm / N;

f = 50;
w = 2*pi*f;

vdc = 640e3;
Vm = 320e3;

Sbase = 1e9;
Vbase = Vm/sqrt(3)
Ibase = Sbase/Vbase/sqrt(3)


def dxdt(t, x):
    iDelta_a, iDelta_b, iDelta_c, iSigma_a, iSigma_b, iSigma_c, vCDelta_a, vCDelta_b, vCDelta_c, vCSigma_a, vCSigma_b, vCSigma_c = x
    # mDelta_a, mDelta_b, mDelta_c, mSigma_a, mSigma_b, mSigma_c = m
     
    vG_a = Vm*cos(w*t)
    vG_b = Vm*cos(w*t-2*pi/3)
    vG_c = Vm*cos(w*t-4*pi/3)
    
    mSigma_a = 1
    mSigma_b = 1
    mSigma_c = 1
    mDelta_a = -0.8*cos(w*t)
    mDelta_b = -0.8*cos(w*t-2*pi/3)
    mDelta_c = -0.8*cos(w*t-4*pi/3)
    
    vMDelta_a = -(mDelta_a*vCSigma_a + mSigma_a*vCDelta_a)/2
    vMDelta_b = -(mDelta_b*vCSigma_b + mSigma_b*vCDelta_b)/2
    vMDelta_c = -(mDelta_c*vCSigma_c + mSigma_c*vCDelta_c)/2
    
    vMSigma_a = (mSigma_a*vCSigma_a + mDelta_a*vCDelta_a)/2
    vMSigma_b = (mSigma_b*vCSigma_b + mDelta_b*vCDelta_b)/2
    vMSigma_c = (mSigma_c*vCSigma_c + mDelta_c*vCDelta_c)/2
    
    diDelta_a_dt = vMDelta_a/Leqac - vG_a/Leqac - Reqac/Leqac*iDelta_a
    diDelta_b_dt = vMDelta_b/Leqac - vG_b/Leqac - Reqac/Leqac*iDelta_b
    diDelta_c_dt = vMDelta_c/Leqac - vG_c/Leqac - Reqac/Leqac*iDelta_c
    
    diSigma_a_dt = vdc/2/Larm - vMSigma_a/Larm - Rarm/Larm*iSigma_a
    diSigma_b_dt = vdc/2/Larm - vMSigma_b/Larm - Rarm/Larm*iSigma_b
    diSigma_c_dt = vdc/2/Larm - vMSigma_c/Larm - Rarm/Larm*iSigma_c
    
    dvCDelta_a_dt = (mSigma_a*iDelta_a/2 + mDelta_a*iSigma_a)/2/Carm
    dvCDelta_b_dt = (mSigma_b*iDelta_b/2 + mDelta_b*iSigma_b)/2/Carm
    dvCDelta_c_dt = (mSigma_c*iDelta_c/2 + mDelta_c*iSigma_c)/2/Carm
    
    dvCSigma_a_dt = (mDelta_a*iDelta_a/2 + mSigma_a*iSigma_a)/2/Carm
    dvCSigma_b_dt = (mDelta_b*iDelta_b/2 + mSigma_b*iSigma_b)/2/Carm
    dvCSigma_c_dt = (mDelta_c*iDelta_c/2 + mSigma_c*iSigma_c)/2/Carm
    
    return [diDelta_a_dt, diDelta_b_dt, diDelta_c_dt, diSigma_a_dt, diSigma_b_dt, diSigma_c_dt,
            dvCDelta_a_dt, dvCDelta_b_dt, dvCDelta_c_dt, dvCSigma_a_dt, dvCSigma_b_dt, dvCSigma_c_dt]


res = solve_ivp(dxdt, (0, 1.1), x0, t_eval = linspace(0,1.1,20000))
iDelta_a, iDelta_b, iDelta_c, iSigma_a, iSigma_b, iSigma_c, vCDelta_a, vCDelta_b, vCDelta_c, vCSigma_a, vCSigma_b, vCSigma_c = res.y
t = [i for i in res.t]

mDelta_a = [-0.8*cos(w*i) for i in t]
mDelta_b = [-0.8*cos(w*i-2*pi/3) for i in t]
mDelta_c = [-0.8*cos(w*i-4*pi/3) for i in t]
mSigma_a = [1 for i in t]
mSigma_b = [1 for i in t]
mSigma_c = [1 for i in t]

iDelta_a = [i/Ibase for i in iDelta_a]
iDelta_b = [i/Ibase for i in iDelta_b]
iDelta_c = [i/Ibase for i in iDelta_c]
iSigma_a = [i/Ibase for i in iSigma_a]
iSigma_b = [i/Ibase for i in iSigma_b]
iSigma_c = [i/Ibase for i in iSigma_c]

vCDelta_a = [v/vdc for v in vCDelta_a]
vCDelta_b = [v/vdc for v in vCDelta_b]
vCDelta_c = [v/vdc for v in vCDelta_c]
vCSigma_a = [v/vdc for v in vCSigma_a]
vCSigma_b = [v/vdc for v in vCSigma_b]
vCSigma_c = [v/vdc for v in vCSigma_c]

close('all')

rc('text', usetex = True)
rc('font', family = 'serif')

figure(0, figsize=(8, 6), dpi = 600)
subplots_adjust(wspace = 0.25, hspace = 0.1)

subplot(421)
xlim(1.06, 1.1)
xticks(visible = False)
grid('on')
plot(t, mDelta_a, 'r', label = r' $m^\Delta_a$')
plot(t, mDelta_b, 'b', label = r' $m^\Delta_b$')
plot(t, mDelta_c, 'g', label = r' $m^\Delta_c$')
ylabel(r'$\bf{m}^\Delta_{abc}$')
legend(loc='center left')

subplot(422)
xlim(1.06, 1.1)
xticks(visible = False)
grid('on')
plot(t, mSigma_a, 'r', label = r' $m^\Sigma_a$')
plot(t, mSigma_b, 'b', label = r' $m^\Sigma_b$')
plot(t, mSigma_c, 'g', label = r' $m^\Sigma_c$')
ylabel(r'$\bf{m}^\Sigma_{abc}$')
legend(loc='center left')

subplot(423)
xlim(1.06, 1.1)
ylim(-2,2)
xticks(visible = False)
plot(t, iDelta_a, 'r', label = r' $i^\Delta_a$')
plot(t, iDelta_b, 'b', label = r' $i^\Delta_b$')
plot(t, iDelta_c, 'g', label = r' $i^\Delta_c$')
grid('on')
ylabel(r'$\bf{i}^\Delta_{abc} \; [\mbox{p.u.}]$')
legend(loc='center left')

subplot(424)
ylim(-2,2)
# yticks([min(iSigma_a), 0, max(iSigma_a)]) #, [r'$ -$', '0', r'$V_m$'])
xlim(1.06, 1.1)
xticks(visible = False)
grid('on')
plot(t, iSigma_a, 'r', label = r' $i^\Sigma_a$')
plot(t, iSigma_b, 'b', label = r' $i^\Sigma_b$')
plot(t, iSigma_c, 'g', label = r' $i^\Sigma_c$')
ylabel(r'$\bf{i}^\Sigma_{abc} \; [\mbox{p.u.}]$')
legend(loc='center left')

subplot(425)
xlim(1.06, 1.1)
# xticks([0, pi/2, pi, 3*pi/2, 2*pi], visible = False)
grid('on')
plot(t, vCDelta_a, 'r', label = r' $v^\Delta_{Ca}$')
plot(t, vCDelta_b, 'b', label = r' $v^\Delta_{Cb}$')
plot(t, vCDelta_c, 'g', label = r' $v^\Delta_{Cc}$')
ylabel(r'$\bf{v}^\Delta_{Cabc} \; [\mbox{p.u.}]$')
legend(loc='center left')
xlabel(r'$t \, [\mbox{s}]$')

subplot(426)
# ylim(-2,2)
# yticks([min(iSigma_a), 0, max(iSigma_a)]) #, [r'$ -$', '0', r'$V_m$'])
xlim(1.06, 1.1)
# xticks([0, pi/2, pi, 3*pi/2, 2*pi], visible = False)
grid('on')
plot(t, vCSigma_a, 'r', label = r' $v^\Sigma_{Ca}$')
plot(t, vCSigma_b, 'b', label = r' $v^\Sigma_{Cb}$')
plot(t, vCSigma_c, 'g', label = r' $v^\Sigma_{Cc}$')
ylabel(r'$\bf{v}^\Sigma_{Cabc} \; [\mbox{p.u.}]$')
legend(loc='center left')
xlabel(r'$t \, [\mbox{s}]$')

savefig('mmc.pdf', bbox_inches='tight', dpi = 600)
# -*- coding: utf-8 -*-
"""
Created on Fri Mar  5 14:40:09 2021

@author: alekic
"""

from pylab import *
from scipy.integrate import ode, solve_ivp, odeint


x0, t0 = [0,0,0], 0

Reqac = 1.02;
Leqac = 83.12e-3;

f = 50;
w = 2*pi*f;

vdc = 640e3;
Vm = 320e3;

Sbase = 1e9;
Vbase = Vm/sqrt(3)
Ibase = Sbase/Vbase/sqrt(3)

m = 0.05


def dxdt(t, x):
    i_a, i_b, i_c= x
     
    vG_a = Vm*cos(w*t)
    vG_b = Vm*cos(w*t-2*pi/3)
    vG_c = Vm*cos(w*t-4*pi/3)
    
    m_a = 1/2-m*cos(w*t)
    m_b = 1/2-m*cos(w*t-2*pi/3)
    m_c = 1/2-m*cos(w*t-4*pi/3)
    
    vC_a = m_a * vdc
    vC_b = m_b * vdc
    vC_c = m_c * vdc
       
    di_a_dt = vC_a/Leqac - vG_a/Leqac - Reqac/Leqac*i_a
    di_b_dt = vC_b/Leqac - vG_b/Leqac - Reqac/Leqac*i_b
    di_c_dt = vC_c/Leqac - vG_c/Leqac - Reqac/Leqac*i_c
    
            
    return [di_a_dt, di_b_dt, di_c_dt]


res = solve_ivp(dxdt, (0, 4.1), x0, t_eval = linspace(0,4.1,20000))
i_a, i_b, i_c = res.y
t = [i for i in res.t]

m_a = [1/2-m*cos(w*i) for i in t]
m_b = [1/2-m*cos(w*i-2*pi/3) for i in t]
m_c = [1/2-m*cos(w*i-4*pi/3) for i in t]

i_a = [i/Ibase for i in i_a]
i_b = [i/Ibase for i in i_b]
i_c = [i/Ibase for i in i_c]

vC_a = [v for v in m_a]
vC_b = [v for v in m_b]
vC_c = [v for v in m_c]

close('all')

rc('text', usetex = True)
rc('font', family = 'serif')

figure(0, figsize=(8, 6), dpi = 600)
subplots_adjust(wspace = 0.25, hspace = 0.1)

subplot(221)
xlim(2.06, 2.1)
xticks(visible = False)
grid('on')
plot(t, m_a, 'r', label = r' $m_a$')
plot(t, m_b, 'b', label = r' $m_b$')
plot(t, m_c, 'g', label = r' $m_c$')
ylabel(r'$\bf{m}_{abc}$')
legend(loc='center left')

subplot(222)
xlim(4.06, 4.1)
#ylim(-2,2)
xticks(visible = False)
plot(t, i_a, 'r', label = r' $i_a$')
plot(t, i_b, 'b', label = r' $i_b$')
plot(t, i_c, 'g', label = r' $i_c$')
grid('on')
ylabel(r'$\bf{i}_{abc} \; [\mbox{p.u.}]$')
legend(loc='center left')

subplot(223)
xlim(4.06, 4.1)
# xticks([0, pi/2, pi, 3*pi/2, 2*pi], visible = False)
grid('on')
plot(t, vC_a, 'r', label = r' $v_{Ca}$')
plot(t, vC_b, 'b', label = r' $v_{Cb}$')
plot(t, vC_c, 'g', label = r' $v_{Cc}$')
ylabel(r'$\bf{v}_{Cabc} \; [\mbox{p.u.}]$')
legend(loc='center left')
xlabel(r'$t \, [\mbox{s}]$')

savefig('2level.pdf', bbox_inches='tight', dpi = 600)
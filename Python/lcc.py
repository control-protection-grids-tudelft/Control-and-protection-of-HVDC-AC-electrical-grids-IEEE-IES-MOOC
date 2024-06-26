# -*- coding: utf-8 -*-
"""
Created on Thu Jan 21 13:56:44 2021

@author: alekic
"""

#! /usr/bin/python

from pylab import *

wt = linspace(0, 1, 1201)*2*pi
n1 = size(wt)

Vm = 230*sqrt(2)
Iout = 10

v1 = Vm*cos(wt)
v2 = Vm*cos(wt - 2*pi/3)
v3 = Vm*cos(wt - 4*pi/3)

alpha = pi/6

v12 = v1 - v2
v13 = v1 - v3
v21 = v2 - v1
v23 = v2 - v3
v31 = v3 - v1
v32 = v3 - v2

va = zeros(n1)
vb = zeros(n1)
vout = zeros(n1)

i1 = zeros(n1)
i2 = zeros(n1)
i3 = zeros(n1)

for i in range(n1):
    l = list([cos(wt[i]-alpha), cos(wt[i]-2*pi/3-alpha), cos(wt[i]-4*pi/3-alpha)])
    max_value = max(l)
    min_value = min(l)
    index_max = l.index(max_value)
    index_min = l.index(min_value)
    l1 = list([cos(wt[i]), cos(wt[i]-2*pi/3), cos(wt[i]-4*pi/3)])
    va[i] = Vm*l1[index_max]
    vb[i] = Vm*l1[index_min]
    vout[i] = va[i] - vb[i]
    
    i1[i] = (index_max == 0)*Iout + (index_min == 0)*(-Iout) + 0
    i2[i] = (index_max == 1)*Iout + (index_min == 1)*(-Iout) + 0
    i3[i] = (index_max == 2)*Iout + (index_min == 2)*(-Iout) + 0
    
close('all')

rc('text', usetex = True)
rc('font', family = 'serif')

figure(0, figsize=(8, 6), dpi = 600)
subplots_adjust(wspace = 0.25, hspace = 0.1)

subplot(211)
ylim(1.2*min(v1), 1.2*max(v1))
yticks([min(v1), 0, max(v1)], [r'$ -V_m$', '0', r'$V_m$'])
xlim(0, 2*pi)
xticks([0, pi/6, pi/3, pi/2, 5*pi/6, 2*pi/3, 7*pi/6, pi, 9*pi/6, 11*pi/6, 5*pi/3, 4*pi/3, 2*pi], visible = False)
grid('on')
plot(wt, v1, 'k', label = r' $v_a$')
plot(wt, v2, 'k--', label = r' $v_b$')
plot(wt, v3, 'k-.', label = r' $v_c$')
plot(wt, va, 'r', linewidth = 2.5, label = r' $v_A$')
plot(wt, vb, 'b', linewidth = 2.5, label = r' $v_B$')
ylabel(r'$v_{A}, \; v_B \; [\mbox{V}]$')
legend(loc='center left', bbox_to_anchor=(1, 0.5))

subplot(212)
ylim(1.2*min(v12), 1.2*max(v12))
yticks([min(v12), 0, max(v12)], [r'$ -V_m \sqrt{3}$', '0', r'$ V_m \sqrt{3}$'])
xlim(0, 2*pi)
xticks([0, pi/6, pi/3, pi/2, 2*pi/3, 5*pi/6, pi, 7*pi/6, 5*pi/3, 4*pi/3, 2*pi, 9*pi/6, 11*pi/6], [r'$ 0$', r'$ \frac{\pi}{6}$', r'$ \frac{\pi}{3}$', r'$ \frac{\pi}{2}$', r'$ \frac{2\pi}{3}$', r'$ \frac{5\pi}{6}$', r'$ \pi$', r'$ \frac{7\pi}{6}$', r'$ \frac{5\pi}{3}$', r'$ \frac{4\pi}{3}$', r' $2\pi$', r'$ \frac{3\pi}{2}$', r'$ \frac{11\pi}{6}$'])
grid('on')
plot(wt, v12, 'k', label = r' $v_{ab}$')
plot(wt, v13, 'k:', label = r' $v_{ac}$')
plot(wt, v21, 'k--', label = r' $v_{ba}$')
plot(wt, v23, 'k-.', label = r' $v_{bc}$')
plot(wt, v31, 'c-.', label = r' $v_{ca}$')
plot(wt, v32, 'c:', label = r' $v_{cb}$')
plot(wt, vout, 'r', linewidth = 2.5, label = r' $v_{d}$')
ylabel(r'$v_{d} \; [\mbox{V}]$')
xlabel(r' $\omega t \; [\mbox{rad}]$')
legend(loc='center left', bbox_to_anchor=(1, 0.5))

savefig('lcc_ideal_fig_a.pdf', bbox_inches='tight', dpi = 600)


close('all')

rc('text', usetex = True)
rc('font', family = 'serif')

figure(0, figsize=(8, 9), dpi = 600)
subplots_adjust(wspace = 0.25, hspace = 0.1)

subplot(311)
ylim(-1.2*Iout, 1.2*Iout)
yticks([min(i1), 0, max(i1)], [r'$-I_d$', '0', r'$I_d$'])
xlim(0, 2*pi)
xticks([0, pi/6, pi/3, pi/2, 5*pi/6, 2*pi/3, 7*pi/6, pi, 9*pi/6, 11*pi/6, 5*pi/3, 4*pi/3, 2*pi], visible = False)
grid('on')
plot(wt, i1, 'b', linewidth = 2.5, label = r' $i_a$')
ylabel(r'$i_{a} \; [\mbox{A}]$')

subplot(312)
ylim(-1.2*Iout, 1.2*Iout)
yticks([min(i1), 0, max(i1)], [r'$-I_d$', '0', r'$I_d$'])
xlim(0, 2*pi)
xticks([0, pi/6, pi/3, pi/2, 5*pi/6, 2*pi/3, 7*pi/6, pi, 9*pi/6, 11*pi/6, 5*pi/3, 4*pi/3, 2*pi], visible = False)
grid('on')
plot(wt, i2, 'b', linewidth = 2.5, label = r' $i_b$')
ylabel(r'$i_{b} \; [\mbox{A}]$')

subplot(313)
ylim(-1.2*Iout, 1.2*Iout)
yticks([min(i1), 0, max(i1)], [r'$-I_d$', '0', r'$I_d$'])
xlim(0, 2*pi)
xticks([0, pi/6, pi/3, pi/2, 2*pi/3, 5*pi/6, pi, 7*pi/6, 5*pi/3, 4*pi/3, 2*pi, 9*pi/6, 11*pi/6], [r'$ 0$', r'$ \frac{\pi}{6}$', r'$ \frac{\pi}{3}$', r'$ \frac{\pi}{2}$', r'$ \frac{2\pi}{3}$', r'$ \frac{5\pi}{6}$', r'$ \pi$', r'$ \frac{7\pi}{6}$', r'$ \frac{5\pi}{3}$', r'$ \frac{4\pi}{3}$', r' $2\pi$', r'$ \frac{3\pi}{2}$', r'$ \frac{11\pi}{6}$'])
grid('on')
plot(wt, i3, 'b', linewidth = 2.5, label = r' $i_c$')
ylabel(r'$i_{c} \; [\mbox{A}]$')
xlabel(r' $\omega t \; [\mbox{rad}]$')

savefig('lcc_ideal_fig_b.pdf', bbox_inches='tight', dpi = 600)

clear all; 
clc; 
close all;

%% Load MMC parameters
MMC_PARAMETERS

%% AC grid current control design
s=tf('s');
G_iac = 1/((Lg_1+La_1/2)*s+(Rg_1+Ra_1/2));                %Plant definition
ts_G_iac = 10e-3;                                         %settling time parameter

%% AC power loop control design
ts_G_P = 25e-3;                                           %settling time parameter
tau_Pac=ts_G_P/4;

ts_G_Q = 25e-3;                                           %settling time parameter
tau_Qac=ts_G_Q/4;


%% Circulating current control design
s=tf('s');

% PI CONTROLLER
G_isum = 1/((2*La_1)*s+(2*Ra_1));                         %Plant definition
ts_G_isum = 1e-3;                                         %settling time parameter

% PR CONTROLLER
wc = 2*pi*5;                                              %cut-off frequency for PR CONTROLLER
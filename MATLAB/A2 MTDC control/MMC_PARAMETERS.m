%% MMC PARAMETERS

S_1=1000e6;                         %Rated power    
U_ll1=320e3;                        %Rated voltage (line-line voltage RMS)           
U_pnpeak1=U_ll1*sqrt(2)/sqrt(3);    %Rated grid voltage (phase-neutral voltage peak)
U_pnrms1=U_ll1/sqrt(3);             %Rated grid voltage (phase-neutral voltage RMS)  
f_grid=50;                          %Rated grid frequency
w0 = 2*pi*50;
Vpeak_d1=U_pnpeak1;                 %Rated voltage (Direct voltage)
Vpeak_i1=Vpeak_d1;                  %Rated voltage (Inverse voltage)
psi_Vi1=0;                          %Angle of the negative voltage (referenced to the positive voltage)
Vdc=640e3;                          %Rated DC link voltage                           
Ibase1=S_1/U_ll1/sqrt(3);           %Base current impedance RMS     


Zbase_1=U_ll1^2/S_1;                %Base impedance
Rg_1=0.005*Zbase_1;                 %Grid equivalent impedance
Lg_1=0.18*Zbase_1/2/pi/50;          %Grid equivalent impedance
Ra_1=0.01*Zbase_1;                  %Arm impedance
La_1=0.15*Zbase_1/2/pi/50;          %Arm impedance
Leq = Lg_1+La_1/2;
Req = Rg_1+Ra_1/2;
Cap = 9.5e-3;                       %SM cap
N = 400;                            %sub-modules
Carm = Cap/N;
ArmVoltageRef=640e3;                %Voltage reference for the arm voltage (sum of all the submodule voltages)



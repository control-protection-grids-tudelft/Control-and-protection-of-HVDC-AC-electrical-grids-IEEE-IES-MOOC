# MATLAB codes
### Codes for lectures in course EE4545 and MOOC Control and protection of HVDC/AC electrical grids.
 
There are 4 different libraries:

-[A1 MMC Control Design](/MATLAB/A1%20MMC%20control%20design) models following the lectures of modules C1 and C2 of the MOOC. These files rely on the generalized MMC model [[1]](#1) and
the control design described in [[2]](#2) and [[3]](#3). Using these files is formulated [Assignment 1](/MATLAB/A1%20MMC%20control%20design/Assignment%201%20-%20MMC%20design%20and%20control.pdf).

Files created by: A. Lekić

-[A2 MTDC Control](/MATLAB/A2%20MTDC%20control) is MATLAB/Simulink library following MOOC's module C2. These files represent use of different control strategies
for controlling the MTDC electrical grid. It is based on the publication [[4]](#4). The [Assignment 2](/MATLAB/A2%20MTDC%20control/Assignment%202%20-%20MTDC%20controls.pdf) uses this library.
 
Files created by: M. Aghahadi 
 
-[A3 MTDC Protection](/MATLAB/A3%20MTDC%20Protection) introduces the concept of protection of low voltage DC system. Starting with identification of the 
fault to locating the distance of the fault with both single-terminal and double-terminal fault location methods as described in [[5]](#5)-[[6]](#6). 

Files created by: V. Nougain

-[A4 DC links in distribution networks](/MATLAB/A4%20DC%20links%20in%20distribution%20networks) is MATLAB/Simulink library following MOOC's module C4. These files represent distribution network DC link control. 
It is based on the publication [[7]](#7). 

Files created by: M. Barragan

## References
<a id="1">[1]</a>
Bergna-Diaz, G., Freytes, J., Guillaud, X., D’Arco, S., & Suul, J. A. (2018). Generalized voltage-based state-space modeling of modular multilevel converters with 
constant equilibrium in steady state. IEEE Journal of Emerging and Selected Topics in Power Electronics, 6(2), 707-725.

<a id="2">[2]</a> Liu, L., Shetgaonkar, A., & Lekić, A. (2023). Interoperability of classical and advanced controllers in MMC based MTDC power system. International Journal of 
Electrical Power & Energy Systems, 148, 108980.

<a id="3">[3]</a> Sakinci, Ö. C., Lekić, A., & Beerten, J. (2022). Generalized impedance-based AC/DC power system modeling for harmonic stability analysis. International Journal 
of Electrical Power & Energy Systems, 143, 108456.

<a id="4">[4]</a> Aghahadi, M., Piegari, L., Lekić, A., & Shetgaonkar, A. (2022, October). Sliding Mode Control of the MMC-based Power System. In IECON 2022–48th Annual Conference 
of the IEEE Industrial Electronics Society (pp. 1-6). IEEE.

<a id="5">[5]</a> V. Nougain, S. Mishra, G. S. Misyris and S. Chatzivasileiadis, "Multiterminal DC Fault Identification for MMC-HVDC Systems Based on Modal Analysis—A Localized Protection Scheme," in IEEE Journal of Emerging and Selected Topics in Power Electronics, vol. 9, no. 6, pp. 6650-6661, Dec. 2021, doi: 10.1109/JESTPE.2021.3068800.

<a id="6">[6]</a> V. Nougain, S. Mishra, S. S. Nag and A. Lekić, "Fault Location Algorithm for Multi-Terminal Radial Medium Voltage DC Microgrid," in IEEE Transactions on Power Delivery, vol. 38, no. 6, pp. 4476-4488, Dec. 2023, doi: 10.1109/TPWRD.2023.3318689.

<a id="7">[7]</a> F. d. P. Garcia-Lopez, M. Barragan-Villarejo, A. Marano-Marcolini, and J. M. Maza-Ortega, “Performance
assessment of flexible links in distribution networks using a detailed power losses model,” IEEE Open Access
Journal of Power and Energy, 2023.

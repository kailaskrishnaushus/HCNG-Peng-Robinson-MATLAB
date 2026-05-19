%% HCNG Fueling Station Simulation (Driver Code)
% =============================================================================
% System: Pure H2 & CH4 Cylinders -> Regulators -> Mixing Chamber -> Compressor -> Car Tank
% Uses Peng-Robinson Equation of State for real gas behavior.
clear; clc;

%% 1. User Inputs
tank_V_L      = 60;     % Car Tank Volume (Liters)
final_P_bar   = 200;    % Car Tank Working Pressure (bar)
final_T_C     = 35;     % Temperature inside car tank (Celsius)
h2_percent    = 15;     % Hydrogen molar percentage in the HCNG blend (%)

%% 2. Infrastructure System Pressures & Temperatures
h2_source_P_bar   = 350; % Pressure of pure H2 storage cylinder (bar)
ch4_source_P_bar  = 250; % Pressure of pure CH4 storage cylinder (bar)
MixChamber_P_bar  = 10;  % Regulated pressure before the compressor (bar)
system_T_C        = 25;  % Intake temperature from source cylinders (Celsius)

%% 3. Unit Conversion & Thermodynamic Calculations
P_final_Pa  = final_P_bar * 1e5; 
T_final_K   = final_T_C + 273.15;   
y_H2        = h2_percent / 100;   % Mole fraction of H2
y_mix       = [y_H2, 1 - y_H2];

% Calculate compressibility factor (Z) at final tank conditions
Z_mix_final = solvePengRobinson(P_final_Pa, T_final_K, y_mix); 

% Run the filling mass balance simulation
results = tankfillmass(tank_V_L, P_final_Pa, T_final_K, y_H2, Z_mix_final, ...
                       MixChamber_P_bar, system_T_C, h2_source_P_bar, ch4_source_P_bar);

%% 4. Command Window Display
fprintf('=======================================================================\n');
fprintf('                 HCNG FILLING STATION CALCULATIONS                     \n');
fprintf('=======================================================================\n');
fprintf('Tank & Mixture Configuration:\n'); 
fprintf('  Tank Volume:       %.1f Liters\n', tank_V_L); 
fprintf('  Final Pressure:    %.0f bar\n', final_P_bar); 
fprintf('  Final Temperature: %.1f °C\n', final_T_C); 
fprintf('  H2 Blend Ratio:    %.1f %% H2 / %.1f %% CH4\n\n', h2_percent, 100 - h2_percent); 

fprintf('Thermodynamic Properties:\n'); 
fprintf('  Mixture Z-value at Tank Conditions: %.4f\n', Z_mix_final);
fprintf('  Total HCNG Mass in Full Tank:       %.3f kg\n\n', results.total_mass_in_tank); 

fprintf('*** UPSTREAM SOURCE CONSUMPTION (BEFORE REGULATOR) ***\n'); 
fprintf('  Hydrogen (H2) required:             %.4f kg (%.2f L drawn @ %0.0f bar)\n', ...
        results.req_mass_H2, results.req_vol_H2_source_L, h2_source_P_bar); 
fprintf('  Methane (CH4) required:             %.4f kg (%.2f L drawn @ %0.0f bar)\n\n', ...
        results.req_mass_CH4, results.req_vol_CH4_source_L, ch4_source_P_bar); 

fprintf('--- DOWNSTREAM COMPRESSOR SIZING (AFTER REGULATOR) ---\n'); 
fprintf('  Compressor Intake Pressure:         %.0f bar\n', MixChamber_P_bar); 
fprintf('  Total Mixed HCNG Vol. Required:     %.2f Liters\n', results.req_vol_HCNG_L); 
fprintf('-----------------------------------------------------------------------\n');
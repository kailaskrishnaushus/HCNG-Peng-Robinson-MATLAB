function results = tankfillmass(V_tank_L, P_final_Pa, T_final_K, y_H2, Z_mix_final, ...
                                MixChamber_P_bar, system_T_C, P_H2_source_bar, P_CH4_source_bar)
    % Calculates full system mass balances and volumetric source tracking.
    
    R       = 8.314; 
    M_H2    = 0.002016;    % Molar mass of H2 (kg/mol)
    M_CH4   = 0.01604;     % Molar mass of CH4 (kg/mol)
    y_CH4   = 1 - y_H2;    
    V_tank_m3 = V_tank_L / 1000; 

    %% 1. Final Mass Calculations inside the Vehicle Tank
    avg_molar_mass_mix = y_H2 * M_H2 + y_CH4 * M_CH4; 
    total_moles_in_tank = (P_final_Pa * V_tank_m3) / (Z_mix_final * R * T_final_K); 
    total_mass_in_tank  = total_moles_in_tank * avg_molar_mass_mix; 

    %% 2. Mass Sourcing Breakdown
    mass_fraction_H2 = (y_H2 * M_H2) / avg_molar_mass_mix; 
    req_mass_H2 = total_mass_in_tank * mass_fraction_H2; 
    req_mass_CH4 = total_mass_in_tank - req_mass_H2; 
    
    %% 3. Downstream Mixed Gas Volumetric Flow (Compressor Intake)
    T_system_K = system_T_C + 273.15; 
    P_intake_Pa = MixChamber_P_bar * 1e5; 
    y_mix = [y_H2, y_CH4]; 

    Z_mix_intake = solvePengRobinson(P_intake_Pa, T_system_K, y_mix); 
    rho_mix_intake = (P_intake_Pa * avg_molar_mass_mix) / (Z_mix_intake * R * T_system_K); 
    req_vol_HCNG_L  = (total_mass_in_tank / rho_mix_intake) * 1000; 

    %% 4. Upstream Source Cylinder Volumetric Displacements
    % Pure Hydrogen Storage Cylinder
    P_H2_source_Pa = P_H2_source_bar * 1e5; 
    Z_H2_source = solvePengRobinson(P_H2_source_Pa, T_system_K, [1, 0]); 
    rho_H2_source = (P_H2_source_Pa * M_H2) / (Z_H2_source * R * T_system_K); 
    req_vol_H2_source_L = (req_mass_H2 / rho_H2_source) * 1000; 

    % Pure Methane Storage Cylinder
    P_CH4_source_Pa = P_CH4_source_bar * 1e5; 
    Z_CH4_source = solvePengRobinson(P_CH4_source_Pa, T_system_K, [0, 1]); 
    rho_CH4_source = (P_CH4_source_Pa * M_CH4) / (Z_CH4_source * R * T_system_K); 
    req_vol_CH4_source_L = (req_mass_CH4 / rho_CH4_source) * 1000; 

    %% 5. Package Output Structure
    results.total_mass_in_tank   = total_mass_in_tank; 
    results.req_mass_H2          = req_mass_H2; 
    results.req_mass_CH4         = req_mass_CH4; 
    results.req_vol_H2_source_L  = req_vol_H2_source_L; 
    results.req_vol_CH4_source_L = req_vol_CH4_source_L; 
    results.req_vol_HCNG_L       = req_vol_HCNG_L; 
end
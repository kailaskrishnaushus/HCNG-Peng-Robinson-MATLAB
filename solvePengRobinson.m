function Z = solvePengRobinson(P, T, y) 
    % Solves the Peng-Robinson Equation of State for an H2-CH4 binary mixture.
    % INPUTS: 
    %   P - Absolute Pressure (Pa)
    %   T - Absolute Temperature (K)
    %   y - Row vector of mole fractions [y_H2, y_CH4] 

    R = 8.314; % Universal gas constant [J/(mol*K)]
    
    % Critical Properties: [H2, CH4]
    Tc = [33.2, 190.6];      % Critical Temperature (K)
    Pc = [12.97e5, 45.99e5]; % Critical Pressure (Pa)
    w  = [-0.22, 0.011];     % Acentric factor (omega)
    
    % Binary Interaction Parameter (k_ij) Matrix
    k = [0, 0.08; 0.08, 0]; 

    %% 1. Calculate Pure Component Parameters
    a = zeros(1, 2); 
    b = zeros(1, 2); 
    for i = 1:2 
        Tr = T / Tc(i); 
        kappa = 0.37464 + 1.54226 * w(i) - 0.26992 * w(i)^2; 
        alpha = (1 + kappa * (1 - sqrt(Tr)))^2; 
        a(i) = 0.45724 * (R^2 * Tc(i)^2) / Pc(i) * alpha; 
        b(i) = 0.07780 * (R * Tc(i)) / Pc(i); 
    end 
    
    %% 2. Apply Mixing Rules (Van der Waals)
    a_mix = 0; 
    for i = 1:2 
        for j = 1:2 
            a_mix = a_mix + y(i) * y(j) * sqrt(a(i) * a(j)) * (1 - k(i,j)); 
        end 
    end 
    b_mix = y(1)*b(1) + y(2)*b(2); 

    %% 3. Convert to Dimensionless Cubic Coefficients
    A = a_mix * P / (R^2 * T^2); 
    B = b_mix * P / (R * T); 

    %% 4. Solve Cubic Polynomial for Z
    coeffs = [1, -(1-B), (A - 2*B - 3*B^2), -(A*B - B^2 - B^3)]; 
    roots_Z = roots(coeffs); 

    % Extract real roots and pick the gas phase root (maximum value)
    real_roots = roots_Z(imag(roots_Z) == 0); 
    Z = max(real_roots); 
    
    if isempty(Z) 
        error('Error: Failed to find a valid real root for Z.'); 
    end 
end
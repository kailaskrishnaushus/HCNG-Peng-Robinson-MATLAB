# Real Gas Modeling of HCNG Fueling Stations using Peng-Robinson EOS

This repository hosts a modular MATLAB tool designed to model the thermodynamics of **Hydrogen Compressed Natural Gas (HCNG)** fueling infrastructures. It tracks mass transfers and volume displacements during vehicle cylinder refueling procedures.

## 📊 Process Engineering Scope
The system architecture tracks real gas states through the following process loop:
`Pure H2 & CH4 Cylinders` ➔ `Pressure Regulators` ➔ `Mixing Chamber` ➔ `Compressor Intake` ➔ `Vehicle CNG Storage Tank`

By applying the **Peng-Robinson Equation of State (PR-EOS)**, the model accounts for the non-ideal molecular interactions of Hydrogen and Methane mixtures under high pressures (up to 350+ bar).

---

## 🔬 Thermodynamic Basis
The non-ideal deviations are handled using the standard cubic formulation of the PR-EOS:

$$P = \frac{RT}{v-b} - \frac{a \alpha}{v^2 + 2bv - b^2}$$

To handle the $H_2/CH_4$ binary mixture, **Van der Waals mixing rules** are applied along with a binary interaction parameter ($k_{ij} = 0.08$) to solve for the true compressibility factor ($Z$).

---

## 🛠️ File Layout
* `main.m`: The primary control script. Change parameters like pressure sets or gas mixture ratios here.
* `solvePengRobinson.m`: The thermodynamic equation engine calculating $Z$ variations.
* `tankfillmass.m`: Executes the process mass balances and volume dependencies for infrastructure sizing.

---

## 🚀 How to Run the Model
1. Clone this repository directly into your local machine environment:
   ```bash
   git clone [https://github.com/kailaskrishnaushus/HCNG-Peng-Robinson-MATLAB.git](https://github.com/kailaskrishnaushus/HCNG-Peng-Robinson-MATLAB.git)
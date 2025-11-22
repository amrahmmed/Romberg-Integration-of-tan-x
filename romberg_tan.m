% ========================================================================
% File:        romberg_tan.m
% Description: High-accuracy numerical integration of tan(x) from 0 to pi/4
%              using Romberg Integration with Richardson extrapolation.
%              This script builds the full Romberg table up to level 4,
%              prints all values with controlled precision, compares the
%              final estimate to the analytical solution, computes percent
%              error, and visualizes convergence behavior.
%
% Techniques Demonstrated:
%   - Composite trapezoidal rule refinement
%   - Richardson extrapolation
%   - Construction of Romberg table R(i,j)
%   - Numerical error analysis
%   - MATLAB vectorization & clean scientific coding practices
%
% ========================================================================

clc; clear; close all;

%% ------------------------------------------------------------------------
%  Problem Setup
% -------------------------------------------------------------------------
f = @(x) tan(x);     % Integrand
a = 0;               % Lower limit
b = pi/4;            % Upper limit

% Analytical exact solution
I_exact = -log(cos(b));

% Romberg parameters
maxLevel = 4;
R = zeros(maxLevel, maxLevel);

%% ------------------------------------------------------------------------
%  Step 1: Build Trapezoidal Approximations R(k,1)
% -------------------------------------------------------------------------
for k = 1:maxLevel
    
    n = 2^(k-1);          % Number of subintervals
    h = (b - a) / n;      % Step size
    
    x = a:h:b;            % Partition points
    y = f(x);             % Function values
    
    % Composite trapezoidal rule
    R(k,1) = h * (0.5*y(1) + sum(y(2:end-1)) + 0.5*y(end));
end

%% ------------------------------------------------------------------------
%  Step 2: Richardson Extrapolation to Build Full Romberg Table
% -------------------------------------------------------------------------
for i = 2:maxLevel
    for j = 2:i
        R(i,j) = R(i,j-1) + (R(i,j-1) - R(i-1,j-1)) / (4^(j-1) - 1);
    end
end

%% ------------------------------------------------------------------------
%  Step 3: Display Full Romberg Table
% -------------------------------------------------------------------------
fprintf("\nRomberg Table (values shown with 6 significant figures):\n\n");

for i = 1:maxLevel
    for j = 1:i
        fprintf("%12.6g  ", R(i,j));
    end
    fprintf("\n");
end

%% ------------------------------------------------------------------------
%  Step 4: Error Computation
% -------------------------------------------------------------------------
I_romberg = R(maxLevel, maxLevel);
percent_error = abs((I_exact - I_romberg) / I_exact) * 100;

fprintf("\nExact Value      = %.6g\n", I_exact);
fprintf("Romberg R(4,4)   = %.6g\n", I_romberg);
fprintf("Percent Error    = %.6g %%\n", percent_error);

%% ------------------------------------------------------------------------
%  Step 5: Convergence Plot
% -------------------------------------------------------------------------
figure;
plot(1:maxLevel, R(:,1), 'o-', 'LineWidth', 1.5); hold on;
plot(1:maxLevel, diag(R), 's-', 'LineWidth', 1.5);

yline(I_exact, '--', 'Exact');

xlabel('Refinement Level');
ylabel('Integral Estimate');
title('Romberg Convergence (O(h^8) Accuracy)');
legend('R(k,1) - Trapezoidal','R(k,k) - Romberg','Exact','Location','best');
grid on;
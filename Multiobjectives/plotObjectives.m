% Define ranges for L (ship length) and C_B (block coefficient)
L_range = linspace(200, 300, 100);  % Ship length range (from 50 to 200 meters)
C_B_range = linspace(0.5, 0.85, 100);  % Block coefficient range (from 0.5 to 0.85)

% Preallocate matrices for objective values
fuelConsumptionValues = zeros(length(L_range), length(C_B_range));
cargoCapacityValues = zeros(length(L_range), length(C_B_range));

% Constants based on previous estimations
a = 0.15;  % Frictional resistance constant
b = 0.9;   % Wave-making resistance constant
c = 1.2;   % Cargo capacity constant

% Calculate fuel consumption and cargo capacity for each combination of L and C_B
for i = 1:length(L_range)
    for j = 1:length(C_B_range)
        L = L_range(i);
        C_B = C_B_range(j);
        
        % Objective 1: Fuel Consumption (to minimize)
        fuelConsumptionValues(i, j) = a * L^(-2) + b * C_B^2;
        
        % Objective 2: Cargo Capacity (to maximize, negated for minimization)
        cargoCapacityValues(i, j) = - (c * L^3 * C_B);  % Negative for minimization
    end
end

% Create a meshgrid for L and C_B to plot 3D surfaces
[L_mesh, C_B_mesh] = meshgrid(L_range, C_B_range);

% Plot Fuel Consumption (Objective 1)
figure;
surf(L_mesh, C_B_mesh, fuelConsumptionValues');
title('Fuel Consumption (Objective 1)');
xlabel('Ship Length (L)');
ylabel('Block Coefficient (C_B)');
zlabel('Fuel Consumption');
colorbar;
shading interp;  % Smooth shading for better visualization

% Plot Cargo Capacity (Objective 2)
figure;
surf(L_mesh, C_B_mesh, cargoCapacityValues');
title('Cargo Capacity (Objective 2, negated)');
xlabel('Ship Length (L)');
ylabel('Block Coefficient (C_B)');
zlabel('Negated Cargo Capacity');
colorbar;
shading interp;  % Smooth shading for better visualization

% If you want to plot contour plots for a 2D view:
figure;
contour(L_mesh, C_B_mesh, fuelConsumptionValues', 50);
title('Contour Plot of Fuel Consumption (Objective 1)');
xlabel('Ship Length (L)');
ylabel('Block Coefficient (C_B)');
colorbar;

figure;
contour(L_mesh, C_B_mesh, cargoCapacityValues', 50);
title('Contour Plot of Cargo Capacity (Objective 2, negated)');
xlabel('Ship Length (L)');
ylabel('Block Coefficient (C_B)');
colorbar;
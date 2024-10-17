% Define the number of variables (L and Cb)
numberOfVariables = 2;

% Set the lower and upper bounds for L and Cb
lb = [200, 0.6];
ub = [300, 0.85];

% Use gamultiobj to solve the multi-objective optimization problem
options = optimoptions(@gamultiobj, 'PlotFcn', {@gaplotpareto});
[x, fval] = gamultiobj(@multi, numberOfVariables, [], [], [], [], lb, ub, [], options);

% Extract L values from Pareto front solutions
L_values = x(:,1);  % First column of x corresponds to L values

% Specify the number of clusters for L (for example, 3 clusters)
numClusters = 3;

% Apply k-means clustering based on the L values
[idx, C] = kmeans(L_values, numClusters);

% Plot the Pareto front and color the solutions based on their clusters
figure;
scatter(fval(:,1), fval(:,2), 100, idx, 'filled');
title('Pareto Front with Clustering Based on L');
xlabel('Fuel Consumption');
ylabel('Cargo Capacity (negated)');
colorbar;
colormap jet;

% Optional: Plot L values vs Cb values, colored by clusters
figure;
scatter(x(:,1), x(:,2), 100, idx, 'filled');
title('L vs Cb Clustered by L');
xlabel('Ship Length (L)');
ylabel('Block Coefficient (C_B)');
colorbar;
colormap jet;

% Define constants
a = 0.15;
b = 0.95;
c = 1.25;

% Define the objective functions for fuel consumption and cargo capacity
function cost = fuelConsumption(x)
    L = x(1); % First variable is L
    Cb = x(2); % Second variable is Cb
    cost = 0.15 * L^-2 + 0.95 * Cb^2;
end

function cost = cargoCapacity(x)
    L = x(1); % First variable is L
    Cb = x(2); % Second variable is Cb
    cost = 1.25 * L^3 * Cb;
end

% Multi-objective function that returns two objectives
function y = multi(x)
    y(1) = fuelConsumption(x);   % First objective: Minimize fuel consumption
    y(2) = -cargoCapacity(x);    % Second objective: Maximize cargo capacity (negate for minimization)
end

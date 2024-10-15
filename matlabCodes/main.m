addpath(".\matlabCodes\HighFidilityModel\")
addpath("C:\Users\10aks\OneDrive\Desktop\optimisation\matlabCodes\Samplings")
addpath("./matlabCodes/PolynomialRegression/")
addpath("./matlabCodes/RBNN/")
addpath("./matlabCodes/ensembledModel/")

psi = [
    0, 0.002, 0.0356, 0.0991, 0.1662, 0.2297, 0.2852, 0.3299, 0.3631, 0.3861, 0.4012, 0.4107, 0.4163, 0.4192, 0.4203, 0.4200, ...
    0.4188, 0.4170, 0.4147, 0.4122, 0.4095, 0.4069, 0.4042, 0.4017, 0.3993, 0.3971, 0.3951, 0.3932, 0.3916, 0.3900, ...
    0.3886, 0.3874, 0.3863, 0.3853, 0.3844, 0.3836, 0.3828, 0.3822, 0.3816, 0.3810, 0.3806, 0.3801, 0.3798, 0.3794, ...
    0.3791, 0.3788, 0.3786, 0.3783, 0.3781, 0.3780, 0.3778, 0.3776, 0.3775, 0.3774, 0.3773, 0.3772, 0.3771, 0.3770, ...
    0.3769, 0.3769, 0.3768, 0.3768, 0.3767, 0.3767, 0.3766, 0.3766, 0.3766, 0.3766, 0.3765, 0.3765, 0.3765, 0.3765, ...
    0.3764, 0.3764, 0.3764, 0.3764, 0.3764, 0.3764, 0.3764, 0.3764, 0.3764, 0.3764, 0.3763, 0.3763, 0.3763, 0.3763, ...
    0.3763, 0.3763, 0.3763, 0.3763, 0.3763, 0.3763, 0.3763, 0.3763, 0.3763, 0.3763, 0.3763, 0.3763, 0.3763, 0.3763, ...
    0.3763, 0.3763, 0.3763, 0.3763, 0.3763, 0.3763, 0.3763, 0.3763, 0.3763, 0.3763, 0.3763, 0.3763, 0.3763, 0.3763, ...
    0.3763, 0.3763, 0.3763, 0.3763
];

start = 0;
step = 0.25;
n = length(psi);

% Generate the array
t = start:step:(n - 1) * step;

v = 1;
dt = t(2) - t(1);

% Step 1: Integrate psi to get yaw rate
yaw_rate = cumsum(psi) * dt;  % Cumulative sum of psi to get yaw rate

% Step 3: Calculate X and Y displacements using yaw angle (theta)
x = zeros(1, length(t));  % Initialize x displacement array
y = zeros(1, length(t));  % Initialize y displacement array

% Assuming v and dt are already defined
for i = 2:length(t)  % Start from 2 because x(1) and y(1) are initialized to zero
    dx = v * cos(yaw_rate(i)) * dt;
    dy = v * sin(yaw_rate(i)) * dt;
    x(i) = x(i - 1) + dx;
    y(i) = y(i - 1) + dy;
end

% K and T ranges
bounds = [0.05, 1.5; 0.4, 2];
initial_guess = [0.5, 0.5];

% % Optimisation of K and T from high fidility model itself
[optK, optT] = HFMoptimisation(psi, t, dt, initial_guess, bounds);
[sim_psi, sim_x, sim_y] = Simulate(optK, optT, t, dt);
plotPath(t, psi, x, y, sim_psi, sim_x, sim_y)

% creating dataset for surrogate training
createSurrogateTrainingData(100, bounds, psi, t, dt);

dataset = load('./matlabCodes/Samplings/samplingDataset.mat').dataset;
K_samples = dataset.K_samples; 
T_samples = dataset.T_samples; 
Y = dataset.j;

inputs = [K_samples, T_samples];
targets = Y;

% -------------------------------------------------------------  80-20 split -------------------------------------------------

% Get the total number of samples
num_samples = size(inputs, 1);  % Number of rows in inputs

% Calculate the index for the 80% split
split_index = round(0.8 * num_samples);

% Split the data into training (first 80%) and remaining (20%)
X_train = inputs(1:split_index, :);   % First 80% of inputs
Y_train = targets(1:split_index, :);  % First 80% of targets

% The remaining 20% will be used for testing or validation
X_test = inputs(split_index+1:end, :);  % Remaining 20% of inputs
Y_test = targets(split_index+1:end, :); % Remaining 20% of targets

% -------------------------------------------------------------- Surrogates-------------------------------------------------------

% ---------------------------------------------------------- polynomial model
ployDegree = 5;
polycv = polyCV(X_train, Y_train, ployDegree);
polymodel = polyModel(X_train, Y_train, ployDegree);
polyscore = mse(polymodel(X_test(:, 1), X_test(:, 2)) - Y_test);
[polyK, polyT, polyOpt] = polyOptimise(polymodel, initial_guess, bounds);

% % % % simulation
[sim_psi, sim_x, sim_y] = Simulate(polyK, polyT, t, dt);
plotPath(t, psi, x, y, sim_psi, sim_x, sim_y);


% % ---------------------------------------------------------- neural network model
[goal, spread] = rbHyperParameters(X_train, Y_train);
rbcv = rbCV(X_train, Y_train, goal, spread);
rbmodel = rbModel(X_train, Y_train, goal, spread);
rbscore = mse(rbmodel(X_test')' - Y_test);
[rbK, rbT, rbOpt] = rbOptimise(rbmodel, initial_guess, bounds);

% % simulation
[sim_psi, sim_x, sim_y] = Simulate(rbK, rbT, t, dt);
plotPath(t, psi, x, y, sim_psi, sim_x, sim_y);

% % --------------------------------------------------------- ensembled surrogate 
ensembledmodel = ensembledModel(polymodel, polyscore, rbmodel, rbscore);
ensembledscore = mse(ensembledmodel(X_test) - Y_test);
[ensK, ensT, ensOpt] = ensembledOptimise(ensembledmodel, initial_guess, bounds);

% simulation
[sim_psi, sim_x, sim_y] = Simulate(ensK, ensT, t, dt);
plotPath(t, psi, x, y, sim_psi, sim_x, sim_y);

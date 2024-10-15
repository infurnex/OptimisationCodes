% Define the objective function for optimization
function error = objective(params, psi, t, dt)
    K = params(1);
    T = params(2);

    [p_rp, ~, ~] = Simulate(K, T, t, dt);

    % Compute error as sum of squared differences between simulated and actual yaw rate
    error = sqrt(sum((p_rp - psi').^2));
end
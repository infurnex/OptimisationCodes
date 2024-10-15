
function [K_opti, T_opti] = HFMoptimisation(psi, t, dt, initial_guess, bounds)
    % Perform the optimization
    opts = optimset('Display', 'iter', 'TolFun', 1e-6);

    % Run optimization using fmincon
    [opt_params, fval] = fmincon(@(params) objective(params, psi, t, dt), initial_guess, [], [], [], [], bounds(:, 1), bounds(:, 2), [], opts);

    % Print results
    disp(['Optimal K: ', num2str(opt_params(1))]);
    disp(['Optimal T: ', num2str(opt_params(2))]);
    disp(['Minimum error: ', num2str(fval)]);
    K_opti = opt_params(1);
    T_opti = opt_params(2);
end


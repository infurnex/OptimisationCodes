
function [optK, optT, optVal] = ensembledOptimise(model, initial_guess, bounds)
    % Define the surrogate function
    function f = surrogate_function(v)
        v1 = v(1);
        v2 = v(2);
        f =  model([v1, v2]); % Assuming 'model' has a 'predict' method in MATLAB
    end

    % Optimize the surrogate function using fmincon
    options = optimoptions('fmincon', 'Display', 'off');  % Optional: Add options to suppress output
    [rb_optimal_v, rb_optimal_value] = fmincon(@surrogate_function, initial_guess, [], [], [], [], bounds(:,1), bounds(:,2), [], options);

    % Display the optimal values
    disp('Optimal values (v1, v2):');
    disp(rb_optimal_v);
    disp('Minimum value of the surrogate function:');
    disp(rb_optimal_value);

    optK = rb_optimal_v(1);
    optT = rb_optimal_v(2);
    optVal = rb_optimal_value;
end
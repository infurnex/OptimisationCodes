
function [K_samples, T_samples] = LHSsamplings(number, range_K, range_T)
    % Generate LHS samples
    lhs_samples = lhsdesign(number, 2);
    
    % Scale the samples to the desired ranges for K and T
    K_samples = range_K(1) + (range_K(2) - range_K(1)) * lhs_samples(:, 1);
    T_samples = range_T(1) + (range_T(2) - range_T(1)) * lhs_samples(:, 2);
end

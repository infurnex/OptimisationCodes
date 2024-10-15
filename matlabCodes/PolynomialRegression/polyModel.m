function model = polyModel(inputs, targets, degree)

    % inputs is a matrix where
    % inputs(1, :) corresponds to K_samples
    % inputs(2, :) corresponds to T_samples
    
    K_samples = inputs(:, 1);  % Now a column vector
    T_samples = inputs(:, 2);  % Now a column vector

    Y = targets(:);

    % creating features from K and T samples
    poly_X = createFeatures(K_samples, T_samples, degree);

    % Perform linear regression using the polynomial features
    [B,~,~,~,stats] = regress(Y, poly_X);

    % Print coefficients (optional)
    % fprintf('Coefficients:\n');
    % disp(B);

    % Print intercept (optional)
    % fprintf('Intercept: %f\n', stats);

    % Predict using the model (optional)
    % predictions = poly_X * B;

    % Print predictions (optional)
    % fprintf('Predictions:\n');
    % disp(predictions);
    function mse = polymodel(k, t)
        mse = createFeatures(k, t, degree) * B;
    end
    model = @polymodel;
end

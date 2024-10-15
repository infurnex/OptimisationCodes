
function score = rbCV(inputs, targets, goal, spread)

    inputs = inputs';
    targets = targets';

    k = 10;
    cv = cvpartition(size(inputs, 2), "KFold", k);

    % Initialize performance storage for each cross-validation fold
    cvPerformance = zeros(k, 1);
    
    % Perform k-fold cross-validation
    for fold = 1:k
        % Get the training and validation indices for this fold
        trainIdx = training(cv, fold);
        valIdx = test(cv, fold);
        
        % Split the data into training and validation sets
        trainInputs = inputs(:, trainIdx)';
        trainTargets = targets(:, trainIdx)';
        valInputs = inputs(:, valIdx)';
        valTargets = targets(:, valIdx)';

        % model training
        model = rbModel(trainInputs, trainTargets, goal, spread);
        
        % Validate the network on the validation set
        valOutputs = model(valInputs');

        % Calculate mean squared error (MSE) on validation set
        cvPerformance(fold) = mse(valTargets', valOutputs);
    end
    score = mean(cvPerformance);
end

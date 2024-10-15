
function [] = createSurrogateTrainingData(n, bounds, psi, t, dt)
    % Sampling for creating a Low fidility model
    [K_samples, T_samples] = LHSsamplings(n, bounds(1,:), bounds(2,:));

    figure;
    scatter(K_samples, T_samples, 50, 'filled'); % 50 is the marker size
    xlabel('K samples');
    ylabel('T samples');
    title('2D Plot of K and T Samples');
    grid on;

    % Assuming ObjectiveFunc is defined elsewhere
    j = zeros(size(K_samples)); % Preallocate the output array
    for i = 1:length(K_samples)
        j(i) = objective([K_samples(i), T_samples(i)], psi, t, dt);
    end

    % % Combine into a dataset (e.g., as a table or matrix)
    % dataset = table(K_samples, T_samples, j);
    % % Save the dataset in a .mat file
    % save('./matlabCodes/Samplings/samplingDataset.mat', "dataset");
end
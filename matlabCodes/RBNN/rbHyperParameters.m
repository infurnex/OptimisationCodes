
function [goal, spread] = rbHyperParameters(inputs, targets)

    % Define a range of goal and spread values to test
    goalValues = [1e-3, 1e-2];  % Try different goal values
    spreadValues = [0.2,0.3,0.4,0.5];  % Try different spread values

    % Initialize variables to store the best performance
    bestGoal = NaN;
    bestSpread = NaN;
    bestPerformance = Inf;  % Initialize with a large value

    % Loop through each combination of goal and spread
    for g = goalValues
        for s = spreadValues

            score = rbCV(inputs, targets, g, s);
            
            % If this combination of goal and spread has the best performance, store it
            if score < bestPerformance
                bestPerformance = score;
                bestGoal = g;
                bestSpread = s;
            end
        end
    end

    % Display the best goal, spread, and performance
    disp(['Best Goal: ', num2str(bestGoal)]);
    disp(['Best Spread: ', num2str(bestSpread)]);
    disp(['Best Cross-Validation Performance (MSE): ', num2str(bestPerformance)]);

    goal = bestGoal;
    spread = bestSpread;
end

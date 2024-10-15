
function [] = plotPath(t, psi, x, y, predPSI, predX, predY)
    % Plot the yaw rate versus time
    figure('Position', [100, 100, 1200, 600]);
    
    subplot(1, 2, 1);
    plot(t, predPSI, 'r-'); % Optimized yaw rate
    hold on;
    plot(t, psi, 'b-', 'DisplayName', 'Yaw Rate (Data)'); % Data yaw rate
    title('Yaw Rate versus Time');
    xlabel('Non-dimensional time t''', 'FontSize', 12);
    ylabel('Non-dimensional yaw rate r''', 'FontSize', 12);
    grid on;
    hold off;
    
    % Plot the ship's trajectory
    subplot(1, 2, 2);
    plot(x, y, 'b-', 'DisplayName', 'Ship Trajectory'); % Data trajectory
    hold on;
    plot(predX, predY, 'r-', 'DisplayName', 'Model'); % Optimized model trajectory
    xlabel('X Position (meters)', 'FontSize', 12);
    ylabel('Y Position (meters)', 'FontSize', 12);
    title('Simulated Ship Trajectory');
    legend('show');
    grid on;
    hold off;
end

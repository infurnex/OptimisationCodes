
function [rp_nomoto1, x_nomoto, y_nomoto] = Simulate(K, T, t, dt)
    delta = 35 * pi / 180;  % Rudder angle in radians

    % ODE function based on 'nomoto_ode1'
    function vd = nomoto_ode1(t, v)
        % Calculate the yaw rate derivative (scalar value)
        vd = K * delta * exp(-t / T) / T;
    end

    % Solve ODE
    [~, v_nomoto] = ode45(@(t, v) nomoto_ode1(t, v), t, 0);

    % Extract yaw rate
    rp_nomoto1 = v_nomoto;

    % Step 1: Compute yaw angle (psi)
    psi_nomoto1 = cumsum(rp_nomoto1) .* dt;

    % Step 2: Calculate x and y positions based on yaw angle
    x_nomoto = zeros(1, length(t));
    y_nomoto = zeros(1, length(t));

    % Calculate x and y positions
    for i = 2:length(t)
        x_nomoto(i) = x_nomoto(i - 1) + cos(psi_nomoto1(i)) * dt;
        y_nomoto(i) = y_nomoto(i - 1) + sin(psi_nomoto1(i)) * dt;
    end
end
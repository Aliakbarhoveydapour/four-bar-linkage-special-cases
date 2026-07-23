% Aliakbar Hoveydapoyr : Four-Bar Linkage Special Cases
% Lengths: 4, 4, 10, 10
clear; clc; close all;

%% Figure Setup
% Create a large figure for the 2x2 grid
fig = figure('Name', 'Four-Bar Linkage Special Cases', 'Position', [100, 50, 1000, 800]);
set(fig, 'Color', 'w');

% Shared angle array for drawing dashed reference circles
th_circle = linspace(0, 2*pi, 100);

%% ---------------- Subplot 1: (a) Parallelogram ----------------
subplot(2,2,1); hold on; axis equal; grid on;
axis([-6 16 -12 12]); title('(a) Parallelogram Form');
% Draw reference circles
plot(4*cos(th_circle), 4*sin(th_circle), 'k--', 'Color', [0.5 0.5 0.5]); 
plot(10+4*cos(th_circle), 4*sin(th_circle), 'k--', 'Color', [0.5 0.5 0.5]);
% Draw Ground
plot([0 10], [0 0], 'k^-', 'MarkerSize', 8, 'MarkerFaceColor', 'k');
% Initialize Linkage plot object
link_a = plot([0 0 0 0], [0 0 0 0], 'ro-', 'LineWidth', 2, 'MarkerFaceColor', 'w');

%% ---------------- Subplot 2: (b) Antiparallelogram ----------------
subplot(2,2,2); hold on; axis equal; grid on;
axis([-6 16 -12 12]); title('(b) Antiparallelogram Form');
% Draw reference circles
plot(4*cos(th_circle), 4*sin(th_circle), 'k--', 'Color', [0.5 0.5 0.5]);
plot(10+4*cos(th_circle), 4*sin(th_circle), 'k--', 'Color', [0.5 0.5 0.5]);
% Draw Ground
plot([0 10], [0 0], 'k^-', 'MarkerSize', 8, 'MarkerFaceColor', 'k');
% Initialize Linkage plot object
link_b = plot([0 0 0 0], [0 0 0 0], 'ro-', 'LineWidth', 2, 'MarkerFaceColor', 'w');

%% ---------------- Subplot 3: (c) Double-parallelogram ----------------
subplot(2,2,3); hold on; axis equal; grid on;
axis([-6 22 -12 12]); title('(c) Double-parallelogram (Pure Translation)');
% Ground Geometry (Distance between pivots is exactly 10: sqrt(8^2+6^2)=10)
g1x = 0;  g1y = 0; 
g2x = 8;  g2y = -6; 
g3x = 16; g3y = 0;
% Draw dashed reference circles (radius 4)
plot(g1x + 4*cos(th_circle), g1y + 4*sin(th_circle), 'k--', 'Color', [0.5 0.5 0.5]);
plot(g2x + 4*cos(th_circle), g2y + 4*sin(th_circle), 'k--', 'Color', [0.5 0.5 0.5]);
plot(g3x + 4*cos(th_circle), g3y + 4*sin(th_circle), 'k--', 'Color', [0.5 0.5 0.5]);
% Draw ground dashed lines forming the base triangle and pivot markers
plot([g1x, g2x, g3x, g1x], [g1y, g2y, g3y, g1y], 'k--', 'Color', [0.5 0.5 0.5], 'LineWidth', 1);
plot([g1x, g2x, g3x], [g1y, g2y, g3y], 'k^', 'MarkerSize', 8, 'MarkerFaceColor', 'k');
% Initialize moving parts
crank_c1 = plot([g1x, g1x+4], [g1y, g1y], 'ro-', 'LineWidth', 2, 'MarkerFaceColor', 'w');
crank_c2 = plot([g2x, g2x+4], [g2y, g2y], 'ro-', 'LineWidth', 2, 'MarkerFaceColor', 'w');
crank_c3 = plot([g3x, g3x+4], [g3y, g3y], 'ro-', 'LineWidth', 2, 'MarkerFaceColor', 'w');
% Coupler (translucent red patch) and joint markers
coupler_c = patch([g1x g2x g3x], [g1y g2y g3y], 'r', 'FaceAlpha', 0.3, 'EdgeColor', 'r', 'LineWidth', 2);
joints_c = plot([g1x g2x g3x], [g1y g2y g3y], 'ro', 'MarkerSize', 6, 'MarkerFaceColor', 'w');

%% ---------------- Subplot 4: (d) Kite ----------------
subplot(2,2,4); hold on; axis equal; grid on;
axis([-8 16 -12 12]); title('(d) Deltoid or Kite Form');
% Draw reference circles (Ground is 4. Left circle radius 4, right circle radius 10)
plot(4*cos(th_circle), 4*sin(th_circle), 'k--', 'Color', [0.5 0.5 0.5]);
plot(4+10*cos(th_circle), 10*sin(th_circle), 'k--', 'Color', [0.5 0.5 0.5]);
% Draw Ground
plot([0 4], [0 0], 'k^-', 'MarkerSize', 8, 'MarkerFaceColor', 'k');
% Initialize Linkage plot object
link_d = plot([0 0 0 0], [0 0 0 0], 'ro-', 'LineWidth', 2, 'MarkerFaceColor', 'w');

%% ================== GIF Export Setup ==================
gif_filename = 'animation.gif';   % Output file name
save_gif = true;                  % Set to false to disable GIF export
gif_frame_skip = 3;                % Only capture every Nth frame (keeps file size down)

%% ================== Animation Loop ==================
% Adding a tiny offset (0.001) to angles to avoid the exact mathematical 
% singularity  occurs at change points (when links become perfectly flat)
angles = linspace(0.001, 8*pi + 0.001, 400); 

for i = 1:length(angles)
    th = angles(i);
    
    % --- Update (a) Parallelogram: a=4, b=10, c=4, d=10. Mode = 1 (Open) ---
    [xa, ya] = solve_fourbar(4, 10, 4, 10, th, 1);
    if ~isempty(xa), set(link_a, 'XData', xa, 'YData', ya); end
    
    % --- Update (b) Antiparallelogram: a=4, b=10, c=4, d=10. Mode = -1 (Crossed) ---
    [xb, yb] = solve_fourbar(4, 10, 4, 10, th, -1);
    if ~isempty(xb), set(link_b, 'XData', xb, 'YData', yb); end
    
    % --- Update (c) Double-parallelogram (Pure Translation) ---
    dx = 4 * cos(th);  dy = 4 * sin(th);
    c1x = g1x + dx;    c1y = g1y + dy;
    c2x = g2x + dx;    c2y = g2y + dy;
    c3x = g3x + dx;    c3y = g3y + dy;
    % Update the 3 cranks
    set(crank_c1, 'XData', [g1x, c1x], 'YData', [g1y, c1y]);
    set(crank_c2, 'XData', [g2x, c2x], 'YData', [g2y, c2y]);
    set(crank_c3, 'XData', [g3x, c3x], 'YData', [g3y, c3y]);
    % Update the triangular Coupler and its joints
    set(coupler_c, 'XData', [c1x, c2x, c3x], 'YData', [c1y, c2y, c3y]);
    set(joints_c, 'XData', [c1x, c2x, c3x], 'YData', [c1y, c2y, c3y]);
    
    % --- Update (d) Kite / Deltoid: a=4, b=10, c=10, d=4. Mode = 1 ---
    [xd, yd] = solve_fourbar(4, 10, 10, 4, th, 1);
    if ~isempty(xd), set(link_d, 'XData', xd, 'YData', yd); end
    
    % Render the current frame
    drawnow;

    % --- Capture frame for GIF export ---
    if save_gif && mod(i, gif_frame_skip) == 0
        frame = getframe(fig);
        im = frame2im(frame);
        [imind, cm] = rgb2ind(im, 256);
        if i == gif_frame_skip
            % First captured frame: create the file
            imwrite(imind, cm, gif_filename, 'gif', ...
                'Loopcount', inf, 'DelayTime', 0.02);
        else
            % Subsequent frames: append
            imwrite(imind, cm, gif_filename, 'gif', ...
                'WriteMode', 'append', 'DelayTime', 0.02);
        end
    end

    pause(0.02); 
end

if save_gif
    fprintf('Animation saved to %s\n', gif_filename);
end

%% ================== Kinematics Function ==================
function [x, y] = solve_fourbar(a, b, c, d, th2, mode)
    % Calculates the X and Y coordinates of the 4 joints of the linkage
    % mode = 1 for open assembly, mode = -1 for crossed assembly
    
    % Ground joints
    x1 = 0; y1 = 0;
    x4 = d; y4 = 0;
    
    % Crank joint A
    x2 = a * cos(th2);
    y2 = a * sin(th2);
    
    % Distance from A to O4
    D = sqrt((x4 - x2)^2 + (y4 - y2)^2);
    
    % Check if linkage can physically connect
    if D > (b + c) || D < abs(b - c)
        x = []; y = [];
        return;
    end
    
    % Angle of the line connecting A to O4
    phi = atan2(y4 - y2, x4 - x2);
    
    % Internal angle beta using the Law of Cosines
    cos_beta = (b^2 + D^2 - c^2) / (2 * b * D);
    
    % Constrain floating point errors between -1 and 1
    cos_beta = max(min(cos_beta, 1), -1);
    beta = acos(cos_beta);
    
    % Two solutions for the coupler angle th3 based on assembly mode
    if mode == 1
        th3 = phi - beta; % Open configuration
    else
        th3 = phi + beta; % Crossed configuration
    end
    
    % Coupler joint B
    x3 = x2 + b * cos(th3);
    y3 = y2 + b * sin(th3);
    
    % Return coordinate arrays
    x = [x1, x2, x3, x4];
    y = [y1, y2, y3, y4];
end
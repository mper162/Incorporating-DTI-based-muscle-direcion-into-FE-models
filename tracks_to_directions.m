clear all; close all; clc;

%% Read output file from MRTrix tractography algorithm (.tck file)

% Enter muscle name and run :-)
muscle = 'sol';

folder = 'C:\Users\ac129847\Documents\Dokumente\00_projects\NZ\model\20230221\tractography\';
f_name = 'gm_tracktography.tck';
tracks = read_mrtrix_tracks(f_name);

%% Calculate directions and midpoints from tracks
n_tracks = length(tracks.data);

% Add directions and midpoints to tracks structure
tracks.directions = [];
tracks.midpoints = [];

% Iterate over all tracks
for n = 1:n_tracks
    t = tracks.data(n);
    coords = t{1,1}; % Access the coordinates of the points
    n_directions = length(coords)-1; % Total number of directions is number of points - 1
    tracks.directions{n} = zeros(n_directions, 3);
    tracks.midpoints{n} = zeros(n_directions, 3);
    for i = 1:n_directions
        d = coords(i+1,:) - coords(i,:); % Direction vector
        l = norm(d); % Length of direction vector
        u = d * 1/l; % Unit direction
        tracks.midpoints{n}(i,:) = coords(i,:) + 0.5*l*u; % Midpoint calculation

        % Check for negative z-direction (fiber orientation from proximal to distal)
        if u(3) >= 0
            u = -u;
        end
        tracks.directions{n}(i,:) = u;
        
        % TODO: Save directions and midpoints to .tck file?
    end
end

directions = cell2mat(tracks.directions');
midpoints = cell2mat(tracks.midpoints');
tracks_coords = cat(3, directions, midpoints);

save("tracks_coords.mat", "tracks_coords");

%% Visualize midpoints together with original track points
% n_plots = 10;
% for i = 1:n_plots
%     figure;
%     hold on;
%     idx = randi([1,n_tracks]);  
%     scatter3(tracks.midpoints{idx}(:,1), tracks.midpoints{idx}(:,2), tracks.midpoints{idx}(:,3));
%     scatter3(tracks.data{idx}(:,1), tracks.data{idx}(:,2), tracks.data{idx}(:,3));
%     view(3);
%     axis equal
%     legend({'Mid points', 'Track points'})
% end

%% Visualize vector field of directions
figure;
quiver3(midpoints(:,1), midpoints(:,2), midpoints(:,3), directions(:,1), directions(:,2), directions(:,3));
axis equal

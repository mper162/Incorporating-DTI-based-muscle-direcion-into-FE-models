clear all; close all; clc;

% Enter muscle name and run :-)
muscle = 'gl';
knn = 10; % Number of nearest neigbors = number of track points and directions to be averaged over

% Folder and file names of dti and element results
% dti_folder = 'C:\Users\ac129847\Documents\Dokumente\00_projects\NZ\model\20230221\tractography\';
% elem_folder = 'C:\Users\ac129847\Documents\Dokumente\00_projects\NZ\model\20230221\febio_elements\';
dti_name = 'tracks_coords.mat';
elem_name = 'elem_coords.mat';
% tform_name = 'diff2struct_mrtrix.txt';

load(dti_name); 
load(elem_name);

track_directions = tracks_coords(:,:,1);
track_points = tracks_coords(:,:,2);
%track_points(:,1) = -track_points(:,1);
%track_points(:,2) = -track_points(:,2);

% Read transformation matrix to transform track points to FEBio elements
% tform = readTform(strcat(dti_folder, tform_name));
% track_points = cat(2, track_points, ones(length(track_points),1));
% track_points_t = inv(tform) * track_points';
% track_points_t = track_points_t';
% track_points_t = track_points_t(:,1:3);

track_points_t = track_points ; % my edit
%% Visualize
figure;
hold on;
scatter3(elems_center_coords(:,1), elems_center_coords(:,2), elems_center_coords(:,3));
%scatter3(track_points(:,1), track_points(:,2), track_points(:,3));
scatter3(track_points_t(:,1), track_points_t(:,2), track_points_t(:,3));
view(3);
axis equal
legend({'FEBio', 'Tracks', 'Tracks transformed'});

%% Perform knn search
idx = knnsearch(track_points_t, elems_center_coords, "K", knn);

% Find directions from indices and assign them to the elements for all knn neighbors
n_elems = length(elems_center_coords);
elem_directions = zeros(n_elems, 3, knn);
for i = 1:n_elems
    for k = 1:knn
        elem_directions(i,:,k) = track_directions(idx(i,k),:);
    end
end

% Average over all knn neighbors
mean_elem_directions = mean(elem_directions,3);

% Write FEBio input file for fiber orientation
fibo_file = fopen('_fibo.txt', 'w');
for i = 1:n_elems
   fprintf(fibo_file, strcat('\t\t','<elem lid="', string(i), '">', string(mean_elem_directions(i,1)), ',', string(mean_elem_directions(i,2)), ',', string(mean_elem_directions(i,3)), '</elem> \n')); 
end
fclose(fibo_file);

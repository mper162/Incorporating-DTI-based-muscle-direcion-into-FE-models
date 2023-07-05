clear all; close all; clc;

% Enter muscle name and run :-)
muscle = 'sol';

%folder = 'C:\Users\ac129847\Documents\Dokumente\00_projects\NZ\model\20230221\febio_elements\';

%folder  = 'Macintosh HD:\Users\mper162\Desktop\dsi_workspace\2023\FEBIO_Forum\1.1.Real_Geometry-June\4.DTI_post_process\Manuela\Randika\';
f_nodes = 'nodes_list_MG.txt';
f_elems = 'element_list_MG.txt';

%[nodes, node_id] = readFEBioText(strcat(folder, f_nodes), '<node id="', '</node>');

[nodes, node_id]  = readFEBioText(f_nodes, '<node id="', '</node>');
[elems,  elem_id] = readFEBioText(f_elems, '<elem id="', '</elem>');

elems_coords = zeros(length(elems),3,4);
for i = 1:length(elems)
    for e = 1:4
        elems_coords(i,:,e) = nodes(elems(i,e)-node_id+1,:);
    end
end

elems_center_coords = squeeze(mean(elems_coords, 3));
save('elem_coords.mat', "elems_center_coords");

% Plot element center coordinates
figure;
scatter3(elems_center_coords(:,1), elems_center_coords(:,2), elems_center_coords(:,3))
view(3);
axis equal



function [Borders_cell, n_borders]=Find_Borders_2D_Map_2(map_input,x_var,y_var,threshold_lo,threshold_hi)
%Given a 2D input map (e.g. 2D topo Z map) with its x and y coordinates, outputs a 3D matrix Borders_matrix
%containing the parametric curves of the borders within the map. The size
%of the matrix is n_parameter x 3 (parameter|x|y) x n_borders. The
%threshold is a user input defining the boundary of the border.

[a,b]=find(map_input > threshold_lo & map_input < threshold_hi);
temp=zeros(size(map_input));

for i=1:length(a)
    temp(a(i),b(i))=1;
end

temp_logical=logical(temp);
Borders_cell = bwboundaries(imfill(temp_logical,'holes'));
%size(boundaries{1})

n_borders=length(Borders_cell);

figname='Boundary finder';
figure ('Name', figname);
subplot(1,2,1);
imagesc(x_var, y_var, map_input');
title('Original');
axis xy;
axis image;
ylabel('y [m]');
xlabel('x [m]');
%zlim([min(min(I_A_map)) max(max(I_A_map))]);
colorbar;

subplot(1,2,2);
imagesc(x_var, y_var, map_input');
title('Boundary');
axis xy;
axis image;
ylabel('y [m]');
xlabel('x [m]');
%zlim([min(min(I_A_map)) max(max(I_A_map))]);
colorbar;
hold on;

for i=1:n_borders
    plot(y_var(Borders_cell{i}(:,1)),x_var(Borders_cell{i}(:,2)),'--k','LineWidth',3);
end

end
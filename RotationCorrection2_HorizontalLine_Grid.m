function [Grid_output, x_var_new, y_var_new]=RotationCorrection2_HorizontalLine_Grid...
    (Grid_input, x_var, y_var,x_rotation_center, y_rotation_center, x1,y1, x2,y2)
%Spatially rotates the 3D grid (I(V)) map_input by the angle (in rad) 
%such that a desired feature is horizontal. The angle is positive if the
% rotation to render the line horizontal is counterclockwise.

Grid_output=Grid_input;
%angle_rad=((-90+angle))*pi/180;
angle_rad=-atan((y2-y1)/(x2-x1));
R=[cos(angle_rad) sin(angle_rad);-sin(angle_rad) cos(angle_rad)];

 %[x_mesh, y_mesh]=meshgrid(-x_var,y_var);

nx=length(x_var);
Lx=x_var(nx)-x_var(1);
delta_x=(x_var(nx)-x_var(1))/(nx-1);
x_var_new=linspace(-Lx/2,Lx/2,nx);

ny=length(y_var);
Ly=y_var(ny)-y_var(1);
delta_y=(y_var(ny)-y_var(1))/(ny-1);
y_var_new=linspace(-Ly/2,Ly/2,ny);

%For each new set of indexes (i,j) in the new coordinate system, we need to find the old set of indexes corresponding to the considered position in the old set 
% of coordinates. The indexes of this old position are then derived, and
%the new map value is related to the old map value at these indexes.
for i=1:nx
    for j=1:ny
        temp=R*[x_var_new(i);y_var_new(j)];
        x_old=x_rotation_center+temp(1);
        y_old=y_rotation_center+temp(2);
        i_old=round(((x_old-x_var_new(1))/delta_x)+1);
        j_old=round(((y_old-y_var_new(1))/delta_y)+1);
        if (i_old >= 1) && (i_old <= nx) && (j_old >= 1) && (j_old <= ny)
            Grid_output(:,i,j)=Grid_input(:,i_old,j_old);
        else
            Grid_output(:,i,j)=0;
        end
        %x_old=x_rotation_center+x_var_new(i)*cos(angle_rad)+y_var_new(j)*sin(angle_rad);
        %y_old=y_rotation_center+x_var_new(i)*(-sin(angle_rad))+y_var_new(j)*cos(angle_rad);
        %map_output(i,j)=interp2(x_mesh,y_mesh,map_input,x_old,y_old,'linear', 0);
    end
end

[a,b,c]=size(Grid_input);
temp_input=zeros(b,c);
temp_input(:,:)=Grid_input(round(a/2),:,:);
temp_output=zeros(b,c);
temp_output(:,:)=Grid_output(round(a/2),:,:);

figname='Rotation correction';
figure ('Name', figname);
subplot(1,2,1);
imagesc(x_var, y_var, temp_input');
title('Original (non-corrected)');
axis xy;
axis image;
ylabel('y [m]');
xlabel('x [m]');
%zlim([min(min(I_A_map)) max(max(I_A_map))]);
colorbar;

subplot(1,2,2);
imagesc(x_var_new, y_var_new, temp_output');
title('Rotation corrected');
axis xy;
axis image;
ylabel('y [m]');
xlabel('x [m]');
%zlim([0,0.2]);
colorbar;

end
% grid_bias_slice.m

% Katherine Cochrane
% November 2016


function[slice]=grid_bias_slice(V_input,Bias_V,grid_data,x_var,y_var,incomplete);
%%
%%%%%INPUTS
%  V_input= bias you would like your map at Bias_V= bias vector
%  (typically V in code I have written..) 
%  grid data = 3D matrix of data you would like to see 
%  xvar, y_var = x and y variables corresponding to the grid data 
%  incomplete = if the grid is complete,this will be zero. 
%     However if the grid is incomplete (or if you only
%     want part of the grid to plot, this will be the line you want the
%     movie to go to, ie if the grid took 80 lines out of 128, then
%     incomplete would be 79)

%example input parameters
%     V_input = 1.2;
%     Bias_V=V;
%     grid_data=IV.norm_dIdV_offset_smooth;
%     x_var=x;
%     y_var=y;
%     incomplete=79;

%%%%% OUTPUTS
    % slice = a 2d matrix at the input bias
    % ... a map!

    %%
    

vmax=max(Bias_V);
vmin=min(Bias_V);
step=(vmax-vmin)./(length(Bias_V)-1);
voltage=[-vmin:step:(vmax-step)];
n_points=length(Bias_V);
delta_Bias_V=(Bias_V(n_points)-Bias_V(1))/(n_points-1);
V_index=round((V_input-Bias_V(1))/delta_Bias_V)+1;
if incomplete==0
    slice=squeeze(grid_data(V_index,:,:));
    figure
    imagesc(x,y,slice');

else
slice=squeeze(grid_data(V_index,:,1:incomplete));
    figure
    imagesc(x_var,y_var(1:incomplete),slice');
end


axis xy
title('Mask');
axis image;
ylabel('y [m]');
xlabel('x [m]');


end
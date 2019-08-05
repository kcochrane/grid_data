%offset_IV_normalization.m
%use IV_grid_load_function first



%function [Bias_V, dIdV_smooth, norm_dIdV_smooth, norm] = offset_IV_normalization_function(x, y, V, Z_plane, )





V_input=V_mask;
  x_var=x;
    y_var=y;
    nV_smooth=3;
    nx_smooth=5;
    ny_smooth=nx_smooth;
    Bias_V=V;  
    I_grid=I_corrected;

    
vmax=max(Bias_V);
vmin=min(Bias_V);
step=(vmax-vmin)./(length(Bias_V)-1);
voltage=[-vmin:step:(vmax-step)];
%mov(length(voltage)-1) = struct('cdata',[],'colormap',[]);

    climsI=[0 5e-10];
    climsdIdV=[0 1e-9];
    climsnorm=[5 25];
    
    
dV=diff(V);
I_smooth_extreme=smooth(I_mask_average,3);
dI=diff(I_mask_average');
dIdV=dI./dV;
dIdV_smooth=smooth(dIdV,n);
norm_dIdV=dIdV_smooth./sqrt((I_smooth_extreme(1:length(dIdV_smooth))./V(1:length(dIdV_smooth))).^2 + C^2);
norm_dIdV_smooth=smooth(norm_dIdV,n);

norm = sqrt((I_smooth_extreme(1:length(dIdV_smooth))./V(1:length(dIdV_smooth))).^2 + C^2);
    %end
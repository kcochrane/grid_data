function ...
    [Bias_V_dI_dV,dI_dV_A_V_in, dI_dV_I_V_norm_in, border_cell]=...
    Find_Borders_Zone_dI_dV_2D_Topo_2...
    (topo_input,x_var_topo,y_var_topo,x1_lim, x2_lim, y1_lim, y2_lim,thres,...
    I_grid, Bias_V, nV_smooth)
    %I_grid, Bias_V, x_m_var_STS, y_m_var_STS,nV_smooth)
%Given a 2D input topo map  and a 3D matrix containing I(x,y,V), finds the topo
%border in the area defined by [x1_lim, y1_lim] and [x2_lim, y2_lim], and
%averages the STS spectra (dI/dV and dI/dV/(I/V))therein. 
%The threshold (in m) determines the boundary. 
%Here, I_grid needs to have same spatial dimensions as topo_input!!!!

I_grid_smooth=smooth3(I_grid, 'box', [nV_smooth 1 1]);

delta_x_topo=(x_var_topo(length(x_var_topo))-x_var_topo(1))/(length(x_var_topo)-1);
delta_y_topo=(y_var_topo(length(y_var_topo))-y_var_topo(1))/(length(y_var_topo)-1);
i1=round((x1_lim-x_var_topo(1))/delta_x_topo+1);
j1=round((y1_lim-y_var_topo(1))/delta_y_topo+1);
i2=round((x2_lim-x_var_topo(1))/delta_x_topo+1);
j2=round((y2_lim-y_var_topo(1))/delta_y_topo+1);
sub_topo=topo_input(i1:i2,j1:j2);
[a,b]=find(sub_topo > thres);

temp_topo=zeros(size(topo_input));
%temp_STS_in=zeros(length(x_m_var_STS),length(y_m_var_STS));

%nx_STS=floor(length(x_var_topo)/length(x_m_var_STS));%number of pixels after which a spectrum is taken
%ny_STS=floor(length(y_var_topo)/length(y_m_var_STS));

n_points=length(Bias_V);
Bias_V_dI_dV=Bias_V(2:n_points);
I_A_smoothed_in=zeros(length(Bias_V),1);

for i=1:length(a)
    x_index_topo=min(i1,i2)+a(i)-1;
    y_index_topo=min(j1,j2)+b(i)-1;
    %x_index_STS=1+round(x_index_topo/nx_STS);
    %y_index_STS=1+round(y_index_topo/ny_STS);
    temp_topo(x_index_topo,y_index_topo)=1;
   % temp_STS_in(x_index_STS,y_index_STS)=1;
    for j=1:length(Bias_V)
        I_A_smoothed_in(j)=I_A_smoothed_in(j)+...
            I_grid_smooth(j,x_index_topo,y_index_topo);        
    end
end

I_A_smoothed_in=I_A_smoothed_in/length(a);
dI_dV_A_V_in=diff(I_A_smoothed_in)./diff(Bias_V);
dI_dV_I_V_norm_in=dI_dV_A_V_in./(I_A_smoothed_in(2:n_points)./Bias_V(2:n_points));

temp_logical=logical(temp_topo);
border_cell = bwboundaries(imfill(temp_logical,'holes'));
n_borders=length(border_cell);

figname='Point STS in specific topographic area';
figure ('Name', figname);
subplot(2,2,1);
imagesc(x_var_topo, y_var_topo, topo_input');
title('Topography');
axis xy;
axis image;
ylabel('y [m]');
xlabel('x [m]');
%zlim([min(min(I_A_map)) max(max(I_A_map))]);
colorbar;
hold on;

for i=1:n_borders
    plot(y_var_topo(border_cell{i}(:,1)),x_var_topo(border_cell{i}(:,2)),'--r','LineWidth',1);
end
hold off;

subplot(2,2,3);
plot(Bias_V_dI_dV, dI_dV_A_V_in,'-r','LineWidth',2);
title('dI/dV');
xlabel('Bias [V]');
ylabel('dI/dV [A/V]');


subplot(2,2,4);
plot(Bias_V_dI_dV, dI_dV_I_V_norm_in,'-r','LineWidth',2);
title('(dI/dV)/(I/V)');
xlabel('Bias [V]');
ylabel('(dI/dV)/(I/V)');

subplot(2,2,2);
plot(Bias_V, I_A_smoothed_in,'-r','LineWidth',2);
title('I(V)');
xlabel('Bias [V]');
ylabel('I(V)');

end
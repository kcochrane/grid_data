function ...
    [I_A_smoothed_topo_border,dI_dV_A_V_topo_border, ...
    dI_dV_I_V_norm_topo_border,I_A_smoothed_STS_border,dI_dV_A_V_STS_border,...
    Bias_V_dI_dV,dI_dV_I_V_norm_STS_border,border_cell_topo,border_cell_STS_map]=...
    Find_Borders_Zone_dI_dV_2D_STSmap...
    (topo_input,x_var_topo,y_var_topo,x1_lim, x2_lim, y1_lim, y2_lim,...
    thres_STS_min,thres_STS_max,thres_topo,I_grid, Bias_V, STS_input,...
    x_m_var_STS, y_m_var_STS,nV_smooth)
%Given a 2D input STS map  and a 3D matrix containing I(x,y,V), finds the
%topo and STS borders in the area defined by [x1_lim, y1_lim] and [x2_lim, y2_lim] , and
%averages the STS spectra (dI/dV and dI/dV/(I/V))therein. 
%thres_STS_min,thres_STS_max determines the threshold boundary in the STS map.
% thres_topo determines the threshold boundary in the topo map.
% Draws the borders in the STS map and corresponding topo map.

I_grid_smooth=smooth3(I_grid, 'box', [nV_smooth 1 1]);
nx_STS=floor(length(x_var_topo)/length(x_m_var_STS));%number of pixels after which a spectrum is taken
ny_STS=floor(length(y_var_topo)/length(y_m_var_STS));

delta_x_topo=(x_var_topo(length(x_var_topo))-x_var_topo(1))/(length(x_var_topo)-1);
delta_y_topo=(y_var_topo(length(y_var_topo))-y_var_topo(1))/(length(y_var_topo)-1);
i1=round((x1_lim-x_var_topo(1))/delta_x_topo+1);
j1=round((y1_lim-y_var_topo(1))/delta_y_topo+1);
i2=round((x2_lim-x_var_topo(1))/delta_x_topo+1);
j2=round((y2_lim-y_var_topo(1))/delta_y_topo+1);
sub_topo=topo_input(i1:i2,j1:j2);
[a_topo,b_topo]=find(sub_topo > thres_topo);

i1_STS=round(i1/nx_STS)+1;
i2_STS=round(i2/nx_STS)+1;
j1_STS=round(j1/ny_STS)+1;
j2_STS=round(j2/ny_STS)+1;
sub_STS_map=STS_input(i1_STS:i2_STS,j1_STS:j2_STS);
[a_STS,b_STS]=find(sub_STS_map > thres_STS_min & sub_STS_map < thres_STS_max);

temp_topo_border_topo=zeros(size(topo_input)); %binary matrix for topo border
temp_STS_border_topo=zeros(size(STS_input));%binary matrix for topo border
temp_topo_border_STS=zeros(size(topo_input));%binary matrix for STS border
temp_STS_border_STS=zeros(size(STS_input));%binary matrix for STS border

n_points=length(Bias_V);
Bias_V_dI_dV=Bias_V(2:n_points);
I_A_smoothed_topo_border=zeros(length(Bias_V),1);
I_A_smoothed_STS_border=zeros(length(Bias_V),1);

for i=1:length(a_topo)
    x_index_topo=min(i1,i2)+a_topo(i)-1;
    y_index_topo=min(j1,j2)+b_topo(i)-1;
    x_index_STS=1+round(x_index_topo/nx_STS);
    y_index_STS=1+round(y_index_topo/ny_STS);
    temp_topo_border_topo(x_index_topo,y_index_topo)=1;
    temp_STS_border_topo(x_index_STS,y_index_STS)=1;
    for j=1:length(Bias_V)
        I_A_smoothed_topo_border(j)=...
            I_A_smoothed_topo_border(j)+I_grid_smooth(j,x_index_STS,y_index_STS);        
    end
end

I_A_smoothed_topo_border=I_A_smoothed_topo_border/length(a_topo);
dI_dV_A_V_topo_border=diff(I_A_smoothed_topo_border)./diff(Bias_V);
dI_dV_I_V_norm_topo_border=dI_dV_A_V_topo_border./(I_A_smoothed_topo_border(2:n_points)./Bias_V(2:n_points));

temp_logical=logical(temp_topo_border_topo);
border_cell_topo = bwboundaries(imfill(temp_logical,'holes'));
n_borders_topo=length(border_cell_topo);

for i=1:length(a_STS)
    x_index_STS=min(i1_STS,i2_STS)+a_STS(i)-1;
    y_index_STS=min(j1_STS,j2_STS)+b_STS(i)-1;
    x_index_topo=(x_index_STS-1)*nx_STS+1;
    y_index_topo=(y_index_STS-1)*ny_STS+1;
    temp_topo_border_STS(x_index_topo,y_index_topo)=1;
    temp_STS_border_STS(x_index_STS,y_index_STS)=1;
    for j=1:length(Bias_V)
        I_A_smoothed_STS_border(j)=...
            I_A_smoothed_STS_border(j)+I_grid_smooth(j,x_index_STS,y_index_STS);        
    end
end

I_A_smoothed_STS_border=I_A_smoothed_STS_border/length(a_STS);
dI_dV_A_V_STS_border=diff(I_A_smoothed_STS_border)./diff(Bias_V);
dI_dV_I_V_norm_STS_border=dI_dV_A_V_STS_border./(I_A_smoothed_STS_border(2:n_points)./Bias_V(2:n_points));

temp_logical=logical(temp_STS_border_STS);
border_cell_STS_map = bwboundaries(imfill(temp_logical,'holes'));
n_borders_STS=length(border_cell_STS_map);

figname='Point STS in specific topographic and STS area';
figure ('Name', figname);
subplot(2,6,1:3);
clims1=min(min(topo_input(i1:i2,j1:j2)));
clims2=max(max(topo_input(i1:i2,j1:j2)));
clims=[clims1 clims2];
imagesc(x_var_topo, y_var_topo, topo_input', clims);
title('Topography');
axis xy;
axis image;
axis([x1_lim x2_lim y1_lim y2_lim])
ylabel('y [m]');
xlabel('x [m]');
%zlim([min(min(I_A_map)) max(max(I_A_map))]);
colorbar;
hold on;
%colormap(gray(256));

for i=1:n_borders_topo
    plot(y_var_topo(border_cell_topo{i}(:,1)),x_var_topo(border_cell_topo{i}(:,2)),'--k','LineWidth',1.5);
end
for i=1:n_borders_STS
    plot(y_m_var_STS(border_cell_STS_map{i}(:,1)),x_m_var_STS(border_cell_STS_map{i}(:,2)),'--w','LineWidth',1.5);
end
hold off;

subplot(2,6,4:6);
clims1=min(min(STS_input(i1_STS:i2_STS,j1_STS:j2_STS)));
clims2=max(max(STS_input(i1_STS:i2_STS,j1_STS:j2_STS)));
clims=[clims1 clims2];
imagesc(x_m_var_STS, y_m_var_STS, STS_input', clims);
title('STS');
axis xy;
axis image;
axis([x1_lim x2_lim y1_lim y2_lim])
ylabel('y [m]');
xlabel('x [m]');
%zlim([min(min(I_A_map)) max(max(I_A_map))]);
colorbar;
hold on;
colormap(jet(256));

for i=1:n_borders_topo
    plot(y_var_topo(border_cell_topo{i}(:,1)),x_var_topo(border_cell_topo{i}(:,2)),'--k','LineWidth',1.5);
end
for i=1:n_borders_STS
    plot(y_m_var_STS(border_cell_STS_map{i}(:,1)),x_m_var_STS(border_cell_STS_map{i}(:,2)),'--w','LineWidth',1.5);
end
hold off;

subplot(2,6,7:8);
plot(Bias_V, I_A_smoothed_topo_border,'-r','LineWidth',2);
hold on;
plot(Bias_V, I_A_smoothed_STS_border,'-g','LineWidth',2);
title('I(V)');
xlabel('Bias [V]');
ylabel('I(V)');
hold off;

subplot(2,6,9:10);
plot(Bias_V_dI_dV, dI_dV_A_V_topo_border,'-r','LineWidth',2);
hold on;
plot(Bias_V_dI_dV, dI_dV_A_V_STS_border,'-g','LineWidth',2);
title('dI/dV');
xlabel('Bias [V]');
ylabel('dI/dV [A/V]');
hold off;


subplot(2,6,11:12);
plot(Bias_V_dI_dV, dI_dV_I_V_norm_topo_border,'-r','LineWidth',2);
hold on;
plot(Bias_V_dI_dV, dI_dV_I_V_norm_STS_border,'-g','LineWidth',2);
title('(dI/dV)/(I/V)');
xlabel('Bias [V]');
ylabel('(dI/dV)/(I/V)');
hold off;

figname='Logical maps';
figure ('Name', figname);
subplot(2,2,1);
imagesc(x_var_topo, y_var_topo, temp_topo_border_topo');
title('Topography');
axis xy;
axis image;
axis([x1_lim x2_lim y1_lim y2_lim])
ylabel('y [m]');
xlabel('x [m]');
%zlim([min(min(I_A_map)) max(max(I_A_map))]);
colorbar;
colormap(gray);

subplot(2,2,2);
imagesc(x_var_topo, y_var_topo, temp_STS_border_topo');
title('STS map');
axis xy;
axis image;
axis([x1_lim x2_lim y1_lim y2_lim])
ylabel('y [m]');
xlabel('x [m]');
%zlim([min(min(I_A_map)) max(max(I_A_map))]);
colorbar;
colormap(gray);

subplot(2,2,3);
imagesc(x_m_var_STS, y_m_var_STS, temp_topo_border_STS');
title('Topo');
axis xy;
axis image;
axis([x1_lim x2_lim y1_lim y2_lim])
ylabel('y [m]');
xlabel('x [m]');
%zlim([min(min(I_A_map)) max(max(I_A_map))]);
colorbar;
colormap(gray);

subplot(2,2,4);
imagesc(x_m_var_STS, y_m_var_STS, temp_STS_border_STS');
title('STS map');
axis xy;
axis image;
axis([x1_lim x2_lim y1_lim y2_lim])
ylabel('y [m]');
xlabel('x [m]');
%zlim([min(min(I_A_map)) max(max(I_A_map))]);
colorbar;
colormap(gray);

end
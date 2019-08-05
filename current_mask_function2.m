%current_mask_function2.m
%% Katherine Cochrane
% Updated 2016


function[norm_dIdV_mask]=current_mask_function2(V_mask,threshold_mask_lo,threshold_mask_hi,IV_grid,IV,x,y,V,C,nV_smooth,nx_smooth)
% V_mask=-2;
% threshold_mask_lo=16;
% threshold_mask_hi=50;
% IV_grid=IV.IV_corrected;
% C=5e-13;
% nV_smooth=3;
% nx_smooth=3;
 ny_smooth=nx_smooth;
%%

V_input=V_mask;
  x_var=x;
    y_var=y;

    Bias_V=V;

vmax=max(Bias_V);
vmin=min(Bias_V);
step=(vmax-vmin)./(length(Bias_V)-1);
voltage=[-vmin:step:(vmax-step)];
%mov(length(voltage)-1) = struct('cdata',[],'colormap',[]);

    climsI=[0 5e-10];
    climsdIdV=[0 1e-9];
    climsnorm=[5 25];
 %v = VideoWriter('newfile.avi');
 %open(v)

%for k=1:(length(voltage)-1);
   
   % V_input=voltage(k);
%V_input=-1;
n_points=length(Bias_V);
delta_Bias_V=(Bias_V(n_points)-Bias_V(1))/(n_points-1);
V_index=round((V_input-Bias_V(1))/delta_Bias_V)+1;
IV_grid_smooth=smooth3(IV_grid, 'box', [nV_smooth nx_smooth ny_smooth]);
I_A_map(:,:)=IV_grid_smooth(V_index, :,:);

dI_dV_A_V=zeros((n_points-1),length(x_var), length(y_var));
dI_dV_I_V_norm=zeros((n_points-1),length(x_var), length(y_var));
Bias_V_dI_dV=Bias_V(2:n_points);

for i=1:length(x_var);
    for j=1:length(y_var)
       dI_dV_A_V(:,i,j)= diff(IV_grid_smooth(:,i,j))./diff(Bias_V);
       dI_dV_I_V_norm(:,i,j)=dI_dV_A_V(:,i,j)./...
           (IV_grid_smooth(2:n_points, i, j)./Bias_V_dI_dV);
    end
end

dI_dV_A_V_map(:,:)=dI_dV_A_V(V_index,:,:);
dI_dV_I_V_norm_map(:,:)=dI_dV_I_V_norm(V_index,:,:);


%%


% if strcmp(iv_didv_normdidv,'iv')==1; 
%     mask_image=I_A_map;
% elseif strcmp(iv_didv_normdidv,'didv')==1;
%     mask_image=dI_dV_A_V_map;
% elseif strcmp(iv_didv_normdidv,'normdidv')==1;
%     mask_image=dI_dV_I_V_norm_map;
% end
V_input=V_mask;
Bias_V=V;
vmax=max(Bias_V);
vmin=min(Bias_V);
step=(vmax-vmin)./(length(Bias_V)-1);
voltage=[-vmin:step:(vmax-step)];
n_points=length(Bias_V);
delta_Bias_V=(Bias_V(n_points)-Bias_V(1))/(n_points-1);
V_index=round((V_input-Bias_V(1))/delta_Bias_V)+1;

mask_image=squeeze(IV.norm_dIdV_offset_smooth(V_index,:,:));

mask=zeros(size(mask_image));


% length_x=length(IV_grid(1,:,1));
% length_y=length(IV_grid(1,1,:));

 length_x=length(x);
 length_y=length(y);


for i=1:length_x
    for j=1:length_y
        if mask_image(i,j)<threshold_mask_hi && mask_image(i,j)>threshold_mask_lo;
            mask(i,j)=1;
        else
             mask(i,j)=0;
        end
   
    end 
    
end
mask(isnan(mask)) = 0;
%%%%%% reverse mask here%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                  for j=1:90
            for i=80:150
                mask(i,j)=0;
            end
                  end
                                    for j=1:90
            for i=70:150
                mask(i,j)=0;
            end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure
imagesc(x, y, mask');
title('Mask');
axis xy;
axis image;
ylabel('y [m]');
xlabel('x [m]');


[a,b]=find(mask_image > threshold_mask_lo & mask_image < threshold_mask_hi);
temp=zeros(size(mask_image));

for i=1:length(a)
    temp(a(i),b(i))=1;
end

temp_logical=logical(temp);
Borders_cell = bwboundaries(imfill(temp_logical,'holes'));

n_borders=length(Borders_cell);

% figure
% imagesc(x_var, y_var, mask_image');
% axis xy;
% axis image;
% ylabel('y [m]');
% xlabel('x [m]');
% %zlim([0,0.2]);
% colorbar;


figure
imagesc(x_var, y_var, mask_image');
hold on;
axis xy;
axis image;
colorbar;
[B,L] = bwboundaries(mask);

for i=1:n_borders
    plot(x_var(Borders_cell{i}(:,1)),y_var(Borders_cell{i}(:,2)),'--k','LineWidth',3);
end


title('dI/dV [A/V] map');
axis xy;
axis image;
ylabel('y [m]');
xlabel('x [m]');
%zlim([0,0.2]);
colorbar;

% figure
% imagesc(x_var, y_var, Z_plane');
% hold on;
% axis xy;
% axis image;
% colormap gray
% 
% for i=1:n_borders
%     plot(x_var(Borders_cell{i}(:,1)),y_var(Borders_cell{i}(:,2)),'--r','LineWidth',3);
% end

%%




matrix_x=length(IV_grid(1,:,1));
matrix_y=length(IV_grid(1,1,:));
% l=1:matrix_x;
% k=1:matrix_y;


 l=1:length_x;
 k=1:length_y;


clims=[0 7e-10];
%{ 
    figname='Plane grid Topography';
figure ('Name', figname);
imagesc(l, k, Z_plane');
colormap(gray)
axis xy;
axis image;
ylabel('y [nm]');
xlabel('x [nm]');
colorbar;
%}

n=3;


mask_3d=zeros(length(V),matrix_x,matrix_y);

for jj=1:length(V);
    mask_3d(jj,:,:)=mask;
end

% I_mask = IV_grid.*mask_3d;
% I_mask(isnan(I_mask)) = 0;
% 
% average_dI=zeros(length(IV_grid(:,1,1)),1);
% average_y_dI=zeros(matrix_y,1);
% for i=1:512
%         for j=1:matrix_x;            
%             I_mask_loop=I_mask(i,j,:);
%             nonzero_I_mask_loop=I_mask_loop(I_mask_loop~=0);
%             average_y_I_loop=mean(nonzero_I_mask_loop);
%             average_y_I_loop(isnan(average_y_I_loop))=0;
%             average_y_I(j)=average_y_I_loop;
%         
%         end
%   %  nonzero_average_y_I=I_mask_loop(average_y_I~=0);
%     I_mask_average(i)=mean(average_y_I);
% end

I_mask = IV_grid.*mask_3d;
I_mask(isnan(I_mask)) = 0;

average_I=zeros(length(IV_grid(:,1,1)),1);
average_y_I=zeros(matrix_y,1);
for i=1:512
        for j=1:matrix_x;            
            I_mask_loop=I_mask(i,j,:);
            nonzero_I_mask_loop=I_mask_loop(I_mask_loop~=0);
            average_y_I_loop=mean(nonzero_I_mask_loop);
            average_y_I_loop(isnan(average_y_I_loop))=0;
            average_y_I(j)=average_y_I_loop;
        
        end
  %  nonzero_average_y_I=I_mask_loop(average_y_I~=0);
    I_mask_average(i)=mean(average_y_I);
end



dV=diff(V);
I_smooth_extreme=smooth(I_mask_average,11);
dI=diff(I_mask_average');
dIdV=dI./dV;
dIdV_smooth=smooth(dIdV,n);

norm_devision_offset_factor = sqrt((I_smooth_extreme./V(1:length(I_smooth_extreme))).^2 + C^2);
norm_dIdV_offset=dIdV_smooth./norm_devision_offset_factor(1:length(dIdV_smooth));
norm_dIdV_offset_smooth=smooth(norm_dIdV_offset,nV_smooth); 

figure
% subplot(1,3,1);
% plot(V(1:length(I_mask_average)),I_mask_average)
% title('I/V');
% ylabel('I/V [nA/V]');
% xlabel('Bias [V]');
% subplot(1,3,2);
% plot(V(1:length(dIdV_smooth)),dIdV_smooth)
% title('dI/dV');
% ylabel('dI/dV [nA/V]');
% xlabel('Bias [V]');
% subplot(1,3,3);
% plot(V(1:length(norm_dIdV)),norm_dIdV_offset_smooth)
% title('normalized dI/dV');
% ylabel('[dI/dV]/[I/V]');
% xlabel('Bias [V]');

plot(V(1:length(norm_dIdV_offset_smooth)),norm_dIdV_offset_smooth)

norm_dIdV_mask=norm_dIdV_offset_smooth;
%%
% 
% figure
% hold on
% [hAx,hLine1,hLine2]=plotyy(V(1:length(dIdV_smooth)),dIdV_smooth,V(1:length(norm_dIdV)),norm_dIdV_smooth);
% ylabel(hAx(1),'dI/dV [A/V]');
% ylabel(hAx(2),'[dI/dV]/[I/V]');
% xlabel('Bias [V]');

%%
end

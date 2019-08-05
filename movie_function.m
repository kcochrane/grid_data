%movie_function.m
% Katherine Cochrane
% Updated 2016
% To create a movie of omicron matrix grid spectroscopy data
% software
%%

%function[v]=movie_function(kind,x_var,y_var,nV_smooth,nxy_smooth,Bias_V,grid_data);

    kind='STS';
    x_var=x;
    y_var=y;
    nV_smooth=3;
    nxy_smooth=1;
    Bias_V=V;
    grid_data=IV.norm_dIdV_smooth_fwd;
    %%
  if strcmp(kind,'STS')==1  
      I_grid=grid_data;
    nx_smooth=nxy_smooth;
    ny_smooth=nx_smooth;
    
    

mov(length(Bias_V)-1) = struct('cdata',[],'colormap',[]);

    climsI=[0 5e-10];
    climsdIdV=[0 1e-9];
    climsnorm=[5 25];
  v = VideoWriter('newfile.avi');
  open(v)


for k=1:(length(Bias_V)-1);
    
    V_input=Bias_V(k);
%V_input=-2.3;
n_points=length(Bias_V);
delta_Bias_V=(Bias_V(n_points)-Bias_V(1))/(n_points-1);
V_index=round((V_input-Bias_V(1))/delta_Bias_V)+1;
I_grid_smooth=smooth3(I_grid, 'box', [nV_smooth nx_smooth ny_smooth]);
I_A_map(:,:)=I_grid_smooth(V_index, :,:);

dI_dV_A_V=zeros((n_points-2),length(x_var), length(y_var));
dI_dV_I_V_norm=zeros((n_points-2),length(x_var), length(y_var));
Bias_V_dI_dV=Bias_V(2:n_points-1);

for i=1:length(x_var);
    for j=1:length(y_var)
       dI_dV_A_V(:,i,j)= diff(I_grid_smooth(:,i,j))./diff(Bias_V(1:length(I_grid_smooth(:,i,j))));
       dI_dV_I_V_norm(:,i,j)=dI_dV_A_V(:,i,j)./...
           (I_grid_smooth(2:n_points-1, i, j)./Bias_V_dI_dV);
    end
end

dI_dV_A_V_map(:,:)=dI_dV_A_V(V_index,:,:);
dI_dV_I_V_norm_map(:,:)=dI_dV_I_V_norm(V_index,:,:);

figname=strcat('I/V and dI/dV maps at bias=',...
     num2str(Bias_V(1)+delta_Bias_V*(V_index-1)),' V');

h=figure ('Name', figname);
subplot(2,2,1);
imagesc(x_var, y_var, I_A_map');
title('I [A] map');
axis xy;
axis image;
ylabel('y [m]');
xlabel('x [m]');
%zlim([min(min(I_A_map)) max(max(I_A_map))]);
colorbar;

subplot(2,2,2);
imagesc(x_var, y_var, dI_dV_A_V_map');
title('dI/dV [A/V] map');
axis xy;
axis image;
ylabel('y [m]');
xlabel('x [m]');
%zlim([0,0.2]);
colorbar;

subplot(2,2,3);

% figname=strcat('Normalized dI/dV maps at bias=',...
%      num2str(Bias_V(1)+delta_Bias_V*(V_index-1)),' V');
%  figure ('Name', figname);
imagesc(x_var, y_var, dI_dV_I_V_norm_map');
title('(dI/dV)/(I/V) map ');
axis xy;
axis image;
ylabel('y [m]');
xlabel('x [m]');
%zlim([min(min(dI_dV_I_V_norm_map)) max(max(dI_dV_I_V_norm_map))]);
colorbar;
axis equal
%print('dpng','test')

% subplot(2,2,4);
% ylabel(' ');
% xlabel(' ');
% ax = gca;
% set(ax,'XTick',[])
% set(ax,'YTick',[])
dim=[.6 0 0.4 0.4];
t = annotation('Textbox',dim,'String',num2str(Bias_V(1)+delta_Bias_V*(V_index-1)),'FitBoxToText','on','FontSize',26);
%t.FontSize;
%t.FontSize = '22';
   mov(k) = getframe(h);
writeVideo(v,mov(k));

close 
end

close(v)
% v = VideoWriter('newfile.avi');
% open(v)
% writeVideo(v,mov)

%movie2avi(mov, 'myPeaks.avi', 'compression', 'None');

% fid=fopen('file_out.raw','w','b');
% fwrite(fid,M,'float32')
% fclose(fid)

% movie(M)
% 
% 
% fid=fopen('file_out.raw','w','b');
% fwrite(fid,M,'float32')
% fclose(fid)

  elseif strcmp(kind,'dfV')==1
        v = VideoWriter('newfile.avi');
  open(v)

      for k=1:(length(Bias_V)-1);
    V_input=Bias_V(k);

      h=figure ('Name', figname);
title('[dfV] Map');

subplot(12,10,[2:1:9])
hold on
    xlabel('Bias [V]');
    yL = ylim;
    line([V_input V_input], yL, 'LineWidth',3);  %x-axis
    axis([Bias_V(length(Bias_V)) Bias_V(1) 0 1])
    set(gca,'XTick',[Bias_V(length(Bias_V)):0.25:Bias_V(1)])
    set(gca,'YTick',[2]);

subplot(12,10,[21:1:120])
imagesc(squeeze(dfV.dfV_fwd(k,1:length(x),1:length(y)))');
axis xy;
axis image;
ylabel('y [m]');
xlabel('x [m]');
colorbar;



filename=strcat(num2str(abs(Bias_V(1)+delta_Bias_V*(V_index-1))),' V.tiff');

   mov(k) = getframe(h);
writeVideo(v,mov(k));

close
      
      end
        
  close v
   end

%movie_function.m

function[v]=movie_function2(x,y,V,grid_data);
% 
%     kind='STS';
%     x_var=x;
%     y_var=y;
%     nV_smooth=3;
%     nxy_smooth=1;
%     Bias_V=V;
%     grid_data=IV.norm_dIdV_smooth_fwd;
    %%
 Bias_V=V;
 x_var=x;
 y_var=y;
 %   if strcmp(kind,'STS')==1  
%     I_grid=grid_data;
%     nx_smooth=nxy_smooth;
%     ny_smooth=nx_smooth;
%     
%     
% 
% mov(length(Bias_V)-1) = struct('cdata',[],'colormap',[]);
% 
%     climsI=[0 5e-10];
%     climsdIdV=[0 1e-9];
%     climsnorm=[5 25];
  
mov(length(Bias_V)-1) = struct('cdata',[],'colormap',[]);

v = VideoWriter('newfile.avi');
  open(v)

  for k=1:(length(Bias_V)-1);
      
          V_input=Bias_V(k);
%V_input=-2.3;
n_points=length(Bias_V);
delta_Bias_V=(Bias_V(n_points)-Bias_V(1))/(n_points-1);
V_index=round((V_input-Bias_V(1))/delta_Bias_V)+1;
figname=strcat('I/V and dI/dV maps at bias=',...
     num2str(Bias_V(1)+delta_Bias_V*(V_index-1)),' V');
h=figure ('Name', figname);

subplot(12,10,[2:1:9])
hold on
    xlabel('Bias [V]');
    yL = ylim;
    line([V_input V_input], yL, 'LineWidth',3);  %x-axis
    axis([Bias_V(length(Bias_V)) Bias_V(1) 0 1])
    set(gca,'XTick',[Bias_V(length(Bias_V)):0.25:Bias_V(1)])
    set(gca,'YTick',[2]);

subplot(12,10,[21:1:120])
imagesc(squeeze(grid_data(k,1:length(x_var),1:length(y_var)))');
axis xy;
axis image;
ylabel('y [m]');
xlabel('x [m]');
colorbar;

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

%   elseif strcmp(kind,'dfV')==1
%         v = VideoWriter('newfile.avi');
%   open(v)
% 
%       for k=1:(length(Bias_V)-1);
%     V_input=Bias_V(k);
% 
%       h=figure %('Name', figname);
% title('[dfV] Map');
% 
% subplot(12,10,[2:1:9])
% hold on
%     xlabel('Bias [V]');
%     yL = ylim;
%     line([V_input V_input], yL, 'LineWidth',3);  %x-axis
%     axis([Bias_V(length(Bias_V)) Bias_V(1) 0 1])
%     set(gca,'XTick',[Bias_V(length(Bias_V)):0.25:Bias_V(1)])
%     set(gca,'YTick',[2]);
% 
% subplot(12,10,[21:1:120])
% imagesc(squeeze(grid_data(k,1:length(x_var),1:length(y_var)))');
% axis xy;
% axis image;
% ylabel('y [m]');
% xlabel('x [m]');
% colorbar;
% 
% 
% 
% filename=strcat(num2str(abs(Bias_V(1)+delta_Bias_V*(V_index-1))),' V.tiff');
end

  
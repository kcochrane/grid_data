%IV_grid_load_function.m
% Katherine Cochrane
% Updated 2016
% For use for current/voltage pixel by pixel grids taken with the MATRIX
% software

function[IV,Z_topo,V,x,y,x_topo,y_topo]=IV_grid_load_function(grid_folder,Z_topo_file,IV_file,up_dn,fwd_bkwd,C,nV_smooth,nxy_smooth)

%%PARAMETERS
% grid_folder = subfolder where grid data is locations
% Z_topo = z topographic file taken during grid measurement
% IV_file = IV file
% up_down = parameter indicating the direction the grid was taken
%    if up_down = 0, then the grid was up only 
%    if up_down = 1, the grid was up and down and you are choosing the up
%                 scan
%    if up_down = 2, the grid was up and down and you are choosing the down
%                 scan
% fwd_bkwd = parameter indicating if the grid was a forward only scan or
%           forward and backwards
%    if fwd_bkwd = 0, then the grid was only forwards 
%    if fwd_bkwd = 1, the grid was forwards and backwards
% C = the offset for normalization
%       typical values are 1e-12
% nV_smooth = boxcar smoothing parameter for IV curves
% nxy_smooth = boxcar smoothing paramerter for spatial data
% 

%example parameters:
%  grid_folder='flat_20160225';
%  IV_file='20160225-163028_Ag(111)_NaCl_PTCDA_CuPc--42_1.I(V)_flat';
%  Z_topo_file='20160225-163028_Ag(111)_NaCl_PTCDA_CuPc--22_1.Z_flat';
%  up_dn=0; 
%  fwd_bkwd=0;
%  C=1e-12;
%  nV_smooth = 3
%  nxy_smooth = 3

%%


addpath(grid_folder)

%loading files from matrix flat form to matlab structures
%must hace flat_parse and flat2matrix m files that are available from
%Omicron

f_IV=flat_parse(IV_file);
m_IV=flat2matrix(f_IV);
f_Z_topo=flat_parse(Z_topo_file);
m_Z_topo=flat2matrix(f_Z_topo);


x_topo=m_Z_topo{1,2};
y_topo=m_Z_topo{1,3};
Z_topo_extract=m_Z_topo{1,1};

if fwd_bkwd == 1
    topo_size_x=length(x_topo)./2;
    x_topo=x_topo(1:topo_size_x);
    Z_topo=Z_topo_extract(1:topo_size_x,:);
elseif fwd_bkwd == 0 
    topo_size_x=length(x_topo);
    Z_topo=Z_topo_extract;
end

if up_dn == 1
    topo_size_y=length(y_topo)./2;
    y_topo=y_topo(1:topo_size_y);
    Z_topo=Z_topo(:,1:topo_size_y);
elseif up_dn == 2
    topo_size_y=length(y_topo)./2;
    y_topo=y_topo((topo_size_y+1):end);
    Z_topo=Z_topo(:,(topo_size_y+1):end);
elseif up_dn == 0
    topo_size_y=length(y_topo);
end

%plotting Z topographic image taken during scan
figname='Z Topography';
figure ('Name', figname);
imagesc(x_topo, y_topo, Z_topo');
title('Z Topography');
axis xy;
axis image;
ylabel('y [m]');
xlabel('x [m]');
colorbar;

%extracting current data
x=m_IV{1,3};
y=m_IV{1,4};
V=m_IV{1,2}(1:(length(m_IV{1,2})/2));
IV_extract=m_IV{1,1};
V_length=length(V);
 

if up_dn == 1
    grid_size_y=length(y)/2;
    y=y(1:grid_size_y);
    IV_raw=IV_extract(:,:,1:grid_size_y);
elseif up_dn == 2
    grid_size_y=length(y)/2;
    y=y(1:grid_size_y);
    IV_raw=IV_extract(:,:,(grid_size_y+1):end);
elseif up_dn == 0
    grid_size_y=length(y);
    IV_raw=IV_extract;
end

% if fwd_bkwd == 1
%     grid_size_x=length(x)/2;
%     IV_raw=(IV_extract(:,1:grid_size_x,:)+IV_extract(:,grid_size_x+1:end,:))./2;
% elseif fwd_bkwd == 0
%     grid_size_x=length(x);
%     IV_raw=IV_extract;

     grid_size_x=length(x);
     IV_raw=IV_extract;

%Matrix forward and backward data is stored as one string, this takes the
%forward and backward data and averages it
IV.IV_fwd=IV_raw(1:V_length,:,:);
IV.IV_bkwd=IV_raw((V_length+1):end,:,:);
for i=1:length(x)
       for j=1:length(y)
        IV.IV_bkwd(:,i,j)=flipud(IV.IV_bkwd(:,i,j));
       IV.IV_ave(:,i,j)=(IV.IV_fwd(:,i,j)+IV.IV_bkwd(:,i,j))./2;

       end
end

%% This next segment subtracts any current offset so that there is zero current at zero bias

a=zeros(1,length(V));
for i=1:length(V);
if V(i)<0;
a(i)=0;
else
a(i)=1;
end

end 
%finding the zero crossing linearly
b=find(a);
cross_V_number=length(V)-length(b);

intercept=zeros(length(x),length(y));
IV.IV_corrected=zeros(length(V),length(x),length(y));
I_grid=smooth3(IV.IV_ave,'box',[nV_smooth,nxy_smooth,nxy_smooth]);

for i=1:length(x)
   for j=1:length(y)
       
       intercept(i,j)=I_grid(cross_V_number,i,j)-V(cross_V_number).*(I_grid(cross_V_number+1,i,j)-I_grid(cross_V_number,i,j))./(V(cross_V_number+1)-V(cross_V_number));
           %for incomplete grids, to remove NaN
           l=isnan(intercept(i,j));
            if l==1
               intercept(i,j)=0;
           end
       for k=1:length(V)
           
      IV.IV_corrected(k,i,j)=(I_grid(k,i,j)-intercept(i,j));
       end
       
        IV.IV_smooth(:,i,j)=smooth(IV.IV_ave(:,i,j),nV_smooth);   
        IV.IV_corrected_smooth_extreme(:,i,j)=smooth(IV.IV_corrected(:,i,j),25);

   end
end
%subtracting this found offset from each point
IV.IV_corrected_smooth=smooth3(IV.IV_corrected, 'box', [nV_smooth,nxy_smooth,nxy_smooth]);

%taking the normalized derivative for each pixel
for i=1:length(x)
   for j=1:length(y)
           IV.dIdV(:,i,j)=diff(IV.IV_corrected_smooth(:,i,j))./diff(V);          
           IV.dIdV_smooth(:,i,j)=smooth(IV.dIdV(:,i,j),nV_smooth);           
           IV.norm_dIdV(:,i,j)=IV.dIdV_smooth(:,i,j)./(IV.IV_corrected_smooth_extreme(1:length(IV.dIdV_smooth(:,i,j)),i,j)./V(1:length(IV.dIdV_smooth(:,i,j))));
           IV.norm_dIdV_smooth(:,i,j)=smooth(IV.norm_dIdV(:,i,j),nV_smooth); 
           
            IV.norm_devision_offset_factor(:,i,j) = sqrt((IV.IV_corrected_smooth_extreme(:,i,j)./V(1:length(IV.IV_corrected_smooth(:,i,j)))).^2 + C^2);
            IV.norm_dIdV_offset(:,i,j)=IV.dIdV_smooth(:,i,j)./IV.norm_devision_offset_factor(1:length(IV.dIdV_smooth(:,i,j)),i,j);
            IV.norm_dIdV_offset_smooth(:,i,j)=smooth(IV.norm_dIdV_offset(:,i,j),nV_smooth); 
%  
%             IV.IV_offset_corrected(:,i,j) = sqrt((IV.IV_corrected_smooth((1:length(IV.dIdV_smooth(:,i,j))),i,j)./V(1:length(IV.dIdV_smooth(:,i,j)))).^2 + C^2);
%             IV.IV_offset_corrected_smooth(:,i,j)=smooth(IV.IV_offset_corrected(:,i,j),3); 
%             IV.IV_offset_corrected_smooth_extreme(:,i,j)=smooth(IV.IV_offset_corrected(:,i,j),21);           
%             IV.dIdV_offset(:,i,j)=diff(IV.IV_offset_corrected_smooth(:,i,j))./diff(V(1:length(IV.IV_offset_corrected_smooth(:,i,j))));
%             IV.dIdV_offset_smooth(:,i,j)=smooth(IV.dIdV_offset(:,i,j),3);           
%             IV.norm_dIdV_offset(:,i,j)=IV.dIdV_offset_smooth(:,i,j)./(IV.IV_offset_corrected_smooth_extreme(1:length(IV.dIdV_offset_smooth(:,i,j)),i,j)./V(1:length(IV.dIdV_offset_smooth(:,i,j))));
%             IV.norm_dIdV_offset_smooth(:,i,j)=smooth(IV.norm_dIdV_offset(:,i,j),3);            

%            IV.IV_offset(:,i,j) = sqrt((IV.IV_smooth((1:length(IV.dIdV_smooth(:,i,j))),i,j)./V(1:length(IV.dIdV_smooth(:,i,j)))).^2 + C^2);
%            IV.IV_offset_smooth(:,i,j)=smooth(IV.IV_offset(:,i,j),3); 
%            IV.IV_offset_smooth_extreme(:,i,j)=smooth(IV.IV_offset(:,i,j),21);           
%            IV.dIdV_offset(:,i,j)=diff(IV.IV_offset_corrected_smooth(:,i,j))./diff(V(1:length(IV.IV_offset_smooth(:,i,j))));
%            IV.dIdV_offset_smooth(:,i,j)=smooth(IV.dIdV_offset(:,i,j),3);           
%            IV.norm_dIdV_offset(:,i,j)=IV.dIdV_offset_smooth(:,i,j)./(IV.IV_offset_smooth_extreme(1:length(IV.dIdV_offset_smooth(:,i,j)),i,j)./V(1:length(IV.dIdV_offset_smooth(:,i,j))));
%            IV.norm_dIdV_offset_smooth(:,i,j)=smooth(IV.norm_dIdV_offset(:,i,j),3);            

       end
end
% 



end

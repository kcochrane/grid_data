%I_Z_load_function.m
% Katherine Cochrane
% Updated 2016
% For use for current/voltage pixel by pixel grids taken with the MATRIX
% software

function[IZ,Z_topo,Z_sweep,x,y,x_topo,y_topo]=I_Z_load_function(grid_folder,IZ_file,Z_topo_file,up_dn,fwd_bkwd,nZ_smooth,nxy_smooth)


%%PARAMETERS
% grid_folder = subfolder where grid data is locations
% IZ_file = IZ file
% Z_topo = z topographic file taken during grid measurement
% if up_down = 0, then the grid was up only 
% if up_down = 1, the grid was up and down and you are choosing the up
% scan
% if up_down = 2, the grid was up and down and you are choosing the down
% scan

% grid_folder='pineapple_k_maps';
% IZ_file='20160127-100224_Ag(111)_NaCl_PTCDA_CuPc--227_1.I(Z)_flat';
% Z_topo_file='20160128-171629_Ag(111)_NaCl_PTCDA_CuPc--16_1.Z_flat';
% up_dn=0;
% fwd_bkwd=0;
% nZ_smooth=1;
% nxy_smooth=1;
% 
%%
addpath(grid_folder)

directory=grid_folder;

%loading files from matrix flat to matlab structures
f_IZ=flat_parse(IZ_file);
m_IZ=flat2matrix(f_IZ);


f_Z_topo=flat_parse(Z_topo_file);
m_Z_topo=flat2matrix(f_Z_topo);


%topo extraction
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

figname='Z Topography';
figure ('Name', figname);
imagesc(x_topo, y_topo, Z_topo');
title('Z Topography');
axis xy;
axis image;
ylabel('y [m]');
xlabel('x [m]');
colorbar;

%IZ extraction
x=m_IZ{1,3};
y=m_IZ{1,4};
Z_sweep=m_IZ{1,2}(1:(length(m_IZ{1,2})/2));
IZ_extract=m_IZ{1,1};

grid_size_x=length(x);
if up_dn == 1
    grid_size_y=length(y)/2;
    y=y(1:grid_size_y);
    dIZ_raw=IZ_extract(:,:,1:grid_size_y);
elseif up_dn == 2
    grid_size_y=length(y)/2;
    y=y(1:grid_size_y);
    dIZ_raw=IZ_extract(:,:,(grid_size_y+1):end);
elseif up_dn == 0
    grid_size_y=length(y);
    dIZ_raw=IZ_extract;
end

Z_length=length(Z_sweep);
IZ.IZ_fwd=dIZ_raw(1:Z_length,:,:);
IZ.IZ_bkwd=dIZ_raw((Z_length+1):end,:,:);

for i=1:length(x)
       for j=1:length(y)
IZ.IZ_bkwd(:,i,j)=flipud(IZ.IZ_bkwd(:,i,j));
IZ.IZ_ave(:,i,j)=(IZ.IZ_bkwd(:,i,j)+IZ.IZ_fwd(:,i,j))./2;
       end
end

% fitting IZ

Z_sweep_m=Z_sweep*10^9;

IZ.I_fit_m=zeros(length(x),length(y));
IZ.I_fit_b=zeros(length(x),length(y));

IZ.IZ_smooth=smooth3(IZ.IZ_ave,'box',[nZ_smooth,nxy_smooth,nxy_smooth]);
 for ii=1:length(x)
     for jj=1:length(y)
        %for kk=1:length(Z_sweep)
            

I_log_temp=log10(IZ.IZ_smooth(:,ii,jj));            
temp_fit=polyfit(Z_sweep_m, I_log_temp, 1);
IZ.I_fit_m(ii,jj)=real(temp_fit(1));
IZ.I_fit_b(ii,jj)=real(temp_fit(2));

        
        end  
        
    end

%determining kappa for decay constants
IZ.kappa=-IZ.I_fit_m./2;
figure
imagesc(ii, jj, IZ.kappa');
axis xy
axis image
colorbar
end
%IV_grid_load_function.m
% Katherine Cochrane
% Updated 2016
% To load a series of IV point spectra with the MATRIX
% software

%%
function[IV]=IV_series_load_function(grid_folder,num_averages,C,start_spectra_number,n_smooth)


%%PARAMETERS
% grid_folder = subfolder where series data is locations
% num_averages = number of averages taken at each point
% C = the offset for normalization
    %typical values are 1e-12
% start_spectra_number= starting spectra appended number
%n_smooth = boxcar smoothing applied

%%
%example parameters
%grid_folder='/au29';
%num_averages=1;
%nsmooth=7; 
%start_spectra_number=12;
%C=5e-13;


%%
directory = pwd;

added_path = [pwd,grid_folder]; 
addpath(added_path);

directory=added_path;

f=dir([directory,'/*.I(V)_flat']);
addpath(grid_folder)
IV=struct;

for ii=1:length(f)
 p = fullfile(directory,f(ii).name);
 fileroot(ii)=cellstr(f(ii).name(end-start_spectra_number:end-10));
temp_name=['s' cell2mat(fileroot(ii))];
 temp=flat_parse(p);
 temp=flat2matrix(temp);
 V_full=temp{2:2};
 I_raw_full=temp{1:2};
 
Bias_V=V_full(1:(length(V_full))/2);
IV.(temp_name).I_raw_fwd=I_raw_full(1:(length(I_raw_full))/2);
IV.(temp_name).I_raw_bkwd=I_raw_full((length(I_raw_full)/2+1):length(I_raw_full));
IV.(temp_name).I_raw_ave=(IV.(temp_name).I_raw_fwd+flipud(IV.(temp_name).I_raw_bkwd))./2;
IV.(temp_name).I_smooth=smooth(IV.(temp_name).I_raw_ave,25);
IV.(temp_name).V=Bias_V;

a=zeros(1,length(IV.(temp_name).V));
for i=1:length(IV.(temp_name).V);
if IV.(temp_name).V(i)<0;
a(i)=0;
else
a(i)=1;
end

end 

b=find(a);
cross_V_number=length(IV.(temp_name).V)-length(b);

intercept=IV.(temp_name).I_smooth(cross_V_number)-IV.(temp_name).V(cross_V_number).*(IV.(temp_name).I_smooth(cross_V_number+1)-IV.(temp_name).I_smooth(cross_V_number))./(IV.(temp_name).V(cross_V_number+1)-IV.(temp_name).V(cross_V_number));

I_corrected_initial=zeros(length(IV.(temp_name).I_raw_ave),1);
for k=1:length(IV.(temp_name).V)
           
      I_corrected_initial(k)=(IV.(temp_name).I_raw_ave(k)-intercept);
end
 



% I_smooth2=smooth(I_corrected,3);
% dIdV=diff(I_smooth2)./diff(V);
% dIdV_smooth=smooth(dIdV,3);
% norm_dIdV=dIdV_smooth./(I_smooth2(1:length(dIdV_smooth))./V(1:length(dIdV_smooth)));
% norm_dIdV_smooth=smooth(norm_dIdV,3);



IV.(temp_name).I_corrected  = I_corrected_initial;
 I_stack(:,ii)=I_corrected_initial;


end

%%
% I_loop=zeros(length(IV.(temp_name).V), num_averages);
% I_corrected_matrix=zeros(length(IV.(temp_name).V),length(f)/num_averages);
% 
% for jj=1:(length(f)/num_averages)  
%     for kk=(1:num_averages)
%         I_loop(:,kk)=I_stack(:,jj*kk);
%     end
% 
% I_corrected_matrix(:,jj)=mean(I_loop,2);
% end
% 
% I_loop=zeros(length(IV.(temp_name).V), num_averages);
% I_corrected_matrix=zeros(length(IV.(temp_name).V),length(f)/num_averages);
% 
% for jj=1:(length(f)/num_averages)  
%     for kk=(1:num_averages)
%         I_loop(:,kk)=I_stack(:,jj*kk);
%     end
% 
% I_corrected_matrix(:,jj)=mean(I_loop,2);
% end
% 
% %%
% 
% ave_I=mean(I_corrected_matrix,2);
% ave_I=(I_corrected_matrix(:,1)+I_corrected_matrix(:,4))/2;
% I_smooth_extreme=smooth(ave_I,11);
% norm_offset_factor=sqrt((I_smooth_extreme./Bias_V(1:length(I_smooth_extreme))).^2+C^2);
% dIdV=diff(ave_I)./diff(Bias_V);
% dIdV_norm=smooth(dIdV,5)./norm_offset_factor(1:length(dIdV));
% 
% figure
% hold on
% plot(Bias_V(1:length(dIdV_norm)),dIdV_norm)
% 
% 

%%

for ii=1:length(f)
    temp_name=['s' cell2mat(fileroot(ii))];
IV.(temp_name).ave_I=IV.(temp_name).I_corrected;
IV.(temp_name).I_smooth_extreme=smooth(IV.(temp_name).ave_I,11);
IV.(temp_name).norm_offset_factor=sqrt((IV.(temp_name).I_smooth_extreme./IV.(temp_name).V(1:length(IV.(temp_name).I_smooth_extreme))).^2+C^2);
IV.(temp_name).dIdV=diff(IV.(temp_name).ave_I)./diff(IV.(temp_name).V);
IV.(temp_name).dIdV_norm=smooth(IV.(temp_name).dIdV,nsmooth)./IV.(temp_name).norm_offset_factor(1:length(IV.(temp_name).dIdV));
    IV.(temp_name).dIdV_norm_smooth=smooth(IV.(temp_name).dIdV_norm,nsmooth);
end
    
figure
hold on

for ii=1:length(f)
temp_name=['s' cell2mat(fileroot(ii))];
plot(IV.(temp_name).V(1:length(IV.(temp_name).dIdV_norm_smooth)),IV.(temp_name).dIdV_norm_smooth,'DisplayName',temp_name)
end
%%
figure
hold on
for ii=1:length(f)
temp_name=['s' cell2mat(fileroot(ii))];
plot(IV.(temp_name).V(1:length(IV.(temp_name).I_raw_ave)),IV.(temp_name).I_raw_ave,'DisplayName',temp_name)
end
%end

%%
for ii=1:length(f)
        temp_name=['s' cell2mat(fileroot(ii))];
  export_spectra=horzcat(IV.(temp_name).V(1:length(IV.(temp_name).dIdV_norm_smooth)),IV.(temp_name).dIdV_norm_smooth);
            save(['spectra' temp_name],'export_spectra','-ascii','-tabs')
end

%%
for ii=1:length(f)
        temp_name=['s' cell2mat(fileroot(ii))];
  export_spectra=horzcat(IV.(temp_name).V(1:length(IV.(temp_name).I_raw_ave)),IV.(temp_name).I_raw_ave);
            save(['spectra' temp_name],'export_spectra','-ascii','-tabs')
end
  %%  
figure
hold on

for ii=1:length(f)
temp_name=['s' cell2mat(fileroot(ii))];
plotsmooth(IV.(temp_name).V(1:(length(IV.(temp_name).dIdV)-1)),smooth(IV.(temp_name).dIdV,'DisplayName',temp_name),3)
end

%%
clear stack

for ii=1:length(f)
temp_name=['s' cell2mat(fileroot(ii))];
temp=(IV.(temp_name).dIdV_norm_smooth);
stack(ii,:)=temp;
end
%end
didvave=mean(stack);
didvave=didvave';

figure
hold on
plot(Bias_V(1:length(didvave)),didvave)

%%
V=Bias_V;
I_mean=mean(I_stack');
I_mean=I_mean';
I_smooth2=smooth(I_mean,7);
dIdV=diff(I_smooth2)./diff(V);
dIdV_smooth=smooth(dIdV,5);

figure
plot(V(1:length(dIdV_smooth)),dIdV_smooth)

end

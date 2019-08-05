%gapmap with mask

%Finds gap in d(I)/d(V) with nsmooth for the voltage smoothing

Voltage=0.15;
nsmooth=3;
threshold=5e-13;

%function []= gapmap(Voltage,nsmooth,threshold)

 f=flat_parse('20131210-092747_AFM_NonContact_QPlus-Au(111)--93_1.I(V)_flat'); %extract flat file (Omicron m file)
 [x,y,V,I]=Extract_Data_Omicron_Flat_I_V_grid(f,0,0,1); %(extract grid data) AS program
[I_A_map, dI_dV_A_V_map, dI_dV_I_V_norm_map]=...
Grid_Numerical_Map_dI_dV...
(I,V,Voltage,x,y,3,11,11);
threshold=5e-13;
%current chosen voltage with really defined borders for PTCDA island


% HOMO=zeros(128);
% LUMO=zeros(128);
maskxy=zeros(128);
HOMO=maskxy;
LUMO=maskxy;


for i=1:128
    for j=1:128
        if (I_A_map(i,j)<threshold);
            maskxy(i,j)=1;
        else
             maskxy(i,j)=0;
        end
   
    end 
end
% "reverse mask" for molecule in corner
for j=100:128
for i=1:10
    maskxy(i,j)=0;
end
end


for j=1:128
    for i=1:128
  if maskxy(i,j)==1;
I_ij=I(:,i,j); % I at a specific point i,j % % Ismooth=smooth(I_ij);
Ismooth=smooth(I_ij);% basic smoothing of current
dI=diff(Ismooth); %differentiating current
dV=diff(V); %differentiating bias
dIdV=dI./dV(1:length(dI)); %finding dI/dV
dIdVsmooth=smooth(dIdV,nsmooth);
% dIdV_IV=dIdVsmooth./Ismooth(1:length(dIdVsmooth)).*V(1:length(dI)); %finds normalized dI/dV
% smoothdIdV_IV=smooth(dIdV_IV); %smooths normalized dI/dV

%finding where dI/dV curve crosses 2e-11 to get boundaries of gap
k=0;
for l=1:178
    if (dIdVsmooth(l)<0.000000000025)
       while k==0
           HOMO(i,j)=V(l);
        k=1;
       end
    else
        k=0;
    end
end
k=0;
for l=179:length(dIdVsmooth)
    if (dIdVsmooth(l)>0.000000000025)
       while k==0
           LUMO(i,j)=V(l);
        k=1;
       end
    else
        k=0;
    end   
end
  end
    end
end
gap=LUMO-HOMO;

figure
subplot(1,3,3);
imagesc(x,y,gap');
title('Gap');
axis xy;
axis image;
ylabel('y [m]');
xlabel('x [m]');
%zlim([min(min(I_A_map)) max(max(I_A_map))]);
colorbar;

subplot(1,3,1);
imagesc(x,y,HOMO');
title('HOMO');
axis xy;
axis image;
ylabel('y [m]');
xlabel('x [m]');
%zlim([0,0.2]);
colorbar;

subplot(1,3,2);
imagesc(x,y,LUMO');
title('LUMO');
axis xy;
axis image;
ylabel('y [m]');
xlabel('x [m]');
%zlim([min(min(dI_dV_I_V_norm_map)) max(max(dI_dV_I_V_norm_map))]);
colorbar;



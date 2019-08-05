%subtract_current_offset.m
%subtracts average offset from 0,0 in I/V such that there is zero current
%at zero volts. 

function [x,y,V,I, I_corrected, SAVENAME] = subtract_current_offset(filename, path, molecule)

%path= 'C:\Users\TanyaRoussy628\Dropbox\MASC\CuPC_PTCDA_Analysis\XO_laser_power_study';
addpath(path);

%filename='20160106-112011_Ag(111)_NaCl_PTCDA_CuPc--451_1.I(V)_flat';
NAME=[filename(1:8),filename(41:44)]
SAVENAME=[path,'\',NAME, molecule]
singlept_grid='grid';
raw_smooth='smooth';

n=3;

f=flat_parse(filename);

if strcmp(singlept_grid,'singlept')==1
        
m=flat2matrix(f);
   
V_full=m{2:2};
I_raw_full=m{1:2};

Bias_V=V_full(1:(length(V_full))/2);
I_raw_fwd=I_raw_full(1:(length(I_raw_full))/2);
I_raw_bkwd=I_raw_full((length(I_raw_full)/2+1):length(I_raw_full));
I_raw_ave=(I_raw_fwd+flipud(I_raw_bkwd))./2;
I_smooth=smooth(I_raw_ave,25);
V=Bias_V;

a=zeros(1,length(V));
for i=1:length(V);
if V(i)<0;
a(i)=0;
else
a(i)=1;
end

end 

b=find(a);
cross_V_number=length(V)-length(b);

intercept=I_smooth(cross_V_number)-V(cross_V_number).*(I_smooth(cross_V_number+1)-I_smooth(cross_V_number))./(V(cross_V_number+1)-V(cross_V_number));

I_corrected=zeros(512,1);
for k=1:length(V)
           
      I_corrected(k)=(I_raw_ave(k)-intercept);
end
       
I_smooth2=smooth(I_corrected,n);
dIdV=diff(I_smooth2)./diff(V);
dIdV_smooth=smooth(dIdV,n);
norm_dIdV=dIdV_smooth./(I_smooth2(1:length(dIdV_smooth))./V(1:length(dIdV_smooth)));
norm_dIdV_smooth=smooth(norm_dIdV,n);

elseif strcmp(singlept_grid,'grid')==1
    

x_pt=35;
y_pt=40;
nsmooth=5;
xsmooth=5;
ysmooth=5;

%Run Agustin's code
[x,y,V,I]=Extract_Data_Omicron_Flat_I_V_grid(f,0,0,1);

Bias_V=V;
%This is because the bias vector has a couple of different names in
%different code I have written. Sloppy sloppy.

%Below is a really round about way to figure out where the bias crosses
%zero for arbitrary bias lengths and start and end points.
a=zeros(1,length(V));
for i=1:length(V);
if V(i)<0;
a(i)=0;
else
a(i)=1;
end

end 

b=find(a);
cross_V_number=length(V)-length(b);

I_smooth=smooth3(I,'box',[nsmooth,xsmooth,ysmooth]);

if strcmp(raw_smooth,'raw')==1;
        I_grid=I;
    elseif strcmp(raw_smooth,'smooth')==1;
        I_grid=I_smooth;
end

intercept=zeros(length(x),length(y));
I_corrected=zeros(length(V),length(x),length(y));
for i=1:length(x)
   for j=1:length(y)
       intercept(i,j)=I_grid(cross_V_number,i,j)-V(cross_V_number).*(I_grid(cross_V_number+1,i,j)-I_grid(cross_V_number,i,j))./(V(cross_V_number+1)-V(cross_V_number));
           %for incomplete grids, to remove NaN
           l=isnan(intercept(i,j));
            if l==1
               intercept(i,j)=0;
           end
       for k=1:length(V)
           
      I_corrected(k,i,j)=(I_grid(k,i,j)-intercept(i,j));
       end
       
    
   end
       
       
end       
  

dIdV=zeros(length(V)-1,length(x),length(y));
dIdV_norm=zeros(length(V)-1,length(x),length(y));


for ii=1:length(x)
   for jj=1:length(y)
    dIdV(:,ii,jj)=diff(I_corrected(:,ii,jj))./diff(V);
     dIdV_norm(:,ii,jj)=dIdV(:,ii,jj)./(I_corrected(2:length(V),ii,jj)./V(2:length(V)));
       
   end
end

end


%save(SAVENAME, 'Bias_V')



%     figname='I/V curves forward, backward and average';
%     figure ('Name', figname);
%     plot(Bias_V, I_fwd,'r',Bias_V, I_bkwd,'b',Bias_V, I_ave,'k');
% 
%     title('I(V) Forward');
%     xlabel('Bias [V]');
%     ylabel('I_t [nA]');
%     hleg=legend('Forward','Backward','Average');
%         xmin=-0.15;
%         xmax=0.15;
%         ymin=-5e-12;
%         ymax=5e-12;
% %         axis([xmin xmax ymin ymax])
%     xL = xlim;
%     yL = ylim;
%     line([0 0], yL);  %x-axis
%     line(xL, [0 0]);  %y-axis
% 
%     I_smoothxy_fwd=I_smooth_fwd_grid(:,xpt,ypt);
%     figure
%     dIdV=diff(I_smoothxy_fwd)./diff(Bias_V);
%     norm_dIdV=dIdV./(I_smooth_fwd(1:length(dIdV))./Bias_V(1:length(dIdV)));
%     smooth_norm_dIdV=smooth(norm_dIdV,nsmooth);
%     hold on
%     plot(Bias_V(1:length(norm_dIdV)),norm_dIdV);
%     plot(Bias_V(1:length(smooth_norm_dIdV)),smooth_norm_dIdV,'k');
%     title('[dI/dV]/[I/V] Forward');
%     xlabel('Bias [V]');
%     ylabel('normalized dI/dV[nA]');
% %     
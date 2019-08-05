%efs_fitting_appen.m

%data for curve fitting for appendix

%clover
grid_folder='flat20160513';
dfV_file='20160513-181459_Ag(111)_NaCl_PTCDA--92_1.Df(V)_flat';
IV_file='20160513-181459_Ag(111)_NaCl_PTCDA--92_1.I(V)_flat';
I_topo_file='20160513-181459_Ag(111)_NaCl_PTCDA--37_1.I_flat';
df_topo_file='20160513-181459_Ag(111)_NaCl_PTCDA--37_1.Df_flat';
up_dn=1; 
fwd_bkwd=1;

nV_smooth=3;
nxy_smooth=3;
C=1e-11;


[dfV,IV,df_topo,I_topo,V,x,y,x_topo,y_topo]=dfv_grid_load_function(grid_folder,I_topo_file,df_topo_file,dfV_file,IV_file,up_dn,fwd_bkwd,nV_smooth,nxy_smooth,C);
%%

figure
imagesc(squeeze(dfV.dfV_fwd(1,1:length(x),1:length(y)))');
axis xy;
axis image;
ylabel('y [m]');
xlabel('x [m]');
colorbar;
%%
i=11;
j=7;

figure
hold on
plot(V,dfV.dfV_fwd(:,i,j))
plot(V,dfV.dfV_bkwd(:,i,j))
%%

n=3;
neg_lim=369;
mid_lim_neg=314;
mid_lim_pos=247;
pos_lim=206;



neg_V=V(neg_lim:end);
mid_V=V(mid_lim_pos:mid_lim_neg);
pos_V=V(1:pos_lim);
for i=1:length(x)
    for j=1:length(y)
        

        neg_dfV_fwd(:,i,j)=dfV.dfV_fwd(neg_lim:end,i,j);
        mid_dfV_fwd(:,i,j)=dfV.dfV_fwd(mid_lim_pos:mid_lim_neg,i,j);       
        pos_dfV_fwd(:,i,j)=dfV.dfV_fwd(1:pos_lim,i,j);
        neg_dfV_bkwd(:,i,j)=dfV.dfV_bkwd(neg_lim:end,i,j);
        mid_dfV_bkwd(:,i,j)=dfV.dfV_bkwd(mid_lim_pos:mid_lim_neg,i,j);       
        pos_dfV_bkwd(:,i,j)=dfV.dfV_bkwd(1:pos_lim,i,j);
        neg_dfV_ave(:,i,j)=dfV.dfV_ave(neg_lim:end,i,j);
        mid_dfV_ave(:,i,j)=dfV.dfV_ave(mid_lim_pos:mid_lim_neg,i,j);       
        pos_dfV_ave(:,i,j)=dfV.dfV_ave(1:pos_lim,i,j);
        
        %%%
        neg_dfV_fwd(:,i,j)=smooth(neg_dfV_fwd(:,i,j),n);
        mid_dfV_fwd(:,i,j)=smooth(mid_dfV_fwd(:,i,j),n);
        pos_dfV_fwd(:,i,j)=smooth(pos_dfV_fwd(:,i,j),n);
        neg_dfV_bkwd(:,i,j)=smooth(neg_dfV_bkwd(:,i,j),n);
        mid_dfV_bkwd(:,i,j)=smooth(mid_dfV_bkwd(:,i,j),n);    
        pos_dfV_bkwd(:,i,j)=smooth(pos_dfV_bkwd(:,i,j),n);
        neg_dfV_ave(:,i,j)=smooth(neg_dfV_ave(:,i,j),n);
        mid_dfV_ave(:,i,j)=smooth(mid_dfV_ave(:,i,j),n);       
        pos_dfV_ave(:,i,j)=smooth(pos_dfV_ave(:,i,j),n);
        %%%

        [p_neg_fwd,S] = polyfit(neg_V,neg_dfV_fwd(:,i,j),2);
        y_neg_fwd(:,i,j) = polyval(p_neg_fwd,V);
        [max_neg_fwd_df(i,j),b_neg] = max(y_neg_fwd(:,i,j));
        max_neg_fwd(i,j)= V(b_neg);
        capacitance_fwd(i,j)=p_neg_fwd(1);        
        [p_mid_fwd,S] = polyfit(mid_V,mid_dfV_fwd(:,i,j),2);
        y_mid_fwd(:,i,j) = polyval(p_mid_fwd,V);
        [max_mid_fwd_df(i,j),b_mid] = max(y_mid_fwd(:,i,j));
        max_mid_fwd(i,j)= V(b_mid);
        capacitance_fwd(i,j)=p_mid_fwd(1);
        [p_pos_fwd,S] = polyfit(pos_V,pos_dfV_fwd(:,i,j),2);
        y_pos_fwd(:,i,j) = polyval(p_pos_fwd,V);
        [max_pos_fwd_df(i,j),b_pos] = max(y_pos_fwd(:,i,j));
        max_pos_fwd(i,j)= V(b_pos);
        [p_neg_bkwd,S] = polyfit(neg_V,neg_dfV_bkwd(:,i,j),2);
        y_neg_bkwd(:,i,j) = polyval(p_neg_bkwd,V);
        [max_neg_bkwd_df(i,j),b_neg] = max(y_neg_bkwd(:,i,j));
        max_neg_bkwd(i,j)= V(b_neg);
        capacitance_bkwd(i,j)=p_neg_bkwd(1);
        [p_mid_bkwd,S] = polyfit(mid_V,mid_dfV_bkwd(:,i,j),2);
        y_mid_bkwd(:,i,j) = polyval(p_mid_bkwd,V);
        [max_mid_bkwd_df(i,j),b_mid] = max(y_mid_bkwd(:,i,j));
        max_mid_bkwd(i,j)= V(b_mid);
        capacitance_bkwd(i,j)=p_mid_bkwd(1);  
        [p_pos_bkwd,S] = polyfit(pos_V,pos_dfV_bkwd(:,i,j),2);
        y_pos_bkwd(:,i,j) = polyval(p_pos_bkwd,V);
        [max_pos_bkwd_df(i,j),b_pos] = max(y_pos_bkwd(:,i,j));
        max_pos_bkwd(i,j)= V(b_pos);
%       [p,S] = polyfit(V,dfV(:,i,j),2);
%       y_full(:,i,j) = polyval(p,V);
%       [a,b] = max(y_full(:,i,j));
%       max_full(i,j)= V(b);
        [p_neg_ave,S] = polyfit(neg_V,neg_dfV_ave(:,i,j),2);
        y_neg_ave(:,i,j) = polyval(p_neg_ave,V);
        [max_neg_ave_df(i,j),b_neg] = max(y_neg_ave(:,i,j));
        max_neg_ave(i,j)= V(b_neg);
        capacitance_ave(i,j)=p_neg_ave(1);
        [p_mid_ave,S] = polyfit(mid_V,mid_dfV_ave(:,i,j),2);
        y_mid_ave(:,i,j) = polyval(p_mid_ave,V);
        [max_mid_ave_df(i,j),b_mid] = max(y_mid_ave(:,i,j));
        max_mid_ave(i,j)= V(b_mid);
        capacitance_ave(i,j)=p_mid_ave(1);
        [p_pos_ave,S] = polyfit(pos_V,pos_dfV_ave(:,i,j),2);
        y_pos_ave(:,i,j) = polyval(p_pos_ave,V);
        [max_pos_ave_df(i,j),b_pos] = max(y_pos_ave(:,i,j));
        max_pos_ave(i,j)= V(b_pos);
        
        difference_mid_fwd(:,i,j)=dfV.dfV_fwd(:,i,j)-y_mid_fwd(:,i,j);
        difference_mid_bkwd(:,i,j)=dfV.dfV_fwd(:,i,j)-y_mid_bkwd(:,i,j);
        difference_mid_ave(:,i,j)=dfV.dfV_ave(:,i,j)-y_mid_ave(:,i,j);
        difference_neg_fwd(:,i,j)=dfV.dfV_fwd(:,i,j)-y_neg_fwd(:,i,j);
        difference_neg_bkwd(:,i,j)=dfV.dfV_fwd(:,i,j)-y_neg_bkwd(:,i,j);
        difference_neg_ave(:,i,j)=dfV.dfV_ave(:,i,j)-y_neg_ave(:,i,j);
        difference_pos_fwd(:,i,j)=dfV.dfV_fwd(:,i,j)-y_pos_fwd(:,i,j);
        difference_pos_bkwd(:,i,j)=dfV.dfV_fwd(:,i,j)-y_pos_bkwd(:,i,j);
        difference_pos_ave(:,i,j)=dfV.dfV_ave(:,i,j)-y_pos_ave(:,i,j);


    end
end



%%
for i=1:length(x)
    for j=1:length(y)

difference_neg_fwd_smooth(:,i,j)=smooth(difference_neg_fwd(:,i,j),5);
difference_neg_bkwd_smooth(:,i,j)=smooth(difference_neg_bkwd(:,i,j),5);
difference_neg_ave_smooth(:,i,j)=smooth(difference_neg_ave(:,i,j),5);

difference_pos_ave_smooth(:,i,j)=smooth(difference_pos_ave(:,i,j),9);

    end
end
%%

neg_dfV_fwd=zeros(length(V),length(x),length(y));
mid_dfV_fwd=zeros(length(V),length(x),length(y));
pos_dfV_fwd=zeros(length(V),length(x),length(y));
neg_dfV_bkwd=zeros(length(V),length(x),length(y));
mid_dfV_bkwd=zeros(length(V),length(x),length(y));
pos_dfV_bkwd=zeros(length(V),length(x),length(y));
neg_dfV_ave=zeros(length(V),length(x),length(y));
mid_dfV_ave=zeros(length(V),length(x),length(y));
pos_dfV_ave=zeros(length(V),length(x),length(y));


%segmenting into 3 curves

for i=1:length(x)
    for j=1:length(y)
                 neg_lim_index(i,j)=neg_lim;
       pos_lim_index(i,j)=pos_lim;
        clear neg_V
        clear mid_V
        clear pos_V
        clear pos_dfV_fwd_temp
        clear pos_dfV_fwd_temp
        clear neg_dfV_fwd_temp
        clear mid_dfV_fwd_temp
        clear pos_dfV_bkwd_temp
        clear neg_dfV_bkwd_temp
        clear mid_dfV_bkwd_temp
        clear pos_dfV_ave_temp
        clear neg_dfV_ave_temp
        clear mid_dfV_ave_temp

        neg_V=V(neg_lim_index(i,j):end);
        mid_V=V(mid_lim_pos:mid_lim_neg);
        pos_V=V(1:pos_lim_index(i,j));
        %find overall curvature
                [p_full_ave,S] = polyfit(V(mid_lim_pos:end),dfV.dfV_ave(mid_lim_pos:end,i,j),2);
        y_full_ave(:,i,j) = polyval(p_full_ave,V);
%         [max_ave_df(i,j),b] = max(y_full_ave(:,i,j));
%         max_full(i,j)= V(b);
        a_polynomial_full(i,j)=p_full_ave(1);
        
%         dfV.dfV_fwd(:,i,j)=smooth(dfV.dfV_fwd(:,i,j),9);
%         dfV.dfV_bkwd(:,i,j)=smooth(dfV.dfV_bkwd(:,i,j),9);
%         dfV.dfV_ave(:,i,j)=smooth(dfV.dfV_ave(:,i,j),9);

        
        neg_dfV_fwd(neg_lim_index(i,j):end,i,j)=dfV.dfV_fwd(neg_lim_index(i,j):end,i,j);
        mid_dfV_fwd(mid_lim_pos:mid_lim_neg,i,j)=dfV.dfV_fwd(mid_lim_pos:mid_lim_neg,i,j);       
        pos_dfV_fwd(1:pos_lim_index(i,j),i,j)=dfV.dfV_fwd(1:pos_lim_index(i,j),i,j);
        neg_dfV_bkwd(neg_lim_index(i,j):end,i,j)=dfV.dfV_bkwd(neg_lim_index(i,j):end,i,j);
        mid_dfV_bkwd(mid_lim_pos:mid_lim_neg,i,j)=dfV.dfV_bkwd(mid_lim_pos:mid_lim_neg,i,j);       
        pos_dfV_bkwd(1:pos_lim_index(i,j),i,j)=dfV.dfV_bkwd(1:pos_lim_index(i,j),i,j);
        neg_dfV_ave(neg_lim_index(i,j):end,i,j)=dfV.dfV_ave(neg_lim_index(i,j):end,i,j);
        mid_dfV_ave(mid_lim_pos:mid_lim_neg,i,j)=dfV.dfV_ave(mid_lim_pos:mid_lim_neg,i,j);       
        pos_dfV_ave(1:pos_lim_index(i,j),i,j)=dfV.dfV_ave(1:pos_lim_index(i,j),i,j);

            ft = fittype( 'poly2' );
            opts = fitoptions( 'Method', 'LinearLeastSquares' );
            opts.Lower = [p_full_ave(1)-0.001 -Inf -Inf];
            opts.Upper = [p_full_ave(1)+0.001 Inf Inf];
        
            pos_dfV_fwd_temp=pos_dfV_fwd(:,i,j);
            pos_dfV_fwd_temp=pos_dfV_fwd_temp(pos_dfV_fwd_temp~=0);
            neg_dfV_fwd_temp=neg_dfV_fwd(:,i,j);
            neg_dfV_fwd_temp=neg_dfV_fwd_temp(neg_dfV_fwd_temp~=0);
            mid_dfV_fwd_temp=mid_dfV_fwd(:,i,j);
            mid_dfV_fwd_temp=mid_dfV_fwd_temp(mid_dfV_fwd_temp~=0);
            pos_dfV_bkwd_temp=pos_dfV_bkwd(:,i,j);
            pos_dfV_bkwd_temp=pos_dfV_bkwd_temp(pos_dfV_bkwd_temp~=0);
            neg_dfV_bkwd_temp=neg_dfV_bkwd(:,i,j);
            neg_dfV_bkwd_temp=neg_dfV_bkwd_temp(neg_dfV_bkwd_temp~=0);
            mid_dfV_bkwd_temp=mid_dfV_bkwd(:,i,j);
            mid_dfV_bkwd_temp=mid_dfV_bkwd_temp(mid_dfV_bkwd_temp~=0); 
            pos_dfV_ave_temp=pos_dfV_ave(:,i,j);
            pos_dfV_ave_temp=pos_dfV_ave_temp(pos_dfV_ave_temp~=0);
            neg_dfV_ave_temp=neg_dfV_ave(:,i,j);
            neg_dfV_ave_temp=neg_dfV_ave_temp(neg_dfV_ave_temp~=0);
            mid_dfV_ave_temp=mid_dfV_ave(:,i,j);
            mid_dfV_ave_temp=mid_dfV_ave_temp(mid_dfV_ave_temp~=0); 
            
            
            [df_fit_pos_fwd,gof_pos_fwd]=fit(pos_V,pos_dfV_fwd_temp,ft,opts);
            [df_fit_neg_fwd,gof_neg_fwd]=fit(neg_V,neg_dfV_fwd_temp,ft,opts);
            [df_fit_mid_fwd,gof_mid_fwd]=fit(mid_V,mid_dfV_fwd_temp,ft,opts);
            [df_fit_pos_bkwd,gof_pos_bkwd]=fit(pos_V,pos_dfV_bkwd_temp,ft,opts);
            [df_fit_neg_bkwd,gof_neg_bkwd]=fit(neg_V,neg_dfV_bkwd_temp,ft,opts);
            [df_fit_mid_bkwd,gof_mid_bkwd]=fit(mid_V,mid_dfV_bkwd_temp,ft,opts);
            [df_fit_pos_ave,gof_pos_ave]=fit(pos_V,pos_dfV_ave_temp,ft,opts);
            [df_fit_neg_ave,gof_neg_ave]=fit(neg_V,neg_dfV_ave_temp,ft,opts);
            [df_fit_mid_ave,gof_mid_ave]=fit(mid_V,mid_dfV_ave_temp,ft,opts);      

            df_fit_pos_ave_p1_matrix(i,j)=df_fit_pos_ave.p1;
            df_fit_pos_ave_p2_matrix(i,j)=df_fit_pos_ave.p2;
            df_fit_pos_ave_p3_matrix(i,j)=df_fit_pos_ave.p3;
            
            df_fit_mid_ave_p1_matrix(i,j)=df_fit_mid_ave.p1;
            df_fit_mid_ave_p2_matrix(i,j)=df_fit_mid_ave.p2;
            df_fit_mid_ave_p3_matrix(i,j)=df_fit_mid_ave.p3;
            
            df_fit_neg_ave_p1_matrix(i,j)=df_fit_neg_ave.p1;
            df_fit_neg_ave_p2_matrix(i,j)=df_fit_neg_ave.p2;
            df_fit_neg_ave_p3_matrix(i,j)=df_fit_neg_ave.p3;
            
            
            
            dc2dz2_pos_fwd(i,j)=df_fit_pos_fwd.p1*-2;
            Vcpd_pos_fwd(i,j)=df_fit_pos_fwd.p2./dc2dz2_pos_fwd(i,j);
            offset_pos_fwd(i,j)=-0.5*dc2dz2_pos_fwd(i,j)*Vcpd_pos_fwd(i,j).^2+df_fit_pos_fwd.p3;

            dc2dz2_pos_bkwd(i,j)=df_fit_pos_bkwd.p1*-2;
            Vcpd_pos_bkwd(i,j)=df_fit_pos_bkwd.p2./dc2dz2_pos_bkwd(i,j);
            offset_pos_bkwd(i,j)=-0.5*dc2dz2_pos_bkwd(i,j)*Vcpd_pos_fwd(i,j).^2+df_fit_pos_bkwd.p3;
            
            dc2dz2_pos_ave(i,j)=df_fit_pos_ave.p1*-2;
            Vcpd_pos_ave(i,j)=df_fit_pos_ave.p2./dc2dz2_pos_ave(i,j);
            offset_pos_ave(i,j)=-0.5*dc2dz2_pos_ave(i,j)*Vcpd_pos_fwd(i,j).^2+df_fit_pos_ave.p3;
            
            dc2dz2_mid_fwd(i,j)=df_fit_mid_fwd.p1*-2;
            Vcpd_mid_fwd(i,j)=df_fit_mid_fwd.p2./dc2dz2_mid_fwd(i,j);
            offset_mid_fwd(i,j)=-0.5*dc2dz2_mid_fwd(i,j)*Vcpd_mid_fwd(i,j).^2+df_fit_mid_fwd.p3;
            
            dc2dz2_mid_bkwd(i,j)=df_fit_mid_bkwd.p1*-2;
            Vcpd_mid_bkwd(i,j)=df_fit_mid_bkwd.p2./dc2dz2_mid_bkwd(i,j);
            offset_mid_bkwd(i,j)=-0.5*dc2dz2_mid_bkwd(i,j)*Vcpd_mid_bkwd(i,j).^2+df_fit_mid_bkwd.p3;
            
            dc2dz2_mid_ave(i,j)=df_fit_mid_ave.p1*-2;
            Vcpd_mid_ave(i,j)=df_fit_mid_ave.p2./dc2dz2_mid_ave(i,j);
            offset_mid_ave(i,j)=-0.5*dc2dz2_mid_ave(i,j)*Vcpd_mid_ave(i,j).^2+df_fit_mid_ave.p3;
            
            dc2dz2_neg_fwd(i,j)=df_fit_neg_fwd.p1*-2;
            Vcpd_neg_fwd(i,j)=df_fit_neg_fwd.p2./dc2dz2_neg_fwd(i,j);
            offset_neg_fwd(i,j)=-0.5*dc2dz2_neg_fwd(i,j)*Vcpd_neg_fwd(i,j).^2+df_fit_neg_fwd.p3;
            
            dc2dz2_neg_bkwd(i,j)=df_fit_neg_bkwd.p1*-2;
            Vcpd_neg_bkwd(i,j)=df_fit_neg_bkwd.p2./dc2dz2_neg_bkwd(i,j);
            offset_neg_bkwd(i,j)=-0.5*dc2dz2_neg_bkwd(i,j)*Vcpd_neg_bkwd(i,j).^2+df_fit_neg_bkwd.p3;

            dc2dz2_neg_ave(i,j)=df_fit_neg_ave.p1*-2;
            Vcpd_neg_ave(i,j)=df_fit_neg_ave.p2./dc2dz2_neg_ave(i,j);
            offset_neg_ave(i,j)=-0.5*dc2dz2_neg_ave(i,j)*Vcpd_neg_ave(i,j).^2+df_fit_neg_ave.p3;
    end
end



%%

for i=1:length(x)
    for j=1:length(y)
y1_pos(:,i,j)=polyval([df_fit_pos_ave_p1_matrix(i,j), df_fit_pos_ave_p2_matrix(i,j), df_fit_pos_ave_p3_matrix(i,j)],V);
y1_mid(:,i,j)=polyval([df_fit_mid_ave_p1_matrix(i,j), df_fit_mid_ave_p2_matrix(i,j), df_fit_mid_ave_p3_matrix(i,j)],V);
y1_neg(:,i,j)=polyval([df_fit_neg_ave_p1_matrix(i,j), df_fit_neg_ave_p2_matrix(i,j), df_fit_neg_ave_p3_matrix(i,j)],V);

    end
end 

%%

figure
hold on
i=6;
j=15;



plot(V,dfV.dfV_ave(:,i,j),'DisplayName',mat2str(j))
 plot(V,dfV.dfV_bkwd(:,i,j),'DisplayName',mat2str(j))
plot(V,y1_pos(:,i,j),'k','DisplayName',mat2str(j))
 plot(V,y1_mid(:,i,j),'r','DisplayName',mat2str(j)')
 plot(V,y1_neg(:,i,j),'b','DisplayName',mat2str(j))
line([Vcpd_pos_ave(i,j) Vcpd_pos_ave(i,j)], [-4 -0],'Color','k','DisplayName',mat2str(j));
 line([Vcpd_mid_ave(i,j) Vcpd_mid_ave(i,j)], [-4 -0],'Color','r','DisplayName',mat2str(j));
 
 line([Vcpd_neg_ave(i,j) Vcpd_neg_ave(i,j)], [-4 -0],'Color','b','DisplayName',mat2str(j));

 %%
 
figure
hold on
i=13;
j=12;


        plot(V,difference_mid_ave_smooth(:,i,j),'DisplayName',[mat2str(i) ',' mat2str(j)])


%%

for i=1:length(x)
    for j=1:length(y)-1

difference_neg_fwd_smooth(:,i,j)=smooth(difference_neg_fwd(:,i,j),5);
difference_neg_bkwd_smooth(:,i,j)=smooth(difference_neg_bkwd(:,i,j),5);
difference_neg_ave_smooth(:,i,j)=smooth(difference_neg_ave(:,i,j),5);
difference_mid_ave_smooth(:,i,j)=smooth(difference_mid_ave(:,i,j),9);

difference_pos_ave_smooth(:,i,j)=smooth(difference_pos_ave(:,i,j),9);

    end
end
 
 %%
i=8;
j=7;


 figure
hold on
        plot(V,difference_mid_ave_smooth(:,i,j),'DisplayName',[mat2str(i) ',' mat2str(j)])

    figure
hold on
        plot(V,difference_pos_ave_smooth(:,i,j),'DisplayName',[mat2str(i) ',' mat2str(j)])


    figure
hold on
        plot(V,difference_neg_ave_smooth(:,i,j),'DisplayName',[mat2str(i) ',' mat2str(j)])






%parabola_modeling.m

syms  V

%% all same but df_V
%1A
dC_1=0.5;
dC_2=0.5;
V_CPD_1=0;
V_CPD_2=.2;
offset_1=-1;
offset_2=-1;
V_switch=0.8;
y1_1A=(-1/2*dC_1*(V-V_CPD_1)^2+offset_1);
y2_1A=(-1/2*dC_2*(V-V_CPD_2)^2+offset_2);
df_1A=heaviside(V_switch-V)*y1_1A+heaviside(V-V_switch)*y2_1A;


figure
hold on
ezplot(df_1A,[-1.5,1.5])
ezplot(y1_1A,[-1.5,1.5])
ezplot(y2_1A,[-1.5,1.5])
figure
hold on
ezplot((df_1A-y1_1A),[-1.5, 1.5])

%% 1B
dC_1=0.5;
dC_2=0.5;
V_CPD_1=0;
V_CPD_2=.2;
offset_1=-1;
offset_2=-1;
V_switch=-0.8;
y1_1B=(-1/2*dC_1*(V-V_CPD_1)^2+offset_1);
y2_1B=(-1/2*dC_2*(V-V_CPD_2)^2+offset_2);
df_1B=heaviside(V_switch-V)*y1_1B+heaviside(V-V_switch)*y2_1B;

figure
hold on
ezplot(df_1B,[-1.5,1.5])
ezplot(y1_1B,[-1.5,1.5])
ezplot(y2_1B,[-1.5,1.5])
figure
hold on
ezplot((df_1B-y1_1B),[-1.5, 1.5])
ezplot((df_1A-y1_1A),[-1.5, 1.5])


%% 1C
dC_1=0.5;
dC_2=0.5;
V_CPD_1=0;
V_CPD_2=.2;
offset_1=-1;
offset_2=-1;
V_switch=0.1;
y1_1C=(-1/2*dC_1*(V-V_CPD_1)^2+offset_1);
y2_1C=(-1/2*dC_2*(V-V_CPD_2)^2+offset_2);
df_1C=heaviside(V_switch-V)*y1_1C+heaviside(V-V_switch)*y2_1C;

figure
hold on
ezplot(df_1C,[-1.5,1.5])
ezplot(y1_1C,[-1.5,1.5])
ezplot(y2_1C,[-1.5,1.5])

%% plotting all 3 case 1 difference plots


figure
hold on
ezplot(((df_1A-y1_1A)),[-1.5, 1.5])
ezplot((df_1B-y1_1B+0.02),[-1.5, 1.5])

ezplot(((df_1C-y1_1C)+0.04),[-1.5, 1.5])

%% Case 2_A where vcdp is not the same as well as offset


dC_1=0.5;
dC_2=0.5;
V_CPD_1=0;
V_CPD_2=.2;
offset_1=-1;
offset_2=-.95;
V_switch=0.8;


y1_2A=(-1/2*dC_1*(V-V_CPD_1)^2+offset_1);
y2_2A=(-1/2*dC_2*(V-V_CPD_2)^2+offset_2);
df_2A=heaviside(V_switch-V)*y1_2A+heaviside(V-V_switch)*y2_2A;

figure
hold on
ezplot(df_2A,[-1.5,1.5])
ezplot(y1_2A,[-1.5,1.5])
ezplot(y2_2A,[-1.5,1.5])

%ezplot(((df_2A-y1_2A)),[-1.5, 1.5])

%% 2_B

dC_1=0.5;
dC_2=0.5;
V_CPD_1=0;
V_CPD_2=.2;
offset_1=-0.95;
offset_2=-1;
V_switch=0.8;


y1_2B=(-1/2*dC_1*(V-V_CPD_1)^2+offset_1);
y2_2B=(-1/2*dC_2*(V-V_CPD_2)^2+offset_2);
df_2B=heaviside(V_switch-V)*y1_2B+heaviside(V-V_switch)*y2_2B;

figure
hold on
ezplot(df_2B,[-1.5,1.5])
ezplot(y1_2B,[-1.5,1.5])
ezplot(y2_2B,[-1.5,1.5])

%% 2C

dC_1=0.5;
dC_2=0.5;
V_CPD_1=0;
V_CPD_2=.2;
offset_1=-1;
offset_2=-.95;
V_switch=-.8;


y1_2C=(-1/2*dC_1*(V-V_CPD_1)^2+offset_1);
y2_2C=(-1/2*dC_2*(V-V_CPD_2)^2+offset_2);
df_2C=heaviside(V_switch-V)*y1_2C+heaviside(V-V_switch)*y2_2C;

figure
hold on
ezplot(df_2C,[-1.5,1.5])
ezplot(y1_2C,[-1.5,1.5])
ezplot(y2_2C,[-1.5,1.5])
 

%% 2_D

dC_1=0.5;
dC_2=0.5;
V_CPD_1=0;
V_CPD_2=.2;
offset_1=-0.95;
offset_2=-1;
V_switch=-0.8;


y1_2D=(-1/2*dC_1*(V-V_CPD_1)^2+offset_1);
y2_2D=(-1/2*dC_2*(V-V_CPD_2)^2+offset_2);
df_2D=heaviside(V_switch-V)*y1_2D+heaviside(V-V_switch)*y2_2D;

figure
hold on
ezplot(df_2D,[-1.5,1.5])
ezplot(y1_2D,[-1.5,1.5])
ezplot(y2_2D,[-1.5,1.5])

%% 2E
dC_1=0.5;
dC_2=0.5;
V_CPD_1=0;
V_CPD_2=.2;
offset_1=-1;
offset_2=-.95;
V_switch=0.1;


y1_2E=(-1/2*dC_1*(V-V_CPD_1)^2+offset_1);
y2_2E=(-1/2*dC_2*(V-V_CPD_2)^2+offset_2);
df_2E=heaviside(V_switch-V)*y1_2E+heaviside(V-V_switch)*y2_2E;

figure
hold on
ezplot(df_2E,[-1.5,1.5])
ezplot(y1_2E,[-1.5,1.5])
ezplot(y2_2E,[-1.5,1.5])

%% 2F

dC_1=0.5;
dC_2=0.5;
V_CPD_1=0;
V_CPD_2=.2;
offset_1=-0.95;
offset_2=-1;
V_switch=0.1;


y1_2F=(-1/2*dC_1*(V-V_CPD_1)^2+offset_1);
y2_2F=(-1/2*dC_2*(V-V_CPD_2)^2+offset_2);
df_2F=heaviside(V_switch-V)*y1_2F+heaviside(V-V_switch)*y2_2F;

figure
hold on
ezplot(df_2F,[-1.5,1.5])
ezplot(y1_2F,[-1.5,1.5])
ezplot(y2_2F,[-1.5,1.5])



% %%
% figure
% hold on
% ezplot((df_2A-y1_2A),[-1.5, 1.5])
% ezplot((df_2B-y1_2B),[-1.5, 1.5])
% ezplot((df_2C-y1_2C),[-1.5, 1.5])
% ezplot((df_2D-y1_2D),[-1.5, 1.5])
% ezplot((df_2E-y1_2E),[-1.5, 1.5])
% ezplot((df_2F-y1_2F),[-1.5, 1.5])

i=0.15;
figure
hold on
ezplot((df_2A-y1_2A),[-1.5, 1.5])
ezplot(((df_2B-y1_2B)+i),[-1.5, 1.5])
ezplot(((df_2C-y1_2C)+2*i),[-1.5, 1.5])
ezplot(((df_2D-y1_2D)+3*i),[-1.5, 1.5])
ezplot(((df_2E-y1_2E)+4*i),[-1.5, 1.5])
ezplot(((df_2F-y1_2F)+5*i),[-1.5, 1.5])

figure
hold on
ezplot((df_1A-y1_1A),[-1.5, 1.5])
ezplot((df_2A-y1_2A),[-1.5, 1.5])

%% Case 3 - evvverybody different

%3A_1: Vswitch after maxima, df1 lower df2, dc1 lower dc2
%3A_2: Vswitch after maxima, df1 lower df2, dc1 higher dc2

%3B_1: Vswitch after maxima, df1 higher df2, dc1 lower dc2
%3B_2: Vswitch after maxima, df1 higher df2, dc1 higher dc2

%3C_1: Vswitch before maxima, df1 lower df2, dc1 lower dc2
%3C_2: Vswitch before maxima, df1 lower df2, dc1 higher dc2

%3D_1: Vswitch before maxima, df1 higher df2, dc1 lower dc2
%3D_2: Vswitch before maxima, df1 higher df2, dc1 higher dc2

%3E_1: Vswitch between maxima, df1 lower df2, dc1 lower dc2
%3E_2: Vswitch betweem maxima, df1 lower df2, dc1 higher dc2

%3F_1: Vswitch between maxima, df1 higher df2, dc1 lower dc2
%3F_2: Vswitch between maxima, df1 higher df2, dc1 higher dc2

%% 
%%
%%
%%
%%


%% Case 3A_1


dC_1=0.5;
dC_2=0.2;
V_CPD_1=0;
V_CPD_2=.2;
offset_1=-1;
offset_2=-.95;
V_switch=0.8;


y1_3A_1=(-1/2*dC_1*(V-V_CPD_1)^2+offset_1);
y2_3A_1=(-1/2*dC_2*(V-V_CPD_2)^2+offset_2);
df_3A_1=heaviside(V_switch-V)*y1_3A_1+heaviside(V-V_switch)*y2_3A_1;

figure
hold on
ezplot(df_3A_1,[-1.5,1.5])
ezplot(y1_3A_1,[-1.5,1.5])
ezplot(y2_3A_1,[-1.5,1.5])

figure
hold on
ezplot((df_3A_1-y1_3A_1),[-1.5, 1.5])

%% Case 3A_2


dC_1=0.2;
dC_2=0.5;
V_CPD_1=0;
V_CPD_2=.2;
offset_1=-1;
offset_2=-.95;
V_switch=0.8;


y1_3A_2=(-1/2*dC_1*(V-V_CPD_1)^2+offset_1);
y2_3A_2=(-1/2*dC_2*(V-V_CPD_2)^2+offset_2);
df_3A_2=heaviside(V_switch-V)*y1_3A_2+heaviside(V-V_switch)*y2_3A_2;

figure
hold on
ezplot(df_3A_2,[-1.5,1.5])
ezplot(y1_3A_2,[-1.5,1.5])
ezplot(y2_3A_2,[-1.5,1.5])

figure
hold on
ezplot((df_3A_2-y1_3A_2),[-1.5, 1.5])

%% Case 3B_1


dC_1=0.5;
dC_2=0.2;
V_CPD_1=0;
V_CPD_2=.2;
offset_1=-.95;
offset_2=-1;
V_switch=0.8;


y1_3B_1=(-1/2*dC_1*(V-V_CPD_1)^2+offset_1);
y2_3B_1=(-1/2*dC_2*(V-V_CPD_2)^2+offset_2);
df_3B_1=heaviside(V_switch-V)*y1_3B_1+heaviside(V-V_switch)*y2_3B_1;

figure
hold on
ezplot(df_3B_1,[-1.5,1.5])
ezplot(y1_3B_1,[-1.5,1.5])
ezplot(y2_3B_1,[-1.5,1.5])

figure
hold on
ezplot((df_3B_1-y1_3B_1),[-1.5, 1.5])

%% Case 3B_2


dC_1=0.2;
dC_2=0.5;
V_CPD_1=0;
V_CPD_2=.2;
offset_1=-.95;
offset_2=-1;
V_switch=0.8;


y1_3B_2=(-1/2*dC_1*(V-V_CPD_1)^2+offset_1);
y2_3B_2=(-1/2*dC_2*(V-V_CPD_2)^2+offset_2);
df_3B_2=heaviside(V_switch-V)*y1_3B_2+heaviside(V-V_switch)*y2_3B_2;

figure
hold on
ezplot(df_3B_2,[-1.5,1.5])
ezplot(y1_3B_2,[-1.5,1.5])
ezplot(y2_3B_2,[-1.5,1.5])

figure
hold on
ezplot((df_3B_2-y1_3B_2),[-1.5, 1.5])

%% 
%% 


%% Case 3C_1


dC_1=0.5;
dC_2=0.2;
V_CPD_1=0;
V_CPD_2=.2;
offset_1=-1;
offset_2=-.95;
V_switch=-0.8;


y1_3C_1=(-1/2*dC_1*(V-V_CPD_1)^2+offset_1);
y2_3C_1=(-1/2*dC_2*(V-V_CPD_2)^2+offset_2);
df_3C_1=heaviside(V_switch-V)*y1_3C_1+heaviside(V-V_switch)*y2_3C_1;

figure
hold on
ezplot(df_3C_1,[-1.5,1.5])
ezplot(y1_3C_1,[-1.5,1.5])
ezplot(y2_3C_1,[-1.5,1.5])

figure
hold on
ezplot((df_3C_1-y1_3C_1),[-1.5, 1.5])

%% Case 3C_2


dC_1=0.2;
dC_2=0.5;
V_CPD_1=0;
V_CPD_2=.2;
offset_1=-1;
offset_2=-.95;
V_switch=-0.8;


y1_3C_2=(-1/2*dC_1*(V-V_CPD_1)^2+offset_1);
y2_3C_2=(-1/2*dC_2*(V-V_CPD_2)^2+offset_2);
df_3C_2=heaviside(V_switch-V)*y1_3C_2+heaviside(V-V_switch)*y2_3C_2;

figure
hold on
ezplot(df_3C_2,[-1.5,1.5])
ezplot(y1_3C_2,[-1.5,1.5])
ezplot(y2_3C_2,[-1.5,1.5])

figure
hold on
ezplot((df_3C_2-y1_3C_2),[-1.5, 1.5])

%% Case 3D_1


dC_1=0.5;
dC_2=0.2;
V_CPD_1=0;
V_CPD_2=.2;
offset_1=-.95;
offset_2=-1;
V_switch=-0.8;


y1_3D_1=(-1/2*dC_1*(V-V_CPD_1)^2+offset_1);
y2_3D_1=(-1/2*dC_2*(V-V_CPD_2)^2+offset_2);
df_3D_1=heaviside(V_switch-V)*y1_3D_1+heaviside(V-V_switch)*y2_3D_1;

figure
hold on
ezplot(df_3D_1,[-1.5,1.5])
ezplot(y1_3D_1,[-1.5,1.5])
ezplot(y2_3D_1,[-1.5,1.5])

figure
hold on
ezplot((df_3D_1-y1_3D_1),[-1.5, 1.5])

%% Case 3D_2


dC_1=0.2;
dC_2=0.5;
V_CPD_1=0;
V_CPD_2=.2;
offset_1=-.95;
offset_2=-1;
V_switch=-0.8;


y1_3D_2=(-1/2*dC_1*(V-V_CPD_1)^2+offset_1);
y2_3D_2=(-1/2*dC_2*(V-V_CPD_2)^2+offset_2);
df_3D_2=heaviside(V_switch-V)*y1_3D_2+heaviside(V-V_switch)*y2_3D_2;

figure
hold on
ezplot(df_3D_2,[-1.5,1.5])
ezplot(y1_3D_2,[-1.5,1.5])
ezplot(y2_3D_2,[-1.5,1.5])

figure
hold on
ezplot((df_3D_2-y1_3D_2),[-1.5, 1.5])

%% 
%% 


%% Case 3E_1


dC_1=0.5;
dC_2=0.2;
V_CPD_1=0;
V_CPD_2=.2;
offset_1=-1;
offset_2=-.95;
V_switch=0.1;


y1_3E_1=(-1/2*dC_1*(V-V_CPD_1)^2+offset_1);
y2_3E_1=(-1/2*dC_2*(V-V_CPD_2)^2+offset_2);
df_3E_1=heaviside(V_switch-V)*y1_3E_1+heaviside(V-V_switch)*y2_3E_1;

figure
hold on
ezplot(df_3E_1,[-1.5,1.5])
ezplot(y1_3E_1,[-1.5,1.5])
ezplot(y2_3E_1,[-1.5,1.5])

figure
hold on
ezplot((df_3E_1-y1_3E_1),[-1.5, 1.5])

%% Case 3E_2


dC_1=0.2;
dC_2=0.5;
V_CPD_1=0;
V_CPD_2=.2;
offset_1=-1;
offset_2=-.95;
V_switch=0.1;


y1_3E_2=(-1/2*dC_1*(V-V_CPD_1)^2+offset_1);
y2_3E_2=(-1/2*dC_2*(V-V_CPD_2)^2+offset_2);
df_3E_2=heaviside(V_switch-V)*y1_3E_2+heaviside(V-V_switch)*y2_3E_2;

figure
hold on
ezplot(df_3E_2,[-1.5,1.5])
ezplot(y1_3E_2,[-1.5,1.5])
ezplot(y2_3E_2,[-1.5,1.5])

figure
hold on
ezplot((df_3E_2-y1_3E_2),[-1.5, 1.5])

%% Case 3F_1


dC_1=0.5;
dC_2=0.2;
V_CPD_1=0;
V_CPD_2=.2;
offset_1=-.95;
offset_2=-1;
V_switch=0.1;


y1_3F_1=(-1/2*dC_1*(V-V_CPD_1)^2+offset_1);
y2_3F_1=(-1/2*dC_2*(V-V_CPD_2)^2+offset_2);
df_3F_1=heaviside(V_switch-V)*y1_3F_1+heaviside(V-V_switch)*y2_3F_1;

figure
hold on
ezplot(df_3F_1,[-1.5,1.5])
ezplot(y1_3F_1,[-1.5,1.5])
ezplot(y2_3F_1,[-1.5,1.5])

figure
hold on
ezplot((df_3F_1-y1_3F_1),[-1.5, 1.5])

%% Case 3F_2


dC_1=0.2;
dC_2=0.5;
V_CPD_1=0;
V_CPD_2=.2;
offset_1=-.95;
offset_2=-1;
V_switch=0.1;


y1_3F_2=(-1/2*dC_1*(V-V_CPD_1)^2+offset_1);
y2_3F_2=(-1/2*dC_2*(V-V_CPD_2)^2+offset_2);
df_3F_2=heaviside(V_switch-V)*y1_3F_2+heaviside(V-V_switch)*y2_3F_2;

figure
hold on
ezplot(df_3F_2,[-1.5,1.5])
ezplot(y1_3F_2,[-1.5,1.5])
ezplot(y2_3F_2,[-1.5,1.5])

figure
hold on
ezplot((df_3F_2-y1_3F_2),[-1.5, 1.5])

%%


i=0.6;
k=0.3;
figure
hold on
ezplot((df_3A_1-y1_3A_1),[-1.5, 1.5])
ezplot(((df_3A_2-y1_3A_2)+k),[-1.5, 1.5])

ezplot(((df_3B_1-y1_3B_1)+i),[-1.5, 1.5])
ezplot(((df_3B_2-y1_3B_2)+i+k),[-1.5, 1.5])

ezplot(((df_3C_1-y1_3C_1)+2*i),[-1.5, 1.5])
ezplot(((df_3C_2-y1_3C_2)+2*i+k),[-1.5, 1.5])

ezplot(((df_3D_1-y1_3D_1)+3*i),[-1.5, 1.5])
ezplot(((df_3D_2-y1_3D_2)+3*i+k),[-1.5, 1.5])

ezplot(((df_3E_1-y1_3E_1)+4*i),[-1.5, 1.5])
ezplot(((df_3E_2-y1_3E_2)+4*i+k),[-1.5, 1.5])

ezplot(((df_3F_1-y1_3F_1)+5*i),[-1.5, 1.5])
ezplot(((df_3F_2-y1_3F_2)+5*i+k),[-1.5, 1.5])


%dfV_model_ncafm.m

syms  V

% Case 2_A where vcdp is not the same as well as offset and 2 fits


dC_1=0.85;
dC_2=0.85;
V_CPD_1=-0.1;
V_CPD_2=.05;
offset_1=-1;
offset_2=-.97;
V_switch=0.5;


y1_2A=(-1/2*dC_1*(V-V_CPD_1)^2+offset_1);
y2_2A=(-1/2*dC_2*(V-V_CPD_2)^2+offset_2);
df_2A=heaviside(V_switch-V)*y1_2A+heaviside(V-V_switch)*y2_2A;

figure
hold on
ezplot(df_2A,[-1.25,1.5])
ezplot(y1_2A,[-1.25,1.5])
ezplot(y2_2A,[-1.25,1.5])

%ezplot(((df_2A-y1_2A)),[-1.5, 1.5])

%% 3 fits exactly matching ptcda

syms  V

% Case 2_A where vcdp is not the same as well as offset and 2 fits


dC_1=0.92;
dC_2=0.92;
dC_3=0.92;
V_CPD_1=0.01753;
V_CPD_2=.061;
V_CPD_3=0.14;
offset_1=-1.745;
offset_2=-1.77;
offset_3=-1.86;
V_switch_a=-0.32;
V_switch_b=0.64;


y1_2A=(-1/2*dC_1*(V-V_CPD_1)^2+offset_1);
y2_2A=(-1/2*dC_2*(V-V_CPD_2)^2+offset_2);
y3_2A=(-1/2*dC_3*(V-V_CPD_3)^2+offset_3);

df_2A=heaviside(V_switch_a-V)*heaviside(V_switch_b-V)*y1_2A+heaviside(V-V_switch_a)*heaviside(V_switch_b-V)*y2_2A+heaviside(V-V_switch_a)*heaviside(V-V_switch_b)*y3_2A;

figure
hold on
ezplot(df_2A,[-1.25,1.5])
ezplot(y1_2A,[-1.25,1.5])
ezplot(y2_2A,[-1.25,1.5])
ezplot(y3_2A,[-1.25,1.5])

%% 3 fits exadurated

syms  V

% Case 2_A where vcdp is not the same as well as offset and 2 fits


dC_1=0.7;
dC_2=0.7;
dC_3=0.7;
V_CPD_1=-.5;
V_CPD_2=-.3;
V_CPD_3=-.1;
offset_1=-1.73;
offset_2=-1.7;
offset_3=-1.67;
V_switch_a=-0.4;
V_switch_b=0.6;


y1_2A=(-1/2*dC_1*(V-V_CPD_1)^2+offset_1);
y2_2A=(-1/2*dC_2*(V-V_CPD_2)^2+offset_2);
y3_2A=(-1/2*dC_3*(V-V_CPD_3)^2+offset_3);

df_2A=heaviside(V_switch_a-V)*heaviside(V_switch_b-V)*y1_2A+heaviside(V-V_switch_a)*heaviside(V_switch_b-V)*y2_2A+heaviside(V-V_switch_a)*heaviside(V-V_switch_b)*y3_2A;

figure
hold on
ezplot(df_2A,[-1.25,1.5])
ezplot(y1_2A,[-1.25,1.5])
ezplot(y2_2A,[-1.25,1.5])
ezplot(y3_2A,[-1.25,1.5])
line([V_CPD_1 V_CPD_1],[-3 0])
line([V_CPD_2 V_CPD_2],[-3 0])
line([V_CPD_3 V_CPD_3],[-3 0])
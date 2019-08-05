%to make this more accurate, you need a figure with the lattice showing
%This script performs the polarization calculation for the selected molecule
%You need to have the relevant image (topography) figure open
clear all

e_charge=1.60217662e-19; %charge of electron in Coulombs
epsilon_0=8.854187817e-12; %epsilon naught in C^2*N^-1*m^-2

message = ['select the center of molecule for which you are calculating the polarization energy,'...
'press RETURN when done'];
h=msgbox(message);

[x0,y0]=getpts;

delete(h)

message = ['how many PTCDAs? Remember to comment out the relevant sections (or vice versa).'...
    'Dont include the molecule you are calculating the energy for'...
    'Press OK after answering'];
n = inputdlg(message);
n=str2num(n{1});
b=zeros(n,1);
R=zeros(n,1);

%%%%%PTCDA1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%get the long axis of the PTCDA molecule
message = ['select the points at ends of the long axis of the first PTCDA,'...
    'PICK CLOSEST POINT FIRST'...
'press RETURN when done'];
h=msgbox(message);

[Px1,Py1]=getpts;

delete(h)

%change coordinate origin to molecule of interest

for i=1:length(Px1)
    Px1(i)=Px1(i)-x0;
    Py1(i)=Py1(i)-y0;
end

%find lengths of the two vectors just defined to use in law of cosines
r1=zeros(length(Px1),1);

for i=1:length(Px1)
    r1(i)=sqrt(Px1(i)^2+Py1(i)^2);
    r1(i)=r1(i)*1e-9;
end

%get angles of two vectors just defined wrt x axis
a1=zeros(length(Px1)+1,1);
for i=1:length(Px1)
    a1(i)=atan2(Py1(i), Px1(i));
end

%get angle between two vectors
a1(3)=a1(1)-a1(2);

%apply law of cosines to find beta (b)

R(1) = sqrt(r1(1)^2+r1(2)^2-2*r1(1)*r1(2)*cos(a1(3)));
b(1) = acos((r1(1)^2+r1(2)^2-R(1)^2)/(2*r1(1)*r1(2)));

%%%%%%PTCDA2%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
%get the long axis of the PTCDA molecule
message = ['select the points at ends of the long axis of the next PTCDA,'...
    'PICK CLOSEST TO CENTER POINT FIRST'...
'press RETURN when done'];
h=msgbox(message);

[Px2,Py2]=getpts;

delete(h)

%change coordinate origin to molecule of interest

for i=1:length(Px2)
    Px2(i)=Px2(i)-x0;
    Py2(i)=Py2(i)-y0;
end

%find lengths of the two vectors just defined to use in law of cosines and
%final calculation
r2=zeros(length(Px2)+1,1);

for i=1:length(Px2)
    r2(i)=sqrt(Px2(i)^2+Py2(i)^2);
    r2(i)=r2(i)*1e-9;
end

%get angles of two vectors just defined wrt x axis
a2=zeros(length(Px2)+1,1);
for i=1:length(Px2)
    a2(i)=atan2(Py2(i), Px2(i));
end

%get angle between two vectors
a2(3)=a2(1)-a2(2);

%apply law of cosines to find beta (b)

R(2) = sqrt(r2(1)^2+r2(2)^2-2*r2(1)*r2(2)*cos(a2(3)));
b(2) = acos((r2(1)^2+r2(2)^2-R(2)^2)/(2*r2(1)*r2(2)));

%%%%%%CuPc%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%}
message = ['select the center of all the other CuPc molecules'...
'press RETURN when done'];
h=msgbox(message);

[Cx,Cy]=getpts;

delete(h)

%change coordinate origin to molecule of interest

for i=1:length(Cx)
    Cx(i)=Cx(i)-x0;
    Cy(i)=Cy(i)-y0;
end

%find lengths of the vectors just defined to use in law of cosines and
%final calculation
rC=zeros(length(Cx),1);

for i=1:length(Cx)
    rC(i)=sqrt(Cx(i)^2+Cx(i)^2);
    rC(i)=rC(i)*1e-9;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%now finally calculate the energy
aS = 50.3*((1e-10)^3);
aL = 88.2*((1e-10)^3);

aCUPC = 135.8*((1e-10)^3);

k=e_charge^2/(4*pi*epsilon_0);

E = zeros((n+length(Cx)),1);

for i=1:length(b)
    E(i)=(aS*(sin(b(i)))^2+aL*(cos(b(i)))^2)/((R(i))^4); 
end

for i=(length(b)+1):(length(b)+length(Cx))
    E(i)=aCUPC/(rC(i-length(b))^4);
end

E_total=k*sum(E); %energy in Joules

%convert to eV
E_total_eV = E_total*(6.2415093e18)


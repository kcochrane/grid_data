%plot and extract topography

function [Z_plane]=plot_topography(file)


%add the path to the data files
%path='C:\Users\TanyaRoussy628\Dropbox\MASC\CuPC_PTCDA_Analysis\XO_laser_power_study';
%addpath(path);

% paste file name here:
%file='20160106-112011_Ag(111)_NaCl_PTCDA_CuPc--99_1.Z_flat';

%%Plane subtraction - points currently arbitrary
%enter points below (x1,y1), (x2,y2), (x3,y3) (in nm)
x1=-0.5;
y1=0.5;
x2=0;
y2=0;
x3=.5;
y3=.5;

f=flat_parse(file);
m=flat2matrix(f);

x_m=m{1,2};
x_nm=x_m*10^9;
y_m=m{1,3};
y_nm=y_m*10^9;
Z=m{1,1};

%{
figname='Raw Topography';
figure ('Name', figname);
imagesc(x_nm, y_nm, Z');
axis xy;
axis image;
ylabel('y [nm]');
xlabel('x [nm]');
colorbar;
%}

[Z_plane]=PlaneSubstraction (Z, x_nm, y_nm, x1, y1, x2, y2, x3, y3);

clims=[0 7e-10];
%{
figname='Plane corrected Topography';
figure ('Name', figname);
imagesc(x_nm, y_nm, Z_plane');
colormap(gray)
axis xy;
axis image;
ylabel('y [nm]');
xlabel('x [nm]');
colorbar;
%}

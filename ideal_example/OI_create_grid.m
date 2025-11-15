function create_grid(lon_west, lon_est, lat_south, lat_north, grid_step)
%
% lon_west  0-360
% lon_est  0-360
%last _south  -180-180
%lat_north
% grid_step

% bg corr length scale in number of grid

 cov_lx=10;
 cov_ly=10;
%
% background RMS error
 be_err=1;

% Ob error
 err_ob=0.1;
%
% grid set up
 lat1=20:0.1:50;
 lon1=130:0.1:160;
%
% 2D grid array 
%
 [lon2,lat2]=meshgrid(lon1,lat1);
 lon=lon2';
 lat=lat2';
 [M,N]=size(lat);

 return


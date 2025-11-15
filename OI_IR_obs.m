
function [nir_obs]=OI_IR_obs(grid_coor,date,casename,input_dir,fig_dir);
% ftp://coastwatch.noaa.gov/pub/socd2/coastwatch/sst/ran/viirs/npp/l3u

if nargin ~=5;
    disp('??? Error! Not enough input arguments, please retry!')
else
    
    viirs_file=[input_dir,'viirs/',datestr(date,'yyyymmdd'),'_viirs.nc'];
    
    dataname='IR';

    if ~exist(viirs_file,'file');
    
        disp('--- lack viirs data, must use initial data process');
        
        OI_viirs_data(date,input_dir);
    end
        disp('--- viirs data existed');
    
    %=====================================================================
    % read the viirs 
        lon_ob=double(ncread(viirs_file,'lon'));
        lat_ob=double(ncread(viirs_file,'lat'));
        sst=double(ncread(viirs_file,'sst'));
      
     
        nir_obs=OI_focus_area(grid_coor,lon_ob,lat_ob,sst,dataname,date,casename,fig_dir);
        

end
return

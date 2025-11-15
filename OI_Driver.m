% Multiscale optimal interplation algorithm 
% Developed by Ms. Ying Wen, Prof Zhijin Li 
%    Deparment of Atmospheric and Oceanic Sceinces
%    Fudan University
% January, 2025
% Copyright @2025 
% Refernce:
%
% Contact: 
%
% Requirement: matlab higher than matlab 2018
%

clear all; close all; clc;

disp('...')
disp(['... Multiscale optimal interplation algorithm'])
disp(['... Deparment of Atmospheric and Oceanic Sceinces'])
disp(['... Fudan University'])
disp(['... '])

disp(['... ',mfilename,' start at ',datestr(now),'------']);


%  set up
% set casename
  casename='ECS47';

disp(['... Case ', casename])

% set initial date

  date_ini=datenum(2024,09,04,0,0,0);

  date=date_ini;

% set directory 
  parent_directory='./';
  fig_dir      = [parent_directory,'figures/'];
  output_dir   = [parent_directory,'output/'];
  input_dir    = [parent_directory,'input/'];
  static_dir   = [input_dir,'data/'];
  tool_dir     = [parent_directory,'tools/'];
  tutorial_dir = [parent_directory,'ideal_example/'];
  
  addpath(genpath(tool_dir));
  
% set domain scope and grid size in lat(-90-90) and lon(0-360);
  lon_west=120;
  lon_east=128;
  lat_south=24;
  lat_north=34;
  grid_step=0.03;%0.03;

% set start method, cold or hot
% cold start: background interpolated from the WOA climatological data
  start_method='cold' ;  

% wether enter the tutoril example?  yes or no
  tutorial_case='no';

% % parallel
  numCore=15;

% thin
  intervalNum1=1;  % microwave sensor data
  intervalNum2=1;  % nir sensor data
  
%   
% Specify the background error: 
  eb_type='be_constant';  %   constant
%  eb_type='be_variable';  %   variable
%
  switch eb_type
    case 'be_constant';
        disp('...');
        disp('... Background error is spatially constant');
        eb=0.5;
    case 'be_variable';
        eb_datafile=[input_dir,'eb_file.dat'];
        if exist(eb_datafile,'file');        
            disp('... Background error spatially varies and from the data file:');
            disp(['... data file: ',eb_datafile]);       
            data=load(eb_datafile);
            eb=data;
        else
            disp('... Lack the eb_file.dat');
        end
  end

%
% Correlation coefficient scale length
  disp('... Correlation coefficient scale length');
  cov_len_mv=0.5;   %mircowave sensor data
  cov_len_ir=0.06;  %nir sensor data
  
% specify observational error. The default valuse as 1/2 of eb;
  disp('... Observational RMSE');
%
% microwave SST
  ob_err_mv=0.5;  
% Infra-red SST
  ob_err_ir=0.2;  
%
% specify the directory and filenames of OI analyses
%
  results_file=[output_dir,casename,'_',datestr(date,'yyyymmdd'),'_analysis.nc'];
  disp(['... Output OI analysis file: ', results_file]);
  disp('... ')
%
disp('... USER DEFINE END');

%==========================================================================
switch  tutorial_case
    case 'yes';      
        disp('... Tutorial example case');
            cd tutorial_dir;
            OI_Driver
    case 'no'
        disp('... Real case')
        
    % 2D grid array  lon 0-360  lat -90-90
    [lon,lat]=OI_create_grid(lon_west, lon_east, lat_south, lat_north,grid_step,fig_dir,casename);
    [M,N]=size(lat);
    grid_coor.lon=lon;
    grid_coor.lat=lat;
    disp(['... Grid generated'])

%=====
% mask file: land=0; water=1;
%
    disp('--- Mask created: water=1, land=0')
    mask=OI_mask_setup(grid_coor,casename,input_dir,output_dir); 
  
    %======================================================================
%%start method
    switch start_method
        case 'cold'
            
        %==============================================================
        % use woa2023 generate the background
        disp('... WOA2023 monthly data as background ');
            hb_woa=OI_background_setup(grid_coor,casename,date,input_dir,output_dir,fig_dir);      
         
        %===============================================================
        % obs microwave data process
        % the input data name was: RSS_AMSR2_ocean_L3_daily_2024-09-04_v08.2.nc
        % file was in the input folder
        disp('... MV SST processing')
             mic_obs=OI_mv_obs(grid_coor,date,casename,input_dir,fig_dir);
        
        %==============================================================
        disp(['... Blending MV SST for low resolution'])
        disp('... ')
             [ha_mic,xa_inc_mic,obs_mic_thin]=OI_mv_case(grid_coor,mic_obs,eb,ob_err_mv,hb_woa,grid_step,cov_len_mv);
        disp(['... MIC analysis done'])
       
       
        disp(['... plotting MV SST'])
            OI_mv_plot(grid_coor,ha_mic,fig_dir,casename,date);
            
             
        %==============================================================               
        % virrs data combine (48hr)
        %the input data name:  20240904_viirs.nc  
        disp('... IR SST processing')   
      
             nir_obs=OI_IR_obs(grid_coor,date,casename,input_dir,fig_dir);
             
        disp(['... IR SST done']);    
        
        %==============================================================
        % the analysis filed of nir data;
        disp(['... Blending IR SST for high resolution']) 
        disp('... ')
             [ha_nir,xa_inc_nir,obs_nir_thin]=OI_IR_case(grid_coor,nir_obs,ha_mic,eb,ob_err_ir,grid_step,cov_len_ir);
        
        disp(['... IR analysis done']);
                
        
        disp(['... plotting IR SST'])
            OI_IR_plot(grid_coor,ha_nir,fig_dir,casename,date);       
        disp('... ')
    case 'hot'
        
        date0=date-1;
        
        restart_file=[output_dir,casename,'_',datestr(date0,'yyyymmdd'),'_analysis.nc']; 
        
        if exist(restart_file,'file');
            
        disp('... Restart file existed------');
            
        %===============================================================
        % use the ha_nir as the background 
        disp(['... MV data of the day before as background']);
            
            hb=double(ncread(restart_file,'analysis_sst_of_nir'));
            
            hb=OI_background_process(grid_coor,hb);
            
            hb_woa=smooth2a(hb,6,6);   
            
            
            %===============================================================
            % obs microwave data process
            % the input data name was: RSS_AMSR2_ocean_L3_daily_2024-09-04_v08.2.nc
            % file was in the input folder
        disp('... MV SST processing')
            mic_obs=OI_mv_obs(grid_coor,date,casename,input_dir,fig_dir);           

        %==============================================================
        disp(['... Blending MV SST for low resolution'])
        disp('... ')
            [ha_mic,xa_inc_mic,obs_mic_thin]=OI_mv_case(grid_coor,mic_obs,eb,ob_err_mv,hb_woa,grid_step,cov_len_mv);
        disp(['... MIC analysis done'])
       
       
        disp(['... plotting MV SST'])
            OI_mv_plot(grid_coor,ha_mic,fig_dir,casename,date);
            
             
        %==============================================================               
        % virrs data combine (48hr)
        %the input data name:  20240904_viirs.nc  
        disp('... IR SST processing')   
       
            viirs_file=[input_dir,datestr(date,'yyyymmdd'),'_viirs.nc']; 
             if ~exist(viirs_file,'file');   
                 OI_viirs_data(date,input_dir);    
            end
  
           
            nir_obs=OI_IR_obs(grid_coor,date,casename,input_dir,fig_dir);
             
        disp(['... IR SST done']);    
        
        %==============================================================
        % the analysis filed of nir data;
        disp(['... Blending IR SST for high resolution'])  
        disp('... ')
            [ha_nir,xa_inc_nir,obs_nir_thin]=OI_IR_case(grid_coor,nir_obs,ha_mic,eb,ob_err_ir,grid_step,cov_len_ir);
        
        disp(['... IR analysis done']);
                
        
        disp(['... plotting IR SST']);
            OI_IR_plot(grid_coor,ha_mic,fig_dir,casename,date);                
        disp('... ')   
        else
            
            disp('... Lack restart file: ',restart_file,' pleae use the cold start');
            
        end
        
    end
    
end

% %output nc file
disp(['... Output the analysis file: ',results_file]);

  OI_analysis_output_file(ha_nir,ha_mic,hb_woa,grid_coor,results_file,mask);


disp(['... CASE end at ',datestr(now),'------']);

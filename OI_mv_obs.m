
function obs=OI_mv_obs(grid_coor,date,casename,input_dir,fig_dir);
%  deal the AMSR2 data 
%  output was the scatter data without nan

if nargin ~=5;
    
    disp('??? Error! Not enough input arguments, please retry!');
    
else

 dataname='MV'; %'AMSR2';   % Î¢²¨Êý¾Ý
 date0=date-1; %datenum(0000,00,01,0,0,0);
 datem=datestr(date0,'yyyy-mm-dd');
 sst=[];
 ii=0;
 
 while (datem<=date);
     ii=ii+1;
     obfile=[input_dir,'AMSR2/RSS_AMSR2_ocean_L3_daily_',datestr(datem,'yyyy-mm-dd'),'_v08.2.nc'];
%      ncdisp(obfile);
     lon_ob=double(ncread(obfile,'lon'));
     lat_ob=double(ncread(obfile,'lat'));
     SST_ob=ncread(obfile,'SST');
     st=nanmean(SST_ob,3);    
     sst(:,:,ii)=st(:,:);
     
     datem=datenum(datem)+1; %datenum(0000,00,01,0,0,0);
 end
 
 sst=nanmean(sst,3);

 obs=OI_focus_area(grid_coor,lon_ob,lat_ob,sst,dataname,date,casename,fig_dir);


end

 return

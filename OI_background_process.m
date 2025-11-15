function SST=OI_background_process(grid_coor,hb);
    if nargin~=2;
        disp('??? Error! Not enough input arguments, please retry!');
        SST=[];
        
    else
        lon=grid_coor.lon;
        lat=grid_coor.lat;
        
        WLon=reshape(lon,[size(lon,1)*size(lon,2),1]);
        WLat=reshape(lat,[size(lon,1)*size(lon,2),1]);
        Sst1=reshape(hb,[size(lon,1)*size(lon,2),1]);
        
        z=find(~isnan(Sst1));
        
        WLon1=WLon(z);
        WLat1=WLat(z);
        Sst2=Sst1(z);
      
        SST=griddata(WLon1,WLat1,Sst2,lon,lat,'nearest');
      

    end



return

function SST=OI_background_setup(grid_coor,casename,date,input_dir,output_dir,fig_dir);


if nargin~=6;
    disp('??? Error! Not enough input arguments, please retry!');
    SST=[];
else
    lon=grid_coor.lon;
    lat=grid_coor.lat;
	
	dataname='WOA2023';
    
    Month=month(date);
    
    file=[output_dir,casename,'_background_woa2023_',sprintf('%02d',Month),'.mat'];
    
    if exist(file,'file');
        disp('--- background filed existed------');
        load (file);
        
    else
   
        woa_file=[input_dir,'woa/','woa23_decav_t',sprintf('%02d',Month),'_04.nc'];
        
        disp(['--- WOA data processing: ',woa_file])
        
        t_an=ncread(woa_file,'t_an');
        sst=double(t_an(:,:,1));
        wlon=double(ncread(woa_file,'lon'));
        wlat=double(ncread(woa_file,'lat'));

        sst=sst';
            
        x0=min(min(lon))-0.2;
        x1=max(max(lon))+0.2;
        y0=min(min(lat))-0.2;
        y1=max(max(lat))+0.2;
        index_x=find(wlon>= x0 & wlon<=x1);  %& 1440
        index_y=find(wlat>= y0 & wlat<=y1 );  %& 720     
        
        
        [wLon,wLat]=meshgrid(wlon(index_x),wlat(index_y));
        Sst_woa=sst(index_y,index_x);
        
        
        WLon=reshape(wLon,[size(wLon,1)*size(wLon,2),1]);
        WLat=reshape(wLat,[size(wLon,1)*size(wLon,2),1]);
        Sst1=reshape(Sst_woa,[size(wLon,1)*size(wLon,2),1]);
        
        z=find(~isnan(Sst1));
        
        WLon1=WLon(z);
        WLat1=WLat(z);
        Sst2=Sst1(z);
      
        SST=griddata(WLon1,WLat1,Sst2,lon,lat,'nearest');
       
        save(file,'SST');
        
        %visible
        figure('position',[0 0 800 600],'Visible','on');
        %  set(0,'DefaultFigureVisible', 'off');
        m_proj('miller','lon',[min(min(lon)) max(max(lon))],'lat',[min(min(lat)) max(max(lat))]);
        set(gca,'fontname', 'Arial', 'fontsize', 12);
        m_pcolor(wLon,wLat,Sst_woa);    
        shading interp;
        hold on;
        m_grid('box','fancy');
        m_gshhs('h','patch',[205 201 201]./255);
        caxis([20 32])
        colormap(nclCM(18,256)); 
        hc=colorbar;
        ylabel(hc,'SST (^oC)');
        title('WOA2023');
        xlabel('Longitude','fontsize',15,'fontweight','bold');
        ylabel('Latitude','fontsize',15,'fontweight','bold');
        grid off;
        print(gcf,'-dpng','-r600',[fig_dir,casename,'_',dataname,'_',datestr(date,'yyyymmdd'),'_woa2023_initial.png']);      
  
    end

    figure('position',[0 0 800 600],'Visible','on');
    %set(0,'DefaultFigureVisible', 'off');
    m_proj('miller','lon',[min(min(lon)) max(max(lon))],'lat',[min(min(lat)) max(max(lat))]);
    set(gca,'fontname', 'Arial', 'fontsize', 12);
    m_pcolor(lon,lat,SST);
    shading interp;
    hold on;
    m_grid('box','fancy');
    m_gshhs('h','patch',[205 201 201]./255);
    caxis([20 32])
    colormap(nclCM(18,256)); 
    hc=colorbar;
    ylabel(hc,'SST (^oC)');
    title(dataname);
    grid off;
    xlabel('Longitude','fontsize',15,'fontweight','bold');
    ylabel('Latitude','fontsize',15,'fontweight','bold');
    print(gcf,'-dpng','-r600',[fig_dir,casename,'_',dataname,'_',datestr(date,'yyyymmdd'),'_background.png']);
end

return

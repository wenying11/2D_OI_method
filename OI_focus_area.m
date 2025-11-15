function obs=OI_focus_area(grid_coor,lon_ob,lat_ob,sst,dataname,date,casename,fig_dir);

if nargin ~=8;
    disp('??? Error! Not enough input arguments, please retry!');
    obs=[];
else
     %%  search area
     lon=grid_coor.lon;
     lat=grid_coor.lat;
     deltx=lon(1,2)-lon(1,1);
     delty=lat(2,1)-lat(1,1);
    x0=min(min(lon))-deltx;
    x1=max(max(lon))+deltx;
    y0=min(min(lat))-delty;
    y1=max(max(lat))+delty;
    index_x=find(lon_ob>= x0 & lon_ob<=x1);  %&
    index_y=find(lat_ob>=y0 & lat_ob<=y1);  %& 
    
    % 
    [x,y]=meshgrid(lon_ob(index_x),lat_ob(index_y));
    %
    sst=sst';
    sst1=sst(index_y,index_x);
    [m,n]=size(x);

    ho=reshape(sst1,[m*n,1]);
    xob=reshape(x,[m*n,1]);
    yob=reshape(y,[m*n,1]);
    ind_nan=find(~isnan(ho));
%  
    ho=ho(ind_nan);
    xob=xob(ind_nan);
    yob=yob(ind_nan);
 %   
    obs.ho=ho;
    obs.xob=xob;
    obs.yob=yob;
 
    disp(['--- ','plotting ',dataname,' obs SST']);
    %visible 
     figure('position',[0 0 800 600],'Visible','on');
    %  set(0,'DefaultFigureVisible', 'off');
     m_proj('miller','lon',[min(min(lon)) max(max(lon))],'lat',[min(min(lat)) max(max(lat))]);
         set(gca,'fontname', 'Arial', 'fontsize', 12);
     m_pcolor(x,y,sst1);
     shading interp;
     hold on;
     m_grid('box','fancy');
     m_gshhs('h','patch',[205 201 201]./255);
     caxis([20 32])
     colormap(nclCM(18,256)); 
     hc=colorbar;
     ylabel(hc,'SST (^oC)');
     title([dataname,' OBS SST']);
     xlabel('Longitude','fontsize',15,'fontweight','bold');
     ylabel('Latitude','fontsize',15,'fontweight','bold');
     grid off;
     print(gcf,'-dpng','-r600',[fig_dir,casename,'_',dataname,'_',datestr(date,'yyyymmdd'),'_obs.png']);
end
return

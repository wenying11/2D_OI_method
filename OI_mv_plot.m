function OI_mv_plot(grid_coor,ha_mic,dir_fig,casename,date);
if nargin ~=5;
    
    disp('??? Error! Not enough input arguments, please retry!');
    
else
    lon=grid_coor.lon;
    lat=grid_coor.lat;

    figure('position',[0 0 800 600]);

	m_proj('miller','lon',[min(min(lon)) max(max(lon))],'lat',[min(min(lat)) max(max(lat))]);
         set(gca,'fontname', 'Arial', 'fontsize', 12);
    m_pcolor(lon,lat,ha_mic); %,25,'linestyle','none'
    shading interp;
    hold on;
    m_grid('box','fancy');
    m_gshhs('h','patch',[205 201 201]./255);
    caxis([20 32])
    colormap(nclCM(18,256)); 
    hc=colorbar;
    ylabel(hc,'SST (^oC)');
    title('MV analysis SST')
    xlabel('Longitude','fontsize',15,'fontweight','bold')
    ylabel('Latitude','fontsize',15,'fontweight','bold')
    grid off;
    
    print(gcf,'-dpng','-r600',[dir_fig,casename,'_',datestr(date,'yyyymmdd'),'_mic_analysis.png']);
 
end
 return
 

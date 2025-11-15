    
function OI_IR_plot(grid_coor,ha_nir,fig_dir,casename,date);  

if nargin ~=5;
    
    disp('??? Error! Not enough input arguments, please retry!');
    
else

    lon=grid_coor.lon;
    lat=grid_coor.lat;
    figure('position',[0 0 800 600]);
    m_proj('miller','lon',[min(min(lon)) max(max(lon))],'lat',[min(min(lat)) max(max(lat))]);
    set(gca,'fontname', 'Arial', 'fontsize', 12);
    hold on
    m_pcolor(lon,lat,ha_nir); %,25,'linestyle','none'
    shading interp;
    caxis([20 32])
    colormap(nclCM(18,256)); 
    hc=colorbar;
    ylabel(hc,'SST (^oC)');
    hold on;
    m_grid('box','fancy');
    m_gshhs('h','patch',[205 201 201]./255);
    title('IR analysis SST')
    xlabel('Longitude','fontsize',15,'fontweight','bold')
    ylabel('Latitude','fontsize',15,'fontweight','bold');
    grid off;
    print(gcf,'-dpng','-r600',[fig_dir,casename,'_',datestr(date,'yyyymmdd'),'_IR_analysis.png']);
end

return

    
    
    
    
    
    
    

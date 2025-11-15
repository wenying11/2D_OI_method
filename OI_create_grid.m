function [lon,lat]=OI_create_grid(lon_west, lon_east, lat_south, lat_north, grid_step,fig_dir,casename);
% grid setup
% lon_west  0-360
% lon_est  0-360
% lat _south  -90-90
% lat_north  -90-90

if nargin ~= 7;
    disp('Error! Not enough input arguments, please retry!');
    lon=[];
    lat=[];
else
    if lon_west < 0;
        disp('Error! The longitude must between the 0-360бу, please reset the longitude!');
    end

    if lon_east < 0;
        disp('Error! The longitude must between the 0-360бу, please reset the longitude!');
    end

    if lon_west >= lon_east;
        disp('Error! The longitude of east must greater than the west!')
    end

    if lat_south >= lat_north;
        disp('Error! The the latitude of north must greater than the south!');
    end
    
 lat1=lat_south:grid_step:lat_north;
 
 lon1=lon_west:grid_step:lon_east;

% 2D grid array 
 [lon,lat]=meshgrid(lon1',lat1');
 [m,n]=size(lon);
 figure('position',[0 0 800 600],'Visible','on');
 %set(0,'DefaultFigureVisible', 'off');
  m_proj('miller','lon',[min(min(lon)) max(max(lon))],'lat',[min(min(lat)) max(max(lat))]);
  set(gca,'fontname', 'Arial', 'fontsize', 12);
  for i=1:5:m;
      m_plot(lon(i,:),lat(i,:),'k');
      hold on
  end
  hold on;
  
  for i=1:5:n;
      m_plot(lon(:,i),lat(:,i),'k');
      hold on 
  end    
  m_grid('box','fancy');
  m_gshhs('h','patch',[205 201 201]./255);
  grid off;
  xlabel('Longitude','fontsize',15,'fontweight','bold');
  ylabel('Latitude','fontsize',15,'fontweight','bold');
  print(gcf,'-dpng','-r600',[fig_dir,casename,'_grid.png']);      
  

  
end 

return
 
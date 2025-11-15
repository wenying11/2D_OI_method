function mask_new=OI_mask_setup(grid_coor,casename,input_dir,output_dir);

% set the mask of specific area
% lon and lat are the specify at he step create grid;
if nargin ~=4;
    disp('Error! Not enough input arguments, please retry!');
    mask_new=[];
else
    lon=grid_coor.lon;
    lat=grid_coor.lat;
    
    file=[output_dir,casename,'_mask.mat'];
    
    if exist(file,'file');
        
        disp('--- mask existed------');
        load (file);  
%         mask_new=mask_new;
    else  
        load ([input_dir,'data/mask_initial_ghrsst.mat']);          

        mcol=find(Lon>= min(min(lon)) & Lon<=max(max(lon)));  
        mrow=find(Lat>=min(min(lat)) & Lat<=max(max(lat)));  
        
        [mlon,mlat]=meshgrid(Lon(mcol),Lat(mrow));
        
        mask_index=mask(mcol,mrow);

        mask_new=interp2(mlon,mlat,mask_index',lon,lat);
        
        mask_new((mask_new~=0) & (mask_new~=1))=0;  
        
        save(file,'mask_new');
        disp('--- mask generated successfully------');
    end
     
end

return

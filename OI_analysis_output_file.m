function  OI_analysis_output_file(ha_nir,ha_mv,hb_woa,grid_coor,results_file,mask);

 if nargin ~=6;
     disp('??? Error! Not enough input arguments, please retry!');
     
 else
     lon=grid_coor.lon;
     lat=grid_coor.lat;
     
     [M,N]=size(lat);
     
     ha_nir(mask==0)=nan;
     ha_mv(mask==0)=nan;
     
     nc=netcdf.create(results_file,'clobber');

     %define global attributes
     netcdf.putAtt(nc,netcdf.getConstant('NC_GLOBAL'),'source','fudan university');
     netcdf.putAtt(nc,netcdf.getConstant('NC_GLOBAL'),'institution','AOS');

     %dimensions
     south_north_dimid=netcdf.defDim(nc,'latitude',M); %51
     west_east_dimid=netcdf.defDim(nc,'longitude',N);  %61

     % coordinate
     lon_varid=netcdf.defVar(nc,'lon','NC_FLOAT',[south_north_dimid,west_east_dimid]);
     netcdf.putAtt(nc,lon_varid,'description',"longitude");
     netcdf.putAtt(nc,lon_varid,'units','degree');

     lat_varid=netcdf.defVar(nc,'lat','NC_FLOAT',[south_north_dimid,west_east_dimid]);
     netcdf.putAtt(nc,lat_varid,'description',"latitude" );
     netcdf.putAtt(nc,lat_varid,'units','degree');

     % sst backgournd of woa 2023
     sst_bgwoa_varid=netcdf.defVar(nc,'sst_background','NC_FLOAT',[south_north_dimid,west_east_dimid]);
     netcdf.putAtt(nc,sst_bgwoa_varid,'long_name','background sea surface temperature');
     netcdf.putAtt(nc,sst_bgwoa_varid,'standard_name','background sea surface temperature');
     netcdf.putAtt(nc,sst_bgwoa_varid,'units','^o C');
     netcdf.putAtt(nc,sst_bgwoa_varid,'type','data');    
     
     % sst analysis of mv
     sst_ana_mic_varid=netcdf.defVar(nc,'analysis_sst_of_mv','NC_FLOAT',[south_north_dimid,west_east_dimid]);
     netcdf.putAtt(nc,sst_ana_mic_varid,'long_name','analysis sea surface temperature of mic');
     netcdf.putAtt(nc,sst_ana_mic_varid,'standard_name','analysis sea surface temperature of MV');
     netcdf.putAtt(nc,sst_ana_mic_varid,'units','^o C');
     netcdf.putAtt(nc,sst_ana_mic_varid,'type','data');      

     % sst analysis of nir
     sst_ana_nir_varid=netcdf.defVar(nc,'analysis_sst_of_nir','NC_FLOAT',[south_north_dimid,west_east_dimid]);
     netcdf.putAtt(nc,sst_ana_nir_varid,'long_name','analysis sea surface temperature of nir');
     netcdf.putAtt(nc,sst_ana_nir_varid,'standard_name','analysis sea surface temperature of IR');
     netcdf.putAtt(nc,sst_ana_nir_varid,'units','^o C');
     netcdf.putAtt(nc,sst_ana_nir_varid,'type','data');      
     
     % end definitions
     netcdf.endDef(nc);

     %dump data
     netcdf.putVar(nc,lon_varid,lon);
     netcdf.putVar(nc,lat_varid,lat);
     netcdf.putVar(nc,sst_bgwoa_varid,hb_woa);
     netcdf.putVar(nc,sst_ana_mic_varid,ha_mv);
     netcdf.putVar(nc,sst_ana_nir_varid,ha_nir);
     
     % close file
     netcdf.close(nc);
     
 end
return
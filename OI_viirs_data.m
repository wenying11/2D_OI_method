function OI_viirs_data(date,input_dir);

if nargin ~=2;
   disp('??? Error! Not enough input arguments, please retry!');
else
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purposes:
%   VIIRS daily avg
%
% Modifications:
%   2022-06-04 18:10 --- created by MWL (FDU)
%   2023-03-21 14:06 --- modified for pac by MWL (FDU)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% nnw = 36;
% c = parcluster('local');
% c.NumWorkers = nnw;
% parpool(c,nnw);

%%
sdate = date ;%datenum('20240904','yyyymmdd');
edate =date; %datenum('20240904','yyyymmdd');

ndays = round(edate-sdate)+1;

dir_viirs_npp = [input_dir,'viirs/',datestr(date,'yyyymmdd'),'/npp'];
dir_viirs_n20 = [input_dir,'viirs/',datestr(date,'yyyymmdd'),'/n20'];
dir_viirs_n21 = [input_dir,'viirs/',datestr(date,'yyyymmdd'),'/n21'];

dir_daily =[input_dir,'viirs/'];
if ~exist(dir_daily,'dir')
    mkdir(dir_daily)
end

%% 
% grid
filelist = dir(fullfile([dir_viirs_npp],'*.nc'));
filem = [dir_viirs_npp,'/',filelist(1).name];
disp(['... ' filem]);
%%
ncid = netcdf.open(filem,'NC_NOWRITE');
    vid = netcdf.inqVarID(ncid,'lat');
    lat = netcdf.getVar(ncid,vid);
    vid = netcdf.inqVarID(ncid,'lon');
    lon = netcdf.getVar(ncid,vid);
netcdf.close(ncid);

nlon = length(lon);
nlat = length(lat);
%%
% daily avg
%
% for d = 1:ndays
for d = 1:ndays
    %
    sst = zeros(nlon,nlat);
    num = zeros(nlon,nlat);
    %
    tdate = sdate+d-1;
    [year,~] = datevec(tdate);
    ref_day = round(tdate-datenum(year,1,1)+1);
    %
    % npp
    %
    dir_npp = [dir_viirs_npp];
    filelist = dir(fullfile(dir_npp,'*.nc'));
    nf = length(filelist);

    for f = 1:nf
        filem = [dir_npp '/' filelist(f).name];
        disp(['... ' filem])
        
        ncid = netcdf.open(filem,'NC_NOWRITE');
            vid = netcdf.inqVarID(ncid,'quality_level');
            qlevel = double(squeeze(netcdf.getVar(ncid,vid)));
            fill_value = double(netcdf.getAtt(ncid,vid,'_FillValue'));
            qlevel(qlevel==fill_value) = nan;
            vid = netcdf.inqVarID(ncid,'sea_surface_temperature');
            value = double(squeeze(netcdf.getVar(ncid,vid)));
            scale_factor = double(netcdf.getAtt(ncid,vid,'scale_factor'));
            add_offset = double(netcdf.getAtt(ncid,vid,'add_offset'));
            fill_value = double(netcdf.getAtt(ncid,vid,'_FillValue'));
            value(value==fill_value) = nan;
            value = value*scale_factor+add_offset-273.15;
        netcdf.close(ncid);

        llon = ~isnan(value) & qlevel==5;
        num = num+(llon);
        sst(llon) = sst(llon) + value(llon);
    end
    %
    % n20
    %
    dir_n20 = [dir_viirs_n20];
    filelist = dir(fullfile(dir_n20,'*.nc'));
    nf = length(filelist);

    for f = 1:nf
        filem = [dir_n20 '/' filelist(f).name];
        disp(['... ' filem])
        
        ncid = netcdf.open(filem,'NC_NOWRITE');
            vid = netcdf.inqVarID(ncid,'quality_level');
            qlevel = double(squeeze(netcdf.getVar(ncid,vid)));
            fill_value = double(netcdf.getAtt(ncid,vid,'_FillValue'));
            qlevel(qlevel==fill_value) = nan;
            vid = netcdf.inqVarID(ncid,'sea_surface_temperature');
            value = double(squeeze(netcdf.getVar(ncid,vid)));
            scale_factor = double(netcdf.getAtt(ncid,vid,'scale_factor'));
            add_offset = double(netcdf.getAtt(ncid,vid,'add_offset'));
            fill_value = double(netcdf.getAtt(ncid,vid,'_FillValue'));
            value(value==fill_value) = nan;
            value = value*scale_factor+add_offset-273.15;
        netcdf.close(ncid);

        llon = ~isnan(value) & qlevel==5;
        num = num+(llon);
        sst(llon) = sst(llon) + value(llon);
    end
    %
    % n21
    %
    dir_n21 = [dir_viirs_n21];
    filelist = dir(fullfile(dir_n21,'*.nc'));
    nf = length(filelist);

    for f = 1:nf
        filem = [dir_n21 '/' filelist(f).name];
        disp(['... ' filem])
        
        ncid = netcdf.open(filem,'NC_NOWRITE');
            vid = netcdf.inqVarID(ncid,'quality_level');
            qlevel = double(squeeze(netcdf.getVar(ncid,vid)));
            fill_value = double(netcdf.getAtt(ncid,vid,'_FillValue'));
            qlevel(qlevel==fill_value) = nan;
            vid = netcdf.inqVarID(ncid,'sea_surface_temperature');
            value = double(squeeze(netcdf.getVar(ncid,vid)));
            scale_factor = double(netcdf.getAtt(ncid,vid,'scale_factor'));
            add_offset = double(netcdf.getAtt(ncid,vid,'add_offset'));
            fill_value = double(netcdf.getAtt(ncid,vid,'_FillValue'));
            value(value==fill_value) = nan;
            value = value*scale_factor+add_offset-273.15;
        netcdf.close(ncid);

        llon = ~isnan(value) & qlevel==5;
        num = num+(llon);
        sst(llon) = sst(llon) + value(llon);
    end
    %
    num(num==0) = nan;
    sst = sst ./ num;
    %
    % write
    %
    sst(isnan(sst)) = -9999;
    if any(isnan(sst(:)))
        disp('... NaN exist')
        error('stop')
    end

    file_daily = [dir_daily '/' datestr(tdate,'yyyymmdd') '_viirs.nc'];
    disp(['...' file_daily])

    nw = netcdf.create(file_daily,'clobber');
        %
        xi_rho_dim = netcdf.defDim(nw,'lon',nlon);
        eta_rho_dim = netcdf.defDim(nw,'lat',nlat);
        %
        x_id=netcdf.defVar(nw,'lon','float',xi_rho_dim);
        netcdf.putAtt(nw,x_id,'long_name','longitude');
        netcdf.putAtt(nw,x_id,'units','degree_east');
        %
        y_id=netcdf.defVar(nw,'lat','float',eta_rho_dim);
        netcdf.putAtt(nw,y_id,'long_name','latitude');
        netcdf.putAtt(nw,y_id,'units','degree_north');
        %
        t_id=netcdf.defVar(nw,'sst','double',[xi_rho_dim,eta_rho_dim]);
        netcdf.putAtt(nw,t_id,'long_name','surface temperature');
        netcdf.putAtt(nw,t_id,'units','C');
        netcdf.putAtt(nw,t_id,'_FillValue',-9999);
        %
        netcdf.endDef(nw);
        netcdf.putVar(nw,x_id,lon);
        netcdf.putVar(nw,y_id,lat);
        netcdf.putVar(nw,t_id,sst);
        %
    netcdf.close(nw);

    
end
%
delete(gcp('nocreate'));

end

return


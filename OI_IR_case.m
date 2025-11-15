function [ha_nir,xa_inc_nir,obs]=OI_IR_case(grid_coor,nir_obs,ha_mic,eb,ob_err,grid_step,cov_len_ir);
% use microwave data and woa2023 calculate the ha
% the ha was the background of NIR
% input data: obs(mic)
%             background(woa2023)
%             mask(ghrsst)
%             speicify grid
%             casename 
% output: hb_mic,ha_mic,xa_inc_mic,file
% time: 2024-12-19

if nargin ~=7;
    disp([mfilename,': Error! Not enough input arguments, please retry!']);   
else
  
 [M,N]=size(grid_coor.lat);

 [Row,Col,obs]=OI_search_ob(nir_obs,grid_coor);
 
%% Background error cov      
 % BG correlation length scale (units:degree)
 cov_lon=cov_len_ir; %0.06;  
 cov_lat=cov_len_ir; %0.06; 
  
 lx=cov_lon/grid_step;
 ly=cov_lat/grid_step;
 xx=1:M;
 yy=1:N;

 % specifiy BG err
 for j=1:M
     Bx(:,j)=exp(-(xx-xx(j)).^2/lx^2/2);
 end
 for j=1:N
     By(:,j)=exp(-(yy-yy(j)).^2/ly^2/2);
 end
 
 
 [ha_nir,xa_inc_nir]=OI_method_sub(ha_mic,obs,Row,Col,Bx,By,eb,ob_err);  
 

end

return

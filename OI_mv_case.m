function [ha_mic,xa_inc_mic,obs]=OI_mv_case(grid_coor,mic_obs,eb,ob_err,hb_woa,grid_step,cov_len_mv);
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
    disp('Error! Not enough input arguments, please retry!')
else
    
 [M,N]=size(grid_coor.lat);


 [Row,Col,obs]=OI_search_ob(mic_obs,grid_coor);
 
 
% Background error cov      
 %BG correlation length scale (units:degree)
 cov_lon=cov_len_mv;%0.75;
 cov_lat=cov_len_mv;%0.75;
 
  Bx=zeros(M,M);
  By=zeros(N,N);
  
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


 [ha_mic,xa_inc_mic]=OI_method_sub(hb_woa,obs,Row,Col,Bx,By,eb,ob_err); 
 
end

return

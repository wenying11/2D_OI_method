function OI_(berr,cov_lon, cov_lat)
%
% OI method
%
  
% Background error cov
%
% no need to make changes
%
  Lx=cov_lon;
  Ly=cov_lat;
  [M,N]-size(lat);

  Bx=zeros(M,M);
  By=zeros(N,N);
%
% specifiy BG err
%
  for j=1:M
      Bx(:,j)=exp(-(xx-xx(j)).^2/Lx^2/2);
  end
  for j=1:N
     By(:,j)=exp(-(yy-yy(j)).^2/Ly^2/2);
  end


return
%
% rmse ob and bg
%
%  eo=err_ob;
  eb=be_err;
%
%model observational error - random error
%
  eo_rand(1:nob)=0.2*squeeze(rand(nob,1))+0.2;
  Ro=zeros(nob,nob);
  for i=1:nob
    Ro(i,i)=eo_rand(i)*eo_rand(i);
  end
%
% compute HBHT
%
  for i=1:nob
    for j=1:nob
       Bo(i,j)=Bx(xob(i),xob(j))*By(yob(i),yob(j));
    end
  end
%
% inversion
% (HBH^T + R)^-1
%
   BR=Ro+eb*eb*Bo;
% BRinv=inv(BR);
%
% BRinvy=BRinv*ob_inc';
%
  BRinvy=BR\ob_inc';

  xa_inc=zeros(M,N);
  for j=1:N
   for i=1:M
% 
     xa_inc(i,j)=0.;
     for io=1:nob
 	xa_inc(i,j)=xa_inc(i,j)+eb*eb*Bx(i,xob(io))*By(j,yob(io))*BRinvy(io) ;
     end
%
   end
  end

 ha=zeros(M,N);
 ha=hb+xa_inc;


 figure
 
 contourf(lon,lat,xa_inc)
 colorbar
 xlabel('Latitude')
 ylabel('Longitude')
 title('Analysis Inc')

 figure

 contourf(lon,lat,ha)
 colorbar
 xlabel('Latitude')
 ylabel('Longitude')
 title('Analysis')


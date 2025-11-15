%
% Test OI method
% Twin experimeriment
%
% 1 homogeneous andistropic  background error
%
clear all
close all
%
% grid set up
%

  lat1=15:0.1:50;
  lon1=125:0.1:160;
   % 2D grid array 
  [lon2,lat2]=meshgrid(lon1,lat1);
  lon=lon2';
  lat=lat2';
  [M,N]=size(lat);
%
% lon 0-360
% lat -90-90

  [lon2, lat2]=x=create_grid(
  [M,N]=size(lat2);

%
% BG error correlation1 length scale in number of grid
% in degree
%
%  cov_lx=10.0;
%  cov_ly=10.0;
% 
% for test
%
   cov_lx=0.5;    %
   cov_ly=0.5;
%
% background RMS error
   be_err=zeros(M,N);

% Ob error
%   err_ob=0.1;
%
%%% grid numbers
%
  xx=1:M;
  yy=1:N;
%
% setup truth state background 
%% truth and background
%
 mh=fix(M/2);
 nh=fix(N/2);
 Lt=80;
 xb=zeros(M,N);
 ht=zeros(M,N);
 for j=1:N
%    ht(:,j)=1.0*exp( - ( (xx(:)-mh).^2+(yy(j)-nh)^2)/(Lt*Lt) );
%    hb(:,j)=2.0*exp( - ( (xx(:)-mh).^2+(yy(j)-nh)^2)/(Lt*Lt) );
%
%    ht(:,j)=1.0*exp( - ( (xx(:)-mh).^2+(yy(j)-nh)^2)/(Lt*Lt) );
%    hb(:,j)=1.0*exp( - ( (xx(:)-mh).^2+(yy(j)-nh)^2)/(0.4*Lt*Lt) );
    ht(:,j)=1.0*exp( - ( (xx(:)-mh).^2+(yy(j)-nh)^2)/(Lt*Lt) );
    hb(:,j)=1.0*exp( - ( (xx(:)-mh-50).^2+(yy(j)-nh)^2)/(0.4*Lt*Lt) );

 end

%% observation

% Case 1
% Single observation

%  nob=1;
%  xob(nob)=mh;
%  yob(nob)=nh;
%  for i=1:nob
%   ho(nob)=ht(xob,yob)+0.1;
%  end

%
% case 2
%
%  sk=10;
%  nn=0;
%  for j=1:sk:N
%    for i=1:sk:M
%      nn=nn+1;
%      xob(nn)=i;
%      yob(nn)=j;
%      ho(nn)=ht(i,j);
%     end
%   end
%   nob=nn;
%case 3
% one line
%
%   sk=5;
%   nn=0;
%   i=mh;
%   for j=1:sk:N
%      nn=nn+1;
%      xob(nn)=i;
%      yob(nn)=j;
%      ho(nn)=ht(i,j);
%   end
%   nob=nn;
%%
% case 4 Obs Inc
%
   sk=5;
   nn=0;
   i=150;
   for j=1:sk:N
      nn=nn+1;
      xob(nn)=i;
      yob(nn)=j;
      ho(nn)=ht(i,j);
   end
   nob=nn;
%
% plot the truth
%
 figure
 contourf(xx,yy,ht)
 colorbar
 title('Truth')

 figure
 contourf(xx,yy,hb)
 colorbar
 title('Background')

%
% observation
%
%% innovation
%
for i=1:nob
   ob_inc(i)=ho(i) - hb(xob(i),yob(i));
end
%
%START OI
%
  nob=length(ob_inc);
%
% Background error cov
%
% no need to make changes
%
  Lx=cov_lx;
  Ly=cov_ly;

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


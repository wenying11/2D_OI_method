%function xa_inc=oi_lat_lon(lon, lat, xb, loc_ij, ob_inc)
%
% loc_ij(2,nob)  loc_ij(i,j,nob)
%
clear all

% bg corr length scale in number of grid

 cov_lx=10;
 cov_ly=10;
%
% background RMS error
 be_err=1;

% Ob error
  err_ob=0.1;
%
% grid set up
 lat1=20:0.1:50;
 lon1=130:0.1:160;
%
% 2D grid array 
%
 [lon2,lat2]=meshgrid(lon1,lat1);
 lon=lon2';
 lat=lat2';
 [M,N]=size(lat);
%
 xx=1:M;
 yy=1:N;
 mh=fix(M/2);
 nh=fix(N/2);
%
% setup 
 Lt=60;

 xb=zeros(M,N);
%% truth and background
%
 ht=zeros(M,N);
 for j=1:N
    ht(:,j)=1.0*exp( - ( (xx(:)-mh).^2+(yy(j)-nh)^2)/(Lt*Lt) );
    hb(:,j)=2.0*exp( - ( (xx(:)-mh).^2+(yy(j)-nh)^2)/(Lt*Lt) );
 end

%% observation

% case 1
%nob=60
%xob(1:60)=mh+Lt/2;
%yob(1:60)=nh-30:nh+29;
%hob(nob)=0;
%for i=1:nob
%    hob(i)=ht(xob(i),yob(i));
%end
%
%% innovation
%for i=1:nob
%   ob_inc(i)=hob(i) - hb(xob(i),yob(i));
%end
% case 2
%
%   sk=5;
%   nn=0;
%   for j=1:sk:N
%    for i=1:sk:M
%      nn=nn+1;
%      xob(nn)=i;
%      yob(nn)=j;
%      ob_inc(nn)=ht(i,j)-hb(i,j);
%     end
%   end
%case 3
%
%   sk=5;
%   nn=0;
%   i=100;
%   for j=1:sk:N
%      nn=nn+1;
%      xob(nn)=i;
%      yob(nn)=j;
%      ob_inc(nn)=ht(i,j)-hb(i,j);
%   end
%
% case 4 Obs Inc
%
   sk=5;
   nn=0;
   i=150;
   for j=1:sk:N
      nn=nn+1;
      xob(nn)=i;
      yob(nn)=j;
      ob_inc(nn)=ht(i,j)-hb(i,j);
   end
%
   cov_lx=70;
   cov_ly=70;

%contourf(xx,yy,ht)
%colorbar
% observation
%
%START OI
%
 nob=length(ob_inc);

% Background error cov

 Lx=cov_lx;
 Ly=cov_ly;

 Bx=zeros(M,M);
 By=zeros(N,N);
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
 eo=err_ob;
 eb=be_err;

 Ro=zeros(nob,nob);
 for i=1:nob
    Ro(i,i)=1;
 end

% compute HBHT
%
 for i=1:nob
   for j=1:nob
      Bo(i,j)=Bx(xob(i),xob(j))*By(yob(i),yob(j));
   end
 end
%
% inversion
%
 BR=eo*eo*Ro+eb*eb*Bo;
% BRinv=inv(BR);
%
% BRinvy=BRinv*ob_inc';
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

 contourf(lon,lat,ha)
 colorbar
 xlabel('Latitude')
 ylabel('Longitude')

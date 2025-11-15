clear all


% grid


M=300;
N=260;

xx=1:M;
yy=1:N;


mh=M/2;
nh=N/2;

Lt=50;

%% truth and background

ht=zeros(M,N);
for j=1:N
    ht(:,j)=1.0*exp( - ( (xx(:)-mh).^2+(yy(j)-nh)^2)/(Lt*Lt) );
    hb(:,j)=2.0*exp( - ( (xx(:)-mh).^2+(yy(j)-nh)^2)/(Lt*Lt) );
end

%% observation

nob=60
xob(1:60)=mh+Lt/2;
yob(1:60)=nh-30:nh+29;

hob(nob)=0;
for i=1:nob
    hob(i)=ht(xob(i),yob(i));
end

% innovation
for i=1:nob
   dho(i)=hob(i) - hb(xob(i),yob(i));
end

%contourf(xx,yy,ht)
%colorbar


Bx=zeros(M,M);
By=zeros(N,N);


Lx=20;
Ly=20;

for j=1:M
	Bx(:,j)=exp(-(xx-xx(j)).^2/Lx^2/2);
end
for j=1:N
	By(:,j)=exp(-(yy-yy(j)).^2/Ly^2/2);
end


Ro=zeros(nob,nob);
eo=0.1;
for i=1:nob
	Ro(i,i)=1;
end
Ro=eo*Ro;

%HBHT

for i=1:nob
for j=1:nob
Bo(i,j)=Bx(xob(i),xob(j))*By(yob(i),yob(j));
end
end


BR=Ro+Bo;
BRinv=inv(BR);

BRinvy=BRinv*dho';


dxa=zeros(M,N);
for j=1:N
  for i=1:M
	 
    dxa(i,j)=0.;
    for io=1:nob
	dxa(i,j)=dxa(i,j)+Bx(i,xob(io))*By(j,yob(io))*BRinvy(io) ;
    end

  end
end

ha=zeros(M,N);
ha=hb+dxa;

contourf(xx,yy,ha')
colorbar

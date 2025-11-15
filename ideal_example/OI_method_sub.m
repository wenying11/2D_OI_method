function OI_method_sub(hbkg, hobs
%
% OI method
%
  
   detect hobs 1-d
   nobs=length(hobs)
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

return

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


function [ha,xa_inc]=OI_method_sub(hb,obs,Row,Col,Bx,By,eb,ob_err);  
 % OI method
 % hb:  background of the REAL
 % nob:  the number of the observation data;
 % ho: the varible of the observation
 % xob: the x-axis of observation
 % yob: the y-axis of observation
 % Bx,By: Background error cov 
 % time: 2024-12-19
 
 if nargin ~=8;
     disp('Error! Not enough input arguments, please retry!');
     ha=[];
     xa_inc=[];
 else
     
     ho=obs.ho;
     nob=length(ho);
%   
    disp('--- please set the observational error');
%     eo_rand=OI_ob_err(nob,eb);
    eo_rand(1:nob)=ob_err;
    
    disp('--- calculate the observation innovation');
%     hb(isnan(hb))=0;
   
%     [ob_inc]=OI_innovation(Row,Col,ho,hb);
 
    ob_inc=[];
    nob=length(ho);
    
    for i=1:nob
        ob_inc(i)=ho(i) - hb(Row(i),Col(i)); 
    end
    
    
    Ro=zeros(nob,nob);
    for i=1:nob
        Ro(i,i)=eo_rand(i)*eo_rand(i);
    end

    disp('--- HBHT ')
    % compute HBHT
    
%    for i=1:nob
%        for j=1:nob
%            Bo(i,j)=Bx(Row(i),Row(j))*By(Col(i),Col(j));
%        end
%    end

tic
     Bo(1:nob,1:nob)=Bx(Row(1:nob),Row(1:nob)).*By(Col(1:nob),Col(1:nob));    
toc

    disp('------------Bo done---------------')
    % inversion
tic
    BR=Ro+eb*eb*Bo;
toc

tic
    BRinvy=BR\ob_inc';
toc

  [M,N]=size(hb);
  
  xa_inc=zeros(M,N);
    
% delete(gcp('nocreate'));         % stop the process before start a new run.
% numCore = feature('numcores');   % get the maxmium core num of PC.
% parpool(numCore-1);              % start parpool.

tic
    for j=1:N
        for i=1:M
            xa_inc(i,j)=0.;
            for io=1:nob
                xa_inc(i,j)=xa_inc(i,j)+eb*eb*Bx(i,Row(io))*By(j,Col(io))*BRinvy(io) ;
            end
        end
    end
toc
    
    xa_inc(abs(xa_inc)>100)=nan;
    
    ha=zeros(M,N);
    
    ha=hb+xa_inc;   
    

 end

return

function [Row2,Col2,OBS]=OI_search_ob(obs,grid_coor);

if nargin ~=2;
    disp('Error! Not enough input arguments, please retry!');
    Row2=[];
    Col2=[];
else
     
    xob=obs.xob;
    yob=obs.yob;
    ho=obs.ho;
    lon=grid_coor.lon;
    lat=grid_coor.lat;
    
       % start parpool by codes.
%     delete(gcp('nocreate'));         % stop the process before start a new run.
%     numCore = feature('numcores');   % get the maxmium core num of PC.
%     parpool(numCore-1);              % start parpool. 
    
for i=1:length(xob);

    temp_x=xob(i)-lon;
    
    temp_y=yob(i)-lat;
    
    dis=sqrt(temp_x.^2+temp_y.^2);
    
    dis_temp=min(min(dis));
    [row,col]=find(dis==dis_temp(1));
    Row1(i)=row(1);
    Col1(i)=col(1);
end
    RC=[Row1; Col1];
    
    [re_RC,ia,ic]=unique(RC','rows','stable');
    
    Row=re_RC(:,1);
    Col=re_RC(:,2);
    Row=Row';
    Col=Col';
   
    temp_xob=xob(ia);
    temp_yob=yob(ia);
    temp_ho=ho(ia);
    
%     if length(temp_ho)<500;
%        intervalNum=1;
%     elseif (length(temp_ho)>500 & length(temp_ho)<1000);
%        intervalNum=3;
%     elseif (length(temp_ho)>1000 & length(temp_ho)<2000);
%        intervalNum=5;
%     elseif (length(temp_ho)>2000 );
%        intervalNum=3;
%     end
     intervalNum=1;
     OBS.xob=temp_xob(1:intervalNum:end);
     OBS.yob=temp_yob(1:intervalNum:end);
     OBS.ho=temp_ho(1:intervalNum:end);
     
     Row2=Row(1:intervalNum:end);
     Col2=Col(1:intervalNum:end);
end

return
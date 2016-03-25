function [direction,speed,height]=loadECMWF(ncName,Lat,Lon,heightThreshold,speedThreshold)

% Read the nc file
speedECMWF=ncread(ncName,'hor_windspeed');
directionECMWF=ncread(ncName,'hor_winddir');
LatECMWF=ncread(ncName,'latitude');
LonECMWF=ncread(ncName,'longitude');
heightECMWF=ncread(ncName,'height');
elevationECMWF=ncread(ncName,'height_sfc');

% Make refmat for ECMWF
lon1=double(LonECMWF(1));
lat1=double(LatECMWF(1));
dlon=double(LonECMWF(2)-LonECMWF(1));
dlat=double(LatECMWF(2)-LatECMWF(1));
refmat=makerefmat(lon1,lat1,dlon,dlat);

% Convert Lat/Lon to index
[rows,cols]=latlon2pix(refmat,Lat,Lon);
rows=round(rows);
cols=round(cols);

direction=directionECMWF(cols,rows,:);
speed=speedECMWF(cols,rows,:);
height=heightECMWF(cols,rows,:);
elevation=elevationECMWF(cols,rows);
height=height-elevation;

% Filtering
index=height>heightThreshold|height<0|speed<=speedThreshold|isnan(direction)|isnan(speed)|isnan(height);
direction(index)=[];
speed(index)=[];
height(index)=[];

if ~isempty(direction) && ~isempty(speed) && ~isempty(height)
    direction=reshape(direction,1,max(size(direction)));
    speed=reshape(speed,1,max(size(speed)));
    height=reshape(height,1,max(size(height)));
end

% Convert TO direction to FROM direction
direction=direction+180;
direction(direction>360)=direction(direction>360)-360;


end
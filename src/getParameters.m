function [direction,speed]=getParameters(data,heightThreshold,speedThreshold,elevation)


%% Parameters

height=data(:,2)'; % Geopotential Height (m)
height=height-elevation; % The height above surface (m)
direction=data(:,7)'; % Wind direction (degree)
speedKnot=data(:,8)'; % Wind speed, Unit: knot
speed=speedKnot.*0.5144444; % Unit: m/s -- 1 knot = 0.5144444 m/s

%% Filtering

index=height>=heightThreshold|height<0|speed<=speedThreshold;
direction(index)=[];
speed(index)=[];

end

clear
clc

addpath('src/');

% Parameters
regionStr='europe';
inputStr='/home/bijianzhao/bjz_tmp/Europe/Europe036Hourly/';
outputStr=['output/',regionStr,'/'];

[siteArr,latArr,lonArr,eleArr]=getSite(['input/',[regionStr,'_test.xlsx']]);
%{
%Wuhan
siteArr={'57494'};
latArr={30.61};
lonArr={114.13};
eleArr={23};
%}
yearArr=2005:2014;
monthArr=5:9;
timeArr=[0,12];

% Output data
directionTotal=[];
speedTotal=[];
heightTotal=[];

for siteNum=1:length(siteArr)           % For each site
    directionTotal=[];
    speedTotal=[];
    heightTotal=[];
    for year=yearArr                    % For each year
        for month=monthArr              % For each month
            dayNum=eomday(year,month);  % For each day
            for day=1:dayNum
                %% Make Parameters
                yearStr=num2str(year);
                monthStr=sprintf('%02d',month);
                dayStr=sprintf('%02d',day);
                siteStr=cell2mat(siteArr(siteNum));
                lat=double(cell2mat(latArr(siteNum)));
                lon=double(cell2mat(lonArr(siteNum)));
                
                %% Folder Path
                folderPath=[inputStr,yearStr,'/',monthStr,'/',dayStr,'/netcdf_complete/'];
                disp(folderPath);
                
                %% The elevation of this site and the height threshold
                elevation=cell2mat(eleArr(siteNum));
                disp(['Elevation=',num2str(elevation)]);
                heightThreshold=500;
                disp(['Height Threshold=',num2str(heightThreshold)]);
                speedThreshold=2;
                disp(['Speed Threshold=',num2str(speedThreshold)]);
                
                %% Processing
                for time=timeArr        % For observation time
                    
                    timeStr=sprintf('%02d',time);
                    ncName=[folderPath,yearStr,monthStr,dayStr,'_',timeStr,'_complete.nc'];
                    [direction,speed,height]=loadECMWF(ncName,lat,lon,heightThreshold,speedThreshold);
                    directionTotal=[directionTotal,direction];
                    speedTotal=[speedTotal,speed];
                    heightTotal=[heightTotal,height];
                    
                end
                disp(['Total Number=',num2str(length(directionTotal))]);
            end
        end
    end
    
    %% Save mat file
    savepath=['output/mat/',regionStr,'/',siteStr,'/'];
    if ~exist(savepath,'dir')
        eval(['mkdir ',savepath]);
    end
    saveFileName=[siteStr,'_',num2str(min(yearArr)),num2str(sprintf('%02d',min(monthArr))),...
        '_',num2str(max(yearArr)),num2str(sprintf('%02d',max(monthArr))),'_ECMWF.mat'];
    save([savepath,saveFileName],'directionTotal','speedTotal','heightTotal');
    disp([savepath,saveFileName]);
    
end

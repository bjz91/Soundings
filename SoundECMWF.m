clear
clc

addpath('src/');

% Parameters
regionStr='europe';
inputStr='input/';
inputStrECMWF='/home/bijianzhao/bjz_tmp/Europe/Europe036Hourly/';
outputStr=['output/',regionStr,'/'];

[siteArr,latArr,lonArr,eleArr]=getSite([inputStr,[regionStr,'_sub.xlsx']]);
%{
%Wuhan
siteArr={'57494'};
eleArr={23};
%}
yearArr=2005:2014;
monthArr=5:9;
timeArr=[0,12];

% Output data
directionSoundTotal=[];
speedSoundTotal=[];
heightSoundTotal=[];

directionECMWFTotal=[];
speedECMWFTotal=[];
heightECMWFTotal=[];


for siteNum=1:length(siteArr) % For each site
    
    directionSoundTotal=[];
    speedSoundTotal=[];
    heightSoundTotal=[];
    
    directionECMWFTotal=[];
    speedECMWFTotal=[];
    heightECMWFTotal=[];
    
    lossTimeNum=0;
    lossTimeStr=cell(1);
    
    for year=yearArr                    % For each year
        for month=monthArr              % For each month
            dayNum=eomday(year,month);  % For each day
            for day=1:dayNum
                %% Make strings
                siteStr=cell2mat(siteArr(siteNum));
                yearStr=num2str(year);
                monthStr=sprintf('%02d',month);
                dayStr=sprintf('%02d',day);
                lat=double(cell2mat(latArr(siteNum)));
                lon=double(cell2mat(lonArr(siteNum)));
                
                %% Folder Path
                folderPathSound=[outputStr,siteStr,'/',yearStr,'/',monthStr,'/',dayStr,'/'];
                disp(folderPathSound);
                folderPathECMWF=[inputStrECMWF,yearStr,'/',monthStr,'/',dayStr,'/netcdf_complete/'];
                disp(folderPathECMWF);
                
                %% The elevationSound of this site and the heightSound threshold
                elevationSound=cell2mat(eleArr(siteNum));
                disp(['Elevation=',num2str(elevationSound)]);
                heightThreshold=500;
                disp(['Height Threshold=',num2str(heightThreshold)]);
                speedThreshold=2;
                disp(['Speed Threshold=',num2str(speedThreshold)]);
                disp(['Loss Times=',num2str(lossTimeNum)]);
                
                %% Processing
                for time=timeArr        % For observation time
                    
                    timeStr=sprintf('%02d',time);
                    data=openSoundings([folderPathSound,'List_',siteStr,'_',yearStr,monthStr,dayStr,'_',timeStr,'.txt']);
                    
                    if ~isempty(data)
                        % For soundings
                        [directionSound,speedSound,heightSound]=loadSoundings(data,heightThreshold,speedThreshold,elevationSound);
                        directionSoundTotal=[directionSoundTotal,directionSound];
                        speedSoundTotal=[speedSoundTotal,speedSound];
                        heightSoundTotal=[heightSoundTotal,heightSound];
                        
                        % For ECMWF
                        ncName=[folderPathECMWF,yearStr,monthStr,dayStr,'_',timeStr,'_complete.nc'];
                        [directionECMWF,speedECMWF,heightECMWF]=loadECMWF(ncName,lat,lon,heightThreshold,speedThreshold);
                        directionECMWFTotal=[directionECMWFTotal,directionECMWF];
                        speedECMWFTotal=[speedECMWFTotal,speedECMWF];
                        heightECMWFTotal=[heightECMWFTotal,heightECMWF];
                    else
                        lossTimeNum=lossTimeNum+1;
                        lossTimeStr(lossTimeNum,1)={[yearStr,monthStr,dayStr,'_',timeStr]};
                    end
                end
                disp(['Total Number of Soundings=',num2str(length(directionSoundTotal))]);
                disp(['Total Number of ECMWF=',num2str(length(directionECMWFTotal))]);
            end
        end
    end
    
    %% Save mat file
    savepath=['results/',regionStr,'/',siteStr,'/'];
    if ~exist(savepath,'dir')
        eval(['mkdir ',savepath]);
    end
    
    % For soundings
    saveFileNameSoundings=[siteStr,'_',num2str(min(yearArr)),num2str(sprintf('%02d',min(monthArr))),...
        '_',num2str(max(yearArr)),num2str(sprintf('%02d',max(monthArr))),'_Sound.mat'];
    save([savepath,saveFileNameSoundings],'directionSoundTotal','speedSoundTotal','heightSoundTotal','lossTimeStr');
    disp([savepath,saveFileNameSoundings]);
    
    % For ECMWF
    saveFileNameECMWF=[siteStr,'_',num2str(min(yearArr)),num2str(sprintf('%02d',min(monthArr))),...
        '_',num2str(max(yearArr)),num2str(sprintf('%02d',max(monthArr))),'_ECMWF.mat'];
    save([savepath,saveFileNameECMWF],'directionECMWFTotal','speedECMWFTotal','heightECMWFTotal','lossTimeStr');
    disp([savepath,saveFileNameECMWF]);
    
end

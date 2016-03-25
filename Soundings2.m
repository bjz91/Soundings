clear
clc

addpath('src/');


% Parameters
regionStr='seasia';
inputStr='input/';
outputStr=['output/',regionStr,'/'];

[siteArr,~,~,eleArr]=getSite([inputStr,[regionStr,'.xlsx']]);
yearArr=2005:2013;
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
                %% Make strings
                siteStr=cell2mat(siteArr(siteNum));
                yearStr=num2str(year);
                monthStr=sprintf('%02d',month);
                dayStr=sprintf('%02d',day);
                
                %% Folder Path
                folderPath=[outputStr,siteStr,'/',yearStr,'/',monthStr,'/',dayStr,'/'];
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
                    data=loadSoundings([folderPath,'List_',siteStr,'_',yearStr,monthStr,dayStr,'_',timeStr,'.txt']);
                    
                    if ~isempty(data)
                        [direction,speed,height]=getParameters(data,heightThreshold,speedThreshold,elevation);
                        directionTotal=[directionTotal,direction];
                        speedTotal=[speedTotal,speed];
                        heightTotal=[heightTotal,height];
                    end
                end
                disp(['Total Numer=',num2str(length(directionTotal))]);
            end
        end
    end
    
    %% Save mat file
    savepath=['output/mat/',regionStr,'/',siteStr,'/'];
    if ~exist(savepath,'dir')
        eval(['mkdir ',savepath]);
    end
    saveFileName=[siteStr,'_',num2str(min(yearArr)),num2str(sprintf('%02d',min(monthArr))),...
        '_',num2str(max(yearArr)),num2str(sprintf('%02d',max(monthArr))),'_Sound.mat'];
    save([savepath,saveFileName],'directionTotal','speedTotal','heightTotal');
    disp([savepath,saveFileName]);
    
end

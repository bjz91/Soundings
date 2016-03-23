clear
clc

addpath('src/');

%regionStr='europe';
typeStr='TEXT%3ALIST';
%--------------------
% For validation
regionStr='seasia';
%--------------------

inputStr='input/';
outputStr=['output/',regionStr,'/'];

% Parameters
siteArr=getSite([inputStr,[regionStr,'.xlsx']]);
yearArr=2005:2013;
monthArr=1:12;
timeArr=[0,12];

%% For each site
for siteNum=1:length(siteArr)
    
    siteStr=cell2mat(siteArr(siteNum));
    if ~exist([outputStr,siteStr],'dir')
        eval(['mkdir ',[outputStr,siteStr]]);
    end
    
    %% For each year
    for year=yearArr
        
        yearStr=num2str(year);
        if ~exist([outputStr,siteStr,'/',yearStr],'dir')
            eval(['mkdir ',[outputStr,siteStr,'/',yearStr]]);
        end
        
        %% For each month
        for month=monthArr
            
            monthStr=sprintf('%02d',month);
            if ~exist([outputStr,siteStr,'/',yearStr,'/',monthStr],'dir')
                eval(['mkdir ',[outputStr,siteStr,'/',yearStr,'/',monthStr]]);
            end
            
            %% For each day
            dayNum=eomday(year,month);
            
            for day=1:dayNum
                
                dayStr=sprintf('%02d',day);
                if ~exist([outputStr,siteStr,'/',yearStr,'/',monthStr,'/',dayStr],'dir')
                    eval(['mkdir ',[outputStr,siteStr,'/',yearStr,'/',monthStr,'/',dayStr]]);
                end
                
                % Folder Path
                folderPath=[outputStr,siteStr,'/',yearStr,'/',monthStr,'/',dayStr,'/'];    
                disp(folderPath);
                
                %% For observation time
                for time=timeArr
                    
                    timeStr=sprintf('%02d',time); 
                    
                    % Write files
                    writeSoundingsFiles(folderPath,regionStr,typeStr,yearStr,monthStr,dayStr,timeStr,siteStr);
                    
                end           
            end
        end
    end  
end

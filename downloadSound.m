clear
clc

addpath('src/');

%parpool(10);

regionStr='europe';
typeStr='TEXT%3ALIST';
%--------------------
% For validation
%regionStr='seasia';
%--------------------

inputStr='input/';
outputStr=['output/',regionStr,'/'];

% Parameters
siteArr=getSite([inputStr,[regionStr,'_sub.xlsx']]);
yearArr=2007:2014;
monthArr=1:12;
timeArr=[0,12];

%% Loop

% For each site
%parfor siteNum=1:length(siteArr)
for siteNum=3
    
    % For each year
    for year=yearArr
        
        % For each month
        for month=monthArr
            
            % For each day
            dayNum=eomday(year,month);
            for day=1:dayNum
                
                siteStr=cell2mat(siteArr(siteNum));
                yearStr=num2str(year);
                monthStr=sprintf('%02d',month);
                dayStr=sprintf('%02d',day);
                      
                % Folder Path
                folderPath=[outputStr,siteStr,'/',yearStr,'/',monthStr,'/',dayStr,'/'];
                disp(folderPath);
                
                % For observation time
                for time=timeArr
                    
                    timeStr=sprintf('%02d',time);
                    % Write files
                    writeSoundingsFiles(folderPath,regionStr,typeStr,yearStr,monthStr,dayStr,timeStr,siteStr);
                    
                end
            end
        end
    end
end

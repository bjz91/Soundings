clear
clc

addpath('src/');

parpool(10);

regionStr='europe';
typeStr='TEXT%3ALIST';
%--------------------
% For validation
%regionStr='seasia';
%--------------------

inputStr='input/';
outputStr=['output/',regionStr,'/'];

% Parameters
siteArr=getSite([inputStr,[regionStr,'.xlsx']]);
yearArr=2005:2014;
monthArr=5:9;
timeArr=[0,12];

%% Loop

% For each site
parfor siteNum=length(siteArr)-20:length(siteArr)
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
                    writeSound(folderPath,regionStr,typeStr,yearStr,monthStr,dayStr,timeStr,siteStr);
                    
                end
            end
        end
    end
end

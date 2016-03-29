function writeSoundingsFiles(folderPath,regionStr,typeStr,yearStr,monthStr,dayStr,timeStr,siteStr)

% Construct folders
if ~exist(folderPath,'dir')
    eval(['mkdir ',folderPath]);
end

while true
    
    [str,stats]=urlread(['http://weather.uwyo.edu/cgi-bin/sounding?region=',regionStr,...
        '&TYPE=',typeStr,'&YEAR=',yearStr,'&MONTH=',monthStr,'&FROM=',dayStr,timeStr,...
        '&TO=',dayStr,timeStr,'&STNM=',siteStr]);
    
    if stats==1 % Stats equals to 0 means that it cannot access to the web page
        
        preStart=strfind(str,'<PRE>');
        preEnd=strfind(str,'</PRE>');
        
        if ~isempty(preStart) % Empty means that it cannot get the data from web page
            
            strList=str(preStart(1)+6:preEnd(1)-2);
            strHead=str(preStart(2)+6:preEnd(2)-2);
            
            filePathList=[folderPath,'List_',siteStr,'_',yearStr,monthStr,dayStr,'_',timeStr,'.txt'];
            fidList=fopen(filePathList,'w');
            fprintf(fidList,'%s',strList);
            fclose(fidList);
            
            disp(filePathList);
            
            filePathHead=[folderPath,'Head_',siteStr,'_',yearStr,monthStr,dayStr,'_',timeStr,'.txt'];
            fidHead=fopen(filePathHead,'w');
            fprintf(fidHead,'%s',strHead);
            fclose(fidHead);
            
            disp(filePathHead);
            
        else
            
            disp([siteStr,'_',yearStr,monthStr,dayStr,'_',timeStr,' is empty']);
            
        end
        
        break;
        
    end
    
end

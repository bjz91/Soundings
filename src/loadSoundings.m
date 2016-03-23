function data=loadSoundings(fileName)

fid=fopen(fileName,'r');

if fid~=-1
    % Remove the header
    for i=1:4
        fgetl(fid);
    end
    
    % Read each line
    lineNum=0;
    data=cell(1,11);
    while ~feof(fid)
        lineNum=lineNum+1;
        data{lineNum,1}=str2double(fscanf(fid,'%7c',1)); % PRES (hPa)
        data{lineNum,2}=str2double(fscanf(fid,'%7c',1)); % HGHT (m)
        data{lineNum,3}=str2double(fscanf(fid,'%7c',1)); % TEMP (C)
        data{lineNum,4}=str2double(fscanf(fid,'%7c',1)); % DWPT (C)
        data{lineNum,5}=str2double(fscanf(fid,'%7c',1)); % RELH (%)
        data{lineNum,6}=str2double(fscanf(fid,'%7c',1)); % MIXR (g/kg)
        data{lineNum,7}=str2double(fscanf(fid,'%7c',1)); % DRCT (deg)
        data{lineNum,8}=str2double(fscanf(fid,'%7c',1)); % SKNT (knot)
        data{lineNum,9}=str2double(fscanf(fid,'%7c',1)); % THTA (K)
        data{lineNum,10}=str2double(fscanf(fid,'%7c',1)); % THTE (K)
        data{lineNum,11}=str2double(fscanf(fid,'%7c',1)); % THTV (K)
        fscanf(fid,'%1c',1); % New line
    end
    
    data=cell2mat(data);
    
    fclose(fid);
    
else
    
    data=[];
    
end

end



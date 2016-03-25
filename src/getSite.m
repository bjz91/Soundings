function [siteArr,latArr,lonArr,eleArr]=getSite(fileName)

[~,~,raw] = xlsread(fileName);

siteArr=raw(2:length(raw(:,1)),1);
latArr=raw(2:length(raw(:,1)),3);
lonArr=raw(2:length(raw(:,1)),4);
eleArr=raw(2:length(raw(:,1)),5);

end
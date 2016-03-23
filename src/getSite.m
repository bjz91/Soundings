function [siteArr,eleArr]=getSite(fileName)

[~,~,raw] = xlsread(fileName);

siteArr=raw(2:length(raw(:,1)),1);
eleArr=raw(2:length(raw(:,1)),5);

end
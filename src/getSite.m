function siteArr=getSite(fileName)

[~,~,raw] = xlsread(fileName);

siteArr=raw(2:length(raw(:,1)),1);

end
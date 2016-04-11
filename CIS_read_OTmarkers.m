function [trackerpos] = CIS_read_OTmarkers(name,nmk)

ID = fopen(name,'r');
headers = textscan(ID, '%s',1 );

if nmk == 3
    fData = textscan(ID, '%d %s %s %d %d %s %s %s %f %f %f %f %f %f %f %d %s %f %f %f %s %f %f %f %s %f %f %f', 'HeaderLines', 1, 'CollectOutput', true);
    % fData{8}, fData{10}, fData{12} are markers
    m1 = mean(fData{8});
    m2 = mean(fData{10});
    m3 = mean(fData{12});
    trackerpos = [m1; m2; m3];
else fData = textscan(ID, '%d %s %s %d %d %s %s %s %f %f %f %f %f %f %f %d %s %f %f %f %s %f %f %f', 'HeaderLines', 1, 'CollectOutput', true);
    % fData2{8}, fData2{10} are target markers
    m1 = mean(fData{8});
    m2 = mean(fData{10});
    trackerpos = [m1; m2];
end

fclose(ID);

end
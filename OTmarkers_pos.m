clc; clear all; close all;
%% Read input .txt file
ID = fopen('033016_3_stray_markers.tsv','r');
ID2 = fopen('033016_2_target_markers.tsv','r');
headers = textscan(ID, '%s',1 );
headers2 = textscan(ID2, '%s',1 );
fData = textscan(ID, '%d %s %s %d %d %s %s %s %f %f %f %f %f %f %f %d %s %f %f %f %s %f %f %f %s %f %f %f', 'HeaderLines', 1, 'CollectOutput', true);
    % fData{8}, fData{10}, fData{12} are markers 
fData2 = textscan(ID2, '%d %s %s %d %d %s %s %s %f %f %f %f %f %f %f %d %s %f %f %f %s %f %f %f', 'HeaderLines', 1, 'CollectOutput', true);
    % fData2{8}, fData2{10} are target markers 
fclose(ID);
fclose(ID2);
m1 = mean(fData{8});
m2 = mean(fData{10});
m3 = mean(fData{12});
tm1 = mean(fData2{8});
tm2 = mean(fData2{10});
trackerpos = [m1; m2; m3];
%% Get markers locations in C-arm coordinate
load RegistrationMarkers_PROJ.mat
load ProjectionMatrices.mat
[ X , cstore] = CarmCoord(Y,P,50,3);
X
c2opt = cis_PCR(X',trackerpos);

load TargetMarkers_PROJ.mat
[ X2 , cstore2] = CarmCoord(Y,P,50,2);
X2 = X2';
tm1_calc = c2opt.tf(X2(1,:)');
tm2_calc2 = c2opt.tf(X2(2,:)');
[tm1_calc tm2_calc2]
[tm1' tm2']

% fData = textscan(ID, '%s', 'HeaderLines', 1, 'CollectOutput', true,'Delimiter','\n');
% fclose(ID);
% 
% 
% %% Designate values
% N_markers = headers{1};
% data = fData{1};
% 
% %% Fill the Y_set and p_tip with values from input
% Y_set = data(1:N_markers,:)';
% p_tip = data(N_markers+1,:)';
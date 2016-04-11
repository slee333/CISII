clc; clear all; close all;
%% Load OT markers
[s_trackerpos] = CIS_read_OTmarkers('033016_3_stray_markers.tsv',3);
[t_trackerpos] = CIS_read_OTmarkers('033016_2_target_markers.tsv',2);

%% Get markers locations in C-arm coordinate
load RegistrationMarkers_PROJ.mat
load ProjectionMatrices.mat
[ X , cstore] = CarmCoord(Y,P,50,3);            % Get marker pos. in C-arm coordinate
c2opt = cis_PCR(X',s_trackerpos);               % Transformation from C-arm coordinate to OT coordinate


%% Validate C_arm registration process through TRE
load TargetMarkers_PROJ.mat
[ X2 , cstore2] = CarmCoord(Y,P,50,2);          % Get target markers pos. in C-arm coordicate
% Calculate marker positions in OT coordinate using transformation matrix
tm1_calc = c2opt.tf(X2(:,1));
tm2_calc = c2opt.tf(X2(:,2));
% Find the norm of two markers and take a mean to obtain TRE (and display it)
tre1 = norm(tm1_calc - t_trackerpos(1,:)');
tre2 = norm(tm2_calc - t_trackerpos(2,:)');
tre = mean([tre1 tre2]);
fprintf('The TRE of C-arm Registration is %f.\n', tre);



















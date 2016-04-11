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

%% Find Center of Rotation of C-arm (assuming it is a perfect circle)
SourcePos = zeros(3,size(P,3));
for i = 1:size(P,3)
    SourcePos(:,i) = -P(1:3,1:3,i)\P(:,4,i);
end
[cor, rad] = CIS_CircleFitTaubin3D(SourcePos);

%% Create output 4x4 transformation matrices

AffineTransform_double_3_3 = reshape([c2opt.R, c2opt.p],12,1);
fixed = [0;0;0];
savename = input('Type in a name for C-arm transformation: ','s');
savename2 = input('Type in a name for Center of rotation / radius: ','s');
save(savename, 'AffineTransform_double_3_3', 'fixed')
save(savename2, 'cor', 'rad','-ascii')
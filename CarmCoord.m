function [ X , cstore] = CarmCoord(Y,P,fr,nmk)
%CARMCOORD Summary of this function goes here
%   Detailed explanation goes here
%   nmk: Numver of optical markers


% Take 2D projections of corresponding frames
Y_pr(Y>(mean(Y(:))+std(Y(:)))) = nan;                % Remove too high values
img_prj = Y_pr(:,:,ceil(linspace(1,size(Y_pr,3),fr))); 
Pstore = P(:,:,ceil(linspace(1,size(Y_pr,3),fr)));  % Take corresponding camera projection matrices

cstore = zeros(2,nmk,fr);                         % Matrix to store centroids
estore = [];

% Find centroids in projections
for i = 1:fr
    % Thresholding
    img= img_prj(:,:,i);
    th = mean(img(~isnan(img)))-std(img(~isnan(img)));

    centers = imfindcircles(img<th,[20 30]);

    if size(centers,1) < 3
        estore = [estore;i];
    else
        [~,idx] = sort(centers(:,2));
        cstore(:,:,i) = centers(idx,:)'; %Store centroid per projection
    end
end

% Remove empty parts
cstore(:,:,estore) = [];
Pstore(:,:,estore) = [];

X = backtrace(Pstore,flipud(cstore));

end


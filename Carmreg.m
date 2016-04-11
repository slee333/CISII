%---------------------------------------------------
%Author:    Seung Wook Lee, Ju Young Ahn
%           Department of Biomedical Engineering
%           Johns Hopkins University, Baltimore, MD.
%E-mail:    slee333@jhu.edu
%Revision:  03/21/16
%---------------------------------------------------

% C-arm registration (practice)
% clear;
% load practicedata.mat
% Define constants

% Choose number of frames (fr) to extract from total projections
fr = 50;
% Take 2D projections of corresponding frames
Y_pr = Y;
% Y_pr(Y_pr == NaN)
Y_pr(Y>(mean(Y(:))+std(Y(:)))) = nan;                % Remove too high values
img_prj = Y_pr(:,:,ceil(linspace(1,size(Y_pr,3),fr))); 
Pstore = P(:,:,ceil(linspace(1,size(Y_pr,3),fr)));  % Take corresponding camera projection matrices
angles = AngularEncoder(ceil(linspace(1,size(Y_pr,3),fr)));
% clear Y_pr;

nmk = 3;                                            % Number of optical markers
nprj = size(img_prj,3);                             % Number of projections
cstore = zeros(2,nmk,nprj);                         % Matrix to store centroids
% Pstore = zeros(3,4,nprj);
estore = [];
% Find centroids in 15 projections
for i = 1:nprj
    % Thresholding
    img= img_prj(:,:,i);
%     h = histogram(medfilt2(img_prj(:,:,i)));
%     f = fit(double(h.BinEdges(1:end-1))',double(h.Values)','gauss1');
    % Threshold backgrounds out and find circles
%     upperth = f.b1+5*f.c1;
%     img_prj(img_prj(:,:,i)>upperth)  = 0;
    
    th = mean(img(~isnan(img)))-std(img(~isnan(img)));
%     th = f.b1-2*f.c1;
    centers = imfindcircles(img<th,[20 30]);

%     [~, c] = kmeans([x,y],nmk,'MaxIter',1000);      % K-means clustering: classify x,y to 4 clusters (representing markers) and return centroid of each marker/cluster. 
    % As centroids are found in random order (i.e. are not very
    % consistent), sort them out. As Y value is consistent here, sort based
    % on that.
    if size(centers,1) < 3
        estore = [estore;i];
    else
        [~,idx] = sort(centers(:,2));
        cstore(:,:,i) = centers(idx,:)'; %Store centroid per projection
    end

%     if i ~= 1
%         for j = 1:4
%             dif = c'-repmat(cstore(:,j,i-1),1,4);
%             % Sort them based on magnitude of differences - could be
%             % inaccurate and **needs to be modified**. Yet this process worked well working with this particular example as we moved along just an orbital position and had small step sizes. 
%             cstore(:,j,i) = c(repmat(sqrt(sum(dif.^2))==min(sqrt(sum(dif.^2))),2,1)');      
%         end
%     ends

%     Pstore(:,:,i) = P(:,:,markerScanAngles(i) == orbitalEncoder);
%     clear x y c
end

% Remove empty parts
cstore(:,:,estore) = [];
Pstore(:,:,estore) = [];
% enc_prj(estore) = [];

X = backtrace(Pstore,flipud(cstore));  % Mostly consistent, but sometimes turns out to be inaccurate depending on result of clustering
% c2opt = cis_PCR(X',trackerpos');
% 
% Xcell = {X(:,1),X(:,2),X(:,3),X(:,4)};
% error = 100;
% iter = 0;
% % Our point-cloud to point-cloud registration is depenednt on how the points are arranged. So finding registration with minimal error
% while error > 0.0025 && iter < 1000      
%     Xcell = Xcell(randperm(4));
%     c2opt = cis_PCR(cat(2,Xcell{:})',trackerpos');
%     tfmat = [c2opt.R , c2opt.p; 0 0 0 1];
%     Xmat= [cat(2,Xcell{:}); 1 1 1 1];
%     submat = tfmat*Xmat-[trackerpos; 1 1 1 1];
%     error = norm(mean(submat(1:3,1:4)));
%     iter=iter+1;
% %     clear Xmat submat tfmat
%     %That iter > 1000 meaning there is something wrong in k-means
%     %clustering, so that centroid positions are defined inaccurately in
%     %this case.
% end
% 
% % For orbital pos = 21.6000
% Porb = P(:,:,122);
% Sourcepos=-Porb(1:3,1:3)\Porb(:,4);
% clear P Pstore
% c2opt.tf(Sourcepos)

%%
% 
% % Carm registration (realdata)
% load realmarkers.mat
% 
% % Filter the image
% X_filt2 = medfilt2(X);
% 
% % Display histogram, fit one gaussian curve to the histogram
% h = histogram(X_filt2);
% f = fit(h.BinEdges(1:end-1)',h.Values','gauss1');
% 
% % Threshold backgrounds out and find circles
% th = f.b1-2*f.c1;
% centers = imfindcircles(X<th,[20 50]);
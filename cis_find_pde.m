function [ PDE ] = cis_find_pde( drr, rad )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

shots = size(drr,3);
pde_val = cell(1,shots);
pde_pts = cell(1,shots);
pde_means = zeros(1,shots);
pde_stds = zeros(1,shots);

for i =1:shots
    figure; imagesc(drr(:,:,i)); title(['DRR ',num2str(i),'th']); colormap gray;
%     n = input('How many points to pick?');
    n = 8;
    [x_d,y_d] = ginput(n);
    close
    
    figure; imagesc(rad(:,:,i)); title(['Rad ',num2str(i),'th']); colormap gray;
    hold on
    scatter(x_d,y_d,'rx')
    hold off
    [x_r,y_r] = ginput(n);
    close
    
    pde_pts{i} = [x_d x_r y_d y_r];
    pde_val{i} = sqrt((x_d-x_r).^2 + (y_d - y_r).^2)*0.194;
    pde_means(i) = mean(pde_val{i});
    pde_stds(i) = std(pde_val{i});
end

PDE = struct;
PDE.mean = pde_means;
PDE.std = pde_stds;
PDE.values = pde_val;
PDE.points = pde_pts;

end
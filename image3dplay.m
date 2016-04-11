function [] = image3dplay(I_3D, nf, dim, tpause, color)
%IMAGE3DPLAY plays a sequence of 2D images contained in 3D matrices.
%   With a series of 2D images complied in as a 3D matrix, the function
%   plays the 2D images sequentially from first frame to the last.
%
%   Syntax:     image3dplay(...,I_3D)
%               image3dplay(...,parameter)
%
%   Inputs:     I_3D: 3D input matrix
%               nf: number of frames to play. Default: whole 2D images
%               dim: dimension along which the images are complied. Must be between 1 and 3. Default = 3.
%               tpause: time interval between each image. default = .2 s
%               color: colormap of generated image. String.
%
%   Output:     Figure with video of image played. To exit, press ctrl+C on
%               command line
%---------------------------------------------------
%Author:    Seung Wook Lee
%           Department of Biomedical Engineering
%           Johns Hopkins University, Baltimore, MD.
%E-mail:    slee333@jhu.edu
%Revision:  04/04/16
%---------------------------------------------------

% Check Input Number
narginchk(1,5)

if ~exist('I_3D','var')
    error('3D matrix input should be given');
end
if ~exist('dim','var')
	dim = 3;
end
if dim < 1 || dim > 3
    error('Dimensino must be between 1 and 3');
end
if ~exist('nf','var')
    nf = size(I_3D,dim);
end
if ~exist('tpause','var')
    tpause = 0.2; %% seconds
end
if ~exist('color','var')
    color = 'parula'; %% seconds
end

figure;

if dim == 1;
    img_prj = I_3D(ceil(linspace(1,size(I_3D,dim),nf)),:,:);
elseif dim == 2;
    img_prj = I_3D(:,ceil(linspace(1,size(I_3D,dim),nf)),:);
elseif dim == 3;
    img_prj = I_3D(:,:,ceil(linspace(1,size(I_3D,dim),nf)));
end

i = 1;
while i <= nf
    if dim == 1;
        imagesc(squeeze(img_prj(i,:,:))); colormap(color); pause(tpause);
    elseif dim == 2;
        imagesc(squeeze(img_prj(:,i,:))); colormap(color); pause(tpause);
    elseif dim == 3;
        imagesc(squeeze(img_prj(:,:,i))); colormap(color); pause(tpause);
    end
    if i == nf
        i = 1;
    else
        i = i+1;
    end
end
end


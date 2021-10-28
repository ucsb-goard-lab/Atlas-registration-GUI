function cortexData = cortexmap2mat(CORTEXMAP_FILENAME, DIM)
% cortexmap2mat(CORTEXMAP_FILENAME) creates ROIs matrix from cortexmap
% image
% INPUTS:
%       CORTEXMAP_FILENAME: string, filename (must be in tif
%       format)
%       DIM: scalar contanining the desired dimensions of x-pixels and
%       y-pixels (program assumes square images)
% OTPUT:
%       cortexData: struct containing the names of the layers in the
%       original dimensions of tif file and a matrix containing all the
%       rois in the desired dimensions (array sized DIM x DIM)
%
%%
% Developed by Luis Franco Mendez
% Last updated by Santiago Acosta on 10/28/2021

%%

cortex_map = importdata(CORTEXMAP_FILENAME);
I = single(rgb2gray(cortex_map)); 
X = zeros(size(cortex_map,1), size(cortex_map,2));
cortexData.cortexMap = I;

% Cortices ROIs manually selected regions
% Note to Santi: This part has to be curated, too much redudance)

% SMC
rois = X; rois(I==190) = 1; rois(I~=190) = 0;
s = regionprops(logical(rois),'Area','PixelIdxList');
x = zeros(length(s),1);
for i=1:length(s)
    x(i) = s(i).Area;
end
[~,y] = sort(x,'descend');
newX = X; newX(s(y(1)).PixelIdxList) = 1; newX(s(y(2)).PixelIdxList) = 1;
cortexData.SMC = newX;
clear('rois','s','x','y','newX')

% SSC
rois = X; rois(I==110) = 1; rois(I~=110) = 0;
s = regionprops(logical(rois),'Area','PixelIdxList');
x = zeros(length(s),1);
for i=1:length(s)
    x(i) = s(i).Area;
end
[~,y] = sort(x,'descend');
newX = X; newX(s(y(1)).PixelIdxList) = 1; newX(s(y(2)).PixelIdxList) = 1;
cortexData.SSC = newX;
clear('rois','s','x','y','newX')

% PPC
rois = X; rois(I==231) = 1; rois(I~=231) = 0;
s = regionprops(logical(rois),'Area','PixelIdxList');
x = zeros(length(s),1);
for i=1:length(s)
    x(i) = s(i).Area;
end
[~,y] = sort(x,'descend');
newX = X; newX(s(y(1)).PixelIdxList) = 1; newX(s(y(2)).PixelIdxList) = 1;
cortexData.PPC = newX;
clear('rois','s','x','y','newX')

% RSC
rois = X; rois(I==32) = 1; rois(I~=32) = 0;
s = regionprops(logical(rois),'Area','PixelIdxList');
x = zeros(length(s),1);
for i=1:length(s)
    x(i) = s(i).Area;
end
[~,y] = sort(x,'descend');
newX = X; newX(s(y(1)).PixelIdxList) = 1; newX(s(y(2)).PixelIdxList) = 1;
cortexData.RSC = newX;
clear('rois','s','x','y','newX')

% VC
rois = X; rois(I==65) = 1; rois(I~=65) = 0;
s = regionprops(logical(rois),'Area','PixelIdxList');
x = zeros(length(s),1);
for i=1:length(s)
    x(i) = s(i).Area;
end
[~,y] = sort(x,'descend');
newX = X; newX(s(y(1)).PixelIdxList) = 1; newX(s(y(2)).PixelIdxList) = 1;
cortexData.VC = newX;
clear('rois','s','x','y','newX')

% AC
rois = X; rois(I==149) = 1; rois(I~=149) = 0;
s = regionprops(logical(rois),'Area','PixelIdxList');
x = zeros(length(s),1);
for i=1:length(s)
    x(i) = s(i).Area;
end
[~,y] = sort(x,'descend');
newX = X; newX(s(y(1)).PixelIdxList) = 1; newX(s(y(2)).PixelIdxList) = 1;
cortexData.AC = newX;
clear('rois','s','x','y','newX')

% TAC
rois = X; rois(I==211) = 1; rois(I~=211) = 0;
s = regionprops(logical(rois),'Area','PixelIdxList');
x = zeros(length(s),1);
for i=1:length(s)
    x(i) = s(i).Area;
end
[~,y] = sort(x,'descend');
newX = X; newX(s(y(1)).PixelIdxList) = 1; newX(s(y(2)).PixelIdxList) = 1;
cortexData.TAC = newX;
clear('rois','s','x','y','newX')

% ROIs
regions_list = fieldnames(cortexData);
regions_list(1) = [];
cortexData.ROIs = zeros(DIM, DIM, 7);

for i = 1:length(regions_list)
    cortexData.ROIs(:,:,i) = imresize(cortexData.(regions_list{i}), ...
        [DIM DIM],'Method','nearest');
end

end

    
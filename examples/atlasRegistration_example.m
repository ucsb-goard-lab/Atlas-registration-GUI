% Atlas-registration-example

%% Figures to see what we intend to do with Atlas-registration-GUI

CORTEXMAP_FILENAME = which('\Atlas-registration-GUI\examples\cortex_map.tif');
REF_RAW_FILENAME = which('\Atlas-registration-GUI\examples\refimg_raw.tif');

figure('Name', 'Register Goal', 'Position', [297,291,1348,520]);
tiledlayout(1,2)

ax1 = nexttile;
imshow(CORTEXMAP_FILENAME)
title(ax1, 'Image of Dorsal Cortex Map', 'FontSize', 22)
ax1.DataAspectRatio = [1 1 1];
axis(ax1, 'square')

ax2 = nexttile;
imshow(REF_RAW_FILENAME)
title(ax2, 'Reference image to register', 'FontSize', 22)
axis(ax2, 'square')


%% First: transform our map image to a layered ROI matrix

% Our data is sized 400 x 400 
DIM = 400;
cortexData = cortexmap2mat(CORTEXMAP_FILENAME, DIM);
ROI = cortexData.ROIs;
region_names = fieldnames(cortexData);

figure('Name', 'Tif vs mat', 'Position', [297,291,1348,520]);
tiledlayout(2,4)

ax1 = nexttile;
imshow(CORTEXMAP_FILENAME)
title(ax1, 'Original Tif Image', 'FontSize', 22)
axis(ax1, 'square')

for i = 2:8
    
ax = nexttile;
imagesc(ROI(:,:,i-1))
title(ax, region_names{i}, 'FontSize', 22)
colormap(ax, flipud(gray));
axis(ax, 'square')
box off
ax.Color = [1 1 1];

end

save('ROI.mat','ROI');

%% Then, we fix our reference image for  a session (or a mouse) so that we can
% later register the atlas to that reference, and the whole time series
% data to that reference.

fixed_reference = fixReference(REF_RAW_FILENAME, 'save');

%% Now, we use RegistrationGUI to register it to the atlas

FIXED_REFERENCE_FILENAME = which('refimg_fixed.tif');
ATLAS_TEMPLATE_FILENAME = which('ROI.mat');
mask = RegistrationGUI(FIXED_REFERENCE_FILENAME, ...
    ATLAS_TEMPLATE_FILENAME);

%% How to apply mask to select for regions
ax_opt = {'XColor', [1 1 1], 'YColor', [1 1 1],...
    'Colormap', colormap('jet'), 'DataAspectRatio', [1 1 1], 'box', 'off'};
close(gcf)

figure('Name', 'Region masking', 'Position', [150,186,1688,662]);
tiledlayout(2,4)

window_mask = mask.Window;
mask_fieldnames = fieldnames(mask);

for i = 2:9
    
    ax = nexttile;
    mask_region = mask.(mask_fieldnames{i});
    mask_region(~window_mask) = false;
    imagesc(ax, fixed_reference, 'AlphaData', mask_region)
    set(ax, ax_opt{:})
    title(ax, mask_fieldnames{i}, 'FontSize', 22)
    
end

%% To apply to the whole stack we will need to register all the raw images to the reference

MOVING_REFERENCE_FILENAME = ...
    which('\Atlas-registration-GUI\examples\refimg_raw_2.tif');
tform = register2reference(MOVING_REFERENCE_FILENAME, FIXED_REFERENCE_FILENAME);

% now if we wanted to transform the moving reference, we would use:

% imwarp(moving_image, tform, 'OutputView', imref2d(size(moving_image)))
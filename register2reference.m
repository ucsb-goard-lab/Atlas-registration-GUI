function tform = register2reference(MOVING_REFERENCE_FILENAME, FIXED_REFERENCE_FILENAME)
% registerSession Registration of the session reference with
% the overall mouse reference.
%
% INPUT:
%       MOVING_REFERENCE_FILENAME: string type, full path containing an
%       image that we want to fix to the reference
%       FIXED_REFERENCE_FILENAME: string type, full path containing the
%       fixed reference imagemust be of type uint16. If it is double, it will be
% OUTPUT:
%       tform: tensor containing the transformation between the two
% imwarp(moving_image, tform, 'OutputView', imref2d(size(moving_image)))
%
%%
% Developed by Santiago Acosta on 12/05/2020
% Last updated by Santiago Acosta on 10/28/2021

%%

moving_reference = uint16(imread(MOVING_REFERENCE_FILENAME));
fixed_reference = uint16(imread(FIXED_REFERENCE_FILENAME));

fig_opt = {'Color', [0.05 0.05 0.05], 'Position', [200 200 725 725]};
ax_opt = {'xticklabel',[],'yticklabel',[], 'XColor',[0 0 0], 'YColor',[0 0 0],...
    'Colormap',colormap('gray'), 'DataAspectRatio', [1 1 1]};
close(gcf)
t_opt = {'FontName', 'CMU Bright', ...
    'Color', [1 1 1], 'FontSize', 30};

[moving_pts, fixed_pts] = cpselect(moving_reference, fixed_reference, 'Wait',true);

if ischar(moving_reference)
    moving_reference = imread(moving_reference);
    fixed_reference = imread(fixed_reference);
end

tform = fitgeotrans(moving_pts, fixed_pts, ...
    'nonreflectivesimilarity');

u = [0 1];
v = [0 0];
[x, y] = transformPointsForward(tform, u, v);
dx = x(2) - x(1);
dy = y(2) - y(1);

angle = (180/pi) * atan2(dy, dx);
scale = 1 / sqrt(dx^2 + dy^2);

disp([' Rotation angle is ', num2str(angle), ' degrees.'])
disp([' Scale is ', num2str(scale), '.'])

fixed_image = imwarp(moving_reference, tform, 'OutputView',...
    imref2d(size(moving_reference) ));

figure(fig_opt{:}, 'Position', [379,135,1241,725])

subplot(1, 2, 1)
imshowpair(moving_reference, fixed_reference)
set(gca, ax_opt{:}),
title('Original Reference', t_opt{:});

subplot(1, 2, 2)
imshowpair(fixed_image, fixed_reference)
set(gca, ax_opt{:}),
title('Processed', t_opt{:});

end
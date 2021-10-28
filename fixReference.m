function fixed_reference = fixReference(RAW_FILENAME, varargin)
% fixReference(RAW_REFERENCE_FILENAME) rotate any image and translates it
% so that it is centered and straight. 
%
% First, the function will prompt the user to draw a line along the saggital
% line to make the reference straight. After double clicking it, the user
% will have to draw a circle to surround the cranial window. After
% positioning it, the user will have to press enter to finish, space to
% repeat or esc to exit. Then, the fixed reference will be saved in the
% current directory.
% 
% INPUTS:
%       UNFIXED_REFERENCE_FILENAME: string, filename (must be in tif
%       format)
%
%       varargin:
%                'save': if the user wants to automatically save the
%                corrected reference. If so, the original file must contain
%                the word 'raw' in it.
%
% OTPUT:
%       fixed_reference: N x N matrix with fixed imaged, where N is num
%       pixels

%% 
% Developed by Santiago Acosta on 11/15/2020. 
% Based on code developed by Luis Franco.
% Last updated 10/27/2021.

%% Importing input image and enforcing tif format

flag_save = ismember('save', varargin);
[~, file_name, ext] = fileparts(RAW_FILENAME);

if ~strcmp(ext, {'.tif', '.tiff'})
    error('Input filename must be in tif format')                           
end

raw_reference = imread(RAW_FILENAME);

%% Figure options 
fig_opt = {'Color', [0.05 0.05 0.05], 'Position', [200 200 725 725]};

ax_opt = {'xticklabel',[],'yticklabel',[], 'XColor',[0 0 0], 'YColor',[0 0 0],...
    'Colormap',colormap('gray'), 'DataAspectRatio', [1 1 1]};
close(gcf)
t_opt = {'FontName', 'CMU Bright', ...
    'Color', [1 1 1], 'FontSize', 30};

%%
isSuccess = false;
while ~isSuccess
    
    fig = figure(fig_opt{:}, 'Position', [200 200 1200 600]);
    set(fig, 'Name', 'Draw line along sagittal fisure. Double click when done');
    
    subplot(1, 2, 1)
    imagesc(raw_reference),
    set(gca, ax_opt{:}),
    title('Raw Reference', t_opt{:});
    
    try
        h = drawline('Position',h.Position,'Color','w');
    catch
        h = drawline('Color','w');
    end
    
    customWait(h);
    set(fig, 'Name', 'Draw circle surrounding cranial window');
    
    % Rotation
    line_param = polyfit(h.Position(:,1), h.Position(:,2), 1);
    angle = 90 - atand(line_param(1));
    fixed_reference = imrotate(raw_reference, -angle, 'crop');
  
    % Centering
    try
        c = drawcircle('Center',c.Center,'Radius',c.Radius, ...
            'Color', 'w', 'FaceAlpha', 0.4);
    catch
        c = drawcircle('Color', 'w', 'FaceAlpha', 0.4);
    end
    
    customWait(c);
    
    translation = round(size(fixed_reference) / 2) - c.Center;
    fixed_reference = imtranslate(fixed_reference, translation);
    
    set(fig, 'Name', 'Enter if done. Space to repeat. Esc to exit');
    
    subplot(1, 2, 2)
    imagesc(fixed_reference),
    set(gca, ax_opt{:}),
    title('Corrected', t_opt{:});
     
    pause(1.5)
    
    waitforbuttonpress;
    button = double(get(gcf,'CurrentCharacter'));
    
    switch button
        
        case 27                     % ESC: Exit altogether
            pause(1.2)
            close(fig)
            return
            
        case 13
            isSuccess = true;       % INTRO: Done
            pause(1.2);
            close(fig)
            
        case 32                     % SPACE: Repeat
            pause(1.2);
            close(fig)
            continue
            
        otherwise
            msg = msgbox('Key not recognized. Please use escp/ent/space next time');
            pause(1.2);
            close(msg);
            continue
            
    end
    
end

if flag_save
    fixed_filename = strrep(file_name, 'raw', 'fixed');
    imwrite(fixed_reference, strcat(fixed_filename, '.tif'), 'tif');
end

    function pos = customWait(hROI)
        
        % Listen for mouse clicks on the ROI
        l = addlistener(hROI,'ROIClicked',@clickCallback);
        
        % Block program execution
        uiwait;
        
        % Remove listener
        delete(l);
        
        % Return the current position
        pos = hROI.Position;
        
    end

    function clickCallback(~,evt)
        
        if strcmp(evt.SelectionType,'double')
            uiresume;
        end
        
    end

end
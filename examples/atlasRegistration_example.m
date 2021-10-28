% Atlas-registration-example

%% First, we fix our reference image for  a session (or a mouse) so that we can
% later register the atlas to that reference, and the whole time series
% data to that reference.

RAW_FILENAME = '\Atlas-registration-GUI\examples\refimg_raw.tif';
corrected_reference = fixReference(RAW_REFERENCE_FILENAME, 'save');

%% Now, we use RegistrationGUI to register it to the atlas

CORRECTED_REFERENCE_FILENAME = 'refimg_corrected.tif';
ATLAS_TEMPLATE_FILENAME = 'ROIs.mat';
register_app = RegistrationGUI(CORRECTED_REFERENCE_FILENAME, ...
    ATLAS_TEMPLATE_FILENAME);








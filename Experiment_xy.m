%% Initialization

my_path = '/Users/xyao/Documents/Field-lab/Photons';

addpath(genpath(my_path))
cd(my_path)

path2save = [my_path, '/saved_stim/2015-11-02'];
screen_number = 0;
def_params = initialize_display('OLED', screen_number);
mglMoveWindow(1, 1080)

%% Set background

% white
mglClearScreen(1);
mglFlush

% gray
mglClearScreen(0.5);
mglFlush

% black
mglClearScreen(0);
mglFlush


%% Focus Squares

fprintf('\n\n<strong> Focus squares. </strong>\n');
clear parameters stimulus;

parameters.class = 'FS';
stimulus = make_stimulus(parameters,def_params);
display_stimulus(stimulus);

%% Moving bar

fprintf('\n\n<strong> Moving bar. </strong>\n');
clear parameters stimulus;

parameters.class = 'MB';
parameters.x_start = 200;  parameters.x_end = 600;
parameters.y_start = 100;   parameters.y_end = 500;
parameters.frames_p_bar = 1; % 1:no need to set frames. 0: have to set frames
% parameters.frames = 70;
parameters.delay_frames = 30;

variable_parameters = randomize_parameters('DIRECTION', [0 45 90 135 180 225 270 315], ...
                                           'DELTA', [4 8], ...
                                           'BAR_WIDTH', [60 120], ...
                                           'BACK_RGB', {[0.2 0.2 0.2]}, ...
                                           'RGB', {[0.3 0.3 0.3], [0.6 0.6 0.6]}, ...
                                           'nrepeats',2);
path2file = write_s_file(parameters, variable_parameters);
s_params = read_s_file(path2file);

% see second option example in "S File read"
for i=2:size(s_params,2)
    trial_params = combine_parameters(s_params{1}, s_params{i});
    stimulus{i-1} = make_stimulus(trial_params, def_params);
end

for i=1:length(stimulus)
    if i == 1
        display_stimulus(stimulus{i}, 'wait_trigger', 0, 'wait_key', 1);
    else
        display_stimulus(stimulus{i}, 'wait_trigger', 0, 'wait_key', 0);
    end
end

%% Moving Grating S File write

fprintf('\n\n<strong> Moving Grating. </strong>\n');
clear parameters stimulus

parameters.class = 'MG';
parameters.spatial_modulation = 'square'; % sine or square
parameters.frames = 5*60; % presentation of each grating, frames
parameters.x_start = 0;  parameters.x_end = 800;
parameters.y_start = 0;   parameters.y_end = 600;

variable_parameters = randomize_parameters('DIRECTION', [0 45 90 135 180 225 270 315], ...
                                           'TEMPORAL_PERIOD', [12 24 60 120 240 480 720 960 1440], ...
                                           'SPATIAL_PERIOD', [200], ...
                                           'RGB', {[0.25 0.25 0.25]}, ...
                                           'BACK_RGB', {[0.5 0.5 0.5]}, ...
                                           'nrepeats',4);
path2file = write_s_file(parameters, variable_parameters);
s_params = read_s_file(path2file);

% see second option example in "S File read"
for i=2:size(s_params,2)
    trial_params = combine_parameters(s_params{1}, s_params{i});
    stimulus{i-1} = make_stimulus(trial_params, def_params);
end
for i=1:length(stimulus)
    display_stimulus(stimulus{i}, 'wait_trigger', 0, 'wait_key', 0);
end

%%%%%%%%%% clean up %%%%%%%%%% 
for i=1:length(stimulus)
    mglDeleteTexture(stimulus{i}.texture.tex1d);
end

%% Moving flashing square 
% presents a square (size=stix_width) within x,y bounds (eg. x_start) that
% flashes ON within bounds for a duration (frames) and OFF for the same
% duration.  It will move by stixel_shift (ie. if shift<width there will be
% overlap in squares).

fprintf('\n\n<strong> Moving flashing squares </strong>\n');
clear parameters stimulus;

parameters.class = 'MFS';  
parameters.rgb = [.5, .5, .5];
parameters.back_rgb = [0, 0, 0];
parameters.frames = 60;                       % "frames" is the number of frame refreshes to wait for each half-cycle (i.e. the pulse is on for the number of frames set here
                                            % and then off for the same number of frames. This completes one repetition of the pulse.

parameters.x_start = 180;  parameters.x_end = 600;  % These fields set the region of stimulation with full square overlap coverage
parameters.y_start = 80;   parameters.y_end = 500; % actual presentation area will be end-start+(stix_w-stix_shift)
parameters.stixel_width = 30;         % size of each stixel in pixels 
parameters.stixel_shift = 10 ; % number of pixels each stixel can be shifted by (below stixel width causes stixel overlap)

parameters.num_reps = 1; % "num_reps" gives the number of times the pulse on-off cycle is completed.
parameters.repeats = 3; % repeats of the whole stimulus block
parameters.wait_trigger = 0;
parameters.wait_key = 0;
parameters.sub_region = 1; % if 1: subdivide the stimulus field into 4 regions, show 4 spatially correlated flash squares 
parameters.random_seq = 0 ; % 1= random sequence, 0 = repeated sequence in order
                         
stimulus = make_stimulus(parameters, def_params);
display_stimulus(stimulus);
clear stimulus;

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
parameters.back_rgb = [1 1 1]*0.5;
parameters.rgb = -[1, 1, 1]*0.48;
parameters.x_start = 200;  parameters.x_end = 600;
parameters.y_start = 100;   parameters.y_end = 500;
parameters.frames_p_bar = 1; % 1:no need to set frames. 0: have to set frames
parameters.frames = 70;
parameters.delay_frames = 30;

variable_parameters = randomize_parameters('direction', [0 45 90 135 180 225 270 315], ...
                                           'delta', [4 8], ...
                                           'bar_width', [60 120], ...
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
parameters.rgb = [1 1 1]*0.48;
parameters.back_rgb = [1 1 1]*0.5;
parameters.frames = 5*60; % presentation of each grating, frames
parameters.x_start = 0;  parameters.x_end = 800;
parameters.y_start = 0;   parameters.y_end = 600;
% parameters.direction = 45;

variable_parameters = randomize_parameters('direction', [0 45 90 135 180 225 270 315], ...
                                           'temporal_period', [12 24 60 120 240 480 720 960 1440], ...
                                           'spatial_period', [200], ...
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
    for j=1:stimulus{i}.temporal_period
        mglDeleteTexture(stimulus{i}.texture{j});
    end
end


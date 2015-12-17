%% Change background color and clear buffer (should run between every stimulus!!)
% gray
mglClearScreen(0.25);
mglFlush
% gray
mglClearScreen(0.25);
mglFlush

%% White noise

fprintf('\n\n<strong> Random Noise </strong>\n');
clear parameters stimulus time_stamps
dataname = 'data000';

% For repeats
%%{
repeats = 10;
parameters.frames = 120;
%}

% For straight through
%{
repeats = 1; % for straight through
parameters.frames = 120*10;
%}

% For masking
%{
mask = zeros(320,160); % this should be in stixels, not pixels
mask(1:300, 1:100) = 255;
parameters.mask = mask;
%}

parameters.class = 'RN';
parameters.back_rgb = [1 1 1]*0.5;
parameters.rgb = [1 1 1]*0.48;
parameters.interval = 2;
parameters.seed = 11111;
parameters.independent = 1;
parameters.binary = 1;
parameters.probability = 1;
parameters.delay_frames = 0;
parameters.frames = 120;

%%{
parameters.x_start = 1;  parameters.x_end = 640;
parameters.y_start = 81;   parameters.y_end = 400;
parameters.stixel_width = 8;   parameters.stixel_height = 8;
parameters.field_width = 80;  parameters.field_height = 40;
%}

stimulus = make_stimulus(parameters, def_params); 
for i = 1:repeats
    time_stamps{i} = display_stimulus(stimulus, 'trigger_interval', 100, 'wait_key',1, 'erase', 1);
end
% Save stuff
save([path2save '/' dataname '_time_stamps.mat'], 'time_stamps');
save_parameters(stimulus, path2save, dataname);

%% Raw Movie

fprintf('\n\n<strong> Raw Movie </strong>\n');
clear parameters stimulus time_stamps;

dataname = 'data000';

% For repeats
%%{
repeats = 3;
parameters.frames = 240;
interleaved = 0;
%}

% For straight through
%{
repeats = 1; % for straight through
parameters.frames = 120*10;
interleaved = 0;
%}

% For interleaved
%{
interleaved = 1;
repeats = 1; % for straight through
frames_testing = 120;
start_frame_testing = 1;
start_frame_fitting = frames_testing+1;
frames_fitting = 360;
parameters.frames = frames_testing;
%}

% For masking
%%{
final_mask = mod(final_mask+1, 2);
mask = final_mask'*255;
parameters.mask = mask;
%}

% Movie Name
parameters.movie_name = '/Volumes/Data/Stimuli/movies/eye-movement/current_movies/NSbrownian/NSbrownian_3000_movies/NSbrownian_3000_A_025.rawMovie';
% parameters.movie_name = '/Volumes/Lab/Users/Nora/new_stim_nora/mask_NSEM/testmask_3_stix2/comp_LES/movie_3_comp_LES.rawMovie';

% Don't need to change
parameters.class = 'RM';
parameters.back_rgb = [1 1 1]*0.25;
parameters.x_start = 1; % x_end and y_end wil depend on movie size (and stixel size)!
parameters.y_start = 81;
parameters.stixel_width = 2;   
parameters.stixel_height = 2;
parameters.start_frame = 1; % >0
parameters.interval = 1;
parameters.flip = 1;  % 1 = normal; 2 = vertical flip; 3 = horizontal flip; 4 = vertical + horizontal flip
parameters.reverse = 0;   % 1 = backward (reverse), 0 = forward

stimulus = make_stimulus(parameters, def_params); 
count = 1;
for i = 1:repeats
    time_stamps{count} = display_stimulus(stimulus, 'trigger_interval', 100, 'wait_key',1, 'erase', 1);
    count = count + 1;
    if interleaved
        parameters.start_frame = start_frame_fitting;
        parameters.frames = frames_fitting;
        stimulus = make_stimulus(parameters, def_params);
        time_stamps{count} = display_stimulus(stimulus, 'trigger_interval', 100, 'wait_key',1, 'erase', 1);
        count = count + 1;
        parameters.start_frame = start_frame_testing;
        parameters.frames = frames_testing;
        stimulus = make_stimulus(parameters, def_params);
        start_frame_fitting = start_frame_fitting + frames_fitting;
    end 
end

% Save stuff
save([path2save '/' dataname '_time_stamps.mat'], 'time_stamps');
save_parameters(stimulus, path2save, dataname);
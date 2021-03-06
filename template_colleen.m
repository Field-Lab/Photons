%% White noise for classification (ie Random Noise)

fprintf('\n\n<strong> Random Noise </strong>\n');
clear parameters stimulus

parameters.class = 'RN';
parameters.back_rgb = [1 1 1]*0.5;
parameters.rgb = [1 1 1]*0.48;
parameters.seed = 11111;
parameters.binary = 1;
parameters.probability = 1;
parameters.jitter = 0;
parameters.delay_frames = 0;

%%%%%%%%%%%%%% OLED %%%%%%%%%%%%%% 
% parameters.x_start = 1;  parameters.x_end = 800;
% parameters.y_start = 1;   parameters.y_end = 600;

%%%%%%%%%%%%%% CRT %%%%%%%%%%%%%% 
parameters.x_start = 0;  parameters.x_end = 639;
parameters.y_start = 80;   parameters.y_end = 399;

parameters.independent = 0;

parameters.interval = 6;
parameters.stixel_width = 1;
parameters.frames = 120*900; % 120*length of stimulus in seconds

parameters.stixel_height = parameters.stixel_width;
parameters.field_width = (parameters.x_end-parameters.x_start+1)/parameters.stixel_width;  
parameters.field_height = (parameters.y_end-parameters.y_start+1)/parameters.stixel_height;

% For Voronoi, set stixel_height and stixel_width to 1 and pass a map path
% parameters.map_file_name = [my_path, '/Maps/2011-12-13-2_f04_vorcones/map-0000.txt'];
%parameters.map_file_name = ['/Volumes/Lab/Users/crhoades/Colleen/matlab/private/colleen/New Cell Types/Stimulus Code/test/data002/large_on/5.txt'];

stimulus = make_stimulus(parameters, def_params);

[time_stamps] = display_stimulus(stimulus, 'wait_trigger', 0);
%save('/Users/vision/Desktop/2016-04-21-x/data002', 'time_stamps')

%% White noise rasters

fprintf('\n\n<strong> Random Noise </strong>\n');
clear parameters stimulus

parameters.class = 'RN';
parameters.back_rgb = [1 1 1]*0.5;
parameters.rgb = [1 1 1]*0.48;
parameters.seed = 11111;
parameters.binary = 1;
parameters.probability = 1;
parameters.jitter = 0;
parameters.delay_frames = 0;
nrepeat = 3;
%%%%%%%%%%%%%% OLED %%%%%%%%%%%%%% 
% parameters.x_start = 1;  parameters.x_end = 800;
% parameters.y_start = 1;   parameters.y_end = 600;

%%%%%%%%%%%%%% CRT %%%%%%%%%%%%%% 
parameters.x_start = 0;  parameters.x_end = 639;
parameters.y_start = 0;   parameters.y_end = 479;

parameters.independent = 0;
parameters.interval = 8;
parameters.stixel_width = 20;
parameters.frames = 120*10; % 120*length of each repeat

parameters.stixel_height = parameters.stixel_width;
parameters.field_width = (parameters.x_end-parameters.x_start+1)/parameters.stixel_width;  
parameters.field_height = (parameters.y_end-parameters.y_start+1)/parameters.stixel_height;

% For Voronoi, set stixel_height and stixel_width to 1 and pass a map path
% parameters.map_file_name = [my_path, '/Maps/2011-12-13-2_f04_vorcones/map-0000.txt'];

stimulus = make_stimulus(parameters, def_params);

for i  = 1:nrepeat
    [time_stamps] = display_stimulus(stimulus, 'wait_trigger', 0);
end
save('/Users/vision/Desktop/2016-04-21-x/data002', 'time_stamps')

%% NSEM repeat
fprintf('\n\n<strong> Raw Movie </strong>\n');
clear parameters stimulus;

parameters.class = 'RM';
parameters.back_rgb = [1 1 1]*0.5;
parameters.x_start = 0; 
parameters.y_start = 79;
% x_end and y_end wil depend on movie size (and stixel size)!
parameters.stixel_width = 2;   
parameters.stixel_height = 2;
parameters.frames = 120*5;  % 120*duration of each repetition, default whole movie
parameters.start_frame = 1; % >0
parameters.interval = 1;
parameters.flip = 1;  % 1 = normal; 2 = vertical flip; 3 = horizontal flip; 4 = vertical + horizontal flip
parameters.reverse = 0;   % 1 = backward (reverse), 0 = forward
parameters.movie_name = '/Users/vision/Desktop/Stimuli/NSinterval_3600_025.rawMovie';

% parameters.movie_name = '/Users/vision/Desktop/1stix_test.rawMovie';
num_repeats = 3;
stimulus = make_stimulus(parameters, def_params);

for i = 1:num_repeats
    time_stamps = display_stimulus(stimulus);
end
save('/Users/vision/Desktop/2016-04-21-x/data002', 'time_stamps')


%% Gray screen for correlations
mglClearScreen(0.5);
mglFlush

%% Spot of light/dark in a mapped location; increasing spot (i.e. Map based Pulse)
fprintf('\n\n<strong> Cone-Isolating Pulse </strong>\n');
clear parameters stimulus;

parameters.class = 'PL';
parameters.back_rgb = [1 1 1]*0.5;
parameters.frames = 120;
parameters.delay_frames = 0;
% without trigger, set delay frames to 120 for 
% a 1 second gray screen, with trigger set trigger low to 1.999
parameters.tail_frames = 0; 

% parameters.rgb = [1 1 1]*0.48;
parameters.x_start = 0;  parameters.x_end = 639;
parameters.y_start = 0;   parameters.y_end = 479;
base_file_path = [my_path, '/saved_stim/2015-11-19-test/2015-11-09-7/'];
maps = {'80_0'};
rgb = {[0.48, 0.48, 0.48], [-0.48, -0.48, -0.48]}; % light and dark
% parameters.map_file_name = [base_file_path, '.txt'];

% s_params = read_s_file([my_path, '/Maps/s03']);
% 
variable_parameters = randomize_parameters('rgb', rgb,'index_map', maps, 'nrepeats',5);
path2file = write_s_file(parameters, variable_parameters);
s_params = read_s_file(path2file);

% see second option example in "S File read"
for i=2:size(s_params,2)
    trial_params = combine_parameters(s_params{1}, s_params{i});
    trial_params.map_file_name = [base_file_path, variable_parameters(i-1).index_map, '.txt'];
    stimulus{i-1} = make_stimulus(trial_params, def_params);

end
for i = 2:size(s_params,2)
    display_stimulus(stimulus{i-1}, 'wait_trigger', 0, 'erase_to_gray', 1);
end
save('/Users/vision/Desktop/2016-04-21-x/data002', 'time_stamps')


%% Moving bar

fprintf('\n\n<strong> Moving bar. </strong>\n');
clear parameters stimulus;

parameters.class = 'MB';
parameters.back_rgb = [1 1 1]*0.5;
parameters.rgb = -[1, 1, 1]*0.48;
parameters.bar_width = 30;
%parameters.orientation = 45;
parameters.delta = 2;  % pixels per frame
parameters.x_start = 0;  parameters.x_end = 640;
parameters.y_start = 0;   parameters.y_end = 480;
parameters.frames = 320;
parameters.delay_frames = 0;

base_file_path = [my_path, '/saved_stim/2015-11-19-test/'];
direction = [0 90 180 270];
delta = [2 4];

variable_parameters = randomize_parameters('direction', direction, 'delta', delta, 'nrepeats',5);
path2file = write_s_file(parameters, variable_parameters);
s_params = read_s_file(path2file);

for i=2:size(s_params,2)
    trial_params = combine_parameters(s_params{1}, s_params{i});
    stimulus{i-1} = make_stimulus(trial_params, def_params);

end
for i = 2:size(s_params,2)
    display_stimulus(stimulus{i-1}, 'wait_trigger', 0);
end
save('/Users/vision/Desktop/2016-04-21-x/data002', 'time_stamps')


%% Moving Grating S File write
% trigger interval 7.99
fprintf('\n\n<strong> Moving Grating. </strong>\n');
clear parameters stimulus

parameters.class = 'MG';
parameters.spatial_modulation = 'sine'; % sine or square
parameters.rgb = [1 1 1]*0.48;
parameters.back_rgb = [1 1 1]*0.5;
parameters.frames = 5*120; % presentation of each grating, frames
parameters.x_start = 0;  parameters.x_end =639;
parameters.y_start = 0;   parameters.y_end = 479;
% parameters.direction = [0 90];

variable_parameters = randomize_parameters('direction', [0 90], 'temporal_period', [30 60], 'spatial_period', [32,64], 'nrepeats',2);
path2file = write_s_file(parameters, variable_parameters);
s_params = read_s_file(path2file);

% see second option example in "S File read"
for i=2:size(s_params,2)
    trial_params = combine_parameters(s_params{1}, s_params{i});
    stimulus{i-1} = make_stimulus(trial_params, def_params);
    display_stimulus(stimulus{i-1}, 'wait_trigger', 1);
end

%%%%%%%%%% clean up %%%%%%%%%% 
for i=1:length(stimulus)
    for j=1:stimulus{i}.temporal_period
        mglDeleteTexture(stimulus{i}.texture{j});
    end
end

% white
mglClearScreen(1);
mglFlush
save('/Users/vision/Desktop/2016-04-21-x/data002', 'time_stamps')


%% White noise over a mosaic of cells

fprintf('\n\n<strong> Random Noise </strong>\n');
clear parameters stimulus

parameters.class = 'RN';
parameters.back_rgb = [1 1 1]*0.5;
parameters.rgb = [1 1 1]*0.48;
parameters.seed = 11111;
parameters.binary = 1;
parameters.probability = 1;
parameters.jitter = 0;
parameters.delay_frames = 0;

%%%%%%%%%%%%%% OLED %%%%%%%%%%%%%% 
% parameters.x_start = 1;  parameters.x_end = 800;
% parameters.y_start = 1;   parameters.y_end = 600;

%%%%%%%%%%%%%% CRT %%%%%%%%%%%%%% 
parameters.x_start = 0;  parameters.x_end = 639;
parameters.y_start = 0;   parameters.y_end = 479;

parameters.independent = 0;
parameters.interval = 1;
parameters.stixel_width = 1;
parameters.frames = 120*10;

parameters.stixel_height = parameters.stixel_width;
parameters.field_width = (parameters.x_end-parameters.x_start+1)/parameters.stixel_width;  
parameters.field_height = (parameters.y_end-parameters.y_start+1)/parameters.stixel_height;

% For Voronoi, set stixel_height and stixel_width to 1 and pass a map path
% parameters.map_file_name = [my_path, '/Maps/2011-12-13-2_f04_vorcones/map-0000.txt'];
parameters.map_file_name = [my_path, '/saved_stim/2015-11-19-test/2015-11-09-7/80_0.txt'];
% mask example
% mask = zeros(80,40);
% mask(1:10, 1:10) = 255;
% parameters.mask = mask;

stimulus = make_stimulus(parameters, def_params);


time_stamps = display_stimulus(stimulus, 'wait_trigger', 0);
save('/Users/vision/Desktop/2016-04-21-x/data002', 'time_stamps')


%% chirp stimulus
% Rectangular Flashing Pulses
% trigger interavl 1.99
fprintf('\n\n<strong> Rectangular Pulses: any sequence. </strong>\n');
clear parameters stimulus time_stamps;

parameters.class = 'FP';
parameters.frames = 1*120;
parameters.delay_frames = 120;
parameters.tail_frames = 120;

parameters.back_rgb = [1 1 1]*0.5;
parameters.x_start = 0;  parameters.x_end = 639;
parameters.y_start = 0;   parameters.y_end = 479;

num_repeats = 3;
rgb = [1 1 1]*0.48;
% start with a black screen


stimulus{1} = make_stimulus(parameters, 'rgb', rgb, def_params);



% increase in contrast

parameters.class = 'CH';
parameters.back_rgb = [1 1 1]*0.5;
parameters.rgb = [1 1 1]*0.48;
parameters.delay_frames = 120;
parameters.tail_frames = 120;

parameters.x_start = 0;  parameters.x_end = 639;
parameters.y_start = 0;   parameters.y_end = 479;
parameters.jitter = 0;
parameters.interval = 1;

rate = 120;

% increase in contrast
parameters.frames = rate*8.25;%parameters.step_start + parameters.step_length + parameters.pre_freq_low +parameters.pre_freq_mid+parameters.freq_frames+parameters.mid_freq_cont+parameters.cont_frames+parameters.post_cont_mid+parameters.post_cont_low; % total for all parts of chirp
parameters.stixel_width = 1;
parameters.stixel_height = parameters.stixel_width;

parameters.field_width = (parameters.x_end-parameters.x_start+1)/parameters.stixel_width;  
parameters.field_height = (parameters.y_end-parameters.y_start+1)/parameters.stixel_height;

t_cont = linspace(0,parameters.frames/rate, parameters.frames);
contrast_values = 30+3.81*t_cont.*cos(4*pi*t_cont);
contrast_values = contrast_values*(floor(parameters.rgb(1)*2*256))./(max(contrast_values)+min(contrast_values));
parameters.intensity_values = contrast_values;

parameters.current_state = 0;
stimulus{2} = make_stimulus(parameters, def_params); 
% save_parameters(stimulus, path2save, 'data000');
% 
% %start with gray screen
% mglClearScreen(0.5);
% mglFlush
% mglClearScreen(0.5);
% mglFlush




% increase in frequency
t_freq = linspace(0,parameters.frames/120, parameters.frames);
frame_values = 30+30*sin(pi*(t_freq.^2+t_freq/10));
range = floor(parameters.rgb(1)*2*256);
frame_values = frame_values*(range)./(max(frame_values)+min(frame_values));
parameters.intensity_values = frame_values;

stimulus{3} = make_stimulus(parameters, def_params); 
% save_parameters(stimulus, path2save, 'data000');




% display all of them

for i = 1:num_repeats
    mglClearScreen(0);
    mglFlush
    mglClearScreen(0);
    mglFlush

    time_stamps{1}{i} = display_stimulus(stimulus{1}, 'wait_trigger', 1,'erase_to_black', 1);

    time_stamps{2}{i} = display_stimulus(stimulus{2}, 'wait_trigger',1, 'erase_to_gray', 1);
    
    time_stamps{3}{i} = display_stimulus(stimulus{3}, 'wait_trigger',1, 'erase_to_gray', 1);
end
save('/Users/vision/Desktop/2016-04-21-x/data002', 'time_stamps')


%% Contrast Reversing Gratings
%trigger 1.99
fprintf('\n\n<strong> Counterphase Grating. </strong>\n');
clear parameters stimulus

parameters.class = 'CG';
parameters.spatial_modulation = 'sine'; % sine or square
parameters.temporal_modulation = 'sine'; % sine or square
parameters.rgb = [1 1 1]*0.48;
parameters.back_rgb = [1 1 1]*0.5;
parameters.frames = 120*6; % presentation of each grating, frames
parameters.x_start = 0;  parameters.x_end = 640;
parameters.y_start = 79;   parameters.y_end = 400;
parameters.spatial_phase = 0; % pixels - offset
temporal_period = [15 30 60];  % frames (how long it takes to return to initial phase)
spatial_period = [48 96 384 768]; % pixels
parameters.orientation = 90;


variable_parameters = randomize_parameters('spatial_period', spatial_period, 'temporal_period', temporal_period, 'nrepeats',3);
path2file = write_s_file(parameters, variable_parameters);
s_params = read_s_file(path2file);

% see second option example in "S File read"
for i=2:size(s_params,2)
    trial_params = combine_parameters(s_params{1}, s_params{i});
    stimulus{i-1} = make_stimulus(trial_params, def_params);
    time_stamps{i} = display_stimulus(stimulus{i-1}, 'wait_trigger', 1);
end

%%%%%%%%%% clean up %%%%%%%%%% 
for i=1:length(stimulus)
    for j=1:stimulus{i}.temporal_period
        mglDeleteTexture(stimulus{i}.texture{j});
    end
end

% white
mglClearScreen(1);
mglFlush
save('/Users/vision/Desktop/2016-04-21-x/data002', 'time_stamps')

%% Moving Bar

fprintf('\n\n<strong> Moving bar. </strong>\n');
clear parameters stimulus;

parameters.class = 'MB';
parameters.back_rgb = [1 1 1]*0.5;
parameters.rgb = -[1, 1, 1]*0.48;
parameters.bar_width = 30;
direction = [0 90 180 270];
delta = [1 2 4 8];  % pixels per frame
parameters.x_start = 0;  parameters.x_end = 639;
parameters.y_start = 0;   parameters.y_end = 479;
parameters.delay_frames = 0;
% parameters.frames = parameters.x_end./min(delta);

variable_parameters = randomize_parameters('direction', direction,'delta', delta, 'nrepeats',3);

path2file = write_s_file(parameters, variable_parameters);
s_params = read_s_file(path2file);

% see second option example in "S File read"
for i=2:size(s_params,2)

    trial_params = combine_parameters(s_params{1}, s_params{i});
     trial_params.frames = (parameters.x_end+1)./trial_params.delta;

    stimulus{i-1} = make_stimulus(trial_params, def_params);
    time_stamps{i} = display_stimulus(stimulus{i-1}, 'wait_trigger', 1);
end

%%%%%%%%%% clean up %%%%%%%%%% 
for i=1:length(stimulus)
    for j=1:stimulus{i}.temporal_period
        mglDeleteTexture(stimulus{i}.texture{j});
    end
end

% white
mglClearScreen(1);
mglFlush
save('/Users/vision/Desktop/2016-04-21-x/data002', 'time_stamps')




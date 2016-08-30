%% Initialization

my_path = '/Users/Suva/Desktop/GitAll/GitClones_FieldLab/Photons';
%my_path = '/Users/acquisition/Photons';
%my_path = '/Users/stimulus/Photons';

addpath(genpath(my_path))
cd(my_path)

path2save = [my_path, '/saved_timestamps/2016-04-21-5/'];
screen_number = 0; % Value = 0 (primary screen small), 1 (primary screen full), 2 (secondary screen full)
def_params = initialize_display('OLED', screen_number);


% % set gamma OLED Aug 2, 2016
% scale = [1.1399    1.0998    1.1027];
% power = [1.1741    1.2998    1.3112];
% offset = [-0.1445   -0.1023   -0.1054];
% set_gamma_from_fit_params(scale, power, offset);

% % set gamma CRT nov 2015
% scale = [0.9998    1.0072    1.0019];
% power = [2.7807    2.8437    2.7429];
% offset = [-0.0017   -0.0043   -0.0002];
% set_gamma_from_fit_params(scale, power, offset);

% % set gamma OLED nov 2015
% scale = [1.1156    1.0919    1.0921];
% power = [1.1799    1.2878    1.2614];
% offset = [-0.1228   -0.0961   -0.0955];
% set_gamma_from_fit_params(scale, power, offset);

% % set gamma CRT Rig 4
% scale = [0.9489    1.0203    1.0090];
% power = [2.4109    2.5974    2.5376];
% offset = [0.0561    0.0040    0.0038];
% set_gamma_from_fit_params(scale, power, offset);

%% Gamma calibration
 
% linear measurements (INSERT HERE)
% CRT, 2015-11-03, ATH
r = [0.1 0.19 1.39 8.09 25.7 57.4 105 170 252 343 453 583 739 930 1140 1400 1670];
g = [0.1 0.12 0.7 5.88 24.7 63.8 127 216 330 457 614 802 1030 1300 1610 1970 2350];
b = [0.1 0.4 3.86 19.1 53.5 112 195 304 438 583 767 990 1250 1570 1940 2360 2790];
w = [0.1 .052 5.93 33.0 103 225 404 647 950 1290 1730 2300 2980 3830 4740 5770 6850];

% linear measurements (INSERT HERE)
% OLED, 2015-11-07, ATH
r = [8.9 7.28 10.5 5.7 12.3 4.2 14.1 2.5 15.9 0.23 17.9 0.02 19.9 0.02 22.0 0.02 24 ];
g = [14.4 11.7 17.1 9.1 20.2 6.45 23.3 3.84 26.5 0.5 30.1 0.02 33.6 0.02 37.3 0.02 40.8];
b = [9.8 8 11.5 6.18 13.5 4.5 15.5 2.78 17.6 0.45 20 0.02 22.3 0.02 24.7 0.02 26.9];

% CRT, 2015-12-16, NJB, rig 4
r = [2.2 1.81 2.69 1.45 3.29 1.16 4 0.92 4.8 0.74 5.8 0.66 6.87 0.63 8.04 0.61 9.2];
g = [2.21 1.74 2.73 1.32 3.45 1 4.29 0.77 5.35 0.65 6.43 0.56 7.74 0.54 9.21 0.60 10.56];
b = [2.61 2.01 3.25 1.56 4.05 1.16 5.03 0.89 6.18 0.74 7.59 0.64 9.06 0.60 10.70 0.59 12.37];
w = [5.97 4.44 7.60 3.19 9.92 2.19 12.57 1.44 15.63 0.98 19.33 0.74 23.2 0.64 27.6 0.63 31.9];

% CRT 2015-12-17, NJB, rig 4
r = [2.31 1.85 2.82 1.47 3.46 1.15 4.22 0.89 5.1 0.707 6.14 0.584 7.24 0.52 8.44 0.498 9.7];
g = [2.21 1.72 2.81 1.30 3.58 0.96 4.48 0.711 5.51 0.57 6.75 0.497 8.04 0.451 9.46 0.459 10.9];
b = [2.65 2.02 3.28 1.51 4.13 1.10 5.17 0.801 6.38 0.599 7.83 0.495 9.24 0.450 10.94 0.446 12.65];
w = [6.05 4.5 7.83 3.17 10.15 2.12 12.87 1.34 15.87 0.832 19.40 0.58 23.6 0.488 28.1 0.47 32.7];
red_offset = 0.4;

g = g-red_offset;
b = b-red_offset;

[~,i] = sort(get_sequence(steps));
r = r(i);
g = g(i);
b = b(i);

[scale, power, offset] = fit_gamma([r',g',b']);

% control
run_gamma_flashes([scale, power, offset], steps, [1 0 0]);

% corrected measurements (INSERT HERE, then proceed below)
% CRT, 2015-11-05, ATH
r = [0.1 101 212 322 429 529 627 736 834 930 1030 1140 1240 1350 1450 1560 1660];
g = [0.1 130 289 445 590 736 879 1030 1170 1300 1450 1580 1720 1870 2010 2160 2310];
b = [0.1 176 367 541 704 874 1050 1210 1400 1550 1720 1880 2080 2260 2430 2600 2780];
w = [0.1 389 813 1220 1610 2040 2480 2920 3370 3780 4220 4640 5100 5520 5950 6370 6790];

% OLED, 2015-11-07, ATH
r = [12.4 10.9 13.9 9.4 15.5 7.9 17 6.39 18.6 4.92 20.3 3.31 21.8 1.1 23.4 0.03 24.4];
g = [21.2 18.5 23.6 15.9 26.2 13.4 28.7 10.8 31.5 8 34.2 5.22 37 1.81 39.5 0.03 41.4];
b = [13.8 12 15.3 10.4 17 8.8 18.8 7.02 20.5 5.2 22.4 3.39 24.2 0.93 26 0.03 27.2];
w = [47.4 41.6 52.7 35.9 58.4 30.5 64.2 24.8 70.2 18.9 76.2 12.8 82.2 5.2 88.1 0.03 92.4];

% CRT, 2015-12-16, NJB, Rig 4
r = [4.64 4 5.14 3.47 5.7 2.99 6.27 2.44 6.77 2.0 7.37 1.5 7.99 1.03 8.53 0.60 9.08];
g = [5.17 4.52 5.70 3.94 6.37 3.33 6.98 2.72 7.53 2.12 8.19 1.57 8.78 1.03 9.39 0.63 9.95];
b = [6.10 5.39 6.74 4.64 7.45 3.89 8.1 3.24 8.94 2.52 9.74 1.86 10.49 1.1 11.11 0.62 11.95];
w = [15.15 13.15 16.87 11.20 18.84 9.21 20.8 7.35 22.7 5.53 24.8 3.75 26.7 1.96 28.6 0.63 30.6];

% CRT, 2015-12-17 NJB Rig 4
r = [4.62 4.05 5.18 3.47 5.7 2.92 6.28 2.39 6.91 1.90 7.49 1.4 8.10 0.9 8.65 0.493 9.27];
g = [5.12 4.49 5.74 3.87 6.33 3.25 7.02 2.61 7.59 2.03 8.28 1.46 8.9 0.896 9.49 0.497 10.20];
b = [6.14 5.39 6.85 4.64 7.63 3.92 8.36 3.19 9.14 2.47 9.97 1.78 10.71 1.07 11.5 0.507 12.33];
w = [15.3 13.3 17.25 11.26 19.21 9.28 21.2 7.32 23.3 5.48 25.4 3.66 27.7 1.91 29.6 0.542 31.8];

% CRT
r = [4.41 3.87 4.95 3.32 5.46 2.80 6.01 2.29 6.6 1.83 7.15 1.36 7.72 0.886 8.45 0.518 9.11];
g = [5.22 4.6 5.85 4.01 6.42 3.38 7.04 2.77 7.60 2.17 8.19 1.62 8.81 1 9.35 0.53 10.07];
b = [6.2 5.45 6.90 4.71 7.61 3.98 8.33 3.31 9.09 2.62 9.81 1.93 10.54 1.19 11.34 0.53 12.01];
w = [15.35 13.31 17.25 11.37 19.11 9.42 21.1 7.56 23.1 5.72 25 3.94 27 2.09 29 0.519 31];

r = r(i);
g = g(i);
b = b(i);
w = w(i);


g = g-red_offset;
b = b-red_offset;

% plot
x = linspace(0,255,steps);
figure
subplot(1,2,1); plot(x, r, 'r', x, g, 'g', x, b, 'b');
subplot(1,2,2); plot(x, w, 'k-o', x, r+g+b, 'm-*'); legend('measured', 'sum')


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


%% Rectangular Flashing Pulses
fprintf('\n\n<strong> Rectangular Pulses: any sequence. </strong>\n');
clear parameters stimulus;

parameters.class = 'FP';
parameters.frames = 1;
parameters.delay_frames = 0;
parameters.back_rgb = [1 1 1]*0.5;
parameters.x_start = 0;  parameters.x_end = 639;
parameters.y_start = 0;   parameters.y_end = 479;

num_repeats = 30;
rgb = [0 0 0]*0.5;
for z = 1:num_repeats
    for i=1:size(rgb,1)
        stimulus = make_stimulus(parameters, 'rgb', rgb(i,:), def_params);
        display_stimulus(stimulus);
    end
end

%% Map based Pulse
fprintf('\n\n<strong> Cone-Isolating Pulse </strong>\n');
clear parameters stimulus;

parameters.class = 'PL';
parameters.back_rgb = [1 1 1]*0.5;
parameters.frames = 120;
parameters.delay_frames = 0;
parameters.tail_frames = 0;

% parameters.rgb = [1 1 1]*0.48;
parameters.x_start = 0;  parameters.x_end = 639;
parameters.y_start = 0;   parameters.y_end = 479;
base_file_path = [my_path, '/saved_stim/2015-11-19-test/'];
maps = {'335', '5615'};
rgb = {[0.48, 0.48, 0.48], [-0.48, -0.48, -0.48]};
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
    display_stimulus(stimulus{i-1}, 'wait_trigger', 1, 'erase_to_gray', 1);
end



% 
% for i=2:size(s_params,2)
%     trial_params = combine_parameters(parameters, s_params{1}, s_params{i});
%     stimulus = make_stimulus(trial_params, def_params);
%     display_stimulus(stimulus)
% end



%% Moving bar

fprintf('\n\n<strong> Moving bar. </strong>\n');
clear parameters stimulus;

fprintf('\n\n<strong> Moving bar. </strong>\n');
clear parameters stimulus;

parameters.class = 'MB';
parameters.back_rgb = [1 1 1]*0.25;
%parameters.rgb = [1, 1, 1]*(0.1*0.25);
parameters.x_start = 100;  parameters.x_end = 700;
parameters.y_start = 0;   parameters.y_end = 600;
parameters.frames_p_bar = 1; % 1:no need to set frames. 0: have to set frames
parameters.frames = 60*5;
parameters.delay_frames = 30;

variable_parameters = randomize_parameters('direction', [0:30:330], ...
                                           'delta', [4], ...
                                           'bar_width', [240], ...
                                           'nrepeats',11,...
                                           'rgb',[(0.1*0.25) (0.3*0.25) (0.6*0.25) (1*0.25) (3*0.25)]);
path2file = write_s_file(parameters, variable_parameters);
s_params = read_s_file(path2file);

% see second option example in "S File read"
for i=2:size(s_params,2)
    trial_params = combine_parameters(s_params{1}, s_params{i});
    stimulus{i-1} = make_stimulus(trial_params, def_params);
end

for i=1:length(stimulus)
    if i == 1
        display_stimulus(stimulus{i}, 'wait_trigger', 0, 'wait_key', 0); % set wait trigger to 1 during experiment
    else
        display_stimulus(stimulus{i}, 'wait_trigger', 0, 'wait_key', 0);
    end
end





%% Moving Grating single trial

fprintf('\n\n<strong> Moving Grating. </strong>\n');
clear parameters stimulus

parameters.class = 'MG';
parameters.spatial_modulation = 'sine'; % sine or square
parameters.rgb = [1 1 1]*0.48;
parameters.back_rgb = [1 1 1]*0.5;
parameters.frames = 5*120; % presentation of each grating, frames
parameters.x_start = 1;  parameters.x_end = 640;
parameters.y_start = 1;   parameters.y_end = 480;
parameters.direction = 45;
parameters.temporal_period = 60;  % frames 
parameters.spatial_period = 120; % pixels

stimulus = make_stimulus(parameters, def_params);
time_stamps = display_stimulus(stimulus);

%%%%%%%%%% clean up %%%%%%%%%% 
for i=1:stimulus.temporal_period
    mglDeleteTexture(stimulus.texture{i});
end


%% Moving Grating simple sequence

fprintf('\n\n<strong> Moving Grating. </strong>\n');
clear parameters stimulus

parameters.class = 'MG';
parameters.spatial_modulation = 'sine'; % sine or square
parameters.back_rgb = [1 1 1]*0.5;
parameters.rgb = [1 1 1]*(0.48);
parameters.x_start = 100;  parameters.x_end = 700;
parameters.y_start = 0;   parameters.y_end = 600;
parameters.frames = 8*60; % presentation of each grating, frames
parameters.delay_frames = 0;

variable_parameters = randomize_parameters('direction', [0:30:330], ...
    'temporal_period', [30 120], 'spatial_period', [100], 'nrepeats',6);
path2file = write_s_file(parameters, variable_parameters);
s_params = read_s_file(path2file);

% see second option example in "S File read"
for i=2:size(s_params,2)
    trial_params = combine_parameters(s_params{1}, s_params{i});
    stimulus{i-1} = make_stimulus(trial_params, def_params);
    display_stimulus(stimulus{i-1}, 'wait_trigger', 0); % set 1 for actual experiment
end

%%%%%%%%%% clean up %%%%%%%%%% 
for i=1:length(stimulus)
    for j=1:stimulus{i}.temporal_period
        mglDeleteTexture(stimulus{i}.texture{j});
    end
end



%% Moving Grating S File read

fprintf('\n\n<strong> Moving Grating. </strong>\n');
clear parameters stimulus

parameters.class = 'MG';
parameters.spatial_modulation = 'sine'; % sine or square
parameters.back_rgb = [1 1 1]*0.5;

s_params = read_s_file([my_path, '/Maps/drifting_gratings/s03']);

%%%%%%%%%% OPTION 1: make/display in loop %%%%%%%%%%%%%%%
for i=2:size(s_params,2)
    trial_params = combine_parameters(parameters, s_params{1}, s_params{i});
    stimulus{i-1} = make_stimulus(trial_params, def_params);
    display_stimulus(stimulus{i-1});
end

%%%%%%%%%% OPTION 2: pre-make all, display all %%%%%%%%%% 
for i=2:size(s_params,2)
    trial_params = combine_parameters(parameters, s_params{1}, s_params{i});
    stimulus{i-1} = make_stimulus(trial_params, def_params);
end
for i=1:length(stimulus)
    display_stimulus(stimulus{i});
end

%%%%%%%%%% clean up %%%%%%%%%% 
for i=1:length(stimulus)
    for j=1:stimulus{i}.temporal_period
        mglDeleteTexture(stimulus{i}.texture{j});
    end
end



%% Moving Grating S File write

fprintf('\n\n<strong> Moving Grating. </strong>\n');
clear parameters stimulus

parameters.class = 'MG';
parameters.spatial_modulation = 'sine'; % sine or square
parameters.rgb = [1 1 1]*0.48;
parameters.back_rgb = [1 1 1]*0.5;
parameters.frames = 5*120; % presentation of each grating, frames
parameters.x_start = 0;  parameters.x_end =639;
parameters.y_start = 0;   parameters.y_end = 479;
parameters.direction = [0 90];

variable_parameters = randomize_parameters('direction', [0 90], 'temporal_period', [30 60], 'spatial_period', [32,64], 'nrepeats',2);
path2file = write_s_file(parameters, variable_parameters);
s_params = read_s_file(path2file);

% see second option example in "S File read"
for i=2:size(s_params,2)
    trial_params = combine_parameters(s_params{1}, s_params{i});
    stimulus{i-1} = make_stimulus(trial_params, def_params);
    display_stimulus(stimulus{i-1}, 'wait_trigger', 0); % set 1 for actual experiment
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
%% Counterphase Grating

fprintf('\n\n<strong> Counterphase Grating. </strong>\n');
clear parameters stimulus

parameters.class = 'CG';
parameters.spatial_modulation = 'sine'; % sine or square
parameters.temporal_modulation = 'sine'; % sine or square
parameters.rgb = [1 1 0]*0.2;
parameters.back_rgb = [1 1 1]*0.4;
parameters.frames = 120; % presentation of each grating, frames
parameters.x_start = 200;  parameters.x_end = 600;
parameters.y_start = 100;   parameters.y_end = 500;
parameters.spatial_phase = 0; % pixels - offset
parameters.temporal_period = 60;  % frames (how long it takes to return to initial phase)
parameters.spatial_period = 120; % pixels
parameters.orientation = 90;

stimulus = make_stimulus(parameters, def_params);

time_stamps = display_stimulus(stimulus);



%% Random Noise

fprintf('\n\n<strong> Random Noise </strong>\n');
clear parameters stimulus

parameters.class = 'RN';
parameters.back_rgb = [1 1 1]*0;
parameters.rgb = [1 1 1]*0.5;
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
parameters.interval = 30;
parameters.stixel_width = 20;
parameters.frames = 60*5;

parameters.stixel_height = parameters.stixel_width;
parameters.field_width = (parameters.x_end-parameters.x_start+1)/parameters.stixel_width;
parameters.field_height = (parameters.y_end-parameters.y_start+1)/parameters.stixel_height;

% For Voronoi, set stixel_height and stixel_width to 1 and pass a map path
%parameters.map_file_name = [my_path, '/Maps/2011-12-13-2_f04_vorcones/map-0000.txt'];
% parameters.map_file_name = ['/Volumes/Lab/Users/crhoades/Colleen/matlab/private/colleen/New Cell Types/Stimulus Code/test/data002/large_on/5.txt'];

% parameters.map_file_name = ['/Volumes/Data/2016-01-05-1/Visual/maps/map_data001.txt'];
% mask example
% mask = zeros(80,40);
% mask(1:10, 1:10) = 255;
% parameters.mask = mask;

% parameters.map_file_name = '/Volumes/Lab/Users/crhoades/Colleen/matlab/private/colleen/New Cell Types/Stimulus Code/test/data002/large_on/5.txt';
stimulus = make_stimulus(parameters, def_params);
time_stamps = display_stimulus(stimulus); % 'wait_trigger', 0, 'erase', 0


%% Raw Movie

fprintf('\n\n<strong> Raw Movie </strong>\n');
clear parameters stimulus;

parameters.class = 'RM';
parameters.back_rgb = [1 1 1]*0.5;
parameters.x_start = 0; % x_end and y_end wil depend on movie size (and stixel size)!
parameters.y_start = 0;
parameters.stixel_width = 8;   parameters.stixel_height = 8;
 parameters.frames = 5*120;  % duration of each repetition, default whole movie
parameters.start_frame = 1; % >0
parameters.interval = 1;
parameters.flip = 1;  % 1 = normal; 2 = vertical flip; 3 = horizontal flip; 4 = vertical + horizontal flip
parameters.reverse = 0;   % 1 = backward (reverse), 0 = forward

% parameters.movie_name = [my_path, '/Movies/test_5_A.rawMovie'];
%parameters.movie_name = '/Volumes/Data/Stimuli/movies/eye-movement/current_movies/NSbrownian/NSbrownian_3000_movies/NSbrownian_3000_A_025.rawMovie';
%parameters.movie_name = '/Users/vision/Desktop/1stix_test.rawMovie';
parameters.movie_name = '/Users/vision/Desktop/1.rawMovie';

stimulus = make_stimulus(parameters, def_params); 
save_parameters(stimulus, path2save, 'data000');
time_stamps = display_stimulus(stimulus, 'trigger_interval', 100, 'wait_key',1, 'erase', 0);

%% Raw Movie with mask (also works with white noise)

fprintf('\n\n<strong> Raw Movie with mask </strong>\n');
clear parameters stimulus;

parameters.class = 'RM';
parameters.back_rgb = [1 1 1]*0.5;
parameters.x_start = 1; % x_end and y_end wil depend on movie size (and stixel size)!
parameters.y_start = 1;
parameters.stixel_width = 1;   parameters.stixel_height = 1;
% parameters.frames = ceil(0.05*60*60);  % min * refresh rate (ceil it?) * 60(sec in min) - duration of each repetition!
parameters.frames = 1200;
parameters.start_frame = 1; % >0
parameters.interval = 1;
parameters.flip = 1;  % 1 = normal; 2 = vertical flip; 3 = horizontal flip; 4 = vertical + horizontal flip
parameters.reverse = 0;   % 1 = backward (reverse), 0 = forward
% parameters.movie_name = [my_path, '/Movies/test_5_A.rawMovie'];
parameters.movie_name = '/Volumes/Data/Stimuli/movies/eye-movement/current_movies/NSbrownian/NSbrownian_3000_movies/NSbrownian_3000_A_025.rawMovie';
% parameters.movie_name = '/Users/vision/Desktop/1stix_test.rawMovie';

% mask
mask = zeros(320,160);
mask(1:10, 1:10) = 255;
parameters.mask = mask;
parameters.movie_name = [my_path, '/Movies/test_5_A.rawMovie'];
% parameters.movie_name = '/Users/vision/Desktop/1stix_test.rawMovie';
num_repeats = 3;
stimulus = make_stimulus(parameters, def_params);

for i = 1:num_repeats
    time_stamps{i} = display_stimulus(stimulus);
end

save_parameters(stimulus, path2save, 'data000');

%% photographic mapping

fprintf('\n\n<strong> Random Noise : Binary. </strong>\n');
clear parameters stimulus;

parameters.class = 'RN';
parameters.rgb = [1 1 1]*0.48;
parameters.independent = 0;
parameters.seed = 11111;
parameters.frames = 1;
parameters.x_start = 0;  parameters.x_end = 639;
parameters.y_start = 80;   parameters.y_end = 399;
%%{ 
%large 
parameters.stixel_width = 1;   parameters.stixel_height = 1;
parameters.field_width = 640;  parameters.field_height = 320;
%{
% medium 
parameters.stixel_width = 10;   parameters.stixel_height = 10;
parameters.field_width = 32;  parameters.field_height = 32;
% small 
parameters.stixel_width = 1;   parameters.stixel_height = 1;
parameters.field_width = 320;  parameters.field_height = 320;
%}
stimulus = make_stimulus(parameters, def_params);
display_stimulus(stimulus, 'erase',0);
%}


%% Moving flashing square
% presents a square (size=stix_width) within x,y bounds (eg. x_start) that
% flashes ON within bounds for a duration (frames) and OFF for the same
% duration.  It will move by stixel_shift (ie. if shift<width there will be
% overlap in squares).

fprintf('\n\n<strong> Moving flashing squares </strong>\n');
clear parameters stimulus;

parameters.class = 'MFS';  
parameters.rgb = [1 1 1].*0.5;
parameters.back_rgb = [1 1 1].*0.5;
parameters.frames = 60;                       % "frames" is the number of frame refreshes to wait for each half-cycle (i.e. the pulse is on for the number of frames set here
                                            % and then off for the same number of frames. This completes one repetition of the pulse.

parameters.x_start = 100;  parameters.x_end = 700;  % These fields set the region of stimulation with full square overlap coverage
parameters.y_start = 0;  parameters.y_end = 600; % actual presentation area will be end-start+(stix_w-stix_shift)
parameters.stixel_width = 30;         % size of each stixel in pixels 
parameters.stixel_shift = 30;  % number of pixels each stixel can be shifted by (below stixel width causes stixel overlap)
parameters.num_reps = 1; % "num_reps" gives the number of times the pulse on-off cycle is completed.
parameters.repeats = 2; % repeats of the whole stimulus block
parameters.wait_trigger = 0;
parameters.wait_key = 0;
parameters.sub_region = 1; % if 1: subdivide the stimulus field into 4 regions, show 4 spatially correlated flash squares 
parameters.random_seq = 0 ; % 1= random sequence, 0 = repeated sequence in order
                         
stimulus = make_stimulus(parameters, def_params);
display_stimulus(stimulus);
clear stimulus;


%%
Stop_Photons

make_normal_table(8)
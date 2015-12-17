%% Initialization

my_path = '/Users/vision/Desktop/Photons';

addpath(genpath(my_path))
cd(my_path)

path2save = [my_path, '/saved_stim/nora_test'];
screen_number = 2;
def_params = initialize_display('CRT', screen_number);

% real refresh rate
%mglTestRefresh(2)

% set gamma CRT nov 2015
scale = [0.9998    1.0072    1.0019];
power = [2.7807    2.8437    2.7429];
offset = [-0.0017   -0.0043   -0.0002];
set_gamma_from_fit_params(scale, power, offset);

% set gamma OLED nov 2015
% scale = [1.1156    1.0919    1.0921];
% power = [1.1799    1.2878    1.2614];
% offset = [-0.1228   -0.0961   -0.0955];
% set_gamma_from_fit_params(scale, power, offset);

%% Gamma calibration

steps = 17;
run_gamma_flashes('linear', steps, [0 0 1]); % FIRST PARAMETER will reset gamma to linear!

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

[~,i] = sort(get_sequence(steps));
r = r(i);
g = g(i);
b = b(i);

[scale, power, offset] = fit_gamma([r',g',b']);

% control
run_gamma_flashes([scale, power, offset], steps, [1 1 1]);

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

r = r(i);
g = g(i);
b = b(i);
w = w(i);

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
parameters.frames = 30;
parameters.delay_frames = 30;
parameters.back_rgb = [1 1 1]*0.5;
parameters.x_start = 120;  parameters.x_end = 620;
parameters.y_start = 50;   parameters.y_end = 400;

rgb = [1 0 1; 1 1 1; 0 1 0; -1 -1 -1]*0.5;
for i=1:size(rgb,1)
    stimulus = make_stimulus(parameters, 'rgb', rgb(i,:), def_params);
    display_stimulus(stimulus);
end


%% Map based Pulse
fprintf('\n\n<strong> Cone-Isolating Pulse </strong>\n');
clear parameters stimulus;

parameters.class = 'PL';
parameters.back_rgb = [1 1 1]*0.5;
parameters.map_file_name = [my_path, '/Maps/map_data034/map_data034.txt'];

s_params = read_s_file([my_path, '/Maps/s03']);

for i=2:size(s_params,2)
    trial_params = combine_parameters(parameters, s_params{1}, s_params{i});
    stimulus = make_stimulus(trial_params, def_params);
    display_stimulus(stimulus)
end


%% Moving bar

fprintf('\n\n<strong> Moving bar. </strong>\n');
clear parameters stimulus;

parameters.class = 'MB';
parameters.back_rgb = [1 1 1]*0.5;
parameters.rgb = -[1, 1, 1]*0.48;
parameters.bar_width = 30;
parameters.orientation = 45;
parameters.delta = 2;  % pixels per frame
parameters.x_start = 100;  parameters.x_end = 300;
parameters.y_start = 100;   parameters.y_end = 350;
parameters.frames = 200;
parameters.delay_frames = 30;
parameters.orientation = 90;

stimulus = make_stimulus(parameters, def_params);

% show 10 times
for i=1:10
    display_stimulus(stimulus);
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
parameters.rgb = [1 1 1]*0.48;
parameters.back_rgb = [1 1 1]*0.5;
parameters.frames = 5*60; % presentation of each grating, frames
parameters.x_start = 1;  parameters.x_end = 640;
parameters.y_start = 1;   parameters.y_end = 480;
parameters.direction = 45;

temporal_period = [30 60];
spatial_period = [60 90 120];

% see second option example in "S File read"
cnt = 1;
for i = 1:length(temporal_period)
    for j= 1:length(spatial_period)
        stimulus{cnt} = make_stimulus(parameters,'temporal_period', temporal_period(i),...
            'spatial_period', spatial_period(i), def_params);
        display_stimulus(stimulus{cnt});
        cnt = cnt+1;
    end
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
parameters.frames = 5*30; % presentation of each grating, frames
parameters.x_start = 1;  parameters.x_end = 640;
parameters.y_start = 1;   parameters.y_end = 480;
parameters.direction = 45;

variable_parameters = randomize_parameters('temporal_period', [30, 60], 'spatial_period', [60, 90, 120], 'nrepeats',3);
path2file = write_s_file(parameters, variable_parameters);
s_params = read_s_file(path2file);

% see second option example in "S File read"
for i=2:size(s_params,2)
    trial_params = combine_parameters(s_params{1}, s_params{i});
    stimulus{i-1} = make_stimulus(trial_params, def_params);
    display_stimulus(stimulus{i-1});
end

%%%%%%%%%% clean up %%%%%%%%%% 
for i=1:length(stimulus)
    for j=1:stimulus{i}.temporal_period
        mglDeleteTexture(stimulus{i}.texture{j});
    end
end


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
parameters.back_rgb = [1 1 1]*0.5;
parameters.rgb = [1 1 1]*0.48;
parameters.seed = 11111;
parameters.binary = 1;
parameters.probability = 1;
parameters.jitter = 0;
parameters.delay_frames = 0;

%%%%%%%%%%%%%% OLED %%%%%%%%%%%%%% 
parameters.x_start = 1;  parameters.x_end = 800;
parameters.y_start = 1;   parameters.y_end = 600;

%%%%%%%%%%%%%% CRT %%%%%%%%%%%%%% 
% parameters.x_start = 1;  parameters.x_end = 640;
% parameters.y_start = 1;   parameters.y_end = 480;

parameters.independent = 1;
parameters.interval = 1;
parameters.stixel_width = 20;
parameters.frames = 60*5;

parameters.stixel_height = parameters.stixel_width;
parameters.field_width = (parameters.x_end-parameters.x_start+1)/parameters.stixel_width;  
parameters.field_height = (parameters.y_end-parameters.y_start+1)/parameters.stixel_height;

% For Voronoi, set stixel_height and stixel_width to 1 and pass a map path
% parameters.map_file_name = [my_path, '/Maps/2011-12-13-2_f04_vorcones/map-0000.txt'];

% mask example
% mask = zeros(80,40);
% mask(1:10, 1:10) = 255;
% parameters.mask = mask;

stimulus = make_stimulus(parameters, def_params);
time_stamps = display_stimulus(stimulus, 'wait_trigger', 1);


%% Raw Movie

fprintf('\n\n<strong> Raw Movie </strong>\n');
clear parameters stimulus;

parameters.class = 'RM';
parameters.back_rgb = [1 1 1]*0.5;
parameters.x_start = 1; % x_end and y_end wil depend on movie size (and stixel size)!
parameters.y_start = 1;
parameters.stixel_width = 1;   parameters.stixel_height = 1;
% parameters.frames = 20*60;  % duration of each repetition, default whole movie
parameters.start_frame = 1; % >0
parameters.interval = 1;
parameters.flip = 1;  % 1 = normal; 2 = vertical flip; 3 = horizontal flip; 4 = vertical + horizontal flip
parameters.reverse = 0;   % 1 = backward (reverse), 0 = forward
% parameters.movie_name = [my_path, '/Movies/test_5_A.rawMovie'];
%parameters.movie_name = '/Volumes/Data/Stimuli/movies/eye-movement/current_movies/NSbrownian/NSbrownian_3000_movies/NSbrownian_3000_A_025.rawMovie';
 parameters.movie_name = '/Users/vision/Desktop/1stix_test.rawMovie';

stimulus = make_stimulus(parameters, def_params); 
save_parameters(stimulus, path2save, 'data000');
time_stamps = display_stimulus(stimulus, 'trigger_interval', 100, 'wait_key',1, 'erase', 1);

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

stimulus = make_stimulus(parameters, def_params); 
save_parameters(stimulus, path2save, 'data000');
time_stamps = display_stimulus(stimulus, 'trigger_interval', 100, 'wait_key',1, 'erase', 1);

%% photographic mapping

fprintf('\n\n<strong> Random Noise : Binary. </strong>\n');
clear parameters stimulus;

parameters.class = 'RN';
parameters.rgb = [1 1 1]*0.48;
parameters.independent = 0;
parameters.seed = 11111;
parameters.frames = 1;
parameters.x_start = 101;  parameters.x_end = 420;
parameters.y_start = 101;   parameters.y_end = 420;
% large 
parameters.stixel_width = 32;   parameters.stixel_height = 32;
parameters.field_width = 10;  parameters.field_height = 10;

% medium 
parameters.stixel_width = 10;   parameters.stixel_height = 10;
parameters.field_width = 32;  parameters.field_height = 32;

% small 
parameters.stixel_width = 1;   parameters.stixel_height = 1;
parameters.field_width = 320;  parameters.field_height = 320;

stimulus = make_stimulus(parameters, def_params);
display_stimulus(stimulus, 'erase',0);


%%
Stop_Photons

make_normal_table(8)


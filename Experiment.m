%% Initialization

my_path = '/Users/vision/Desktop/Photons';

addpath(genpath(my_path))
cd(my_path)

path2save = [my_path, '/saved_stim/nora_test'];
screen_number = 2;
def_params = initialize_display('CRT', screen_number);

% real refresh rate
mglTestRefresh(2)

% set gamma
scale = [0.9998    1.0072    1.0019];
power = [2.7807    2.8437    2.7429];
offset = [-0.0017   -0.0043   -0.0002];
set_gamma_from_fit_params(scale, power, offset);

%% Gamma calibration

steps = 17;
run_gamma_flashes('linear', steps, [1 1 1]); % FIRST PARAMETER will reset gamma to linear!

% linear measurements (INSERT HERE)
r = [0.1 0.19 1.39 8.09 25.7 57.4 105 170 252 343 453 583 739 930 1140 1400 1670];
g = [0.1 0.12 0.7 5.88 24.7 63.8 127 216 330 457 614 802 1030 1300 1610 1970 2350];
b = [0.1 0.4 3.86 19.1 53.5 112 195 304 438 583 767 990 1250 1570 1940 2360 2790];
w = [0.1 .052 5.93 33.0 103 225 404 647 950 1290 1730 2300 2980 3830 4740 5770 6850];

[~,i] = sort(get_sequence(steps));
r = r(i);
g = g(i);
b = b(i);
w = w(i);

[scale, power, offset] = fit_gamma([r',g',b']);

% control
run_gamma_flashes([scale, power, offset], steps, [0 1 0]);

% corrected measurements (INSERT HERE, then proceed below)
r = [0.1 101 212 322 429 529 627 736 834 930 1030 1140 1240 1350 1450 1560 1660];
g = [0.1 130 289 445 590 736 879 1030 1170 1300 1450 1580 1720 1870 2010 2160 2310];
b = [0.1 176 367 541 704 874 1050 1210 1400 1550 1720 1880 2080 2260 2430 2600 2780];
w = [0.1 389 813 1220 1610 2040 2480 2920 3370 3780 4220 4640 5100 5520 5950 6370 6790];

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
    save_parameters(stimulus, path2save, 'data000');
    display_stimulus(stimulus);
end


%% Cone-Isolating Pulse
fprintf('\n\n<strong> Cone-Isolating Pulse </strong>\n');
clear parameters stimulus;

parameters.class = 'PL';
parameters.back_rgb = [1 1 1]*0.5;
parameters.map_file_name = [my_path, '/Maps/map_data034/map_data034.txt'];

s_params = read_stim_lisp_output_hack([my_path, '/Maps/s36_test']); % read S file

for i=2:size(s_params,2)
    trial_params = combine_parameters(parameters, s_params{1}, s_params{i});
    stimulus{i-1} = make_stimulus(trial_params, def_params);
    save_parameters(stimulus{i-1}, path2save, 'data000');
end

time_stamps = cell(1,length(stimulus));

for i=1:length(stimulus)
    time_stamps{i} = display_stimulus(stimulus{i});
end

for i=1:length(stimulus)
    save_time_stamps(time_stamps{i}, path2save, 'data000');
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


orientation = [0 30 45];% 60 90 120 135 150 180 210 225 240 270 300 315 330];
for i = 1:length(orientation)
    stimulus{i} = make_stimulus(parameters,'orientation', orientation(i), def_params);    
    save_parameters(stimulus{i}, path2save, 'data000');
end

time_stamps = cell(1,length(stimulus));

for i=1:length(stimulus)
    time_stamps{i} = display_stimulus(stimulus{i});
end

for i=1:length(stimulus)
    save_time_stamps(time_stamps{i}, path2save, 'data000'); % as one file!
end



%% Moving Grating

fprintf('\n\n<strong> Moving Grating. </strong>\n');
clear parameters stimulus

parameters.class = 'MG';
parameters.spatial_modulation = 'sine'; % sine or square
parameters.rgb = [1 1 1]*0.48;
parameters.back_rgb = [1 1 1]*0.5;
parameters.frames = 5*120; % presentation of each grating, frames
parameters.x_start = 1;  parameters.x_end = 640;
parameters.y_start = 1;   parameters.y_end = 480;
parameters.temporal_period = 60;  % frames (how long it takes to drift one period)
parameters.spatial_period = 120; % pixels
parameters.orientation = 45;

stimulus = make_stimulus(parameters, def_params);

time_stamps = display_stimulus(stimulus, 'wait_trigger', 0);

for i=1:stimulus.temporal_period
    mglDeleteTexture(stimulus.texture{i});
end

% s_params = read_stim_lisp_output_hack([my_path, '/Maps/gratings/s03']); % read S file
% for i=2:size(s_params,2)
%     trial_params = combine_parameters(parameters, s_params{1}, s_params{i});
%     stimulus{i-1} = make_stimulus(trial_params, def_params);
%     save_parameters(stimulus{i-1}, path2save, 'data000');
% end

% 
% orientation = [0 30 45 60 90 120 135 150 180 210 225 240 270 300 315 330];
% for i = 1:length(orientation)
%     stimulus{i} = make_stimulus(parameters,'orientation', orientation(i), def_params);    
%     save_parameters(stimulus{i}, path2save, 'data000');
% end

% time_stamps = cell(1,length(stimulus));
% 
% for i=1:length(stimulus)
%     time_stamps{i} = display_stimulus(stimulus{i});
% end
% 
% for i=1:length(stimulus)
%     save_time_stamps(time_stamps{i}, path2save, 'data000'); % as one file!
% end

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

% S file: copy logic from cone pulses
orientation = [0 30 45];% 60 90 120 135 150 180 210 225 240 270 300 315 330];
for i = 1:length(orientation)
    stimulus{i} = make_stimulus(parameters,'orientation', orientation(i), def_params);    
    save_parameters(stimulus{i}, path2save, 'data000');
end

time_stamps = cell(1,length(stimulus));

for i=1:length(stimulus)
    time_stamps{i} = display_stimulus(stimulus{i});
end

for i=1:length(stimulus)
    save_time_stamps(time_stamps{i}, path2save, 'data000'); % as one file!
end



%% Random Noise

%cd(my_path, '/Utils/mex_functions/')
%mex Draw_Random_Frame_opt.c

fprintf('\n\n<strong> Random Noise </strong>\n');
clear parameters stimulus

parameters.class = 'RN';
parameters.back_rgb = [1 1 1]*0.5;
parameters.rgb = [1 1 1]*0.48;
parameters.interval = 1;
parameters.seed = 11111;
parameters.independent = 0;
parameters.binary = 1;
parameters.probability = 1;
parameters.delay_frames = 0;
% 
% parameters.x_start = 101;  parameters.x_end = 500;
% parameters.y_start = 101;   parameters.y_end = 500;
% parameters.stixel_width = 40;   parameters.stixel_height = 40;
% parameters.field_width = 10;  parameters.field_height = 10;

parameters.x_start = 1;  parameters.x_end = 640;
parameters.y_start = 81;   parameters.y_end = 400;
parameters.stixel_width = 8;   parameters.stixel_height = 8;
parameters.field_width = 80;  parameters.field_height = 40;

% parameters.x_start = 101;  parameters.x_end = 700;
% parameters.y_start = 1;   parameters.y_end = 600;
% parameters.stixel_width = 20;   parameters.stixel_height = 20;
% parameters.field_width = 30;  parameters.field_height = 30;

% parameters.x_start = 1;  parameters.x_end = 600;
% parameters.y_start = 1;   parameters.y_end = 600;
% parameters.stixel_width = 1;   parameters.stixel_height = 1;
% parameters.field_width = 600;  parameters.field_height = 600;

% parameters.map_file_name = [my_path, '/Maps/2011-12-13-2_f04_vorcones/map-0000.txt'];

parameters.frames = 120*300;%ceil(1*60*60);  % min * refresh rate (ceil it?) * 60(sec in min) - duration of each repetition!

parameters.jitter = 0;

% mask example
% mask = zeros(80,40);
% mask(1:10, 1:10) = 255;
% parameters.mask = mask;

stimulus = make_stimulus(parameters, def_params);
% save_parameters(stimulus, path2save, 'data000');
% time_stamps = cell(1,10);
% for i=1:10
time_stamps = display_stimulus(stimulus, 'wait_trigger',0);
%save('time_stamps_data002_minimized.mat', 'time_stamps');

figure
plot(diff(time_stamps))
mean(diff(time_stamps)*1000)
plot(diff(time_stamps(1:100:end)))
% this is to test timing
% figure
% for i=1:10
%     subplot(3,4,i)
%     a = diff(time_stamps{i})*1000;
%     plot(a)
%     xlabel('flush')
%     ylabel('time per flush, ms')
% end

%% Raw Movie

fprintf('\n\n<strong> Raw Movie </strong>\n');
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


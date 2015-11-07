
%% Moving bar

fprintf('\n\n<strong> Moving bar. </strong>\n');
clear parameters stimulus;

parameters.class = 'MB';
parameters.back_rgb = [1 1 1]*0.5;
parameters.rgb = -[1, 1, 1]*0.48;
parameters.bar_width = 40;
parameters.delta = 2;  % pixels per frame
parameters.x_start = 1;  parameters.x_end = 640;
parameters.y_start = 1;   parameters.y_end = 480;
parameters.frames = 280;
parameters.delay_frames = 0;
parameters.orientation = 90;

stimulus = make_stimulus(parameters, def_params);
pause(5)
for j=1:10
time_stamps = display_stimulus(stimulus);
a(j)=diff(time_stamps)/(1/119.5);
end


%% Moving Grating

fprintf('\n\n<strong> Moving Grating. </strong>\n');
clear parameters stimulus

parameters.class = 'MG';
parameters.spatial_modulation = 'sine'; % sine or square
parameters.rgb = [1 1 1]*0.48;
parameters.back_rgb = [1 1 1]*0.5;
parameters.x_start = 1;  parameters.x_end = 640;
parameters.y_start = 1;   parameters.y_end = 480;
parameters.spatial_period = 100;
parameters.direction = 225;
parameters.frames = 10.075*120; %10s on CRT, 20s on OLED
parameters.temporal_period = 30;

stimulus = make_stimulus(parameters, def_params);    
pause(5)
time_stamps = cell(3,1);
for i=1:3
time_stamps{i} = display_stimulus(stimulus, 'wait_trigger', 0);
end
figure
plot(diff(time_stamps{1})*1000, '*-')
hold on
plot(diff(time_stamps{2})*1000, '*-')
plot(diff(time_stamps{3})*1000, '*-')
figure
plot(time_stamps{3})
% 
% for j=1:stimulus.temporal_period
%         mglDeleteTexture(stimulus.texture{j});
% end


%% Counterphase Grating

fprintf('\n\n<strong> Counterphase Grating. </strong>\n');
clear parameters stimulus

parameters.class = 'CG';
parameters.spatial_modulation = 'sine'; % sine or square
parameters.temporal_modulation = 'sine'; % sine or square

parameters.rgb = [1 1 1]*0.48;
parameters.back_rgb = [1 1 1]*0.5;
parameters.x_start = 1;  parameters.x_end = 640;
parameters.y_start = 1;   parameters.y_end = 480;
parameters.spatial_phase = 0; % pixels - offset
parameters.spatial_period = 100; % pixels
parameters.orientation = 135;
parameters.temporal_period = 60;

parameters.frames = 10*120; %10s on CRT, 20s on OLED

stimulus = make_stimulus(parameters, def_params);    
pause(5)
time_stamps = cell(3,1);
for i=1:3
    time_stamps{i} = display_stimulus(stimulus, 'wait_trigger', 0);
end
figure
plot(diff(time_stamps{1})*1000, '*-')
hold on
plot(diff(time_stamps{2})*1000, '*-')
plot(diff(time_stamps{3})*1000, '*-')
figure
plot(time_stamps{3})

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
    display_stimulus(stimulus, 'wait_trigger', 1);
end


%% Cone-Isolating Pulse
fprintf('\n\n<strong> Cone-Isolating Pulse </strong>\n');
clear parameters stimulus;

parameters.class = 'PL';
parameters.back_rgb = [1 1 1]*0.5;

% UDCR type for OLED
parameters.map_file_name = [my_path, '/Maps/udcr/map-0000.txt'];
s_params = read_stim_lisp_output_hack([my_path, '/Maps/udcr/s03']);

for i=2:100
    trial_params = combine_parameters(parameters, s_params{1}, s_params{i});
    stimulus = make_stimulus(trial_params, def_params);
    display_stimulus(stimulus);
end



%% Random Noise

%cd(my_path, '/Utils/mex_functions/')
%mex Draw_Random_Frame_opt.c

fprintf('\n\n<strong> Random Noise </strong>\n');
clear parameters stimulus

parameters.class = 'RN';
parameters.back_rgb = [1 1 1]*0.5;
parameters.rgb = [1 1 1]*0.48;
parameters.seed = 11111;
parameters.independent = 0;
parameters.binary = 1;
parameters.probability = 1;
parameters.delay_frames = 0;
parameters.jitter = 0;
parameters.frames = 30*120; % = 30s on CRT, 60s on OLED

% hard: stixel 1, interval 6
parameters.x_start = 1;  parameters.x_end = 600;
parameters.y_start = 1;   parameters.y_end = 600;
parameters.stixel_width = 1;   parameters.stixel_height = 1;
parameters.field_width = 600;  parameters.field_height = 600;
parameters.interval = 6;

% easy: stixel 10, interval 1
parameters.x_start = 1;  parameters.x_end = 320;
parameters.y_start = 1;   parameters.y_end = 320;
parameters.stixel_width = 10;   parameters.stixel_height = 10;
parameters.field_width = 32;  parameters.field_height = 32;
parameters.interval = 1;

% voronoi
parameters.map_file_name = [my_path, '/Maps/2011-12-13-2_f04_vorcones/map-0000.txt'];
parameters.x_start = 1;  parameters.x_end = 600;
parameters.y_start = 1;   parameters.y_end = 600;
parameters.stixel_width = 1;   parameters.stixel_height = 1;
parameters.field_width = 600;  parameters.field_height = 600;
parameters.interval = 1;

stimulus = make_stimulus(parameters, def_params);
display_stimulus(stimulus, 'wait_trigger',1);


%% Raw Movie

fprintf('\n\n<strong> Raw Movie </strong>\n');
clear parameters stimulus;

parameters.class = 'RM';
parameters.back_rgb = [1 1 1]*0.5;
parameters.x_start = 1;
parameters.y_start = 1;
parameters.stixel_width = 1;   parameters.stixel_height = 1;
parameters.frames = 5*120; % 10s on CRT, 20s on OLED
parameters.start_frame = 1; % >0
parameters.interval = 1;
parameters.flip = 1;
parameters.reverse = 0;

% easy
parameters.movie_name = [my_path, '/Movies/test_5_A.rawMovie'];

% hard
% parameters.movie_name = '/Users/vision/Desktop/1stix_test.rawMovie';

stimulus = make_stimulus(parameters, def_params);
pause(5)
time_stamps = cell(1,2);
for i=1:2
    time_stamps{i}=display_stimulus(stimulus,'wait_trigger',0);
end
figure
plot(diff(time_stamps{1}(1:100:end))*1000)
hold on
plot(diff(time_stamps{2}(1:100:end))*1000)




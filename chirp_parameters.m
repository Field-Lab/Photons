%% chirp stimulus


%% RN
fprintf('\n\n<strong> Raw Movie </strong>\n');
clear parameters stimulus;

parameters.class = 'CH';
parameters.back_rgb = [1 1 1]*0.5;
parameters.rgb = [1 1 1]*0.48;
parameters.seed = 11111;
parameters.binary = 1;
parameters.probability = 1;
parameters.jitter = 0;
parameters.delay_frames = 0;

parameters.x_start = 0;  parameters.x_end = 639;
parameters.y_start = 0;   parameters.y_end = 479;

parameters.independent = 0;
parameters.interval = 1;
parameters.stixel_width = 1;
parameters.frames = 120*19.5; % total for all parts of chirp
parameters.freq_frames = 120*8.25;
parameters.cont_frames = 120*8.25;
paramters.pause_in_middle = 120*3;


parameters.stixel_height = parameters.stixel_width;
parameters.field_width = (parameters.x_end-parameters.x_start+1)/parameters.stixel_width;  
parameters.field_height = (parameters.y_end-parameters.y_start+1)/parameters.stixel_height;


% parameters.movie_name = [my_path, '/Movies/test_5_A.rawMovie'];
%parameters.movie_name = '/Volumes/Data/Stimuli/movies/eye-movement/current_movies/NSbrownian/NSbrownian_3000_movies/NSbrownian_3000_A_025.rawMovie';
%  parameters.movie_name = '/Users/vision/Desktop/1stix_test.rawMovie';
parameters.current_state = 0;
stimulus = make_stimulus(parameters, def_params); 
save_parameters(stimulus, path2save, 'data000');
time_stamps = display_stimulus(stimulus, 'trigger_interval', 100, 'wait_key',0, 'erase', 1);

% t = linspace(0,8.25, 120*8.25); 
% frame_values = 30+30*sin(pi*(t.^2+t/10))
% figure; plot(t, frame_values)
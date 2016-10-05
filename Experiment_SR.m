%% Initialization

%my_path = '/Users/Suva/Desktop/GitAll/GitClones_FieldLab/Photons';
my_path = '/Users/acquisition/Photons';
%my_path = '/Users/stimulus/Photons';

addpath(genpath(my_path))
cd(my_path)

screen_number = 2; % Value = 2 (primary screen small), 1 (primary screen full), 2 (secondary screen full)
def_params = initialize_display('OLED', screen_number);


% set gamma OLED Aug 2, 2016
scale = [1.1399    1.0998    1.1027];
power = [1.1741    1.2998    1.3112];
offset = [-0.1445   -0.1023   -0.1054];
set_gamma_from_fit_params(scale, power, offset);

% % set gamma OLED nov 2015
% scale = [1.1156    1.0919    1.0921];
% power = [1.1799    1.2878    1.2614];
% offset = [-0.1228   -0.0961   -0.0955];
% set_gamma_from_fit_params(scale, power, offset);


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
%parameters.back_rgb = [1 1 1]*0.25;
%parameters.rgb = [1, 1, 1]*(0.1*0.25);
parameters.x_start = 200;  parameters.x_end = 600;
parameters.y_start = 100;   parameters.y_end = 500;
parameters.frames_p_bar = 1; % 1:no need to set frames. 0: have to set frames
parameters.frames = 60*5;
parameters.delay_frames = 30;

variable_parameters = randomize_parameters('direction', [0:30:330], ...
                                           'delta', [4], ...
                                           'bar_width', [240], ...
                                           'nrepeats',10,...
                                           'back_rgb',{[1 1 1].*0.25},...
                                           'rgb',{0.1*0.25.*[1 1 1], 0.3*0.25.*[1 1 1], 0.6*0.25.*[1 1 1],...
                                           1*0.25.*[1 1 1], 3*0.25.*[1 1 1]});
                                       
                                     
path2file = write_s_file(parameters, variable_parameters);
s_params = read_s_file(path2file);

% see second option example in "S File read"
for i=2:size(s_params,2)
    trial_params = combine_parameters(s_params{1}, s_params{i});
    stimulus{i-1} = make_stimulus(trial_params, def_params);
end

for i=1:length(stimulus)
    if i == 1
        display_stimulus(stimulus{i}, 'wait_trigger', 1, 'wait_key', 0); % set wait trigger to 1 during experiment
    else
        display_stimulus(stimulus{i}, 'wait_trigger', 0, 'wait_key', 0);
    end
end


%% Moving Grating simple sequence

fprintf('\n\n<strong> Moving Grating. </strong>\n');
clear parameters stimulus

parameters.class = 'MG';
parameters.spatial_modulation = 'square'; % sine or square
%parameters.back_rgb = [1 1 1]*0.5;
%parameters.rgb = [1 1 1]*(0.48);
parameters.x_start = 100;  parameters.x_end = 700;
parameters.y_start = 0;   parameters.y_end = 600;
parameters.frames = 8*60; % presentation of each grating, frames
parameters.delay_frames = 0;

variable_parameters = randomize_parameters('direction', [0:30:330], ...
                                           'temporal_period', [30 120],...
                                           'spatial_period', [100],... 
                                           'back_rgb',{[1 1 1].*0.5},...
                                           'rgb',{[1 1 1].*0.48},...
                                           'nrepeats',6);
                                       

path2file = write_s_file(parameters, variable_parameters);
s_params = read_s_file(path2file);

% see second option example in "S File read"
for i=2:size(s_params,2)  
    trial_params = combine_parameters(parameters, s_params{1}, s_params{i});
    stimulus{i-1} = make_stimulus(trial_params, def_params);
end


for i=1:length(stimulus)
    display_stimulus(stimulus{i},'wait_trigger', 0, 'wait_key',0); % set wait_trigger to 1 for actual experiment
end





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
parameters.delay_frames = 0;  % onset latency in # of frames 

%%%%%%%%%%%%% OLED %%%%%%%%%%%%%% 
parameters.x_start = 101;  parameters.x_end = 700;
parameters.y_start = 1;   parameters.y_end = 600;

% %%%%%%%%%%%%%% CRT %%%%%%%%%%%%%% 
% parameters.x_start = 0;  parameters.x_end = 639;
% parameters.y_start = 80;   parameters.y_end = 399;

parameters.independent = 0; % (0: rgb values vary together, 1: rgb values vary independently)
parameters.interval = 1;  % # of frames before the image changes 
parameters.stixel_width = 10;
parameters.frames = 30*3600; % 3600 sec 

parameters.stixel_height = parameters.stixel_width;
parameters.field_width = (parameters.x_end-parameters.x_start+1)/parameters.stixel_width;
parameters.field_height = (parameters.y_end-parameters.y_start+1)/parameters.stixel_height;

% For Voronoi, set stixel_height and stixel_width to 1 and pass a map path
%parameters.map_file_name = [my_path, '/Maps/2011-12-13-2_f04_vorcones/map-0000.txt'];

stimulus = make_stimulus(parameters, def_params);

time_stamps = display_stimulus(stimulus, 'wait_trigger', 0);  % set 'wait _trigger' to 1 during experiment


%% Moving flashing square 
% presents a square (size=stix_width) within x,y bounds (eg. x_start) that
% flashes ON within bounds for a duration (frames) and OFF for the same
% duration.  It will move by stixel_shift (ie. if shift<width there will be
% overlap in squares).

fprintf('\n\n<strong> Moving flashing squares </strong>\n');
clear parameters stimulus;

parameters.class = 'MFS';  
parameters.rgb = [1, 1, 1]*.5;
parameters.back_rgb = [0, 0, 0];
parameters.frames = 60;                       % "frames" is the number of frame refreshes to wait for each half-cycle (i.e. the pulse is on for the number of frames set here
                                            % and then off for the same number of frames. This completes one repetition of the pulse.

parameters.x_start = 250;  parameters.x_end = 550;  % These fields set the region of stimulation with full square overlap coverage
parameters.y_start = 150;   parameters.y_end = 450; % actual presentation area will be end-start+(stix_w-stix_shift)
parameters.stixel_width = 30;         % size of each stixel in pixels 
parameters.stixel_shift = 10; % number of pixels each stixel can be shifted by (below stixel width causes stixel overlap)

parameters.num_reps = 1; % "num_reps" gives the number of times the pulse on-off cycle is completed.
parameters.repeats = 4; % repeats of the whole stimulus block
parameters.wait_trigger = 0; % set this to 1 during experiment
parameters.wait_key = 0;
parameters.sub_region = 1; % if 1: subdivide the stimulus field into 4 regions, show 4 spatially correlated flash squares 
parameters.random_seq = 1 ; % 1= random sequence, 0 = repeated sequence in order
                         
stimulus = make_stimulus(parameters, def_params);
display_stimulus(stimulus);
clear stimulus;


%% Random Noise for imaging

fprintf('\n\n<strong> Random Noise </strong>\n');
clear parameters stimulus

parameters.class = 'RN';
parameters.back_rgb = [1 1 1]*0.5;
parameters.rgb = [1 1 1]*0.48;
parameters.seed = 11111;
parameters.binary = 1;
parameters.probability = 1;
parameters.jitter = 0;
parameters.delay_frames = 0;  % onset latency in # of frames 

%%%%%%%%%%%%% OLED %%%%%%%%%%%%%% 
parameters.x_start = 100;  parameters.x_end = 700;
parameters.y_start = 0;   parameters.y_end = 600;

% %%%%%%%%%%%%%% CRT %%%%%%%%%%%%%% 
% parameters.x_start = 0;  parameters.x_end = 639;
% parameters.y_start = 80;   parameters.y_end = 399;

parameters.independent = 0; % (0: rgb values vary together, 1: rgb values vary independently)
parameters.interval = 1000;  % # of frames before the image changes 
parameters.stixel_width = 30;
parameters.frames = 60*3600; % 3600 sec 

parameters.stixel_height = parameters.stixel_width;
parameters.field_width = (parameters.x_end-parameters.x_start+1)/parameters.stixel_width;
parameters.field_height = (parameters.y_end-parameters.y_start+1)/parameters.stixel_height;

% For Voronoi, set stixel_height and stixel_width to 1 and pass a map path
%parameters.map_file_name = [my_path, '/Maps/2011-12-13-2_f04_vorcones/map-0000.txt'];

stimulus = make_stimulus(parameters, def_params);

time_stamps = display_stimulus(stimulus, 'wait_trigger', 0);  % set 'wait _trigger' to 1 during experiment



%%
Stop_Photons

make_normal_table(8)
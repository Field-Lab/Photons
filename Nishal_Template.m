
%% data035
% grey

dataname = 'data035';

% gray
mglClearScreen(0.5);
mglFlush
% gray
mglClearScreen(0.5);
mglFlush


% Raw Movie

fprintf('\n\n<strong> Raw Movie </strong>\n');
clear parameters stimulus time_stamps;
% For repeats
%%{
repeats = 30;
parameters.frames = 1200;
interleaved = 0;
%}


% Movie Name
parameters.movie_name = '/Users/vision/Desktop/1.rawMovie';

% Don't need to change
parameters.class = 'RM';
parameters.back_rgb = [1 1 1]*0.5;
parameters.x_start = 1; % x_end and y_end wil depend on movie size (and stixel size)!
parameters.y_start = 81;
parameters.stixel_width = 8;   
parameters.stixel_height = 8;
parameters.start_frame = 1; % >0
parameters.interval = 4;
parameters.flip = 1;  % 1 = normal; 2 = vertical flip; 3 = h         orizontal flip; 4 = vertical + horizontal flip
parameters.reverse = 0;   % 1 = backward (reverse), 0 = forward

stimulus = make_stimulus(parameters, def_params); 
count = 1;
for i = 1:repeats
    time_stamps{count} = display_stimulus(stimulus, 'trigger_interval', 100, 'wait_trigger',1, 'erase', 1);
    count = count + 1;
     
end


%% Raw Movie with mask (also works with white noise)

fprintf('\n\n<strong> Raw Movie with mask </strong>\n');
clear parameters stimulus;

parameters.class = 'RM';
parameters.back_rgb = [1 1 1]*0.5;
parameters.x_start = 1; % x_end and y_end wil depend on movie size (and stixel size)!
parameters.y_start = 81;
parameters.stixel_width = 8;   parameters.stixel_height = 8;
% parameters.frames = ceil(0.05*60*60);  % min * refresh rate (ceil it?) * 60(sec in min) - duration of each repetition!
parameters.frames = 1200;
parameters.start_frame = 1; % >0
parameters.interval = 4;
parameters.flip = 1;  % 1 = normal; 2 = vertical flip; 3 = horizontal flip; 4 = vertical + horizontal flip
parameters.reverse = 0;   % 1 = backward (reverse), 0 = forward
% parameters.movie_name = [my_path, '/Movies/test_5_A.rawMovie'];
parameters.movie_name = '/Users/vision/Desktop/1.rawMovie';

% mask
mask = zeros(80,40);

mask(40:60, 20:30) = 255;
parameters.mask = mask;

num_repeats = 1;
stimulus = make_stimulus(parameters, def_params);

for i = 1:num_repeats
    time_stamps{i} = display_stimulus(stimulus);
end

save_parameters(stimulus, path2save, 'data000');

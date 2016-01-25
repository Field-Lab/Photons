
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
repeats = 1;
parameters.frames = 1200;
interleaved = 0;
%}


% Movie Name
% parameters.movie_name = '/Volumes/Data/Stimuli/movies/eye-movement/current_movies/NSbrownian/NSbrownian_3000_movies/NSbrownian_3000_A_025.rawMovie';
% parameters.movie_name = '/Volumes/Lab/Users/Nora/new_stim_nora/mask_NSEM/testmask_3_stix2/comp_LES/movie_3_comp_LES.rawMovie';
parameters.movie_name = '/Users/vision/Desktop/2015-12-18-2/2.rawMovie';
% Don't need to change
parameters.class = 'RM';
parameters.back_rgb = [1 1 1]*0.5;
parameters.x_start = 1; % x_end and y_end wil depend on movie size (and stixel size)!
parameters.y_start = 81;
parameters.stixel_width = 8;   
parameters.stixel_height = 8;
parameters.start_frame = 1; % >0
parameters.interval = 40;
parameters.flip = 1;  % 1 = normal; 2 = vertical flip; 3 = h         orizontal flip; 4 = vertical + horizontal flip
parameters.reverse = 0;   % 1 = backward (reverse), 0 = forward

stimulus = make_stimulus(parameters, def_params); 
count = 1;
for i = 1:repeats
    time_stamps{count} = display_stimulus(stimulus, 'trigger_interval', 100, 'wait_trigger',0, 'erase', 1);
    count = count + 1;
     
end


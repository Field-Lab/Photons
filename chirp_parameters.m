%% chirp stimulus

%% Rectangular Flashing Pulses
fprintf('\n\n<strong> Rectangular Pulses: any sequence. </strong>\n');
clear parameters stimulus;

parameters.class = 'FP';
parameters.frames = 1*120;
parameters.delay_frames = 120;
parameters.tail_frames = 120;

parameters.back_rgb = [1 1 1]*0.5;
parameters.x_start = 0;  parameters.x_end = 639;
parameters.y_start = 0;   parameters.y_end = 479;

num_repeats = 2;
rgb = [1 1 1]*0.48;
% start with a black screen
mglClearScreen(0);
mglFlush
mglClearScreen(0);
mglFlush
for z = 1:num_repeats
    for i=1:size(rgb,1)
        stimulus = make_stimulus(parameters, 'rgb', rgb(i,:), def_params);
        display_stimulus(stimulus, 'erase_to_black', 1);
    end
end

%% increase in contrast
clear parameters stimulus;

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
stimulus = make_stimulus(parameters, def_params); 
save_parameters(stimulus, path2save, 'data000');

%start with gray screen
mglClearScreen(0.5);
mglFlush
mglClearScreen(0.5);
mglFlush

for i = 1:1
time_stamps{i} = display_stimulus(stimulus, 'trigger_interval', 100, 'wait_key',0, 'erase_to_gray', 1);
end


%% increase in frequency
t_freq = linspace(0,parameters.frames/120, parameters.frames);
frame_values = 30+30*sin(pi*(3*t_freq.^2+t_freq/10));
range = floor(parameters.rgb(1)*2*256);
frame_values = frame_values*(range)./(max(frame_values)+min(frame_values));
parameters.intensity_values = frame_values;

stimulus = make_stimulus(parameters, def_params); 
save_parameters(stimulus, path2save, 'data000');

for i = 1:1
time_stamps{i} = display_stimulus(stimulus, 'trigger_interval', 100, 'wait_key',0, 'erase_to_gray', 1);
end

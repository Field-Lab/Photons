%% chirp stimulus


%% RN
pause(5)
clear parameters stimulus;

parameters.class = 'CH';
parameters.back_rgb = [1 1 1]*0.5;
parameters.rgb = [1 1 1]*0.48;


parameters.x_start = 0;  parameters.x_end = 639;
parameters.y_start = 0;   parameters.y_end = 479;
parameters.jitter = 0;
parameters.interval = 1;

rate = 120;
parameters.step_start =rate*2;
parameters.step_length =rate*3;
parameters.pre_freq_low =rate*3;
parameters.pre_freq_mid  =rate*2;
parameters.freq_frames= rate*8.25;
parameters.mid_freq_cont  =rate*2;
parameters.cont_frames= rate*8.25;
parameters.post_cont_mid =rate*2;
parameters.post_cont_low=rate*2;

parameters.frames = parameters.step_start + parameters.step_length + parameters.pre_freq_low +parameters.pre_freq_mid+parameters.freq_frames+parameters.mid_freq_cont+parameters.cont_frames+parameters.post_cont_mid+parameters.post_cont_low; % total for all parts of chirp
parameters.stixel_width = 20;
parameters.stixel_height = parameters.stixel_width;

parameters.field_width = (parameters.x_end-parameters.x_start+1)/parameters.stixel_width;  
parameters.field_height = (parameters.y_end-parameters.y_start+1)/parameters.stixel_height;


parameters.current_state = 0;
stimulus = make_stimulus(parameters, def_params); 
save_parameters(stimulus, path2save, 'data000');

for i = 1:2
time_stamps{i} = display_stimulus(stimulus, 'trigger_interval', 100, 'wait_key',0, 'erase', 1);
end

%% Moving bar

fprintf('\n\n<strong> Moving bar. </strong>\n');
clear parameters stimulus;

parameters.class = 'MB';
parameters.back_rgb = [1 1 1]*0.5;
parameters.rgb = -[1, 1, 1]*0.48;
parameters.bar_width = [60];
parameters.direction = [0 45 90 135 180 225 270 315];
parameters.delta = [6 15 30 60 120 180 240 360];  % pixels per frame
parameters.x_start = 1;  parameters.x_end = 800;
parameters.y_start = 1;   parameters.y_end = 600;
parameters.frames = 60;
parameters.delay_frames = 0;
parameters.n_for_each_stim = 4;

[stim, seq] = rand_stim(parameters);
save_s_file(parameters, stim, seq);

        
for i = 1:length(stim)
    stimulus{i} = make_stimulus(stim(i), def_params);    
end

time_stamps = cell(1,length(stimulus));

for i=1:length(stimulus)
    time_stamps{i} = display_stimulus(stimulus{i}, 'wait_trigger', 0);
end

% for i=1:length(stimulus)
%     save_time_stamps(time_stamps{i}, path2save, 'data000'); % as one file!
% end


%% Moving Grating

fprintf('\n\n<strong> Moving Grating. </strong>\n');
clear parameters stimulus

parameters.class = 'MG';
parameters.spatial_modulation = 'square'; % sine or square
parameters.rgb = [1 1 1]*0.48;
parameters.back_rgb = [1 1 1]*0.5;
parameters.frames = 60; % presentation of each grating, frames
parameters.x_start = 0;  parameters.x_end = 800;
parameters.y_start = 0;   parameters.y_end = 600;
parameters.temporal_period = [6 15 30 60 120 180 240 360];  % frames (how long it takes to drift one period)
parameters.spatial_period = [60]; % pixels
parameters.direction = [0 45 90 135 180 225 270 315];
parameters.n_for_each_stim = 4;

[stim, seq] = rand_stim(parameters);
save_s_file(parameters, stim, seq);

for i = 1:length(stim)
    stimulus{i} = make_stimulus(stim(i), def_params);
end

for i = 1:length(stim)
    time_stamps = display_stimulus(stimulus{i}, 'wait_trigger', 0);
end

% for i=1:length(stimulus)
%     save_time_stamps(time_stamps{i}, path2save, 'data000'); % as one file!
% end

%% Counterphase Grating

fprintf('\n\n<strong> Counterphase Grating. </strong>\n');
clear parameters stimulus

parameters.class = 'CG';
parameters.spatial_modulation = 'square'; % sine or square
parameters.temporal_modulation = 'sine'; % sine or square

parameters.rgb = [1 1 0]*0.2;
parameters.back_rgb = [1 1 1]*0.4;
parameters.frames = 60; % presentation of each grating, frames
parameters.x_start = 0;  parameters.x_end = 800;
parameters.y_start = 0;   parameters.y_end = 600;
parameters.spatial_phase = [0 20]; % pixels - offset
parameters.temporal_period = [6 30 120 240];  % frames (how long it takes to return to initial phase)
parameters.spatial_period = [60]; % pixels
parameters.orientation = [0 45 90 135 180 225 270 315];
parameters.n_for_each_stim = 4;

[stim, seq] = rand_stim(parameters);
save_s_file(parameters, stim, seq);

for i = 1:length(stim)
    stimulus{i} = make_stimulus(stim(i), def_params);
end

time_stamps = cell(1,length(stimulus));

for i=1:length(stimulus)
    time_stamps{i} = display_stimulus(stimulus{i});
end

% for i=1:length(stimulus)
%     save_time_stamps(time_stamps{i}, path2save, 'data000'); % as one file!
% end
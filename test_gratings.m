
fprintf('\n\n<strong> Moving Grating. </strong>\n');
clear parameters stimulus

parameters.class = 'MG';
parameters.spatial_modulation = 'sine'; % sine or square
parameters.rgb = [1 1 1]*0.48;
parameters.back_rgb = [1 1 1]*0.5;
parameters.frames = 5*120; % presentation of each grating, frames
parameters.x_start = 1;  parameters.x_end = 640;
parameters.y_start = 1;   parameters.y_end = 480;
tic
parameters.temporal_period = 15;  % frames (how long it takes to drift one period)
parameters.spatial_period = 64; % pixels
parameters.orientation = 300;
stimulus{1} = make_stimulus(parameters, def_params);

parameters.temporal_period = 30;  % frames (how long it takes to drift one period)
parameters.spatial_period = 64; % pixels
parameters.orientation = 0;
stimulus{2} = make_stimulus(parameters, def_params);

parameters.temporal_period = 15;  % frames (how long it takes to drift one period)
parameters.spatial_period = 16; % pixels
parameters.orientation = 300;
stimulus{3} = make_stimulus(parameters, def_params);

parameters.temporal_period = 30;  % frames (how long it takes to drift one period)
parameters.spatial_period = 16; % pixels
parameters.orientation = 180;
stimulus{4} = make_stimulus(parameters, def_params);

parameters.temporal_period = 60;  % frames (how long it takes to drift one period)
parameters.spatial_period = 32; % pixels
parameters.orientation = 300;
stimulus{5} = make_stimulus(parameters, def_params);

parameters.temporal_period = 15;  % frames (how long it takes to drift one period)
parameters.spatial_period = 32; % pixels
parameters.orientation = 210;
stimulus{6} = make_stimulus(parameters, def_params);

parameters.temporal_period = 30;  % frames (how long it takes to drift one period)
parameters.spatial_period = 16; % pixels
parameters.orientation = 330;
stimulus{7} = make_stimulus(parameters, def_params);

parameters.temporal_period = 15;  % frames (how long it takes to drift one period)
parameters.spatial_period = 16; % pixels
parameters.orientation = 90;
stimulus{8} = make_stimulus(parameters, def_params);

parameters.temporal_period = 15;  % frames (how long it takes to drift one period)
parameters.spatial_period = 32; % pixels
parameters.orientation = 30;
stimulus{9} = make_stimulus(parameters, def_params);

parameters.temporal_period = 30;  % frames (how long it takes to drift one period)
parameters.spatial_period = 64; % pixels
parameters.orientation = 240;
stimulus{10} = make_stimulus(parameters, def_params);

parameters.temporal_period = 30;  % frames (how long it takes to drift one period)
parameters.spatial_period = 16; % pixels
parameters.orientation = 120;
stimulus{11} = make_stimulus(parameters, def_params);

parameters.temporal_period = 30;  % frames (how long it takes to drift one period)
parameters.spatial_period = 64; % pixels
parameters.orientation = 30;
stimulus{12} = make_stimulus(parameters, def_params);


parameters.temporal_period = 30;  % frames (how long it takes to drift one period)
parameters.spatial_period = 16; % pixels
parameters.orientation = 270;
stimulus{13} = make_stimulus(parameters, def_params);

parameters.temporal_period = 15;  % frames (how long it takes to drift one period)
parameters.spatial_period = 16; % pixels
parameters.orientation = 180;
stimulus{14} = make_stimulus(parameters, def_params);

parameters.temporal_period = 60;  % frames (how long it takes to drift one period)
parameters.spatial_period = 16; % pixels
parameters.orientation = 0;
stimulus{15} = make_stimulus(parameters, def_params);

parameters.temporal_period = 15;  % frames (how long it takes to drift one period)
parameters.spatial_period = 16; % pixels
parameters.orientation = 210;
stimulus{16} = make_stimulus(parameters, def_params);

parameters.temporal_period = 15;  % frames (how long it takes to drift one period)
parameters.spatial_period = 64; % pixels
parameters.orientation = 60;
stimulus{17} = make_stimulus(parameters, def_params);

parameters.temporal_period = 60;  % frames (how long it takes to drift one period)
parameters.spatial_period = 32; % pixels
parameters.orientation = 240;
stimulus{18} = make_stimulus(parameters, def_params);

parameters.temporal_period = 15;  % frames (how long it takes to drift one period)
parameters.spatial_period = 32; % pixels
parameters.orientation = 300;
stimulus{19} = make_stimulus(parameters, def_params);

parameters.temporal_period = 30;  % frames (how long it takes to drift one period)
parameters.spatial_period = 64; % pixels
parameters.orientation = 60;
stimulus{20} = make_stimulus(parameters, def_params);
toc

parameters.temporal_period = 15;  % frames (how long it takes to drift one period)
parameters.spatial_period = 32; % pixels
parameters.orientation = 330;
stimulus{21} = make_stimulus(parameters, def_params);

save('test_stim.mat', 'stimulus');

load('test_stim.mat', 'stimulus');

time_stamps = cell(21,1);
for i=1:21
    time_stamps{i} = display_stimulus(stimulus{i}, 'wait_trigger', 1);
end

a=[];
for i=1:21
    a = [a; diff(time_stamps{i})];
end
figure
plot(a*1000)

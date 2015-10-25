function make_s_file(parameters, nrepeats)

allfields = fieldnames(parameters);
varparams = [];
for i=1:length(allfields)
    if ~strcmp(allfields{i}, 'class') && ~strcmp(allfields{i}, 'spatial_modulation')
        if length(unique(getfield(parameters, allfields{i})))>1 
            varparams = [varparams i];
        end
    end
end

% params combos


% make s-fiel old style?
trial_params = parameters
parameters.class = 'MG';
parameters.spatial_modulation = 'sine'; % sine or square
parameters.rgb = [1 1 1]*0.48;
parameters.back_rgb = [1 1 1]*0.5;
parameters.x_start = 1;  parameters.x_end = 640;
parameters.y_start = 1;   parameters.y_end = 480;

parameters.frames = 5*120; % presentation of each grating, frames

% individual parameters lists
parameters.temporal_period = [15 30 60 120];
parameters.spatial_period = [16 32 64];
parameters.orientation = 0:30:330;
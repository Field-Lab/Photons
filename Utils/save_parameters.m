function save_parameters(stimulus, data_name)

dir_save = ['/Users/alexth/test4/RSM/saved_stim/', date, '/',data_name,'/parameters/'];
if ~isdir(dir_save)
    mkdir(dir_save);
end

tmp = dir([dir_save, 'stimulus_*.mat']);
stim_number = int2str(length(tmp)+1);

parameters = stimulus.parameters;

save([dir_save, 'stimulus_', stim_number], 'parameters');

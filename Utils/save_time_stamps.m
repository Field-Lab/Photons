function save_time_stamps(time_stamps, data_name)

dir_save = ['/Users/alexth/test4/RSM/saved_stim/', date, '/',data_name,'/time_stamps/'];
if ~isdir(dir_save)
    mkdir(dir_save);
end

tmp = dir([dir_save, 'stimulus_*.mat']);
stim_number = int2str(length(tmp)+1);

tmp1 = dir([['/Users/alexth/test4/RSM/saved_stim/', date, '/',data_name,'/parameters/'], 'stimulus_*.mat']);

if length(tmp) ~= length(tmp1)
    errordlg({'Stim and time file numbers do NOT match!'},'!! Warning !!')    
end

save([dir_save, 'stimulus_', stim_number], 'time_stamps');

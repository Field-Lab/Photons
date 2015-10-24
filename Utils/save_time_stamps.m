function save_time_stamps(time_stamps, path2save, data_name)

dir_save = fullfile(path2save, data_name,'time_stamps');
if ~isdir(dir_save)
    mkdir(dir_save);
end

tmp = dir([dir_save, '/stimulus_*.mat']);
stim_number = int2str(length(tmp)+1);

% tmp1 = dir([fullfile(path2save, data_name,'parameters', filesep), 'stimulus_*.mat']);
% 
% if length(tmp) ~= length(tmp1)
%     errordlg({'Parameters and time stamps file numbers do NOT match!'},'!! Warning !!')    
% end

save([dir_save, '/stimulus_', stim_number], 'time_stamps');

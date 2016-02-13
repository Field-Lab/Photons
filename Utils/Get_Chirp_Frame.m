%Get_Frame
function img_frame = Get_Chirp_Frame(current_state, width, height, intensity_values)

    img_frame = uint8(intensity_values(current_state)*ones(4,width,height));

    img_frame(4,:,:) = 255;
    
%     
%     
% if current_state <= step_start
%     img_frame = uint8(5*ones(4,width,height));
%     img_frame(4,:,:) = 255;
%     
% elseif current_state > step_start && current_state <=step_start+step_length
%     img_frame = uint8(250*ones(4,width,height));
%     img_frame(4,:,:) = 255;
%     
% elseif current_state > step_start+step_length && current_state <=step_start+step_length+pre_freq_low
%     img_frame = uint8(5*ones(4,width,height));
%     img_frame(4,:,:) = 255;
%     
%     
% elseif current_state > step_start+step_length+pre_freq_low && current_state<=step_start+step_length+pre_freq_low+pre_freq_mid
%     img_frame = uint8(127*ones(4,width,height));
%     img_frame(4,:,:) = 255;
%     
% elseif current_state > step_start+step_length+pre_freq_low+pre_freq_mid && current_state <=step_start+step_length+pre_freq_low+pre_freq_mid + freq_frames
%     img_frame = uint8(freq_values(current_state-(step_start+step_length+pre_freq_low+pre_freq_mid))*ones(4,width,height));
%     img_frame(4,:,:) = 255;
%     
% elseif current_state > step_start+step_length+pre_freq_low+pre_freq_mid +freq_frames && current_state <=step_start+step_length+pre_freq_low+pre_freq_mid + freq_frames + mid_freq_cont
%     img_frame = uint8(127*ones(4,width,height));
%     img_frame(4,:,:) = 255;
%     
% elseif  current_state >step_start+step_length+pre_freq_low+pre_freq_mid + freq_frames + mid_freq_cont &&  current_state <=step_start+step_length+pre_freq_low+pre_freq_mid + freq_frames + mid_freq_cont+cont_frames
%     img_frame = uint8(cont_values(current_state-(step_start+step_length+pre_freq_low+pre_freq_mid + freq_frames + mid_freq_cont))*ones(4,width,height));
%     img_frame(4,:,:) = 255;
%     
% elseif current_state > step_start+step_length+pre_freq_low+pre_freq_mid + freq_frames + mid_freq_cont+cont_frames && current_state <=step_start+step_length+pre_freq_low+pre_freq_mid + freq_frames + mid_freq_cont+cont_frames+post_cont_mid
%     img_frame = uint8(127*ones(4,width,height));
%     img_frame(4,:,:) = 255;
%     
% elseif current_state > step_start+step_length+pre_freq_low+pre_freq_mid + freq_frames + mid_freq_cont+cont_frames+post_cont_mid && current_state <=step_start+step_length+pre_freq_low+pre_freq_mid + freq_frames + mid_freq_cont+cont_frames+post_cont_mid + post_cont_low
%     img_frame = uint8(5*ones(4,width,height));
%     img_frame(4,:,:) = 255;
%     
% else
%     img_frame = uint8(127*ones(4,width,height));
%     img_frame(4,:,:) = 255;
%     
% end
% 
% 
% 
% 
% 

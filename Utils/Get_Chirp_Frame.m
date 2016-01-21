%Get_Frame
function img_frame = Get_Chirp_Frame(current_state, freq_values, width, height, cont_values, freq_frames, cont_frames, pause_frames)

if current_state <=freq_frames
    img_frame = uint8(freq_values(current_state)*ones(4,width,height));
elseif current_state>freq_frames && current_state <=(freq_frames+pause_frames+1)
    img_frame = uint8(127*ones(4,width,height));
elseif current_state >(freq_frames+pause_frames+1) && current_state <=(freq_frames+pause_frames+1+cont_frames)
    img_frame = uint8(cont_values(current_state-(freq_frames+pause_frames+1))*ones(4,width,height));
else
    img_frame = uint8(127*ones(4,width,height));
end






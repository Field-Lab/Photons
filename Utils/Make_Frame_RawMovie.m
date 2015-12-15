function img_frame = Make_Frame_RawMovie(stimulus, screen_frame)

movie_frame = floor(screen_frame/stimulus.refresh);
if stimulus.reverse == 1 % reverse mode
    current_frame = stimulus.start_frame - movie_frame;
else % forward mode
    current_frame = stimulus.start_frame + movie_frame;
end
current_frame = current_frame - 1;
[~, img_frame] = Read_RawMov_Frame(stimulus.movie_filename, stimulus.orig_width, stimulus.orig_height, stimulus.header_size, current_frame, stimulus.flip);

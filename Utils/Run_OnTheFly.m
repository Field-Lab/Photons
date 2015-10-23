% Run_OnTheFly: Used for presenting textures that can be updated every
% frame refresh. This routine is the core routine for presenting random
% noise and raw movies
%
%        $Id: NAME VER_ID DATA-TIME vinje $
%      usage: NAME(Args)
%         by: william vinje
%       date: Date
%  copyright: (c) Date William Vinje, Eduardo Jose Chichilnisky (GPL see RSM/COPYING)
%    purpose: Role
%      usage: Examples
%
%

function time_stamps = Run_OnTheFly(stimulus, trigger_interval)

jitterX = 0;jitterY=0;
frametex = mglCreateTexture(zeros(1,1)); % dummy

countdown = 1;
time_stamps = zeros(stimulus.frames,1);

t0 = mglGetSecs;
RSM_Pause(stimulus.delay_frames);

for i=1:stimulus.frames

    if countdown == 1
        
        mglDeleteTexture(frametex);
        countdown = stimulus.refresh;  % reset to the number of frames specified by "interval"
 
        eval(stimulus.make_frame_script);  % get new WN pattern
        
        if stimulus.jitter.flag % jitter stuff
            tmp = ones(size(img_frame,1), size(img_frame,2)+2,size(img_frame,3)+2);
            
            tmp(1,[1:2 end-1:end],:) =stimulus.back_rgb(1);
            tmp(1,:,[1:2 end-1:end]) =stimulus.back_rgb(1);
            tmp(2,[1:2 end-1:end],:) =stimulus.back_rgb(2);
            tmp(2,:,[1:2 end-1:end]) =stimulus.back_rgb(2);
            tmp(3,[1:2 end-1:end],:) =stimulus.back_rgb(3);
            tmp(3,:,[1:2 end-1:end]) =stimulus.back_rgb(3);
            tmp = uint8(tmp*256);
            tmp(:,3:end-2,3:end-2) = img_frame(:,2:end-1,2:end-1);
            img_frame = tmp;
            
            jitterX = mod(double(random_uint16(stimulus.jitter.state)), stimulus.stixel_width) - stimulus.stixel_width/2;
            jitterY = mod(double(random_uint16(stimulus.jitter.state)), stimulus.stixel_height) - stimulus.stixel_height/2;
        end
        
        frametex = mglCreateTexture( img_frame, [], 0, {'GL_TEXTURE_MAG_FILTER','GL_NEAREST'} );  % create new texture

    else
        countdown = countdown - 1;    % it wasn't time to get a new frame, so instead we just decrement the count down
    end

    mglBltTexture(frametex, [stimulus.x_start+jitterX, stimulus.y_start+jitterY, stimulus.span_width, stimulus.span_height], -1, -1); % put it into buffer
    mglFlush
    
    % Test whether it is time to output another pulse to the daq
    if mod(i-1, trigger_interval)==0
        Pulse_DigOut_Channel;
    end
    
    % collect timestamp info
    time_stamps(i) = mglGetSecs(t0);
    
    % following is inherited from Bill
    % Occasionally flush the DIO buffer. Why? To make sure the DIO buffer
    % doesn't overflow.
    % It is uncertain how much this is really needed.
    if mod(i, 10000)==0
        mglDigIO('digin');
    end
    
end

mglDeleteTexture(frametex); % last frame
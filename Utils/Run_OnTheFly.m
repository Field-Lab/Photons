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

frametex = mglCreateTexture( zeros(1,1));

countdown = 1;
time_stamps = zeros(stimulus.frames,1);
t0 = mglGetSecs;
RSM_Pause(stimulus.delay_frames-1);
Pulse_DigOut_Channel;
mglFlush

for i=1:stimulus.frames
    
    if countdown == 1
        
        mglDeleteTexture(frametex);
        countdown = stimulus.refresh;  % reset to the number of frames specified by "interval"
        eval(stimulus.make_frame_script);

        frametex = mglCreateTexture( img_frame, [], 0, {'GL_TEXTURE_MAG_FILTER','GL_NEAREST'} );
        
    else
        countdown = countdown - 1;    % it wasn't time to get a new frame, so instead we just decrement the count down
    end

    mglBltTexture(frametex, [stimulus.x_start, stimulus.y_start, stimulus.span_width, stimulus.span_height], -1, -1);
    mglFlush
    
    % collect timestamp info
    time_stamps(i) = mglGetSecs(t0);
    
    % Occasionally flush the DIO buffer. Why? To make sure the DIO buffer
    % doesn't overflow.
    % It is uncertain how much this is really needed.
    if mod(i, 10000)==0
        mglDigIO('digin');
    end
    
    
    % Test whether it is time to output another pulse to the daq
    if mod(i-1, trigger_interval)==0
        Pulse_DigOut_Channel;
    end
end

mglDeleteTexture(frametex);
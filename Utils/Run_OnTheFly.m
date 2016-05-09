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
mglFlush
mglFlush

% time_stamps(1) = mglGetSecs(t0);
% Pulse_DigOut_Channel

for i=1:stimulus.frames
    
    if countdown == 1
        mglDeleteTexture(frametex);
        countdown = stimulus.refresh;  % reset to the number of frames specified by "interval"
        
        eval(stimulus.make_frame_script);  % get new WN pattern
        if stimulus.jitter.flag % jitter stuff
            
            
            tmp = ones(size(img_frame,1), size(img_frame,2)+2,size(img_frame,3)+2);
            
            % only drop 1 stixel on the border, not two as in older vision
            tmp(1,[1 end],:) =stimulus.back_rgb(1);
            tmp(1,:,[1 end]) =stimulus.back_rgb(1);
            tmp(2,[1 end],:) =stimulus.back_rgb(2);
            tmp(2,:,[1 end]) =stimulus.back_rgb(2);
            tmp(3,[1 end],:) =stimulus.back_rgb(3);
            tmp(3,:,[1 end]) =stimulus.back_rgb(3);
            tmp = uint8(tmp*256);
            tmp(:,2:end-1,2:end-1) = img_frame;
            img_frame = tmp;
            
            % upsample for windowing
            % expand to pixel resolution;
            
            scale = [stimulus.stixel_width stimulus.stixel_height]; % The resolution scale factors: [rows columns]
            oldSize = [size(img_frame,2) size(img_frame,3)]; % Get the size of your image
            newSize = max(floor(scale.*oldSize(1:2)),1);  % Compute the new image size
            
            % Compute an upsampled set of indices:
            
            rowIndex = min(round(((1:newSize(1))-0.5)./scale(1)+0.5),oldSize(1));
            colIndex = min(round(((1:newSize(2))-0.5)./scale(2)+0.5),oldSize(2));
            % Index old image to get new image:
            outputImage = img_frame(:,rowIndex,colIndex);
            img_frame = outputImage;
            
            
            jitterX = mod(double(random_uint16(stimulus.jitter.state)), stimulus.stixel_width) - stimulus.stixel_width/2;
            jitterY = mod(double(random_uint16(stimulus.jitter.state)), stimulus.stixel_height) - stimulus.stixel_height/2;
            
            % Window so that jittering edges aren't visible
            stimulus.mask.mask = 255*ones(size(outputImage,2), size(outputImage,3));
            
            stimulus.mask.mask(1:(2*stimulus.stixel_width - jitterX), :) = 0; %top
            stimulus.mask.mask(size(outputImage,2) - (2*stimulus.stixel_width+jitterX) +1:end,:) = 0; %bottom
            
            stimulus.mask.mask(:,1:(2*stimulus.stixel_width-jitterY)) = 0;
            stimulus.mask.mask(:, size(outputImage,3) - (2*stimulus.stixel_width +jitterY)+1:end) = 0;
            
            img_frame(4,:,:) = stimulus.mask.mask;
            
        end
        
        % The behavior of using a mask with jitter is untested...
        if stimulus.mask.flag; img_frame(4,:,:)=stimulus.mask.mask; end % put the mask into the alpha channel
        
        frametex = mglCreateTexture( img_frame, [], 0, {'GL_TEXTURE_MAG_FILTER','GL_NEAREST'} );  % create new texture
    else
        countdown = countdown - 1;    % it wasn't time to get a new frame, so instead we just decrement the count down
    end
    
    mglBltTexture(frametex, [stimulus.x_start+jitterX, stimulus.y_start+jitterY, stimulus.span_width, stimulus.span_height], -1, -1); % put it into buffer
    mglFlush
    
    
    % collect timestamp info
    time_stamps(i) = mglGetSecs(t0);
    
    % Test whether it is time to output another pulse to the daq
    if mod(i-1, trigger_interval)==0
        Pulse_DigOut_Channel;
    end
    
    
    % following is inherited from Bill
    % Occasionally flush the DIO buffer. Why? To make sure the DIO buffer
    % doesn't overflow.
    % It is uncertain how much this is really needed.
    if mod(i, 10000)==0
        mglDigIO('digin');
    end
    
end
RSM_Pause(stimulus.tail_frames);
mglFlush
mglFlush

mglDeleteTexture(frametex); % last frame
classdef	Moving_Grating < handle
    
    properties
        
        class
        parameters

        rgb
        back_rgb
        
        % size
        x_start
        y_start
        x_span
        y_span
        
        delta 
        base
        
        base_rgb
        base_back_rgb

        temporal_period
        spatial_period
        spatial_modulation
        
        delay_frames
        frames
        texture
        
    end % properties block
    
    properties(Constant)
        run_script = 'Run_Moving_Grating(stimulus);'
    end
    
    methods
        
        % Constructor method
        function stimulus = Moving_Grating(def_params,parameters)
            
            p = inputParser;
            addParameter(p,'class', 'MG'); 
            addParameter(p,'back_rgb', def_params.back_rgb);
            addParameter(p,'x_start', def_params.x_start);
            addParameter(p,'x_end', def_params.x_end);
            addParameter(p,'y_start', def_params.y_start);
            addParameter(p,'y_end', def_params.y_end);             
            addParameter(p,'spatial_modulation', 'sine'); % def sine
            addParameter(p,'delay_frames', def_params.delay_frames);  
            
            addParameter(p,'temporal_period', []); % forced
            addParameter(p,'spatial_period', []); % forced
            addParameter(p,'orientation', []); % forced
            addParameter(p,'frames', []); % forced
            addParameter(p,'rgb', []); % forced
                       
            parse(p,parameters{:});
            parameters = p.Results;
            
            empty_params = structfun(@(x) isempty(x),parameters);
            tmp = fieldnames(parameters);
            for i = find(empty_params)'
                fprintf('Specify %s\n', tmp{i});
            end
            if ~isempty(find(empty_params, 1))
                stimulus.class = 'f';
                return
            end
                     
            stimulus.parameters = parameters;                     
            stimulus.class = parameters.class;
            
            stimulus.rgb = parameters.rgb;
            stimulus.back_rgb = parameters.back_rgb;

            stimulus.x_start = parameters.x_start;
            stimulus.y_start = parameters.y_start;
            stimulus.x_span = abs(parameters.x_end - parameters.x_start)+1;
            stimulus.y_span = abs(parameters.y_end - parameters.y_start)+1;
            
            stimulus.temporal_period = parameters.temporal_period;
            stimulus.spatial_period = parameters.spatial_period;
            stimulus.frames = parameters.frames;
            stimulus.delay_frames = parameters.delay_frames;
            
            %%%%%% calculate the wave %%%%%%
            
            angle = mod(parameters.orientation+90, 360);
%             sf = 2*pi/parameters.spatial_period;  %cycles/pixel
     

            [xMesh,yMesh] = meshgrid(0:(parameters.y_end-parameters.y_start),0:(parameters.x_end-parameters.x_start));
            
            base = (sind(angle)*xMesh + cosd(angle)*yMesh) * (2*pi/parameters.spatial_period);
            
           
            stimulus.delta = 2*pi/parameters.temporal_period;
            
            for i = 1:parameters.temporal_period
                myGrating = sin(base + (i-1)*stimulus.delta);
                if strcmp(stimulus.spatial_modulation,'square')
                    myGrating = sign(myGrating);
                end
                myGrating = repmat(myGrating,1,1,4);
                for j=1:3
                    myGrating(:,:,j) = myGrating(:,:,j)*stimulus.rgb(j)+stimulus.back_rgb(j);
                end
                myGrating(:,:,4) = 1;
                myGrating = uint8(255*myGrating);
                myGrating = shiftdim(myGrating,2);
                stimulus.texture{i} = mglCreateTexture(myGrating);
            end
            
%             stimulus.base = zeros(480,640,3);
%             stimulus.base_rgb = stimulus.base;
%             stimulus.base_back_rgb = stimulus.base;
%             for j=1:3
%                 stimulus.base(:,:,j) = tmp;
%                 stimulus.base_rgb(:,:,j) = stimulus.rgb(j);
%                 stimulus.base_back_rgb(:,:,j) =  stimulus.back_rgb(j);
%             end
            
%                             myGrating = sin(stimulus.base + icur*stimulus.delta);
%                 myGrating = myGrating.*stimulus.base_rgb + stimulus.base_back_rgb;
%                 if strcmp(stimulus.spatial_modulation,'square')
%                     myGrating = sign(myGrating);
%                 end
%                 myGrating = repmat(myGrating,1,1,4);
%                 for j=1:3
%                     myGrating(:,:,j) = myGrating(:,:,j)*stimulus.rgb(j)+stimulus.back_rgb(j);
%                 end
%                 myGrating(:,:,4) = 1;
%                 myGrating = uint8(255*myGrating);
%                 myGrating = shiftdim(myGrating,2);
%                 tex1dsquare = mglCreateTexture(myGrating);
                        
        end		% constructor
        
        
        function time_stamps = Run_Moving_Grating(stimulus)
            
            cnt = 2;
            time_stamps = zeros(floor(stimulus.frames/stimulus.temporal_period)+1,1);
%             if params.wait_trigger
%                 %     fprintf('WAITING FOR TRIGGER\n');
%                 trigger_time = Scan_4_Trigger(params.trigger_sample_rate); % trigger time stamp not used now, maybe we don't need it
%             elseif params.wait_key % wait for key press event
%                 %     fprintf('WAITING FOR KEY\n');
%                 pause;
%             end
            t0 = mglGetSecs;
            RSM_Pause(stimulus.delay_frames);
%             Pulse_DigOut_Channel; % because we want the trigger one frame before the stimulus starts
%             mglClearScreen; % if we want one delay frame
%             mglFlush
            
            
            for i=1:stimulus.frames
                icur = mod(i-1,stimulus.temporal_period)+1;
                if i==1
                    Pulse_DigOut_Channel;
                    time_stamps(1) = mglGetSecs(t0);
                    mglClearScreen
                    mglFlush
                end
                mglBltTexture( stimulus.texture{icur}, [stimulus.x_start stimulus.y_start stimulus.x_span stimulus.y_span], -1, -1);
                mglFlush
                if icur == stimulus.temporal_period % one frame before the end of temporal period
                    Pulse_DigOut_Channel; 
                    time_stamps(cnt) = mglGetSecs(t0);
                    cnt = cnt+1;
                end
            end
%             time_stamps(cnt) = mglGetSecs(t0);
            
%             for i=1:stimulus.temporal_period+1
%                 mglDeleteTexture(stimulus.texture{i});
%             end
%             clear tex1dsquare
            
        end
        
    end	% methods block
end % Grating Class
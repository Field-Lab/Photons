classdef	Moving_Grating < handle
    
    properties
        
        class
        parameters
        
        % size
        x_start
        y_start
        x_span
        y_span
        
        temporal_period        
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
            addParameter(p,'direction', []); % forced
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
            

            stimulus.x_start = parameters.x_start;
            stimulus.y_start = parameters.y_start;
            stimulus.x_span = abs(parameters.x_end - parameters.x_start)+1;
            stimulus.y_span = abs(parameters.y_end - parameters.y_start)+1;
            
            stimulus.temporal_period = parameters.temporal_period;
            stimulus.frames = parameters.frames;
            stimulus.delay_frames = parameters.delay_frames;
            
            %%%%%% calculate the wave %%%%%%
            
            angle = mod(parameters.direction+90, 360);
%             sf = 2*pi/parameters.spatial_period;  %cycles/pixel

            [xMesh,yMesh] = meshgrid(0:(parameters.y_end-parameters.y_start),0:(parameters.x_end-parameters.x_start));
            
            base = (sind(angle)*xMesh + cosd(angle)*yMesh) * (2*pi/parameters.spatial_period);

            delta = 2*pi/parameters.temporal_period;
            
            for i = 1:parameters.temporal_period
                myGrating = sin(base + (i-1)*delta);
                if strcmp(parameters.spatial_modulation,'square')
                    myGrating = sign(myGrating);
                end
                myGrating = repmat(myGrating,1,1,4);
                for j=1:3
                    myGrating(:,:,j) = myGrating(:,:,j)*parameters.rgb(j)+parameters.back_rgb(j);
                end
                myGrating(:,:,4) = 1;
                myGrating = uint8(255*myGrating);
                myGrating = shiftdim(myGrating,2);
                stimulus.texture{i} = mglCreateTexture(myGrating);
            end
                        
        end		% constructor
        
        
        function time_stamps = Run_Moving_Grating(stimulus)
            
            cnt = 1;
            time_stamps = zeros(floor(stimulus.frames/stimulus.temporal_period),1);
            t0 = mglGetSecs;
            RSM_Pause(stimulus.delay_frames);
            mglClearScreen;
            mglFlush
            mglFlush 
                        
            for i=1:stimulus.frames
                icur = mod(i-1,stimulus.temporal_period)+1;
                mglBltTexture( stimulus.texture{icur}, [stimulus.x_start stimulus.y_start stimulus.x_span stimulus.y_span], -1, -1);
                mglFlush
                if icur==1
                    time_stamps(cnt) = mglGetSecs(t0);
                    Pulse_DigOut_Channel; 
                    cnt = cnt+1;
                end
            end            
        end
        
    end	% methods block
end % Grating Class
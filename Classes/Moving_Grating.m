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
        x_delta
        y_delta

        temporal_period
        spatial_period
        
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
            addParameter(p,'spatial_phase', 0); % def 0            
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
            
            angle = mod(parameters.orientation, 180);
            sf = 2*pi/parameters.spatial_period;  %cycles/pixel
            a=cosd(angle)*sf;
            b=sind(angle)*sf;
            phase = parameters.spatial_phase;
            
            x = [parameters.x_start-2*parameters.spatial_period, parameters.x_end+2*parameters.spatial_period];
            y = [parameters.y_start-2*parameters.spatial_period, parameters.y_end+2*parameters.spatial_period];
            x = max(x,y);
            y = x;
            [xMesh,yMesh] = meshgrid(x(1):x(2),y(1):y(2));
            switch parameters.spatial_modulation
                case 'square'
                    myGrating = sign(sin(a*xMesh + b*yMesh - phase));
                case 'sine'
                    myGrating = sin(a*xMesh + b*yMesh - phase);
            end            
            
            if sign(sind((parameters.orientation-45)*2))>0 % horizontal direction
                stimulus.x_delta = -(parameters.spatial_period/parameters.temporal_period)/sind(parameters.orientation);
                stimulus.y_delta = 0;
            else % vertical direction
                stimulus.x_delta = 0;
                stimulus.y_delta = -(parameters.spatial_period/parameters.temporal_period)/cosd(parameters.orientation);
            end
            myGrating = repmat(myGrating,1,1,4);
            for j=1:3
                myGrating(:,:,j) = myGrating(:,:,j)*2*stimulus.rgb(j)+2*stimulus.back_rgb(j)-1;
            end
            myGrating = (myGrating+1)/2;
            myGrating(:,:,4) = 1;
            myGrating = uint8(255*myGrating);
            myGrating = shiftdim(myGrating,2);
            stimulus.texture = myGrating; 
            
        end		% constructor
        
        
        function time_stamps = Run_Moving_Grating(stimulus)
            
            tex1dsquare = cell(stimulus.temporal_period,1);
            for i=0:stimulus.temporal_period
                icur = mod(i,stimulus.temporal_period);
                xlimits = round(stimulus.x_delta*icur : stimulus.x_span + stimulus.x_delta*icur -1)+stimulus.spatial_period*2;
                ylimits = round(stimulus.y_delta*icur : stimulus.y_span + stimulus.y_delta*icur -1)+stimulus.spatial_period*2;
                tmp = stimulus.texture(:,xlimits,ylimits);
                tex1dsquare{i+1} = mglCreateTexture(tmp);
            end
            
            
            cnt = 2;
            time_stamps = zeros(floor(stimulus.frames/stimulus.temporal_period)+1,1);
            t0 = mglGetSecs;
            RSM_Pause(stimulus.delay_frames-1);
            Pulse_DigOut_Channel; % because we want the trigger one frame before the stimulus starts
            time_stamps(1) = mglGetSecs(t0);
            mglFlush % last delay frame
            
            for i=1:stimulus.frames
                icur = mod(i-1,stimulus.temporal_period)+1;
                mglBltTexture( tex1dsquare{icur}, [stimulus.x_start stimulus.y_start stimulus.x_span stimulus.y_span], -1, -1);
                mglFlush
                if icur == stimulus.temporal_period-1 % one frame before the end of temporal period
                    Pulse_DigOut_Channel; 
                    time_stamps(cnt) = mglGetSecs(t0);
                    cnt = cnt+1;
                end
            end
            time_stamps(cnt) = mglGetSecs(t0);
            
            for i=1:stimulus.temporal_period+1
                mglDeleteTexture(tex1dsquare{i});
            end
            clear tex1dsquare
            
        end
        
    end	% methods block
end % Grating Class
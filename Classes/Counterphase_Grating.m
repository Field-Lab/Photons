classdef	Counterphase_Grating < handle
    
    properties

        class
        parameters
        
        back_rgb
        
        % size
        x_start
        y_start
        x_span
        y_span
                
        temporal_period
        
        delay_frames
        frames        
        texture
        lut
        
    end % properties block
    
    properties(Constant)
        run_script = 'Run_Counterphase_Grating(stimulus);'
    end
    
    methods
        
        % Constructor method
        function stimulus = Counterphase_Grating(def_params,parameters)
            
            p = inputParser;
            addParameter(p,'class', 'CG'); 
            addParameter(p,'back_rgb', def_params.back_rgb);
            addParameter(p,'x_start', def_params.x_start);
            addParameter(p,'x_end', def_params.x_end);
            addParameter(p,'y_start', def_params.y_start);
            addParameter(p,'y_end', def_params.y_end);
            addParameter(p,'spatial_phase', 0); % def 0
            addParameter(p,'spatial_modulation', 'sine'); % def sine
            addParameter(p,'temporal_modulation', 'sine'); % def sine
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
            
            stimulus.back_rgb = parameters.back_rgb;

            stimulus.x_start = parameters.x_start;
            stimulus.y_start = parameters.y_start;
            stimulus.x_span = abs(parameters.x_end - parameters.x_start)+1;
            stimulus.y_span = abs(parameters.y_end - parameters.y_start)+1;
            
            stimulus.temporal_period = parameters.temporal_period;
            stimulus.frames = parameters.frames;
            stimulus.delay_frames = parameters.delay_frames;
            
            %%%%%% calculate the wave %%%%%%
            
            
            angle = mod(parameters.orientation+90, 360);
            sf = 2*pi/parameters.spatial_period;  %cycles/pixel
            
            phase = parameters.spatial_phase;
            a=sind(angle)*sf; % change per pixel
            b=cosd(angle)*sf;
            
            y = [0, (parameters.x_end-parameters.x_start)];
            x = [0, (parameters.y_end-parameters.y_start)];


            [xMesh,yMesh] = meshgrid(x(1):x(2),y(1):y(2));
            switch parameters.spatial_modulation
                case 'square'
                    myGrating = sign(sin(a*xMesh + b*yMesh + sf*phase));
                case 'sine'
                     myGrating = sin(a*xMesh + b*yMesh + sf*phase);
            end
           
       
            switch parameters.temporal_modulation
                case 'sine'
                    x = 0:360/parameters.temporal_period:360;
                    parameters.contrast = sind(x(1:end-1));
                case'square'
                    parameters.contrast = [zeros(1,parameters.temporal_period/2)+1 zeros(1,parameters.temporal_period/2)-1];
            end
            myGrating = repmat(myGrating,1,1,4);
            myGrating(:,:,4) = 1;
            myGrating = shiftdim(myGrating,2);
            myGrating = (myGrating+1)/2;
            myGrating = uint8(255*myGrating);
            stimulus.texture = myGrating;
            
            % construct lut
            stimulus.lut = repmat(-1:2/255:1,3,1,stimulus.temporal_period);
            contr = permute(parameters.contrast, [3,1,2] );
            contr = repmat(contr,3,256,1);
            rgbs = repmat(parameters.rgb', 1, 256, stimulus.temporal_period);
            back_rgbs = repmat(stimulus.back_rgb', 1, 256, stimulus.temporal_period);
            
            stimulus.lut = stimulus.lut .* contr .* rgbs + back_rgbs;            
            stimulus.lut = uint8(255*(stimulus.lut));

        end		% constructor
        
        
        function time_stamps = Run_Counterphase_Grating(stimulus)
            
            tex1dsquare = cell(stimulus.temporal_period+1,1); 
            newGrating = uint8(zeros(size(stimulus.texture))+255);
            for i=0:stimulus.temporal_period-1
                newGrating(1,:,:) = intlut(stimulus.texture(1,:,:), stimulus.lut(1,:,i+1));
                newGrating(2,:,:) = intlut(stimulus.texture(2,:,:), stimulus.lut(2,:,i+1));
                newGrating(3,:,:) = intlut(stimulus.texture(3,:,:), stimulus.lut(3,:,i+1));                
                tex1dsquare{i+1} = mglCreateTexture(newGrating);
            end

            cnt = 2; 
            time_stamps = zeros(floor(stimulus.frames/stimulus.temporal_period)+1,1);
            t0 = mglGetSecs;
            RSM_Pause(stimulus.delay_frames-1);
            Pulse_DigOut_Channel; % because we want the trigger one frame before the stimulus starts
            time_stamps(1) = mglGetSecs(t0);
            mglClearScreen;
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
            
            for i=1:stimulus.temporal_period
                mglDeleteTexture(tex1dsquare{i});
            end
            clear tex1dsquare stimulus.texture
            
        end
        
    end	% methods block
end % Grating Class
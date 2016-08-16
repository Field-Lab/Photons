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
            
            display = GetDisplayParams(def_params);

            mglSetParam('visualAngleSquarePixels',0,1);
            mglVisualAngleCoordinates(display.distance,[display.physical_width, display.physical_height]);
         
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
            angle = mod(parameters.direction, 360);
            stimulus.parameters.direction = angle;

            if (mod(angle, 180) >= 45) && (mod(angle, 180) < 135)
                moving_params = [0, 1/sind(angle), 1, 1];
            else
                moving_params = [1/cosd(angle), 0, 1, 1];
            end
            
            sf_pix = stimulus.parameters.spatial_period;
            sf_dva = sf2dva(sf_pix, display); %cycle/deg

            delta = 360/parameters.temporal_period;
            
            texWidth = 2 * sf_dva + display.physical_width + display.physical_height;
            numCycles = ceil(sf_dva*texWidth/2)*2;
            texWidth = numCycles/sf_dva;
            texHeight = texWidth;
            
            % convert to pixels
            texWidthPixels = round(mglGetParam('xDeviceToPixels')*texWidth);
            texHeightPixels = round(mglGetParam('yDeviceToPixels')*texHeight);

            rgb = stimulus.parameters.rgb;
            back_rgb = stimulus.parameters.back_rgb;
            
            switch stimulus.parameters.spatial_modulation
                case 'square'
                    grating = 255*sign(sin(0:numCycles*2*pi/(texWidthPixels-1):numCycles*2*pi));
                case 'sine'
                    grating = 255*sin(0:numCycles*2*pi/(texWidthPixels-1):numCycles*2*pi);
            end
            colored_grating = cat(3, ( (grating .* rgb(1)) + round(255 .* back_rgb(1)) ), ( (grating .* rgb(2)) + round(255 .* back_rgb(2)) ), ( (grating .* rgb(3)) + round(255 .* back_rgb(3)) ));
            tex1d = mglCreateTexture(colored_grating);
            
            tex_params = struct();
            tex_params.tex1d = tex1d;
            tex_params.texWidth = texWidth;
            tex_params.texHeight = texHeight;
            tex_params.moving_params = moving_params;
            tex_params.delta = delta;
            tex_params.sf_dva = sf_dva;
            stimulus.texture = tex_params;
            stimulus.parameters.display = display;
            
        end		% constructor
            
            
        function time_stamps = Run_Moving_Grating(stimulus)
            
            cnt = 1;
            time_stamps = zeros(floor(stimulus.frames/stimulus.temporal_period),1);
            t0 = mglGetSecs;
            RSM_Pause(stimulus.delay_frames);
            mglClearScreen;
            mglFlush
            mglFlush 
                     
            phi = 0;
            for i = 1:stimulus.frames
                if i == 1
                    Pulse_DigOut_Channel;
                end
                % update phase
                phi = phi + stimulus.texture.delta;

                % test for pulse
                if ( phi > 360 )
                    phi = mod(phi, 360);
                    time_stamps(cnt) = mglGetSecs(t0);
                    Pulse_DigOut_Channel;
                    cnt = cnt + 1;
                end
                
                pos = phi/360/stimulus.texture.sf_dva; % + stimulus.texture.texWidth/2;
                mglBltTexture( stimulus.texture.tex1d, [pos pos nan stimulus.texture.texHeight].*stimulus.texture.moving_params, 0, 0, stimulus.parameters.direction);
                
                xstart = stimulus.parameters.x_start;
                xend = stimulus.parameters.x_end;
                ystart = stimulus.parameters.y_start;
                yend = stimulus.parameters.y_end;
                width = stimulus.parameters.display.width;
                height = stimulus.parameters.display.height;
                
                mglScreenCoordinates
                if xstart > 0
                    mglQuad([0; 0; xstart; xstart], [0; height; height; 0], [.5; .5; .5], 0)
                end
                if ystart > 0
                    mglQuad([0; 0; width; width], [0; ystart; ystart; 0], [.5; .5; .5], 0)
                end
                if xend < width
                    mglQuad([xend; xend; width; width], [0; height; height; 0], [.5; .5; .5], 0)
                end
                if yend < height
                    mglQuad([0; 0; width; width], [yend; height; height; yend], [.5; .5; .5], 0)
                end
                mglFlush
                mglSetParam('visualAngleSquarePixels',0,1);
                mglVisualAngleCoordinates(stimulus.parameters.display.distance,[stimulus.parameters.display.physical_width stimulus.parameters.display.physical_height]);

            end            
        end
        
    end	% methods block
end % Grating Class
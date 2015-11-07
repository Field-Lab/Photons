classdef	Moving_Bar < handle
    % Moving_Bar: Presents simple hard-edged rectangle as a moving bar.
%
%        $Id: Moving_Bar VER_ID DATA-TIME vinje $
%      usage: NAME(Args)
%         by: william vinje
%       date: Date
%  copyright: (c) Date William Vinje, Eduardo Jose Chichilnisky (GPL see RSM/COPYING)

    properties
        
        class
        parameters
        
        rgb
        back_rgb
        
        x_center
        y_center
        x_span
        y_span
        x_delta
        y_delta
        x_first
        y_first
        
        delay_frames
        frames_per_bar
        frames
        
	end	
	
    properties(Constant)
            run_script = 'Run_Bar(stimulus);';
    end
	
	
	methods
		
        % Constructor method
        function stimulus = Moving_Bar(def_params, parameters)
            
            p = inputParser;
            addParameter(p,'class', 'MB');
            addParameter(p,'back_rgb', def_params.back_rgb);
            addParameter(p,'x_start', def_params.x_start);
            addParameter(p,'x_end', def_params.x_end);
            addParameter(p,'y_start', def_params.y_start);
            addParameter(p,'y_end', def_params.y_end);  
            addParameter(p,'delay_frames', def_params.delay_frames);  
            addParameter(p,'rgb', []); % forced
            addParameter(p,'bar_width', []); % forced
            addParameter(p,'delta', []); % forced
            addParameter(p,'orientation', []); % forced
            addParameter(p,'frames', []); % forced
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
            
            % colors
            stimulus.rgb = (parameters.rgb + parameters.back_rgb)';
            stimulus.back_rgb = parameters.back_rgb;  
            
            stimulus.frames = parameters.frames;
            stimulus.delay_frames = parameters.delay_frames;
                       
            %field
            stimulus.x_span = parameters.x_end-parameters.x_start;
            stimulus.y_span = parameters.y_end-parameters.y_start;
            stimulus.x_center = parameters.x_start + stimulus.x_span/2;
            stimulus.y_center = parameters.y_start + stimulus.y_span/2;
            angle = parameters.orientation;
            
            L = 3000; % Length of the bar, the idea of making this number large is to ensure that it covers the whole display.
            if angle >= 0 && angle < 90
                r0 = [parameters.x_start, parameters.y_start];
                stimulus.x_first = [-L; -L; L; L];
                stimulus.y_first = [parameters.y_start-parameters.bar_width; parameters.y_start;  parameters.y_start; parameters.y_start-parameters.bar_width];
                [stimulus.x_first, stimulus.y_first] = rotateData(stimulus.x_first, stimulus.y_first, r0(1), r0(2), angle); % then the bar will be rotated around a corner of display by a certain degree (base on moving direction)
            elseif angle >= 90 && angle < 180
                r0 = [parameters.x_start, parameters.y_end];
                stimulus.y_first = [-L; L; L; -L];
                stimulus.x_first = [parameters.x_start-parameters.bar_width; parameters.x_start-parameters.bar_width;  parameters.x_start; parameters.x_start];
                [stimulus.x_first, stimulus.y_first] = rotateData(stimulus.x_first, stimulus.y_first, r0(1), r0(2), angle-90); % then the bar will be rotated around a corner of display by a certain degree (base on moving direction)
            elseif angle >= 180 && angle < 270
                r0 = [parameters.x_end, parameters.y_end];
                stimulus.x_first = [-L; -L; L; L];
                stimulus.y_first = [parameters.y_end; parameters.y_end+parameters.bar_width;  parameters.y_end+parameters.bar_width; parameters.y_end];
                [stimulus.x_first, stimulus.y_first] = rotateData(stimulus.x_first, stimulus.y_first, r0(1), r0(2), angle-180); % then the bar will be rotated around a corner of display by a certain degree (base on moving direction)
            elseif angle >= 270 && angle < 360
                r0 = [parameters.x_end, parameters.y_start];
                stimulus.y_first = [-L; L; L; -L];
                stimulus.x_first = [parameters.x_end; parameters.x_end; parameters.x_end+parameters.bar_width; parameters.x_end+parameters.bar_width;];
                [stimulus.x_first, stimulus.y_first] = rotateData(stimulus.x_first, stimulus.y_first, r0(1), r0(2), angle-270); % then the bar will be rotated around a corner of display by a certain degree (base on moving direction)
            end
            
            stimulus.x_first = stimulus.x_first';
            stimulus.y_first = stimulus.y_first';

            % make the bar moving either vertically or horizontally
            % based on which distance is shorter
            x_dis = (abs(cotd(angle)*stimulus.y_span)+stimulus.x_span);
            y_dis = (abs(stimulus.x_span*tand(angle))+stimulus.y_span);
            if x_dis < y_dis                
                stimulus.x_delta = parameters.delta/sind(angle);
                stimulus.y_delta = 0;
                stimulus.frames_per_bar = (x_dis+ parameters.bar_width/abs(sind(angle)))/abs(stimulus.x_delta);
            else
                stimulus.y_delta = parameters.delta/cosd(angle);
                stimulus.x_delta = 0;
                stimulus.frames_per_bar = (y_dis+ parameters.bar_width/abs(cosd(angle)))/abs(stimulus.y_delta);
            end
            
        end% constructor 
		
        
        function time_stamps = Run_Bar(stimulus)
            
            % make mask
            mglStencilCreateBegin(1);
            mglFillRect(stimulus.x_center,stimulus.y_center,[stimulus.x_span stimulus.y_span]);
            mglStencilCreateEnd;
            mglClearScreen(stimulus.back_rgb);
            mglFlush();
            mglStencilSelect(1);
           
            time_stamps = zeros(2,1);            
            t0 = mglGetSecs;
            RSM_Pause(stimulus.delay_frames);
            mglClearScreen;
            mglFlush
            mglFlush            
            
            for i = 1:stimulus.frames
                    x_vertices = stimulus.x_first + stimulus.x_delta*i;
                    y_vertices = stimulus.y_first + stimulus.y_delta*i;
                    mglFillRect(stimulus.x_center,stimulus.y_center,[stimulus.x_span stimulus.y_span], stimulus.back_rgb);
                    mglQuad(round(x_vertices), round(y_vertices), stimulus.rgb, 0);
                    mglFlush
                    if i==1
                        time_stamps(1) = mglGetSecs(t0);
                        Pulse_DigOut_Channel;  
                    end
            end
            time_stamps(2) = mglGetSecs(t0);
            Pulse_DigOut_Channel;            
            
            mglStencilSelect(0);
        end
    end	
end 
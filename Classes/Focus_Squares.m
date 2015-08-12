% Focus_Squares: Presents simple quad-pattern for aid in parameters focusing
%
%        $Id: Focus_Squares VER_ID DATA-TIME vinje $
%      usage: NAME(Args)
%         by: william vinje
%       date: Date
%  copyright: (c) Date William Vinje, Eduardo Jose Chichilnisky (GPL see RSM/COPYING)
%

classdef	Focus_Squares < handle
    % NB: when using mglQuad my convention is to start in upper left as 0, 0
    % then always work in clockwise manner for sub-quads
    % within each quad or sub-quad vertices are also described in a clockwise
    % manner.
    
    properties
        
        class
        parameters
        
        back_rgb
        x_vertices
        y_vertices
        
    end	
    
    properties(Constant)
        run_script = 'Run_Focus_Squares(stimulus);';
        colors = [1, 0, 1, 0; 1, 0, 1, 0; 1, 0, 1, 0];
    end
    
    methods
        
        % Constructor method
        function stimulus = Focus_Squares(def_params, parameters)
            
            p = inputParser;
            addParameter(p,'class', 'FS');
            addParameter(p,'back_rgb', def_params.back_rgb);
            addParameter(p,'x_start', def_params.x_start);
            addParameter(p,'x_end', def_params.x_end);
            addParameter(p,'y_start', def_params.y_start);
            addParameter(p,'y_end', def_params.y_end);
                       
            parse(p,parameters{:});
            parameters = p.Results;
            
            stimulus.parameters = parameters;                     
            stimulus.class = parameters.class;
            
            stimulus.back_rgb = parameters.back_rgb;
            
            parameters.mid_width = floor((parameters.x_end - parameters.x_start)/2);
            parameters.mid_height = floor((parameters.y_end - parameters.y_start)/2);
            
            stimulus.x_vertices = [parameters.x_start, parameters.mid_width, parameters.mid_width, parameters.x_start;...
                parameters.mid_width, parameters.x_end, parameters.x_end, parameters.mid_width;...
                parameters.mid_width, parameters.x_end, parameters.x_end, parameters.mid_width;...
                parameters.x_start, parameters.mid_width, parameters.mid_width, parameters.x_start];
            
            stimulus.y_vertices = [parameters.y_start, parameters.y_start, parameters.mid_height, parameters.mid_height;...
                parameters.y_start, parameters.y_start, parameters.mid_height, parameters.mid_height;...
                parameters.mid_height, parameters.mid_height, parameters.y_end, parameters.y_end;...
                parameters.mid_height, parameters.mid_height, parameters.y_end, parameters.y_end];
            
        end		% constructor
        
        
        function time_stamps = Run_Focus_Squares(stimulus)

            mglScreenCoordinates
            mglQuad(stimulus.x_vertices, stimulus.y_vertices, stimulus.colors, 0);  % we have to make sure anti-aliasing is off
            mglFlush
            
            fprintf('\n');
            disp('Hit any key to clear screen\n');
            pause
            time_stamps = [];
            
        end % presentation of focus squares
 
    end % methods block
end % Focus Square class
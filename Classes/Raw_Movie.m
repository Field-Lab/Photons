classdef	Raw_Movie < handle
% Raw_Movie: Play a movie stored in raw movie format.
%
%        $Id: Raw_Movie VER_ID DATA-TIME vinje $
%      usage: NAME(Args)
%         by: william vinje
%       date: Date
%  copyright: (c) Date William Vinje, Eduardo Jose Chichilnisky (GPL see RSM/COPYING)
%
	properties
        
        class
        parameters
        
        back_rgb
        
        % size
        x_start
        y_start
        orig_height
        orig_width
        span_height
        span_width
        
        % file path and name, header size
        movie_filename
        header_size
        
        % frames setup
        delay_frames
        start_frame        
        frames
        
        % flip and reverse flags
        reverse
        flip
        
        jitter
        
        % interval
        refresh              
 
    end			% properties block
    
    properties(Constant)
        run_script = 'Run_OnTheFly(stimulus, trigger_interval);';
        make_frame_script = '[img_frame] = Make_Frame_RawMovie(stimulus,i-1);';
    end
	
	methods
		
        % Constructor method
        function stimulus = Raw_Movie(def_params, parameters)
            
            p = inputParser;
            addParameter(p,'class','RM');
            addParameter(p,'back_rgb', def_params.back_rgb);
            addParameter(p,'x_start', def_params.x_start);
            addParameter(p,'x_end', def_params.x_end);
            addParameter(p,'y_start', def_params.y_start);
            addParameter(p,'y_end', def_params.y_end);
            addParameter(p,'delay_frames', def_params.delay_frames);              
            addParameter(p,'stixel_width', 1); % def 1
            addParameter(p,'stixel_height', 1); % def 1
            addParameter(p,'frames', []); % def [] - show all
            addParameter(p,'start_frame', 1); % def 1                
            addParameter(p,'flip', 1); % def no flip
            addParameter(p,'reverse', 0); % def no reverse
            addParameter(p,'interval', 1); % def 1
            
            addParameter(p,'movie_name', []); % forced 
            parse(p,parameters{:});
            parameters = p.Results;
            
            if isempty(parameters.movie_name)            
                fprintf('Specify movie name!\n');
                stimulus.class = 'f';
                return
            end
                     
            stimulus.parameters = parameters;                     
            stimulus.class = parameters.class;
            
            stimulus.back_rgb = parameters.back_rgb;

            % size
            stimulus.x_start = parameters.x_start;
            stimulus.y_start = parameters.y_start;

            % file path and name setup
            stimulus.movie_filename = parameters.movie_name;
            
            % read movie header and extract dimensions and duration (frames)
            fid=fopen(stimulus.movie_filename,'r');
            temp = fscanf(fid, '%s', 1);% scan the file for a string
            if ~isequal( temp, 'header-size' )% check that string is 'header-size'
                fprintf('\t FATAL ERROR in raw movie read: no header-size.');
                keyboard
            else
                stimulus.header_size = str2num( fscanf(fid, '%s', 1) );  % now scan and extract header size info
            end
            
            total_movie_frames = [];
            while isempty(findprop(stimulus,'orig_height')) || isempty(findprop(stimulus,'orig_width')) || isempty(total_movie_frames)
                t=fscanf(fid,'%s',1);               
                switch t
                    case 'height'
                        stimulus.orig_height=str2num(fscanf(fid, '%s', 1));
                    case 'width'
                        stimulus.orig_width=str2num(fscanf(fid, '%s', 1));  
                    case {'frames', 'frames-generated'}                
                        total_movie_frames = str2num(fscanf(fid, '%s', 1));     % we will use frames to track number of individual frames
                end  % switch on header reading
            
            end      % while loop for header reading
            % the mex code is stand alone: opens and closes at each read operation
           fclose(fid);
           
            % this expands each pixel of the movie by stixel dims
            stimulus.span_height=stimulus.orig_height * parameters.stixel_height;
            stimulus.span_width=stimulus.orig_width * parameters.stixel_width;
              
            % number of frames
            stimulus.start_frame = parameters.start_frame;
            if isempty(parameters.frames)
                if parameters.reverse
                    parameters.frames = stimulus.start_frame;
                else
                    parameters.frames = total_movie_frames - stimulus.start_frame;
                end
            end            
            if (parameters.reverse && stimulus.start_frame-parameters.frames<0) || (~parameters.reverse && stimulus.start_frame+parameters.frames-1>total_movie_frames)
                fprintf('\t duration is more than movie length');
                stimulus.class = 'f';
                return;
            end
            stimulus.frames = parameters.frames;
            stimulus.delay_frames = parameters.delay_frames;
                      
            % flags for reverse and flip
            stimulus.flip = parameters.flip;
            stimulus.reverse = parameters.reverse;

            % interval
            stimulus.refresh = parameters.interval;
            
            stimulus.jitter.flag = 0;
              
        end		% constructor
    
	end			% methods block
    
end             % Random Noise clas
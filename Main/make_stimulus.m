function stimulus = make_stimulus(varargin)

parameters = {};
do_silent = 0;
for i = 1:nargin
    if isstruct(varargin{i})
        if ~strcmp(inputname(i),'def_params')
            tmp = [fieldnames(varargin{i}) struct2cell(varargin{i})]';
            parameters = [parameters tmp(:)'];
        else
            def_params = varargin{i};
        end
    elseif strcmp(varargin(i),'silent')
        do_silent = 1;
    else
        parameters{end+1} = varargin{i};
    end
end

if do_silent % silent prerun
    mglStencilCreateBegin(1);
    mglFillRect(0,0,[1 1]);
    mglStencilCreateEnd;
    mglStencilSelect(1);
else % if moving bar was interrupted or after silent prerun 
    mglStencilSelect(0);
end

class_index = find(cell2mat(cellfun(@(x) strcmp(x,'class'), parameters, 'UniformOutput', 0)));

switch parameters{class_index+1}    
    case 'FS'   % focus squares
        stimulus = Focus_Squares(def_params, parameters);
        
    case 'PL'   % map-based pulse
        stimulus = Map_Pulse(def_params, parameters);
        
    case 'FP'  % rectanlular pulse
        stimulus = Rect_Pulse(def_params, parameters);
        
    case 'MB'  % moving bars
        stimulus = Moving_Bar(def_params, parameters);
        
    case 'MG'  % moving gratings
        stimulus = Moving_Grating(def_params, parameters);
        
    case 'CG'  % counterphase gratings
        stimulus = Counterphase_Grating(def_params, parameters);
        
    case 'RN'  % random noise
        stimulus = Random_Noise(def_params, parameters);
                
    case 'RM'   % raw movie
        stimulus = Raw_Movie(def_params, parameters);        
end

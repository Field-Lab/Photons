function [time_stamps] = display_stimulus(stimulus, varargin)

if stimulus.class == 'f'
    fprintf('\n Could not construct the stimulus\n');
    return
end

p = inputParser;
addParameter(p,'trigger_interval', 100);
addParameter(p,'wait_trigger', 0); % for now, normally def is 1
addParameter(p,'wait_key', 0);
addParameter(p,'erase', 1);
addParameter(p, 'erase_to_gray', 0);
parse(p,varargin{:});
params = p.Results;

% trigger parameters
trigger_interval = p.Results.trigger_interval;
% outpulse_duration = 0.001; % taken from RSM_GLOBAL.dio_config.outpulse_duration
trigger_sample_rate = 100; % taken from RSM_GLOBAL.dio_config.trigger_sample_rate

if params.wait_key
    params.wait_trigger = 0;
    fprintf('\n\n"Wait Key" is set to true, "Wait Trigger" forced to false\n\n')
end

% for white noise reset rng before each repetition
if ~isempty( findprop(stimulus, 'rng_init') )
    stimulus.rng_init.state = Init_RNG_JavaStyle(stimulus.rng_init.seed);
    stimulus.jitter.state = Init_RNG_JavaStyle(stimulus.rng_init.seed);
%stimulus.rng_init.state;
end

%%%%%%%%%%% WAIT FOR TRIGGER OR KEY PRESS %%%%%%%%%%%
if params.wait_trigger
%     fprintf('WAITING FOR TRIGGER\n');
    trigger_time = Scan_4_Trigger(trigger_sample_rate); % trigger time stamp not used now, maybe we don't need it
elseif params.wait_key % wait for key press event
%     fprintf('WAITING FOR KEY\n');
    pause;
end

%%%%%%%%%%% RUN ONE STIMULUS %%%%%%%%%%%

time_stamps = eval(stimulus.run_script);

if p.Results.erase_to_gray
    mglClearScreen(0.5);
    mglFlush
    mglClearScreen(0.5);
    mglFlush
end

if p.Results.erase
    mglClearScreen;
    mglFlush
    mglClearScreen;
    mglFlush
end


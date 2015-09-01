function def_params = initialize_display(dev_type, screen_number)

% set monitor parameters
switch dev_type
    case 'CRT'
        width = 640; height = 480; refresh_rate = 120; % in experiments, put real value here!
    case 'OLED'
        width = 800; height = 600; refresh_rate = 60.3578;
end

def_params.x_start = 1;
def_params.x_end = width;
def_params.y_start = 1;
def_params.y_end = height;
def_params.back_rgb = [0.5 0.5 0.5];
def_params.delay_frames = 0;

% initialize MGL
fprintf('Configuring %s display for %4.3f [Hz] , width: %d , height: %d \n', dev_type, refresh_rate, width, height);
mglOpen(screen_number, width, height, refresh_rate);
mglScreenCoordinates;
mglClearScreen(0.5);
mglFlush;

% pre-run white noise and movie to initialize libraries - not sure how much
% it's needed
    
stimulus = make_stimulus(def_params, 'class', 'RN', 'rgb', [0 0 0], 'independent', 1,...
    'seed', 11111, 'x_start', 1, 'x_end', 320, 'y_start', 1, 'y_end', 320,...
    'stixel_width', 10, 'stixel_height', 10, 'field_width', 32, 'field_height', 32,...
    'frames', 10, 'silent');
display_stimulus(stimulus);
stimulus = make_stimulus(def_params, 'class', 'RM', 'frames', 10, 'silent', ...
    'movie_name', '/Users/alexth/test4/RSM/RSM_Movie_Vault/test_5_A.rawMovie');
display_stimulus(stimulus);
mglStencilSelect(0);


fprintf('Silent prerun complete.\n');

% initialize the DIO (we will simply use the default port values specified
% by Justin)
fprintf('Initializing digIO...\n');
mglDigIO('init');
Pulse_DigOut_Channel; % 6501 Output line starts high (~ +4.4 V), clear the line with a pulse
% NB: THIS DOES NOT OUTPUT A PULSE. It merely causes the line voltage to
% drop low.
fprintf('Initialization complete.\n');

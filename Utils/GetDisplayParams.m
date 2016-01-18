function display = GetDisplayParams()

display = struct();
display.width = mglGetParam('screenWidth');
display.height = mglGetParam('screenHeight');
display.physical_width = 16;
display.physical_height = 16/display.width*display.height;
display.distance = 57;

end


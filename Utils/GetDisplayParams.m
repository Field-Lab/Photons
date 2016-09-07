function display = GetDisplayParams(def_params)

display = struct();
display.width = def_params.x_end;
display.height = def_params.y_end;
display.physical_width = 16;
display.physical_height = 16/display.width*display.height;
display.distance = 57;

end
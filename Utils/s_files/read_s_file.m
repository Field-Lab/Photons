function parameters = read_s_file( filepath )
% READ_STIM_LISP_OUTPUT     Attempt to read in and parse stimulus Lisp output
% These usually live in files like "s01".  There are different stimulus
% types; only a few of them have parsers set up.  This will attempt to
% parse as far as it knows how.

% Read lines from file
lines = {};
f = fopen(filepath, 'r');
tline = fgetl(f);
while ischar(tline) && ~isempty(tline)
    lines{end+1} = tline;
    tline = fgetl(f);
end
fclose(f);

% Convert Lisp lines into cell arrays, adding them to a master cell array
cells = {};
for i = 1:length(lines)
    line = lines{i};
    
    % There is one complication: often multiple () () () of Lisp are on a
    % single line.  When converted to {} {} {} this will not evaluate as
    % valid Matlab.  So if LISP2CA fails, we assume that the problem is
    % that the line needs to be wrapped in an extra outer ().  We then cut
    % this added {} back out of the entry in the master cell array.
    try
        cells{end+1} = lisp2ca(line);
    catch
        tempcells = lisp2ca(['(' line ')']);
        cells(length(cells)+1:length(cells)+length(tempcells)) = tempcells;
    end
end

parameters = cell(1, length(cells));
for i=1:length(cells)
    tmp = cells{i};
    for j = 1:2:length(tmp)
        fldnam = lower(tmp{j});
        fldnam = strrep(fldnam, '-', '_');
        parameters{i}.(fldnam) = tmp{j+1};
    end
end


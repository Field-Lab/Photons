function seq = get_sequence(steps)

seq=zeros(steps,1);

seq(1:2:end) = ceil((steps+0.1)/2):steps;
seq(2:2:end) = floor(steps/2):-1:1;

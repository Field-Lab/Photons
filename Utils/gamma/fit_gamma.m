function [scale, power, offset] = fit_gamma(data)

x = linspace(1e-10,1,size(data,1));
cols = 'rgb';

for i=1:size(data,2)
    y = data(:,i);
%     y = y-min(y);
    y = y/max(y);
    fit_results = fit(x',y,'power2');
    scale(i) = fit_results.a;
    power(i) = fit_results.b;
    offset(i) = fit_results.c;    
    
    subplot(2,2,i)
    plot(x, y, 'color', 'k', 'marker','*');
    hold on
    plot(x, scale(i).*x.^power(i)+offset(i),cols(i));
end

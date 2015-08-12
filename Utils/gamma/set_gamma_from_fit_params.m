function set_gamma_from_fit_params (scale, power, offset)

linear_gamma = linspace(0,1,256);

gamma_table = zeros(3,256);
for i=1:3
    gamma_table(i,:) = scale(i)*linear_gamma.^power(i)+offset(i);
end

mglSetGammaTable(gamma_table);

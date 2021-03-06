function set_gamma_from_fit_params (scale, power, offset)

linear_gamma = linspace(0,1,256);

gamma_table = zeros(3,256);
for i=1:3
%     gamma_table(i,:) = scale(i)*linear_gamma.^power(i)+offset(i);
    gamma_table(i,:) = (nthroot(linear_gamma,power(i)))/scale(i)-offset(i);
end
gamma_table(gamma_table<0)=0;
gamma_table(gamma_table>1)=1;

mglSetGammaTable(gamma_table)

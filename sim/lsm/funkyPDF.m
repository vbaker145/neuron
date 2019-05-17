function pdf = funkyPDF(u, sigma, lambda, x )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

norm1 = 1/(sqrt(2*pi*sigma^2)); 
norm2 = sqrt(1/lambda^2)/sqrt(pi);

%pdf = exp(-((x-u).^2)./(2*sigma^2))+exp(-(x./lambda).^2);
pdf = exp(-((x-u).^2)./(2*sigma^2));

end


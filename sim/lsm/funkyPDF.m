function pdf = funkyPDF(u, sigma, lambda, x )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

norm1 = 1/(2*sqrt(2*pi*sigma^2)); %Half the usual 
norm2 = sqrt(1/lambda^2)/sqrt(pi);

pdf = norm1.*exp(-((x-u).^2)./(2*sigma^2))+norm2.*exp(-(x./lambda).^2);


end


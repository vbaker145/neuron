function [ ipos, iwidth, opos, owidth] = findPeaks( inp, outp, dt, thresh)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%Remove refractory periods
spikePeriod = floor(20/dt);
%inp = inputMP; outp=outputMP;
inp = inp+68; outp = outp+68;
inp(inp<0) = 0; outp(outp<0) = 0;

%Smooth and hard threshold
win = ones(1,spikePeriod)./spikePeriod;
inp_s = conv(inp, win); inpThresh = max(inp_s)*thresh;
outp_s = conv(outp,win); outpThresh = max(outp_s)*thresh;

%Detect peaks, find position and width
inpDets = find(inp_s>inpThresh);
idd = diff(inpDets);
idd = find(idd>1);
iwidth = [idd(1) diff(idd)]*dt;
ipos = inpDets(idd).*dt-0.5*iwidth;
nid = length(idd)+1;

outpDets = find(outp_s>outpThresh);
odd = diff(outpDets);
odd = find(odd>1);
owidth = [odd(1) diff(odd)]*dt;
opos = outpDets(odd).*dt-0.5*owidth;
nod = length(odd)+1;

%figure; plot(inp_s); hold on; plot(ones(1,length(inp_s)).*max(inp_s)*thresh)
%figure; plot(outp_s); hold on; plot(ones(1,length(outp_s)).*max(outp_s)*thresh)

end


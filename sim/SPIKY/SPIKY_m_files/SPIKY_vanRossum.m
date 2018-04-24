function Final = SPIKY_vanRossum_analytical_vectorized(st1, st2, tau)

st1 = st1/tau;
st2 = st2/tau;

common = intersect(st1, st2);
st1 = setdiff(st1, common); % N
st2 = setdiff(st2, common); % M

pooledst = unique([st1, st2]); % N + M

ini = [1;0];

if (st1(1) > st2(1))
    ini = 1 - ini;
end

expsummed1 = exp(2*st1); % N
expsummedv1 = exp(st1); % N
cumexpsummed1 = cumsum(expsummed1); % N - 1
cumexpsummedv1 = cumsum(expsummedv1); % N - 1

expsummed2 = exp(2*st2); % M
expsummedv2 = exp(st2); % M
cumexpsummed2 = cumsum(expsummed2); % M - 1
cumexpsummedv2 = cumsum(expsummedv2); % M - 1

c1F = cumexpsummedv1(1:end-1).*expsummedv1(2:end); % N - 1
c1Fc = cumsum(c1F); % N - 2
c1Fs = [zeros(1, length(st1) - length(c1Fc)) c1Fc]; % N (2)

c2F = cumexpsummedv2(1:end-1).*expsummedv2(2:end); % M - 1
c2Fc = cumsum(c2F); % M - 2
c2Fs = [zeros(1, length(st2) - length(c2Fc)) c2Fc]; % M (2)

csrear = SPIKY_vanRossum_rearrange(st1, st2, int32(length(pooledst))); % N + M %rearanging indices
cesv1 = [0 cumexpsummedv1]; % N (1)
cesv2 = [0 cumexpsummedv2]; % M (1)

cx1F = cesv2(csrear{1}).*expsummedv1; % N
cx1Fs = cumsum(cx1F); % N - 1

cx2F = cesv1(csrear{2}).*expsummedv2; % M
cx2Fs = cumsum(cx2F); % M -1

invexppooled = exp(-2*pooledst); % N + M
iepd = -diff([invexppooled 0]); % N + M - 1

sum1 = .5*cumexpsummed1 + c1Fs - cx1Fs; % N
sum2 = .5*cumexpsummed2 + c2Fs - cx2Fs; % M

FFF = SPIKY_vanRossum_sort(st1, st2, sum1, sum2, int32(length(pooledst))); % N + M %sorting values
Final = 2* sqrt(1/tau *(sum(sum(FFF).*iepd))); % N + M

% normalization ( Houghton - Kreuz kernel version )


function colStruct = makeFiringRateColumnEnsemble(dt, colSep, structure)

if nargin<2
   colSep = 7; 
end

%Column ensemble for firing rate encoding experiment

%Column parameters
if nargin < 3
    structure.width = 2;
    structure.height = 2;
    structure.nWide = 3;
    structure.nHigh = 3;
    structure.layers = 30;
    structure.displacement = 0;
end
structure.columnSpacing = colSep;
nCols = structure.nWide*structure.nHigh;
    
connectivity.percentExc = 0.8;
connectivity.connType = 1;
connectivity.lambda = 2.5;
connectivity.C = 0.5;
connectivity.connStrength = 14;
connectivity.maxLength = 100;

delay.delayType = 1;
delay.delayMult = 1;
delay.delayFrac = 1.0;
delay.dt = dt;

Nlayer = structure.width*structure.nWide*structure.height*structure.nHigh;
N = Nlayer*structure.layers;

[a,b,c,d, S, delays, ecn, csec, pos] = makeColumnEnsemble(structure, connectivity, delay);

%Modify for audio processing
%a = a+rand(size(a))*0.06;
%b = b+0.005;
%c = c+10;

colStruct = struct('structure',structure, 'connectivity', connectivity, ...
    'delay',delay, 'a',a,'b',b,'c',c,'d',d,'S',S, 'delays',delays,...
    'ecn', ecn, 'csec',csec, 'N', N, 'nCols', nCols, 'Nlayer', Nlayer, ...
    'pos', pos );


end


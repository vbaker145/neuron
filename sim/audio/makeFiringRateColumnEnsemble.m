function colStruct = makeFiringRateColumnEnsemble(dt)

%Column ensemble for firing rate encoding experiment

%Column parameters
structure.width = 2;
structure.height = 2;
structure.nWide = 3;
structure.nHigh = 3;
structure.columnSpacing = 8;
structure.layers = 20;
structure.displacement = 0;
nCols = structure.nWide*structure.nHigh;

connectivity.percentExc = 0.8;
connectivity.connType = 1;
connectivity.lambda = 3.5;
connectivity.connStrength = 8;
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


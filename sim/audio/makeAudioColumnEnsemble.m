function colStruct = makeAudioColumnEnsemble()
%Colum,n ensemble for audio recognition

%Time step for simulation
dt = 1e3/8e3;

%Column parameters
structure.width = 2;
structure.height = 2;
structure.nWide = 3;
structure.nHigh = 3;
structure.columnSpacing = 12;
structure.layers = 40;
structure.displacement = 0;
nCols = structure.nWide*structure.nHigh;

connectivity.percentExc = 0.8;
connectivity.connType = 1;
connectivity.lambda = 3.5;
connectivity.connStrength = 10;
connectivity.maxLength = 100;

delay.delayType = 1;
delay.delayMult = 0.5;
delay.delayFrac = 1.0;
delay.dt = dt;

Nlayer = structure.width*structure.nWide*structure.height*structure.nHigh;
N = Nlayer*structure.layers;

[a,b,c,d, S, delays, ecn, csec] = makeColumnEnsemble(structure, connectivity, delay);

%Modify for audio processing
a = a+0.01;
b = b+0.005;

colStruct = struct('structure',structure, 'connectivity', connectivity, ...
    'delay',delay, 'a',a,'b',b,'c',c,'d',d,'S',S, 'delays',delays,...
    'ecn', ecn, 'csec',csec, 'N', N, 'nCols', nCols, 'Nlayer', Nlayer );


end


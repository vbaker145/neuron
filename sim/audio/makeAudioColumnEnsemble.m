function colStruct = makeAudioColumnEnsemble()
%Colum,n ensemble for audio recognition

%Time step for simulation
dt = 1e3/8e3;

%Column parameters
structure.width = 2;
structure.height = 2;
structure.nWide = 3;
structure.nHigh = 3;
structure.columnSpacing = 20;
structure.layers = 30;
structure.displacement = 0;
nCols = structure.nWide*structure.nHigh;

connectivity.percentExc = 0.8;
connectivity.connType = 1;
connectivity.lambda = 3.5;
connectivity.connStrength = 10;
connectivity.maxLength = 100;

delay.delayType = 1;
delay.delayMult = 1;
delay.delayFrac = 1.0;
delay.dt = dt;

Nlayer = structure.width*structure.nWide*structure.height*structure.nHigh;
N = Nlayer*structure.layers;

[a,b,c,d, S, delays, ecn, csec] = makeColumnEnsemble(structure, connectivity, delay);

colStruct = struct('structure',structure, 'connectivity', connectivity, ...
    'delay',delay, 'a',a,'b',b,'c',c,'d',d,'S',S, 'delays',delays,...
    'ecn', ecn, 'csec',csec, 'N', N, 'nCols', nCols, 'Nlayer', Nlayer );


end


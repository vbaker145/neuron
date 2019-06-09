function [ connectivity ] = columnConnectivity( S, width, height )

Nlayer = floor( size(S,1)/(width*height) );
LayerSize = 4;
for jj=1:Nlayer-LayerSize
   sidx = (jj-1)*width*height+1;
   layer = S(sidx:sidx+LayerSize*width*height,:);
   connectivity(jj) = sum((layer(:)>0)); 
end

end


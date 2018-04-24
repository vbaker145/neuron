% This is the first file that should be run once the zip-package has been extracted.
% Once the MEX-files have been compiled you can run the main program SPIKY.

mex -Dchar16_t=uint16_T SPIKY_udists_MEX.c
mex -Dchar16_t=uint16_T SPIKY_SPIKEsynchro_MEX.c
mex -Dchar16_t=uint16_T SPIKY_ISI_MEX.c
mex -Dchar16_t=uint16_T SPIKY_SPIKE_MEX.c
mex -Dchar16_t=uint16_T SPIKY_realtimeSPIKE_MEX.c
mex -Dchar16_t=uint16_T SPIKY_forwardSPIKE_MEX.c
mex -Dchar16_t=uint16_T SPIKY_SPIKEpico_MEX.c
mex -Dchar16_t=uint16_T SPIKY_realtimeSPIKEpico_MEX.c
mex -Dchar16_t=uint16_T SPIKY_forwardSPIKEpico_MEX.c

mex -Dchar16_t=uint16_T SPIKY_SPIKE_Neb_MEX.c
mex -Dchar16_t=uint16_T SPIKY_SPIKE_Eero_MEX.c
mex -Dchar16_t=uint16_T SPIKY_SPIKE_Neb_Eero_MEX.c

mex -Dchar16_t=uint16_T SPIKE_order_surro_MEX.c
mex -Dchar16_t=uint16_T SPIKE_order_sim_ann_MEX.c


%mex SPIKY_Victor_MEX.c
%[mex SPIKY_vanRossum_MEX.c]
%mex SPIKY_vanRossum_rearrange.c
%mex SPIKY_vanRossum_sort.c

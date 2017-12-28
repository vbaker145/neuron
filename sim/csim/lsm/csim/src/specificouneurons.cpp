/*! \file specificouneurons.cpp
**  \brief Implementation of various conductance based neurons with Ornstein Uhlenbeck process noise
*/


#include <string.h>
#include <stdio.h>
#include "specificouneurons.h"
#include "mexnetwork.h"

extern MexNetwork *TheNetwork;

bNACOUNeuron::bNACOUNeuron(void)
{
  Rm = 100e6;  // Ohm
  Cm = 0.3e-9; // Farad
//  Rm = 6.749865190938485e+08;  // Ohm
//  Cm = 2.767855827550085e-10; // Farad
  STempHeight = 0.030;       // Volt
  Vresting = 0.0;           // Volt

  Vreset=Vresting;

  Vinit=Vresting;
  Trefract=0.005;
  Inoise=0.0;
  Iinject=0.0;
  Vthresh=0.015;
  Vreset=0.0075;
  doReset=1;

  ahp = 0;
}

int bNACOUNeuron::init(Advancable *a)
{
  ahp  = new AHP_Channel;

//  ahp->Gbar = 10*126e-9;
  ahp->Gbar = 126e-9;  // Trace fits
  ahp->Erev = -0.0045;
  ahp->Ts = 0.285;
  ahp->u = 0.015/2;
//  ahp->u = 0.015;    //  Trace fits


//  ahp->Gbar = 1.28726e-07;
//  ahp->Erev = -0.0045;
//  ahp->Ts = 0.2192;
//  ahp->u = 0.0410916;

  bool e = 0;

  e = e || a->addIncoming(ahp) < 0;
  e = e || ahp->addIncoming(a) < 0;
  e = e || a->addOutgoing(ahp) < 0;
  e = e || ahp->addOutgoing(a) < 0;

  return e ? -1 : 0;

}

int bNACOUNeuron::updateInternal(void)
{
  bool e=0;
  if ( ahp  ) { e = e || ahp->updateInternal() < 0; }
  return e;
}

bNACOUNeuron::~bNACOUNeuron(void)
{
  if ( ahp  ) { delete ahp;  ahp=0;  }
}


cACOUNeuron::cACOUNeuron(void)
{
  Rm = 100e6;  // Ohm
  Cm = 0.3e-9; // Farad
//  Rm = 1.44078e+08;     // Ohm
//  Cm = 2.78187e-10; // Farad
  STempHeight = 0.03;       // Volt
  Vresting = 0.0;           // Volt

  Vreset=Vresting;

  Vinit=Vresting;
  Trefract=0.005;
  Inoise=0.0;
  Iinject=0.0;
  Vthresh=0.015;
  Vreset=0.0075;
  doReset=1;

  ahp = 0;
}

int cACOUNeuron::init(Advancable *a)
{
  ahp  = new AHP_Channel;

//  ahp->Gbar = 10*20e-9;
  ahp->Gbar = 20e-9;    //Trace fits
  ahp->Erev = -0.0045;
  ahp->Ts = 0.230;
  ahp->u = 0.02;
//  ahp->Gbar = 1.30503e-07;
//  ahp->Erev = -0.0045;
//  ahp->Ts = 0.185678;
//  ahp->u = 0.00799109;

  bool e = 0;

  e = e || a->addIncoming(ahp) < 0;
  e = e || ahp->addIncoming(a) < 0;
  e = e || a->addOutgoing(ahp) < 0;
  e = e || ahp->addOutgoing(a) < 0;

  return e ? -1 : 0;
}

int cACOUNeuron::updateInternal(void)
{
  bool e=0;
  if ( ahp  ) {e = e || ahp->updateInternal() < 0;}
  return e;
}

cACOUNeuron::~cACOUNeuron(void)
{
  if ( ahp  ) { delete ahp;  ahp=0;  }
}


dNACOUNeuron::dNACOUNeuron(void)
{
  Rm = 100e6;  // Ohm
  Cm = 0.3e-9; // Farad
//  Rm = 2.55257e+08;     // Ohm
//  Cm = 2.82188e-10; // Farad
  STempHeight = 0.03;       // Volt
  Vresting = 0.0;           // Volt

  Vreset=Vresting;

  Vinit=Vresting;
  Trefract=0.005;
  Inoise=0.0;
  Iinject=0.0;
  Vthresh=0.015;
  Vreset=0.0075;
  doReset=1;

  ah = 0;
}

int dNACOUNeuron::init(Advancable *a)
{
  ah = new AChannel_Hoffman97();
//  ah->Gbar = 10*279e-9;
  ah->Gbar = 279e-9;  // Trace fits

//  ah->Gbar = 8*279e-9;
//  ah->Gbar = 7.0e-07;      % original value in the soma

  bool e = 0;

  e = e || a->addIncoming(ah) < 0;
  e = e || ah->addIncoming(a) < 0;
  e = e || a->addOutgoing(ah) < 0;
  e = e || ah->addOutgoing(a) < 0;

  return e ? -1 : 0;
}

int dNACOUNeuron::updateInternal(void)
{
  bool e=0;
  if (ah){  e = e || ah->updateInternal() < 0; }
  return e;
}


dNACOUNeuron::~dNACOUNeuron(void)
{
  if (ah) { delete ah;  ah=0;  }
}



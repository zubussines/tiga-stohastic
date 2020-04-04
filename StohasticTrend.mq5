//+------------------------------------------------------------------+
//|                                                    Stohastic.mq5 |
//|                                       Copyright 2020, ZSoft Inc. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, ZSoft Inc."
#property link      "https://www.mql5.com"
#property version   "1.00"


#include <Trade\Trade.mqh>

CTrade trade;

string signalMain, closePosisi;

double KArray[];

double DArray[];


int StohasticUtama;
int stohasticTrend;


double Ask, Bid;


double K;

double D;

double KSebelumnya;

double DSebelumnya;

bool overSell = false;
bool overBuy = false;

bool posisiBuy = false;
bool posisiSell = false;

string posisiOver = "kosong";


// Start Variable Input

input int KPeriod = 5;

input int DPeriod = 3;

input int Slowing = 3;


input ENUM_TIMEFRAMES stohasticMainTime = PERIOD_H1;


input int TakeProfitPips = 150;

input int StopLossPips = 75;


input ENUM_MA_METHOD IndicatorMode = MODE_SMA;

input ENUM_STO_PRICE IndicatorPrice = STO_LOWHIGH;

// End Variable Input

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---

StohasticUtama = iStochastic( _Symbol, stohasticMainTime, KPeriod, DPeriod, Slowing, IndicatorMode, IndicatorPrice );
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---

Ask = NormalizeDouble( SymbolInfoDouble( _Symbol, SYMBOL_ASK ), _Digits );

Bid = NormalizeDouble( SymbolInfoDouble ( _Symbol, SYMBOL_BID ), _Digits );



ArraySetAsSeries( KArray, true );

ArraySetAsSeries( DArray, true );




CopyBuffer( StohasticUtama, 0, 0, 3, KArray );

CopyBuffer( StohasticUtama, 1, 0, 3, DArray );



K = KArray[0];

D = DArray[0];

KSebelumnya = KArray[1];

DSebelumnya = DArray[1];


// Start Signal

// signal
if( D < 20 && K < 20 && overSell == false ){
   overSell = true;
   Alert("Over Sell");
}

// open buy
if( overSell == true && K > D && D > 20 && K > 20 && posisiBuy == false ){
   overSell = false;
   posisiBuy = true;
   Alert("Open Buy");
   
   if( PositionsTotal() < 1 ){
   trade.Buy( 0.10, NULL, Ask, 0, 0, NULL );
   }
}


// take profit
if( K < D && D > 50 && K > 50 && posisiBuy == true ){
   posisiBuy = false;
   Alert("Take Profit Buy");
   
   if( PositionsTotal() > 0 ){
   trade.PositionClose( _Symbol, 5 );
   }
}

// stop lose
if( K < D && D < 15 && K < 15 && posisiBuy == true ){
   posisiBuy = false;
   Alert("Stop Lose Buy");
   
   if( PositionsTotal() > 0 ){
   trade.PositionClose( _Symbol, 5 );
   }
}


// sell
if( D > 80 && K > 80 && overBuy == false ){
   overBuy = true;
   Alert("Over Buy");
}

// open sell
if( overBuy == true && K < D && D < 80 && K < 80 && posisiSell == false ){
   posisiSell = true;
   overBuy = false;
   Alert("Open sell");
   
   if( PositionsTotal() < 1 ){
   trade.Sell( 0.10, NULL, Bid, 0, 0, NULL );
   }
   
}


// take profit
if( K > D && D < 50 && K < 50 && posisiSell == true ){
   posisiSell = false;
   Alert("Take Profit Sell");
   
   if( PositionsTotal() > 0 ){
   trade.PositionClose( _Symbol, 5 );
   }
}

// stop lose
if( K > D && D > 85 && K > 85 && posisiSell == true ){
   posisiSell = false;
   Alert("Stop Lose Sell");
   
   if( PositionsTotal() > 0 ){
   trade.PositionClose( _Symbol, 5 );
   }
}




/* Start Open atau Close Position Sell
if( signalMain == "Sell" && PositionsTotal() < 1 ){
   trade.Sell( 0.10, NULL, Bid, 0, 0, NULL );
}

if( closePosisi == "Sell" && PositionsTotal() > 0 ){
   trade.PositionClose( _Symbol, 5 );
   closePosisi = "kosong";
}
// End Open atau Close Position Sell


// Start Open atau Close Position Buy
if( signalMain == "Buy" && PositionsTotal() < 1 ){
   trade.Buy( 0.10, NULL, Bid, 0, 0, NULL );
}

if( closePosisi == "Buy" && PositionsTotal() > 0 ){
   trade.PositionClose( _Symbol, 5 );
   closePosisi = "kosong";
}
// End Open atau Close Position Buy

if( overBuy == true ){
   posisiOver = "over buy";
}

if( overSell == true ){
   posisiOver = "over Sell";
}


// Start Coment
Comment( "Sinyal Main Adalah: ", posisiOver  );
// End Coment */


  }
//+------------------------------------------------------------------+
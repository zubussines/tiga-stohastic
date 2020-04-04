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

string signalMain;

double KArray1[];

double DArray1[];


int StohasticDefinition1;


double Ask, Bid;


double KValue01;

double DValue01;

double KValue11;

double DValue11;


// Start Variable Input

input int KPeriod1 = 14;

input int DPeriod1 = 5;

input int Slowing1 = 5;


input ENUM_TIMEFRAMES stohasticMainTime = PERIOD_M5;


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

StohasticDefinition1 = iStochastic( _Symbol, stohasticMainTime, KPeriod1, DPeriod1, Slowing1, IndicatorMode, IndicatorPrice );
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



ArraySetAsSeries( KArray1, true );

ArraySetAsSeries( DArray1, true );




CopyBuffer( StohasticDefinition1, 0, 0, 3, KArray1 );

CopyBuffer( StohasticDefinition1, 1, 0, 3, DArray1 );



KValue01 = KArray1[0];

DValue01 = DArray1[0];

KValue11 = KArray1[1];

DValue11 = DArray1[1];


// Start Buy Condiction
if( KValue01 < 20 && DValue01 < 20 ){
   if( ( KValue01 > DValue01 ) && ( KValue11 < DValue11 ) ){
      signalMain = "Buy";
   }
}
// End Buy Condition


// Start Sell Condiction
if( KValue01 > 80 && DValue01 > 80 ){
   if( ( KValue01 < DValue01 ) && ( KValue11 > DValue11 ) ){
      signalMain = "Sell";
   }
}
// End Sell Condition


// Start Open Position Sell
if( signalMain == "Sell" && PositionsTotal() < 1 ){
   trade.Sell( 0.10, NULL, Bid, 0, ( Bid - TakeProfitPips * _Point ), NULL );
}
// End Open Position Sell


// Start Open Position Buy
if( signalMain == "Buy" && PositionsTotal() < 1 ){
   trade.Buy( 0.10, NULL, Ask, 0, ( Ask + TakeProfitPips * _Point ), NULL );
}
// End Open Position Buy


// Start Coment
Comment( "Sinyal Main Adalah: ", signalMain );
// End Coment


  }
//+------------------------------------------------------------------+
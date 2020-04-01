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

string signalMain, signalTrend, signalEntrypoint;

double KArray1[];

double DArray1[];

double KArray2[];

double DArray2[];

double KArray3[];

double DArray3[];


int StohasticDefinition1;

int StohasticDefinition2;

int StohasticDefinition3;


double Ask, Bid;


double KValue01;

double DValue01;

double KValue11;

double DValue11;



double KValue02;

double DValue02;

double KValue12;

double DValue12;



double KValue03;

double DValue03;

double KValue13;

double DValue13;


// Start Variable Input

input int KPeriod1 = 5;

input int DPeriod1 = 3;

input int Slowing1 = 3;


input int KPeriod2 = 5;

input int DPeriod2 = 3;

input int Slowing2 = 3;


input int KPeriod3 = 5;

input int DPeriod3 = 3;

input int Slowing3 = 3;


input ENUM_TIMEFRAMES stohasticMainTime = PERIOD_H1;

input ENUM_TIMEFRAMES stohasticTrendtime = PERIOD_H4;

input ENUM_TIMEFRAMES stohasticEntryPointtime = PERIOD_M15;


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
StohasticDefinition2 = iStochastic( _Symbol, stohasticTrendtime, KPeriod2, DPeriod2, Slowing2, IndicatorMode, IndicatorPrice );
StohasticDefinition3 = iStochastic( _Symbol, stohasticEntryPointtime, KPeriod3, DPeriod3, Slowing3, IndicatorMode, IndicatorPrice );
   
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

ArraySetAsSeries( KArray2, true );

ArraySetAsSeries( DArray2, true );

ArraySetAsSeries( KArray3, true );

ArraySetAsSeries( DArray3, true );




CopyBuffer( StohasticDefinition1, 0, 1, 3, KArray1 );

CopyBuffer( StohasticDefinition1, 1, 1, 3, DArray1 );

CopyBuffer( StohasticDefinition2, 0, 0, 3, KArray2 );

CopyBuffer( StohasticDefinition2, 1, 0, 3, DArray2 );

CopyBuffer( StohasticDefinition3, 0, 0, 3, KArray3 );

CopyBuffer( StohasticDefinition3, 1, 0, 3, DArray3 );



KValue01 = KArray1[0];

DValue01 = DArray1[0];

KValue11 = KArray1[1];

DValue11 = DArray1[1];


KValue02 = KArray2[0];

DValue02 = DArray2[0];

KValue12 = KArray2[1];

DValue12 = DArray2[1];


KValue03 = KArray3[0];

DValue03 = DArray3[0];

KValue13 = KArray3[1];

DValue13 = DArray3[1];



// Start Buy Condiction
if( KValue01 < 20 && DValue01 < 20 ){
   if( ( KValue01 > DValue01 ) && ( KValue11 < DValue11 ) ){
      signalMain = "Buy";
   }
}

if( KValue02 < 20 && DValue02 < 20 ){
   if( ( KValue02 > DValue02 ) && ( KValue12 < DValue12 ) ){
      signalTrend = "Buy";
   }
}

if( KValue03 < 20 && DValue03 < 20 ){
   if( ( KValue03 > DValue03 ) && ( KValue13 < DValue13 ) ){
      signalEntrypoint = "Buy";
   }
}

// End Buy Condition


// Start Sell Condiction

if( KValue01 > 80 && DValue01 > 80 ){
   if( ( KValue01 < DValue01 ) && ( KValue11 > DValue11 ) ){
      signalMain = "Sell";
   }
}


if( KValue02 > 80 && DValue02 > 80 ){
   if( ( KValue02 < DValue02 ) && ( KValue12 > DValue12 ) ){
      signalMain = "Sell";
   }
}


if( KValue03 > 80 && DValue03 > 80 ){
   if( ( KValue03 < DValue03 ) && ( KValue13 > DValue13 ) ){
      signalMain = "Sell";
   }
}

// End Sell Condition

// Start Open Position Sell
if( signalMain == "Sell" /*&& signalTrend == "Sell" && signalEntrypoint == "Sell" */&& PositionsTotal() < 1 ){
   trade.Sell( 0.10, NULL, Bid, ( Bid + StopLossPips * _Point ), ( Bid - TakeProfitPips * _Point ), NULL );
}
// End Open Position Sell


// Start Open Position Buy

if( signalMain == "Buy" /*&& signalTrend == "Buy" && signalEntrypoint == "Buy" */&& PositionsTotal() < 1 ){
   trade.Buy( 0.10, NULL, Bid, ( Bid - StopLossPips * _Point ), ( Bid + TakeProfitPips * _Point ), NULL );
}

// End Open Position Buy


// Start Coment
Comment( "Sinyal Main Adalah: ", signalMain );
//Comment( "Sinyal Trend Adalah: ", signalTrend );
//Comment( "Sinyal Entry Point Adalah: ", signalEntrypoint );
// End Coment


  }
//+------------------------------------------------------------------+
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

string signal = "Kosong";

double KArray[];

double DArray[];

int StohasticDefinition;

double Ask, Bid;


// Start Variable Input

input int KPeriod = 5;

input int DPeriod = 3;

input int Slowing = 3;

input int TakeProfitPips = 150;

input int StopLossPips = 150;

input ENUM_MA_METHOD = MODE_SMA;

input ENUM_STO_PRICE = STO_LOWHIGH;

// End Variable Input

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---

StohasticDefinition = iStochastic( _Symbol, _Period, 5, 3, 3, MODE_SMA, STO_LOWHIGH );
   
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

CopyBuffer( StohasticDefinition, 0, 0, 3, KArray );

CopyBuffer( StohasticDefinition, 1, 0, 3, DArray );

double KValue0 = KArray[0];

double DValue0 = DArray[0];

double KValue1 = KArray[1];

double DValue1 = DArray[1];

// Start Buy Condiction
if( KValue0 < 20 && DValue0 < 20 ){
   if( ( KValue0 > DValue0 ) && ( KValue1 < DValue1 ) ){
      signal = "Buy";
   }
}
// End Buy Condition


// Start Sell Condiction
if( KValue0 > 80 && DValue0 > 80 ){
   if( ( KValue0 < DValue0 ) && ( KValue1 > DValue1 ) ){
      signal = "Sell";
   }
}
// End Sell Condition

// Start Open Position Sell
if( signal == "Sell" && PositionsTotal() < 1 ){
   trade.Sell( 0.10, NULL, Bid, 0, ( Bid - 150 * _Point ), NULL );
}
// End Open Position Sell


// Start Open Position Buy
if( signal == "Buy" && PositionsTotal() < 1 ){
   trade.Buy( 0.10, NULL, Bid, 0, ( Bid + 150 * _Point ), NULL );
}
// End Open Position Buy


// Start Coment
Comment( "Sinyal Sekarang Adalah: ", signal );
// End Coment


  }
//+------------------------------------------------------------------+
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

bool posisi = false;


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

////=========== start blok order system ===============//////////////


////=========== start blok order system ===============//////////////






//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---

StohasticUtama = iStochastic( _Symbol, stohasticMainTime, KPeriod, DPeriod, Slowing, IndicatorMode, IndicatorPrice );

ObjectCreate(0,"labelOverSell",OBJ_LABEL,0,0,0,0,0,0,0);
ObjectSetString(0,"labelOverSell",OBJPROP_TEXT,"Over Sell:"); 
ObjectSetInteger(0,"labelOverSell",OBJPROP_XDISTANCE,50);
ObjectSetInteger(0,"labelOverSell",OBJPROP_YDISTANCE,20);
ObjectSetInteger(0,"labelOverSell",OBJPROP_CORNER,CORNER_LEFT_UPPER);
ObjectSetInteger(0,"labelOverSell",OBJPROP_COLOR,clrAliceBlue);



ObjectCreate(0,"labelOverBuy",OBJ_LABEL,0,0,0,0,0,0,0);
ObjectSetString(0,"labelOverBuy",OBJPROP_TEXT,"Over Buy:"); 
ObjectSetInteger(0,"labelOverBuy",OBJPROP_XDISTANCE,50);
ObjectSetInteger(0,"labelOverBuy",OBJPROP_YDISTANCE,40);
ObjectSetInteger(0,"labelOverBuy",OBJPROP_CORNER,CORNER_LEFT_UPPER);
ObjectSetInteger(0,"labelOverBuy",OBJPROP_COLOR,clrAliceBlue);


ObjectCreate(0,"labelK",OBJ_LABEL,0,0,0,0,0,0,0);
ObjectSetString(0,"labelK",OBJPROP_TEXT,"K:"); 
ObjectSetInteger(0,"labelK",OBJPROP_XDISTANCE,50);
ObjectSetInteger(0,"labelK",OBJPROP_YDISTANCE,60);
ObjectSetInteger(0,"labelK",OBJPROP_CORNER,CORNER_LEFT_UPPER);
ObjectSetInteger(0,"labelK",OBJPROP_COLOR,clrAliceBlue);


ObjectCreate(0,"labelD",OBJ_LABEL,0,0,0,0,0,0,0);
ObjectSetString(0,"labelD",OBJPROP_TEXT,"D:"); 
ObjectSetInteger(0,"labelD",OBJPROP_XDISTANCE,50);
ObjectSetInteger(0,"labelD",OBJPROP_YDISTANCE,80);
ObjectSetInteger(0,"labelD",OBJPROP_CORNER,CORNER_LEFT_UPPER);
ObjectSetInteger(0,"labelD",OBJPROP_COLOR,clrAliceBlue);


ObjectCreate(0,"labelPosisiBuy",OBJ_LABEL,0,0,0,0,0,0,0);
ObjectSetString(0,"labelPosisiBuy",OBJPROP_TEXT,"Posisi Buy:"); 
ObjectSetInteger(0,"labelPosisiBuy",OBJPROP_XDISTANCE,50);
ObjectSetInteger(0,"labelPosisiBuy",OBJPROP_YDISTANCE,100);
ObjectSetInteger(0,"labelPosisiBuy",OBJPROP_CORNER,CORNER_LEFT_UPPER);
ObjectSetInteger(0,"labelPosisiBuy",OBJPROP_COLOR,clrAliceBlue);


ObjectCreate(0,"labelPosisiSel",OBJ_LABEL,0,0,0,0,0,0,0);
ObjectSetString(0,"labelPosisiSel",OBJPROP_TEXT,"Posisi Sel:"); 
ObjectSetInteger(0,"labelPosisiSel",OBJPROP_XDISTANCE,50);
ObjectSetInteger(0,"labelPosisiSel",OBJPROP_YDISTANCE,120);
ObjectSetInteger(0,"labelPosisiSel",OBJPROP_CORNER,CORNER_LEFT_UPPER);
ObjectSetInteger(0,"labelPosisiSel",OBJPROP_COLOR,clrAliceBlue);


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

////=========== start initialize value and array ===============//////////////
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
////=========== end initialize value and array ===============//////////////



////=========== start blok buy ===============//////////
if( posisiBuy == true || posisiSell == true ){
   posisi = true;
}else{
   posisi = false;
}

// Start Signal

// Over Sell
if( D < 20 && K < 20 && overSell == false && posisi == false ){
   overSell = true;
   Alert("Over Sell");
}

// open buy
if( overSell == true && K > D && D > 20 && K > 20 && posisiBuy == false ){
   
   
   Alert("Open Buy");
   
   if( trade.Buy( 0.10, NULL, Ask, 0, 0, NULL ) )
   {
      Alert("Open Buy Success");
      posisiBuy = true;
      overSell = false;
   }else{
      Alert("Open Buy Failed");
   }
}


// take profit buy
if( K < D && D > 50 && K > 50 && posisiBuy == true ){
   
   Alert("Take Profit Buy");
   
   if( trade.PositionClose( _Symbol, 5 ) ){
      Alert("Take Profit Buy Success");
      posisiBuy = false;
   }else{
      Alert("Take Profit Buy Failed");
   }
}

// stop lose buy
if( K < D && D < 15 && K < 15 && posisiBuy == true ){

   Alert("Stop Lose Buy");
   
   if( trade.PositionClose( _Symbol, 5 ) ){
      Alert("Stop Lose Buy Success");
      posisiBuy = false;
   }else{
      Alert("Stop Lose Buy Failed");
   }
}
////=========== end blok buy ===============//////////////



////=========== start blok sell ===============//////////
// Over Buy
if( D > 80 && K > 80 && overBuy == false && posisi == false ){
   overBuy = true;
   Alert("Over Buy");
}

// open sell
if( overBuy == true && K < D && D < 80 && K < 80 && posisiSell == false ){
   
   
   Alert("Open Sell");
   
   if( trade.Sell( 0.10, NULL, Bid, 0, 0, NULL ) )
   {
      Alert("Open Sell Success");
      posisiSell = true;
      overBuy = false;
   }else{
      Alert("Open Sell Failed");
   }
   
}


// take profit sell
if( K > D && D < 50 && K < 50 && posisiSell == true ){
   
   Alert("Take Profit Sell");
   
   if( trade.PositionClose( _Symbol, 5 ) ){
      Alert("Take Profit Sell Success");
      posisiSell = false;
   }else{
      Alert("Take Profit Sell Failed");
   }
}

// stop lose sell
if( K > D && D > 85 && K > 85 && posisiSell == true ){
   
   Alert("Stop Lose Sell");
   
   if( trade.PositionClose( _Symbol, 5 ) ){
      Alert("Stop Lose Sell Success");
      posisiSell = false;
   }else{
      Alert("Stop Lose Sell Failed");
   }
}
////=========== end blok sell ===============//////////



////=========== Start blok value object ===============////
ObjectCreate(0,"valueOverSell",OBJ_LABEL,0,0,0,0,0,0,0);
ObjectSetString(0,"valueOverSell",OBJPROP_TEXT, overSell );
ObjectSetInteger(0,"valueOverSell",OBJPROP_XDISTANCE,110);
ObjectSetInteger(0,"valueOverSell",OBJPROP_YDISTANCE,20);
ObjectSetInteger(0,"valueOverSell",OBJPROP_CORNER,CORNER_LEFT_UPPER);
ObjectSetInteger(0,"valueOverSell",OBJPROP_COLOR,clrAliceBlue);


ObjectCreate(0,"valuelabelOverBuy",OBJ_LABEL,0,0,0,0,0,0,0);
ObjectSetString(0,"valuelabelOverBuy",OBJPROP_TEXT, overBuy ); 
ObjectSetInteger(0,"valuelabelOverBuy",OBJPROP_XDISTANCE,110 );
ObjectSetInteger(0,"valuelabelOverBuy",OBJPROP_YDISTANCE,40);
ObjectSetInteger(0,"valuelabelOverBuy",OBJPROP_CORNER,CORNER_LEFT_UPPER);
ObjectSetInteger(0,"valuelabelOverBuy",OBJPROP_COLOR,clrAliceBlue);


ObjectCreate(0,"valuelabelK",OBJ_LABEL,0,0,0,0,0,0,0);
ObjectSetString(0,"valuelabelK",OBJPROP_TEXT, DoubleToString( K, 2 ) ); 
ObjectSetInteger(0,"valuelabelK",OBJPROP_XDISTANCE,80);
ObjectSetInteger(0,"valuelabelK",OBJPROP_YDISTANCE,60);
ObjectSetInteger(0,"valuelabelK",OBJPROP_CORNER,CORNER_LEFT_UPPER);
ObjectSetInteger(0,"valuelabelK",OBJPROP_COLOR,clrAliceBlue);


ObjectCreate(0,"valuelabelD",OBJ_LABEL,0,0,0,0,0,0,0);
ObjectSetString(0,"valuelabelD",OBJPROP_TEXT, DoubleToString( D, 2 ) ); 
ObjectSetInteger(0,"valuelabelD",OBJPROP_XDISTANCE,80);
ObjectSetInteger(0,"valuelabelD",OBJPROP_YDISTANCE,80);
ObjectSetInteger(0,"valuelabelD",OBJPROP_CORNER,CORNER_LEFT_UPPER);
ObjectSetInteger(0,"valuelabelD",OBJPROP_COLOR,clrAliceBlue);


ObjectCreate(0,"valuelabelPosisiBuy",OBJ_LABEL,0,0,0,0,0,0,0);
ObjectSetString(0,"valuelabelPosisiBuy",OBJPROP_TEXT, posisiBuy ); 
ObjectSetInteger(0,"valuelabelPosisiBuy",OBJPROP_XDISTANCE,120);
ObjectSetInteger(0,"valuelabelPosisiBuy",OBJPROP_YDISTANCE,100);
ObjectSetInteger(0,"valuelabelPosisiBuy",OBJPROP_CORNER,CORNER_LEFT_UPPER);
ObjectSetInteger(0,"valuelabelPosisiBuy",OBJPROP_COLOR,clrAliceBlue);


ObjectCreate(0,"valuelabelPosisiSel",OBJ_LABEL,0,0,0,0,0,0,0);
ObjectSetString(0,"valuelabelPosisiSel",OBJPROP_TEXT, posisiSell ); 
ObjectSetInteger(0,"valuelabelPosisiSel",OBJPROP_XDISTANCE,120);
ObjectSetInteger(0,"valuelabelPosisiSel",OBJPROP_YDISTANCE,120);
ObjectSetInteger(0,"valuelabelPosisiSel",OBJPROP_CORNER,CORNER_LEFT_UPPER);
ObjectSetInteger(0,"valuelabelPosisiSel",OBJPROP_COLOR,clrAliceBlue);
////=========== end blok buy ===============//////////////


  }
//+------------------------------------------------------------------+
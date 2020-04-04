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

string signalMain, signalTrend, closePosisi, komen;

double KArray[];

double DArray[];


double KArrayTrend[];
double DArrayTrend[];


int StohasticUtama;
int stohasticTrend;


double Ask, Bid;


double K;
double D;


double KTrend;
double DTrend;


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
input ENUM_TIMEFRAMES stohasticTrendTime = PERIOD_H4;


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
stohasticTrend = iStochastic( _Symbol, stohasticTrendTime, KPeriod, DPeriod, Slowing, IndicatorMode, IndicatorPrice );

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


ObjectCreate(0,"labelTrend",OBJ_LABEL,0,0,0,0,0,0,0);
ObjectSetString(0,"labelTrend",OBJPROP_TEXT,"Trend is:"); 
ObjectSetInteger(0,"labelTrend",OBJPROP_XDISTANCE,50);
ObjectSetInteger(0,"labelTrend",OBJPROP_YDISTANCE,140);
ObjectSetInteger(0,"labelTrend",OBJPROP_CORNER,CORNER_LEFT_UPPER);
ObjectSetInteger(0,"labelTrend",OBJPROP_COLOR,clrAliceBlue);


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

ArraySetAsSeries( KArrayTrend, true );

ArraySetAsSeries( DArrayTrend, true );




CopyBuffer( StohasticUtama, 0, 0, 3, KArray );

CopyBuffer( StohasticUtama, 1, 0, 3, DArray );

CopyBuffer( stohasticTrend, 0, 0, 3, KArrayTrend );

CopyBuffer( stohasticTrend, 1, 0, 3, DArrayTrend );



K = KArray[0];

D = DArray[0];


KTrend = KArrayTrend[1];

DTrend = DArrayTrend[1];


////=========== end initialize value and array ===============//////////////


///============ Strat trend identifcation ==================///////////////

if(  KTrend > 20 && DTrend > 20 && KTrend < 80 && DTrend < 80 && KTrend > DTrend ){
   signalTrend = "Buy";
}

if(  KTrend > 20 && DTrend > 20 && KTrend < 80 && DTrend < 80 && KTrend < DTrend ){
   signalTrend = "Sell";
}

if(  KTrend < 20 && DTrend < 20 ){
   signalTrend = "Danger Buy";
}

if(  KTrend > 80 && DTrend > 80 ){
   signalTrend = "Danger Sell";
}
///============ End trend identifcation ==================///////////////



////=========== start blok buy ===============//////////
if( posisiBuy == true || posisiSell == true ){
   posisi = true;
}else{
   posisi = false;
}

// Over Sell
if( D < 20 && K < 20 && overSell == false && posisi == false ){
   overSell = true;
   overBuy = false;
   //Alert("Over Sell");
   komen = "Over Sell";
}

// open buy
if( overSell == true && K > D && D > 20 && K > 20 && posisiBuy == false && ( signalTrend == "Buy" || signalTrend == "Danger Sell" ) ){
   
   
   //Alert("Open Buy");
   komen = "Open Buy";
   
   if( trade.Buy( 0.10, NULL, Ask, 0, 0, NULL ) )
   {
      //Alert("Open Buy Success");
      //komen = "Open Buy Success";
      //posisiBuy = true;
      //overSell = false;
      if( PositionsTotal() >= 1 ){
         komen = "Open Buy Success";
         posisiBuy = true;
         overSell = false;
      }
   }else{
      //Alert("Open Buy Failed");
      komen = "Open Buy Failed";
   }
}


// take profit buy
if( K < D && D > 50 && K > 50 && posisiBuy == true ){
   
   Alert("Take Profit Buy");
   
   if( trade.PositionClose( _Symbol, 5 ) ){
      //Alert("Take Profit Buy Success");
      //komen = "Take Profit Buy Success";
      //posisiBuy = false;
      if( PositionsTotal() < 1 ){
         komen = "Take Profit Buy Success";
         posisiBuy = false;
      }
   }else{
      //Alert("Take Profit Buy Failed");
      komen = "Take Profit Buy Failed";
   }
}

// stop lose buy
if( K < D && D < 15 && K < 15 && posisiBuy == true ){

   //Alert("Stop Lose Buy");
   komen = "Stop Lose Buy";
   
   if( trade.PositionClose( _Symbol, 5 ) ){
      //Alert("Stop Lose Buy Success");
      //komen = "Stop Lose Buy Success";
      //posisiBuy = false;
      if( PositionsTotal() < 1 ){
         komen = "Stop Lose Buy Success";
         posisiBuy = false;
      }
   }else{
      //Alert("Stop Lose Buy Failed");
      komen = "Stop Lose Buy Failed";
   }
}
////=========== end blok buy ===============//////////////



////=========== start blok sell ===============//////////
// Over Buy
if( D > 80 && K > 80 && overBuy == false && posisi == false ){
   overBuy = true;
   overSell = false;
   //Alert("Over Buy");
   komen = "Over Buy";
}

// open sell
if( overBuy == true && K < D && D < 80 && K < 80 && posisiSell == false && ( signalTrend == "Sell" || signalTrend == "Danger Buy" ) ){
   
   
   //Alert("Open Sell");
   komen = "Open Sell";
   
   if( trade.Sell( 0.10, NULL, Bid, 0, 0, NULL ) )
   {
      //Alert("Open Sell Success");
      //komen = "Open Sell Success";
      //posisiSell = true;
      //overBuy = false;
      if( PositionsTotal() >= 1 ){
         komen = "Open Sell Success";
         posisiSell = true;
         overBuy = false;
      }
   }else{
      //Alert("Open Sell Failed");
      komen = "Open Sell Failed";
   }
   
}


// take profit sell
if( K > D && D < 50 && K < 50 && posisiSell == true ){
   
   //Alert("Take Profit Sell");
   komen = "Take Profit Sell";
   
   if( trade.PositionClose( _Symbol, 5 ) ){
      //Alert("Take Profit Sell Success");
      //komen = "Take Profit Sell Success";
      //posisiSell = false;
      if( PositionsTotal() < 1 ){
         komen = "Take Profit Sell Success";
         posisiSell = false;
      }
   }else{
      //Alert("Take Profit Sell Failed");
      komen = "Take Profit Sell Failed";
   }
}

// stop lose sell
if( K > D && D > 85 && K > 85 && posisiSell == true ){
   
   //Alert("Stop Lose Sell");
   komen = "Stop Lose Sell";
   
   if( trade.PositionClose( _Symbol, 5 ) ){
      //Alert("Stop Lose Sell Success");
      //komen = "Stop Lose Sell Success";
      //posisiSell = false;
      if( PositionsTotal() < 1 ){
         komen = "Stop Lose Sell Success";
         posisiSell = false;
      }
   }else{
      //Alert("Stop Lose Sell Failed");
      komen = "Stop Lose Sell Failed";
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


ObjectCreate(0,"labelTrendValue",OBJ_LABEL,0,0,0,0,0,0,0);
ObjectSetString(0,"labelTrendValue",OBJPROP_TEXT,signalTrend); 
ObjectSetInteger(0,"labelTrendValue",OBJPROP_XDISTANCE,120);
ObjectSetInteger(0,"labelTrendValue",OBJPROP_YDISTANCE,140);
ObjectSetInteger(0,"labelTrendValue",OBJPROP_CORNER,CORNER_LEFT_UPPER);
ObjectSetInteger(0,"labelTrendValue",OBJPROP_COLOR,clrAliceBlue);
////=========== end blok buy ===============//////////////


// Start Coment
Comment( "Coment: ", komen );
// End Coment


  }
//+------------------------------------------------------------------+
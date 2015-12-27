#include <reg52.h>

#include "MacroAndConst.h"
#include "Timer.h"

BOOL g_bSystemTime1Ms=0;

void Timer0Init(void)
{
	TMOD &=0xf0;
	TMOD |=0x01;
	TH0 =0xFC;
	TL0 =0x66;
	TR0 =1;
	ET0 =1;
	
}

void Time0lsr(void) interrupt 1
{
	TH0=0xfc;
	TL0=0x66;
	g_bSystemTime1Ms =1;
}



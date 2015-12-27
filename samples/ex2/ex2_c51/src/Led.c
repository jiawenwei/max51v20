#include <reg52.h>

#include "MacroAndConst.h"
#include "Timer.h"
#include "Led.h"

static uint16 g_u16LedTimeCount =0;
static uint8  g_u8LedState =0;

sbit LED_1  =P1^3;
sbit LED_2  =P1^4;

void LedInit(void)
{
	LED_1 =0;
	LED_2 =0;
}

void LedProcess (void)
{
	if(0==g_u8LedState)
	{
		LED_1 =0;
		LED_2 =0;
	}
	else
	{
		LED_1 =1;
		LED_2 =1;
	}
}

void LedStateChange(void)
{
	if(g_bSystemTime1Ms)
	{
		g_bSystemTime1Ms=0;
		g_u16LedTimeCount++;
		
		if(g_u16LedTimeCount >=500)
		{
			g_u16LedTimeCount =0;
			g_u8LedState =!g_u8LedState;
		}
	}
}




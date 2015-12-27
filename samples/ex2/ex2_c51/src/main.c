//max51v20 ex2
#include <reg52.h>
#include "MacroAndConst.h"
#include "Timer.h"
#include "Led.h"

void main(void)
{
	LedInit();
	Timer0Init();
	EA=1;

	while(1)
	{
		LedProcess();
		LedStateChange();
	}
	
}


/*
** ----------------------------------------------------------------------------
** COMPILER.H
** ----------------------------------------------------------------------------
** Module:     CATS System    
**-----------------------------------------------------------------------------
** Company:    Matra MHS - Temic
** Created:	25/04/97
** $Author: jberthy $
** $Revision: 1.2 $
** $Date: 2001/01/24 09:09:19 $
** ----------------------------------------------------------------------------
** Comments:
** This file redefines dedicated KEIL and TASKINKG C51/C251 keywords in order 
** to ensure that any source file can be processed by both compilers.
** ----------------------------------------------------------------------------
*/

#ifndef _COMPILER_H_
#define _COMPILER_H_

/*
** Header inclusion
*/

/* 
** Type Definition
*/

typedef unsigned char		Uchar;
typedef unsigned int 		Uint16;
typedef int 				Int16;
typedef float              Float16;
typedef unsigned long int 	Uint32;
typedef long int 			Int32;
typedef unsigned char		Bool;

/* 
** Defines 
*/

/* General purpose defines */
#define FALSE	0
#define TRUE	1
#define OFF    0
#define ON     1
#define CLR    0
#define SET    1
#define LOW(U16)   ((Uchar)U16)
#define HIGH(U16)  ((Uchar)(U16>>8))	
#define TST_BIT_X(addrx,mask) 	(*addrx & mask)
#define SET_BIT_X(addrx,mask)	(*addrx = (*addrx | mask))
#define CLR_BIT_X(addrx,mask) 	(*addrx = (*addrx & ~mask))
#define OUT_X(addrx,value)     (*addrx = value)
#define IN_X(addrx)			(*addrx)
/***********************************************************
 SET_SFR_BIT macro 
  parameters 
    sfr_reg : defined value in include file for sfr register 
    bit_pos : defined value B_XX in include file for particular
              bit of sfr register 
    bit_val : CLR / SET 
************************************************************/
#define SET_SFR_BIT(sfr_reg, bit_pos, bit_val) { sfr_reg &= ~(1<<(bit_pos)); sfr_reg |= ((bit_val)<<(bit_pos));}

/***********************************************************
 TST_SFR_BIT macro 
  parameters 
    sfr_reg : defined value in include file for sfr register 
    bit_pos : defined value B_XX in include file for particular
              bit of sfr register 
************************************************************/
#define TST_SFR_BIT(sfr_reg, bit_pos) ((sfr_reg & (1<<(bit_pos)))>>(bit_pos))

/* KEIL compiler */
#ifdef KEIL
#define Reentrant(x)	x reentrant
#define Sfr(x,y)		sfr x = y
#define Sfr16(x,y)		sfr16 x = y
#define Sbit(x,y,z)		sbit x = y ^ z
#define Interrupt(x,y)	x interrupt y
#define At(x)			_at_ x

#ifdef __C51__     /* C51 Compiler */
#define far  xdata      /* far is for 251 only */
#endif

#endif             /* End of KEIL */

/* RAISONANCE compiler */
#ifdef RAISONANCE
#define Reentrant(x)	x reentrant
#define Sfr(x,y)		sfr x = y
#define Sfr16(x,y)		sfr16 x = y
#define Sbit(x,y,z)	sbit x = y ^ z
#define Interrupt(x,y)	x interrupt y
#define At(x)			_at_ x

#ifdef __C51__     /* C51 Compiler */
#define far  xdata      /* far is for 251 only */
#endif

#endif             /* End of RAISONANCE */

/*
** KEIL memory type qualifiers are kept as the reference language
*/
#ifdef TASKING
#include <keil.h>		/* Some job already done! */

#define far 			_far
#define Reentrant(x)	_reentrant x
#define Sfr(x,y)		_sfrbyte x _at(y)
#define Sbit(x,y,z)	_sfrbit x _atbit(y,z)
#define Interrupt(x,y)	_interrupt(y) x
#endif

#endif /* _COMPILER_H_ */



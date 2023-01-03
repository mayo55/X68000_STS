* S_DAT
*
* AFM STR IMPAIL PLANE_MAX
* PATTERN_CODE POINTER_1 еее PC P8
*
*   56 Bytes
*
	.xdef	S_DAT
	.xdef	ITEMRND,ITEMPC,P_ITEM0
	.xdef	P_ITEM1,P_ITEM2,P_ITEM3,P_ITEM4,P_ITEM5,P_ITEM6,P_ITEM7,P_ITEM8
	.xdef	WPNMAX,IR

WPNMAX:	equ	11
IR:	equ	64

	.data

S_DAT:
S_DAT0:	dc.w	40,1,0,14+1	* NORMAL
	dc.w	$0102
	dc.l	forw
	dc.w	0,0,0_,0,0,0_,0,0,0_,0,0,0_,0,0,0_,0,0,0_,0,0,0_

S_DAT1:	dc.w	40,1,1,3+1	* LASER
	dc.w	$014B
	dc.l	forwsl
	dc.w	0,0,0_,0,0,0_,0,0,0_,0,0,0_,0,0,0_,0,0,0_,0,0,0_

S_DAT2:	dc.w	4,1,0,8+1	* AUTO
	dc.w	$0102
	dc.l	forw
	dc.w	0,0,0_,0,0,0_,0,0,0_,0,0,0_,0,0,0_,0,0,0_,0,0,0_

S_DAT3:	dc.w	40,1,0,14+1	* TAIL
	dc.w	$0102
	dc.l	forw
	dc.w	$4102
	dc.l	back
	dc.w	0,0,0_,0,0,0_,0,0,0_,0,0,0_,0,0,0_,0,0,0_

S_DAT4:	dc.w	40,1,0,14+1	* UP DOWN
	dc.w	$8149
	dc.l	up
	dc.w	$0149
	dc.l	down
	dc.w	0,0,0_,0,0,0_,0,0,0_,0,0,0_,0,0,0_,0,0,0_

S_DAT5:	dc.w	40,1,0,14+1	* 3 WAY
	dc.w	$0102
	dc.l	forw
	dc.w	$0148
	dc.l	ru
	dc.w	$8148
	dc.l	rd
	dc.w	0,0,0_,0,0,0_,0,0,0_,0,0,0_,0,0,0_

S_DAT6:	dc.w	40,1,0,14+1	* FORWARD & BACK 3 WAY
	dc.w	$0102
	dc.l	forw
	dc.w	$0D17
	dc.l	back
	dc.w	$0D17
	dc.l	lu
	dc.w	$0D17
	dc.l	ld
	dc.w	0,0,0_,0,0,0_,0,0,0_,0,0,0_

S_DAT7:	dc.w	40,1,0,10+1	* 5 WAY
	dc.w	$0102
	dc.l	forw
	dc.w	$014C
	dc.l	rusm
	dc.w	$814C
	dc.l	rdsm
	dc.w	$0148
	dc.l	rusl
	dc.w	$8148
	dc.l	rdsl
	dc.w	0,0,0_,0,0,0_,0,0,0_

S_DAT8:	dc.w	40,4,0,1+1	* SOUKOUDAN
	dc.w	$014A
	dc.l	forwvs
	dc.w	0,0,0_,0,0,0_,0,0,0_,0,0,0_,0,0,0_,0,0,0_,0,0,0_

S_DAT9:	dc.w	40,1,0,10+1	* WIDE
	dc.w	$0A06
	dc.l	forw
	dc.w	$0907
	dc.l	ms2
	dc.w	$0907
	dc.l	ms4
	dc.w	$0A06
	dc.l	ms1
	dc.w	$0A06
	dc.l	ms5
	dc.w	0,0,0_,0,0,0_,0,0,0_

S_DAT10:dc.w	40,2,0,8+1	* RING
	dc.w	$0A4E
	dc.l	roll
	dc.w	0,0,0_,0,0,0_,0,0,0_,0,0,0_,0,0,0_,0,0,0_,0,0,0_

S_DAT11:dc.w	40,1,1,8+1	* IMPAIL RING
	dc.w	$014F
	dc.l	roll
	dc.w	0,0,0_,0,0,0_,0,0,0_,0,0,0_,0,0,0_,0,0,0_,0,0,0_

forw:	dc.b	$40,$40
	dc.b	$88,0
	dc.l	forw

forwsl:	dc.b	$40,$30
	dc.b	$88,0
	dc.l	forwsl

back:	dc.b	$C0,$C0
	dc.b	$88,0
	dc.l	back

up:	dc.b	$0C,$0C
	dc.b	$88,0
	dc.l	up

down:	dc.b	$04,$04
	dc.b	$88,0
	dc.l	down

ru:	dc.b	$4C,$4C
	dc.b	$88,0
	dc.l	ru

rd:	dc.b	$44,$44
	dc.b	$88,0
	dc.l	rd

lu:	dc.b	$CC,$CC
	dc.b	$88,0
	dc.l	lu

ld:	dc.b	$C4,$C4
	dc.b	$88,0
	dc.l	ld

rusm:	dc.b	$4E,$4E
	dc.b	$88,0
	dc.l	rusm

rdsm:	dc.b	$42,$42
	dc.b	$88,0
	dc.l	rdsm

rusl:	dc.b	$4C,$3D
	dc.b	$88,0
	dc.l	rusl

rdsl:	dc.b	$44,$33
	dc.b	$88,0
	dc.l	rdsl

forwvs:	dc.b	$30,$30
	dc.b	$88,0
	dc.l	forwvs

roll:	dc.b	$0C,$1C,$3C,$3E,$3F,$20,$41,$22,$34,$14,$04,$04,$F4,$D4,$D2,$D1
	dc.b	$E0,$CF,$EE,$DC,$FC,$0C
	dc.b	$0C,$1C,$3C,$3E,$3F,$20,$41,$22,$34,$14,$04,$04,$F4,$D4,$D2,$D1
	dc.b	$E0,$CF,$EE,$DC,$FC,$0C
	dc.b	$0C,$1C,$3C,$3E,$3F,$20,$41,$22,$34,$14,$04,$04,$F4,$D4,$D2,$D1
	dc.b	$E0,$CF,$EE,$DC,$FC,$0C
	dc.b	$0C,$1C,$3C,$3E,$3F,$20,$41,$22,$34,$14,$04,$04,$F4,$D4,$D2,$D1
	dc.b	$E0,$CF,$EE,$DC,$FC,$0C
	dc.b	$0C,$1C,$3C,$3E,$3F,$20,$41,$22,$34,$14,$04,$04,$F4,$D4,$D2,$D1
	dc.b	$E0,$CF,$EE,$DC,$FC,$0C
	dc.b	$0C,$1C,$3C,$3E,$3F,$20,$41,$22,$34,$14,$04,$04,$F4,$D4,$D2,$D1
	dc.b	$E0,$CF,$EE,$DC,$FC,$0C
	dc.b	$0C,$1C,$3C,$3E,$3F,$20,$41,$22,$34,$14,$04,$04,$F4,$D4,$D2,$D1
	dc.b	$E0,$CF,$EE,$DC,$FC,$0C
	dc.b	$0C,$1C,$3C,$3E,$3F,$20,$41,$22,$34,$14,$04,$04,$F4,$D4,$D2,$D1
	dc.b	$E0,$CF,$EE,$DC,$FC,$0C
	dc.b	$88,1

ms2:	dc.b	$4C,$40
loop1:	dc.b	$40,$40
	dc.b	$88,0
	dc.l	loop1

ms4:	dc.b	$44,$40
loop2:	dc.b	$40,$40
	dc.b	$88,0
	dc.l	loop2

ms1:	dc.b	$4C,$4C
loop3:	dc.b	$40,$40
	dc.b	$88,0
	dc.l	loop3

ms5:	dc.b	$44,$44
loop4:	dc.b	$40,$40
	dc.b	$88,0
	dc.l	loop4

ITEMRND:dc.b	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.b	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
	dc.b	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
	dc.b	2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
	dc.b	2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
	dc.b	3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3
	dc.b	4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4
	dc.b	5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5
	dc.b	5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5
	dc.b	6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6
	dc.b	6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6
	dc.b	7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7
	dc.b	8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
	dc.b	9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
	dc.b	10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10
	dc.b	11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11

ITEMPC:	dc.l	PC_I0	* NORMAL
	dc.l	PC_I1	* LASER
	dc.l	PC_I2	* AUTO
	dc.l	PC_I3	* TAIL
	dc.l	PC_I4	* SIDE(UP DOWN)
	dc.l	PC_I5	* 3 WAY
	dc.l	PC_I6	* 4 WAY(FORWARD & BACK 3 WAY)
	dc.l	PC_I7	* 5 WAY
	dc.l	PC_I8	* MISSLE(SOULOUDAN)
	dc.l	PC_I9	* WIDE
	dc.l	PC_I10	* RING
	dc.l	PC_I11	* IMPAIL RING

P_ITEM0:dc.b	$F0,$00
	dc.b	$88,0
	dc.l	P_ITEM0

P_ITEM1:dc.b	$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE
L_PI1:	dc.b	$F0,$00
	dc.b	$88,0
	dc.l	L_PI1

P_ITEM2:dc.b	$EF,$EF,$EF,$EF,$EF,$EF,$EF,$EF,$EF,$EF,$EF,$EF,$EF,$EF,$EF,$EF
L_PI2:	dc.b	$F0,$00
	dc.b	$88,0
	dc.l	L_PI2

P_ITEM3:dc.b	$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1
L_PI3:	dc.b	$F0,$00
	dc.b	$88,0
	dc.l	L_PI3

P_ITEM4:dc.b	$F2,$F2,$F2,$F2,$F2,$F2,$F2,$F2,$F2,$F2,$F2,$F2,$F2,$F2,$F2,$F2
L_PI4:	dc.b	$F0,$00
	dc.b	$88,0
	dc.l	L_PI4

P_ITEM5:dc.b	$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12
L_PI5:	dc.b	$F0,$00
	dc.b	$88,0
	dc.l	L_PI5

P_ITEM6:dc.b	$21,$21,$21,$21,$21,$21,$21,$21,$21,$21,$21,$21,$21,$21,$21,$21
L_PI6:	dc.b	$F0,$00
	dc.b	$88,0
	dc.l	L_PI6

P_ITEM7:dc.b	$2F,$2F,$2F,$2F,$2F,$2F,$2F,$2F,$2F,$2F,$2F,$2F,$2F,$2F,$2F,$2F
L_PI7:	dc.b	$F0,$00
	dc.b	$88,0
	dc.l	L_PI7

P_ITEM8:dc.b	$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E
L_PI8:	dc.b	$F0,$00
	dc.b	$88,0
	dc.l	L_PI8

PC_I0:	dc.w	$150,$150
	dc.w	$FFFF
	dc.l	PC_I0

PC_I1:	dc.w	$151,$151
	dc.w	$FFFF
	dc.l	PC_I1

PC_I2:	dc.w	$152,$152
	dc.w	$FFFF
	dc.l	PC_I2

PC_I3:	dc.w	$953,$953
	dc.w	$FFFF
	dc.l	PC_I3

PC_I4:	dc.w	$954,$954
	dc.w	$FFFF
	dc.l	PC_I4

PC_I5:	dc.w	$955,$955
	dc.w	$FFFF
	dc.l	PC_I5

PC_I6:	dc.w	$956,$956
	dc.w	$FFFF
	dc.l	PC_I6

PC_I7:	dc.w	$957,$957
	dc.w	$FFFF
	dc.l	PC_I7

PC_I8:	dc.w	$158,$158
	dc.w	$FFFF
	dc.l	PC_I8

PC_I9:	dc.w	$959,$959
	dc.w	$FFFF
	dc.l	PC_I9

PC_I10:	dc.w	$A5B,$A5B
	dc.w	$FFFF
	dc.l	PC_I10

PC_I11:	dc.w	$15C,$15C
	dc.w	$FFFF
	dc.l	PC_I11

	.end

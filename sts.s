	.include	doscall.mac
	.include	iocscall.mac
	.include	fefunc.h

	.xref	E_SPAT,S_DAT
	.xref	ITEMRND,ITEMPC,P_ITEM0
	.xref	P_ITEM1,P_ITEM2,P_ITEM3,P_ITEM4,P_ITEM5,P_ITEM6,P_ITEM7,P_ITEM8
	.xref	WPNMAX,IR

GRAMAD:	equ	$C00000
GPALAD:	equ	$E82000
CRTCGS:	equ	$E80018
SSRAD:	equ	$EB0000
SPATAD:	equ	$EB8000
SPALAD:	equ	$E82220
BGADDR:	equ	$EBF000		* Y=256

RISUN:	equ	18
RISUN2:	equ	51
SNAKEN:	equ	49

* LOOP9,13,17 JUMP4,49,59,60,61,64,91,92,93 SP_SET2  ÇkÇnÇrÇs

* LOOP 1-54 USED
* JUMP 1-95 USED

	.text	************************************************************************

SCTRL:	tst.b	(A2)
	beq	SUPER
	movea.l	A2,A0
	addq.l	#1,A0
	dc.w	__STOH
	move.w	D0,SPEED

SUPER:	clr.l	-(SP)
	dc.w	_SUPER
	addq.l	#4,SP
	move.l	D0,SSPBUF
	move.l	USP,A0
	move.l	A0,USPBUF

	bsr	CRT
	bsr	GPALET
	bsr	SSRINIT		* X:0 Y:0 EX_PC:0 PRW:0
	moveq.l	#_SP_ON,D0	* sp_disp(1)
	trap	#15

	bsr	RNDINIT
	bsr	BGINIT
	bsr	VER_PRN
	bsr	TIT_P
	bsr	ASDW
	bsr	ASDW2

SECRET:	moveq.l	#_BITSNS,D0
	move.w	#$C,D1
	trap	#15
	btst.l	#6,D0
	beq	JUMP62
	move.w	#1,UNDEAD	* UNDEAD
	addq.b	#1,SCORE+1
JUMP62:
	bsr	VER_DEL

	lea	GRAMAD+$180000,A0
	move.w	#511,D4
	move.l	#$00050004,D5
	move.w	#1,D6
	bsr	STAR
	lea	GRAMAD+$100000,A0
	move.w	#255,D4
	move.l	#$00030002,D5
	move.w	#0,D6
	bsr	STAR2
	lea	GRAMAD+$80000,A0
	move.w	#15,D4
	move.l	#$00010001,D5
	move.w	#0,D6
	bsr	STAR2

	lea	BGADDR+4*2,A0
	lea	MSG_SC,A1
	bsr	BG_PRN
	move.l	SCORE,D0
	bsr	SC_PRN

TITLE:	bsr	SP_OFFA
	move.w	#%0000000001101111,D0
	bsr	VPAGE
	clr.b	D2
	move.l	#$1_0000,XSCSP
	move.l	#$0_0000,YSCSP

LOOP43:	lea	BGADDR+22*128+10*2,A0
	lea	MSG_TIT,A1
	subq.b	#1,D2
	btst.l	#5,D2
	bne	JUMP58
	lea	MSG_TDL,A1
JUMP58:	bsr	BG_PRN
	bsr	GSCROLL
	bsr	WAIT
SPACE4:	moveq.l	#_BITSNS,D0
	move.w	#6,D1
	trap	#15
	btst.l	#5,D0
	bne	END
TRIG:	moveq.l	#_JOYGET,D0
	clr.w	D1
	trap	#15
	btst.l	#5,D0		* TRIGGER 1
	bne	LOOP43

	move.w	#%0000000001101110,D0
	bsr	VPAGE

	move.w	0(A4),AF

	lea	BGADDR+22*128+10*2,A0
	lea	MSG_TDL,A1
	bsr	BG_PRN

	move.w	#64,X
	move.w	#136,Y
	move.w	#3-1,MYSHIP

	move.l	#$00010000,TS
	move.l	#E_SPAT,E_SPPO
	clr.w	STAGE
	clr.w	READYC

	clr.l	D0
	move.l	D0,SCORE
	bsr	SC_PRN

	lea	BGADDR+1*128,A0
	move.w	MYSHIP,D0
	subq.w	#2,D0
LOOP36:	move.w	#$013C,(A0)+
	dbf	D0,LOOP36

JUMP26:	clr.w	BC
	clr.w	DEAD
	clr.w	SPWAIT
	clr.w	WEAPON
	bsr	WASET

	lea	S_TABLE,A0
	move.w	#14*8,D0
	bsr	WRKCLR

	lea	B_TABLE,A0
	move.w	#38*2,D0
	bsr	WRKCLR

	lea	T_TABLE,A0
	move.w	#24*64,D0
	bsr	WRKCLR

	lea	E_TABLE,A0
	move.w	#34*32,D0
	bsr	WRKCLR

WHILE:
SPACE1:	moveq.l	#_BITSNS,D0
	move.w	#6,D1
	trap	#15
	btst.l	#5,D0
	bne	END

ESC1:	moveq.l	#_BITSNS,D0
	move.w	#0,D1
	trap	#15
	btst.l	#1,D0
	beq	JUMP52
	tst.w	ESCFLUG
	bne	TAB
SPACE2:	moveq.l	#_BITSNS,D0
	move.w	#6,D1
	trap	#15
	btst.l	#5,D0
	bne	END
ESC2:	moveq.l	#_BITSNS,D0
	move.w	#0,D1
	trap	#15
	btst.l	#1,D0
	bne	SPACE2
SPACE3:	moveq.l	#_BITSNS,D0
	move.w	#6,D1
	trap	#15
	btst.l	#5,D0
	bne	END
ESC3:	moveq.l	#_BITSNS,D0
	move.w	#0,D1
	trap	#15
	btst.l	#1,D0
	beq	SPACE3
	move.w	#1,ESCFLUG
	bra	TAB
JUMP52:	clr.w	ESCFLUG

TAB:	moveq.l	#_BITSNS,D0
	move.w	#2,D1
	trap	#15
	btst.l	#0,D0
	beq	JUMP51
	tst.w	TABFLUG
	bne	CTRL
	move.w	#1,TABFLUG
	clr.w	SPWAIT
	movea.l	E_SPPO,A0
LOOP39:	cmpi.w	#$F007,(A0)
	beq	JUMP50
	cmpi.w	#$F000,(A0)+
	bne	LOOP39
	subq.l	#2,A0
JUMP50:	move.l	A0,E_SPPO
	bra	CTRL
JUMP51:	clr.w	TABFLUG

CTRL:	moveq.l	#_BITSNS,D0
	move.w	#$E,D1
	trap	#15
	btst.l	#1,D0
	beq	JUMP86
	tst.w	CTRLFLG
	bne	JUMP85
	move.w	#1,CTRLFLG
	addq.w	#1,WEAPON
	bsr	WASET
	cmpi.w	#WPNMAX+1,WEAPON
	bne	JUMP85
	clr.w	WEAPON
	bsr	WASET
	bra	JUMP85

JUMP86:	clr.w	CTRLFLG

JUMP85:	tst.w	READYC
	beq	JUMP76
	subq.w	#1,READYC
	bra	JUMP77
JUMP76:	lea	BGADDR+16*128+12*2,A0
	lea	MSG_RD,A1
	bsr	BG_PRN

JUMP77:	move.w	DEAD,D0
	beq	JUMP24

	lea	MBC,A0
	adda.w	D0,A0
	adda.w	D0,A0
	move.w	(A0),D3
	clr.w	D0
	move.w	X,D1
	move.w	Y,D2
	move.w	#1,D4
	bsr	SP_SET
	move.w	#1,D0
	bsr	SP_OFF
	addq.w	#1,DEAD
	cmpi.w	#240,DEAD
	beq	BACK
	bra	JUMP5

JUMP24:	clr.w	D0
	move.w	X,D1
	move.w	Y,D2
	move.w	#$0101,D3
	move.w	#1,D4
	bsr	SP_SET
	move.w	#1,D0
	sub.w	#16,D1
	lea	BP,A0
	move.w	BC,D5
	asl.w	#1,D5
	move.w	(A0,D5.w),D3
	bsr	SP_SET
	move.w	BC,D0
	addq.w	#1,D0
	and.w	#3,D0
	move.w	D0,BC

STICK:	moveq.l	#_JOYGET,D0
	clr.w	D1		* JOY STICK 1
	trap	#15
	move.w	D0,D7
	and.w	#$000F,D0
	rol.w	#1,D0

	lea	PX,A0
	move.w	X,D1
	add.w	(A0,D0.w),D1
	cmpi.w	#16,D1
	bcs	JUMP1
	cmpi.w	#241,D1
	bcc	JUMP1
	move.w	D1,X

JUMP1:	lea	PY,A0
	move.w	Y,D1
	add.w	(A0,D0.w),D1
	cmpi.w	#24,D1
	bcs	JUMP2
	cmpi.w	#257,D1
	bcc	JUMP2
	move.w	D1,Y

JUMP2:	move.w	D7,D0
	btst.l	#5,D0		* TRIGGER 1
	bne	JUMP6
	tst.w	AF		* AUTO FLUG CHECK
	bne	JUMP3

S_SET:	movea.l	WADRS,A4

	move.w	0(A4),AF	* AUTO FLUG SET
	lea	8(A4),A5
	move.w	#8-1,D5
LOOP48:	bsr	S_SPN
	bmi	JUMP3
	move.w	X,D1
	addq.w	#2,D1
	move.w	D1,0(A3)
	move.w	Y,D2
	add.w	#9,D2
	move.w	D2,2(A3)
	move.w	(A5)+,D3
	move.w	#1,D4
	bsr	SP_SET
	move.w	2(A4),6(A3)
	move.w	4(A4),8(A3)
	move.l	(A5)+,10(A3)
	tst.w	(A5)
	dbeq	D5,LOOP48

JUMP3:	subq.w	#1,AF
	bcc	JUMP5
JUMP6:	clr.w	AF

JUMP5:	bsr	S_MOVE

E_CTRL1:movea.l	E_SPPO,A0
	move.w	(A0)+,D1
	move.l	A0,E_SPPO
	cmpi.w	#$FFFF,D1
	beq	END
	tst.w	D1
	beq	E_CTRL2
	bsr	SPCTRL
	beq	E_CTRL1
E_CTRL2:bsr	E_MOVE
	bsr	B_MOVE

TAMA:	bsr	T_CTRL
	bsr	A_CTRL
	bsr	T_MOVE

CHECK:	bsr	SE_CHK
	bsr	ME_CHK
	bsr	MT_CHK
	bsr	MB_CHK
	bsr	SB_CHK

SCROLL:	bsr	GSCROLL

	bsr	WAIT

ENDWHILE:
	bra	WHILE

END:	move.l	USPBUF,A0
	move.l	A0,USP
	move.l	SSPBUF,-(SP)
	dc.w	_SUPER
	addq.l	#4,SP

	move.w	#17,-(SP)	* CURSOL ON
	dc.w	_CONCTRL
	addq.l	#2,SP
	clr.w	-(SP)
	dc.w	_KFLUSH

	dc.w	_EXIT


***************     ÇrÇtÇa     ***************
STAR:	move.l	#$00040000,D0	* CALL
	dc.w	__LTOD		*   A0  : G-RAM START ADDR
	move.l	D0,D2		*   D4.W: LOOP-1
	move.l	D1,D3		*   D5.L: (COLOR 2)*65536+(COLOR 1)
	dc.w	__RND		*
	dc.w	__DMUL		* BREAK: D0-D5
	dc.w	__DTOL
	asl.l	#1,D0
	move.w	D5,(A0,D0.l)
	swap	D5
	bsr	GSCROLL
	bsr	WAIT2
	dbf	D4,STAR
	rts

STAR2:	move.l	#$00040000,D0	* CALL
	dc.w	__LTOD		*   A0  : G-RAM START ADDR
	move.l	D0,D2		*   D4.W: LOOP-1
	move.l	D1,D3		*   D5.L: (COLOR 2)*65536+(COLOR 1)
	dc.w	__RND		*
	dc.w	__DMUL		* BREAK: D0-D6
	dc.w	__DTOL
	asl.l	#1,D0
	move.w	D5,(A0,D0.l)
	swap	D5
	btst.l	#0,D4
	beq	JUMP57
	bsr	GSCROLL
	bsr	WAIT2
JUMP57:	dbf	D4,STAR
	rts

TIT_P:	move.w	#%0000000001100000,D0
	bsr	VPAGE

	lea	SYM_XYP,A0
	move.w	#28,D1

LOOP42:	moveq.l	#_SYMBOL,D0
	lea	SYM_PAR,A1
	move.w	0(A0),0(A1)
	move.w	2(A0),2(A1)
	move.w	4(A0),10(A1)
	trap	#15
	addq.l	#6,A0
	dbf	D1,LOOP42

	move.b	#%0000000001101111,D0
	bsr	VPAGE
	rts

CRT:	moveq.l	#_CRTMOD,D0
	move.w	#6,D1		* screen 0,1,1,1
	trap	#15
	move.w	#18,-(SP)	* CURSOL OFF
	dc.w	_CONCTRL
	addq.l	#2,SP
	moveq.l	#_G_CLR_ON,D0
	trap	#15
	rts

SSRINIT:lea	SSRAD,A0
	move.w	#255,D0
LOOP3:	clr.l	(A0)+
	dbf	D0,LOOP3
	rts

GPALET:	lea	PD,A0
	lea	GPALAD,A1
	move.w	#15,D0
LOOP4:	move.w	(A0)+,(A1)+
	dbf	D0,LOOP4
	rts

GSCROLL:move.l	D0,-(SP)
	move.l	XSCSP,D0
	add.l	D0,HX
	move.w	HX,D0
	andi.w	#$00FF,D0
	asl.w	#1,D0
	move.w	D0,CRTCGS+4
	move.w	HX,D0
	move.w	D0,CRTCGS+8
	ror.w	#1,D0
	move.w	D0,CRTCGS+12
	move.l	YSCSP,D0
	add.l	D0,HY
	move.w	HY,D0
	andi.w	#$00FF,D0
	asl.w	#1,D0
	move.w	D0,CRTCGS+6
	move.w	HY,D0
	move.w	D0,CRTCGS+10
	ror.w	#1,D0
	move.w	D0,CRTCGS+14
	move.l	(SP)+,D0
	rts

WAIT:	move.l	D0,-(SP)
	moveq.l	#_B_SFTSNS,D0
	trap	#15
	btst.l	#11,D0
	bne	WAITR
	move.w	SPEED,D0
LOOP10:	dbf	D0,LOOP10
WAITR:	move.l	(SP)+,D0
	rts

WAIT2:	move.l	D0,-(SP)
	moveq.l	#_B_SFTSNS,D0
	trap	#15
	btst.l	#11,D0
	bne	WAIT2R
	move.w	SPEED,D0
	asr.w	#1,D0
LOOP44:	dbf	D0,LOOP44
WAIT2R:	move.l	(SP)+,D0
	rts

RNDINIT:move.l	#256,D0
	dc.w	__LTOD
	move.l	D0,D2
	move.l	D1,D3
	lea	RNDSTAT,A0
	move.w	#1023,D4
LOOP40:	dc.w	__RND
	dc.w	__DMUL
	dc.w	__DTOL
	move.b	D0,(A0)+
	dbf	D4,LOOP40
	rts

BGINIT:	bsr	BGCLR
	moveq.l	#_BGCTRLST,D0	* bg_set(0,1,1)
	moveq.l	#0,D1
	moveq.l	#1,D2
	moveq.l	#1,D3
	trap	#15
	moveq.l	#_BGCTRLST,D0	* bg_set(1,0,0)
	moveq.l	#1,D1
	moveq.l	#0,D2
	moveq.l	#0,D3
	trap	#15
	moveq.l	#_BGSCRLST,D0	* bg_scroll(0,0,256)
	move.l	#$80000000,D1
	moveq.l	#0,D2
	move.l	#256,D3
	trap	#15
*moveq.l	#_BGSCRLST,D0
*move.l	#$80000001,D1
*moveq.l	#0,D2
*moveq.l	#0,D3
*trap	#15
	rts

BGCLR:	lea	BGADDR,A0
	clr.w	D0
	move.w	#2048-1,D1
LOOP52:	move.w	D0,(A0)+
	dbf	D1,LOOP52

ASDW:	lea	ASDEND,A0	* ADD SUB DATA WRITE
	move.w	#$F,D1
LOOP46:	move.w	#$F,D2
LOOP47:	move.w	D2,D0
	bsr	SEXT
	move.w	D0,-(A0)
	move.w	D1,D0
	bsr	SEXT
	move.w	D0,-(A0)
	dbf	D2,LOOP47
	dbf	D1,LOOP46

	rts

SEXT:	btst.l	#3,D0		* SIGN EXTEND (4 BIT -> 1W)
	beq	JUMP80
	or.w	#$FFF0,D0
JUMP80:	rts

ASDW2:	lea	ASDEND2,A0	* ADD SUB DATA WRITE 2
	move.w	#$F,D1
LOOP50:	move.w	#$F,D2
LOOP51:	move.w	D2,D0
	bsr	SEXT2
	move.w	D0,-(A0)
	move.w	D1,D0
	bsr	SEXT2
	move.w	D0,-(A0)
	dbf	D2,LOOP51
	dbf	D1,LOOP50

	rts

SEXT2:	btst.l	#3,D0		* SIGN EXTEND (4 BIT *2 -> 1W)
	beq	JUMP84
	or.w	#$FFF0,D0
JUMP84:	asl.w	#1,D0
	rts

VER_PRN:lea	BGADDR,A0
	lea	MSG_VER,A1
	bsr	BG_PRN
	rts

VER_DEL:lea	BGADDR,A0
	lea	MSG_VDL,A1
	bsr	BG_PRN
	rts

VPAGE:	move.w	D0,$E82600	* VPAGE
	rts			* CALL  D0:W: VSOP R3 SET DATA

WRKCLR:	asr.w	#2,D0		* WORK CLEAR
	subq.w	#1,D0		* CALL
LOOP19:	clr.l	(A0)+		*   D0.W: BYTE(1-16383)
	dbf	D0,LOOP19	*   A0  : START ADDRESS
	rts			* BREAK: D0/A0

BG_PRN:	movem.l	D0/A0-A1,-(SP)	* BG MESSAGE PRINT
	move.w	#$0500,D0	* CALL
LOOP22:	move.b	(A1)+,D0	*   A0: BG ADDRESS
	beq	BG_PRET		*   A1: MESSAGE ADDRESS
	move.w	D0,(A0)+	*
	bra	LOOP22		* BREAK: -----
BG_PRET:movem.l	(SP)+,D0/A0-A1
	rts

SP_SET:	movem.l	D0/A0,-(SP)	* SP_SET
	mulu	#8,D0		* CALL
	lea	SSRAD,A0	*   D0.W: PLANE NUMBER
	adda.l	D0,A0		*   D1.W: X
	move.w	D1,(A0)+	*   D2.W: Y
	move.w	D2,(A0)+	*   D3.W: EX_PC
	move.w	D3,(A0)+	*   D4.W: PRW
	move.w	D4,(A0)		*
	movem.l	(SP)+,D0/A0	* BREAK: -----
	rts

SP_SET3:movem.l	D0/A0,-(SP)	* SP_SET (EX_PC ONLY)
	mulu	#8,D0		* CALL
	lea	SSRAD+4,A0	*   D0.W: PLANE NUMBER
	adda.l	D0,A0		*   D3.W: EX_PC
	move.w	D3,(A0)		*
	movem.l	(SP)+,D0/A0	* BREAK: -----
	rts

SP_SET4:movem.l	D0/A0,-(SP)	* SP_SET (MOVE ONLY 2)
	mulu	#8,D0		* CALL
	lea	SSRAD,A0	*   D0.W: PLANE NUMBER
	adda.l	D0,A0		*   D1.W: X
	move.w	D1,(A0)+	*   D2.W: Y
	move.w	D2,(A0)		*
	movem.l	(SP)+,D0/A0	* BREAK: -----
	rts

SP_SET5:movem.l	D0/A0,-(SP)	* SP_SET (X MOVE ONLY)
	mulu	#8,D0		* CALL
	lea	SSRAD,A0	*   D0.W: PLANE NUMBER
	adda.l	D0,A0		*   D1.W: X
	move.w	D1,(A0)		*
	movem.l	(SP)+,D0/A0	* BREAK: -----
	rts

SP_OFF:	movem.l	D0/A0,-(SP)	* SP_OFF
	mulu	#8,D0		* CALL
	lea	SSRAD+6,A0	*   D0.W: PLANE NUMBER
	adda.l	D0,A0		*
	clr.w	(A0)		* BREAK: -----
	movem.l	(SP)+,D0/A0
	rts

SP_OFFA: move.w	D0,-(SP)	* SP_OFFALL
	clr.w	D0		* CALL
LOOP26:	bsr	SP_OFF		*   -----
	addq.w	#1,D0		*
	cmpi.w	#128,D0		* BREAK: -----
	bne	LOOP26
	move.w	(SP)+,D0
	rts

WASET:	movem.l	D0/A4,-(SP)	* WEAPON ADDRESS SET
	lea	S_DAT,A4
	move.w	WEAPON,D0
	mulu	#56,D0
	adda.l	D0,A4
	move.l	A4,WADRS
	movem.l	(SP)+,D0/A4
	rts

S_SPN:	lea	S_TABLE,A3	* SHOT SP NUMBER READ
	movea.l	WADRS,A4
	move.w	#2,D0		*
LOOP18:	tst.w	0(A3)		* RET
	beq	S_SPNR		*   D0: SP NUMBER(2-15) or ERROR($FFFF)
	cmp.w	6(A4),D0	*   A3: S_TABLE(N:D0)
	beq	S_SPNE		* BREAK: D0/A3 (RET ONLY)
	addq.w	#1,D0
	lea	14(A3),A3
	bra	LOOP18
S_SPNE:	move.w	#$FFFF,D0
S_SPNR:	rts

E_SPN:	lea	E_TABLE,A1	* ENEMY SP NUMBER READ
	move.w	#96,D0		*
LOOP11:	tst.w	0(A1)		* RET
	beq	E_SPNR		*   D0: SP NUMBER(96-127) or ERROR($FFFF)
	cmpi.w	#127,D0		*   A1: E_TABLE(N:D0)
	beq	E_SPNE		* BREAK: D0/A1 (RET ONLY)
	addq.w	#1,D0
	lea	34(A1),A1
	bra	LOOP11
E_SPNE:	move.w	#$FFFF,D0
E_SPNR:	rts

B_SPN:	lea	B_TABLE,A5	* BOSS SP NUMBER READ
	move.w	#16,D0		*
	tst.w	0(A5)		* RET
	beq	B_SPNR		*   D0: SP NUMBER(16-23 or 24-31) or ERROR($FFFF)
	addq.w	#8,D0		*   A5: B_TABLE(N:D0)
	lea	38(A5),A5	* BREAK: D0/A5 (RET ONLY)
	tst.w	0(A5)
	beq	B_SPNR
B_SPNE:	move.w	#$FFFF,D0
B_SPNR:	rts

BOSS:	bsr	B_SPN
	bmi	B_RET
	sub.w	#$8000,D1

	move.w	#28,D2
	mulu	D1,D2		* (BOSS NUMBER)*28
	lea	B_DAT-28,A4
	adda.l	D2,A4		* B_DATn

	move.w	D1,4(A5)
	move.l	0(A4),6(A5)
	move.w	4(A4),10(A5)
	move.w	6(A4),12(A5)
	move.w	6(A4),14(A5)
	move.l	8(A4),16(A5)
	move.l	12(A4),22(A5)
	clr.w	20(A5)
	move.w	20(A4),26(A5)
	clr.w	28(A5)
	move.w	22(A4),30(A5)
	move.w	22(A4),32(A5)
	move.l	24(A4),34(A5)
	move.l	16(A4),A2
	jsr	(A2)
	move.w	26(A5),D3
	bsr	B_SP_S
B_RET:	rts

B_SP_S:	movem.l	D0-D4,-(SP)	* BOSS SP_SET
				* CALL
	move.w	0(A5),D1	*   D3: EX_PC (LEFT TOP)
	move.w	2(A5),D2	*   A5: B_TABLE
	move.w	#1,D4
	bsr	SP_SET
	addq.w	#1,D0
	add.w	#16,D1
	addq.w	#1,D3
	bsr	SP_SET
	addq.w	#1,D0
	add.w	#16,D1
	addq.w	#1,D3
	bsr	SP_SET
	addq.w	#1,D0
	add.w	#16,D1
	addq.w	#1,D3
	bsr	SP_SET

	addq.w	#1,D0
	sub.w	#48,D1
	add.w	#16,D2
	addq.w	#5,D3
	bsr	SP_SET
	addq.w	#1,D0
	add.w	#16,D1
	addq.w	#1,D3
	bsr	SP_SET
	addq.w	#1,D0
	add.w	#16,D1
	addq.w	#1,D3
	bsr	SP_SET
	addq.w	#1,D0
	add.w	#16,D1
	addq.w	#1,D3
	bsr	SP_SET

	movem.l	(SP)+,D0-D4
	rts

SPCTRL:	tst.w	SPWAIT
	beq	JUMP71
	subq.w	#1,SPWAIT
	subq.l	#2,E_SPPO
	bra	SPCRET
JUMP71:	cmpi.w	#$F000,D1
	bcc	ETC
	cmpi.w	#$8000,D1
	bcc	BOSS

	bsr	ENEMY
SPCRET:	rts

S_MOVE:	lea	S_TABLE,A3
	move.w	#2,D0

LOOP49:	tst.w	0(A3)
	beq	JUMP83
	movea.l	10(A3),A2

	clr.w	D2
JUMP81:	move.b	(A2)+,D2
	cmp.b	#$88,D2
	bne	JUMP82
	cmpi.b	#1,(A2)+
	beq	S_LOST
	movea.l	(A2),A2
	bra	JUMP81
JUMP82:	move.l	A2,10(A3)
	lea	ASD2,A1
	mulu	#4,D2
	adda.l	D2,A1
	move.w	(A1)+,D4
	add.w	D4,0(A3)
	move.w	(A1),D4
	add.w	D4,2(A3)

	tst.w	0(A3)
	bmi	S_LOST
	cmpi.w	#272,0(A3)
	bcc	S_LOST
	tst.w	2(A3)
	bmi	S_LOST
	cmpi.w	#272,2(A3)
	bcc	S_LOST

	move.w	0(A3),D1
	move.w	2(A3),D2
	bsr	SP_SET4

JUMP83:	lea	14(A3),A3
	addq.w	#1,D0
	cmpi.w	#16,D0
	bne	LOOP49

	rts

S_LOST:	clr.w	0(A3)
	bsr	SP_OFF
	bra	JUMP83

ENEMY:	bsr	E_SPN		* ENEMY SP NUMBER READ
				*   RET   D0:SP NUMBER   A1: E_TABLE(N:D0)
	bmi	E_RET		* 32 SP ALL USED (RETURN)

	move.w	#30,D2
	mulu	D1,D2		* (ENEMY NUMBER)*30
	lea	E_DAT-30,A0
	adda.l	D2,A0		* E_DATn

	move.w	D1,4(A1)
	move.w	2(A0),12(A1)
	move.w	4(A0),14(A1)
	move.w	4(A0),24(A1)
	move.w	8(A0),6(A1)
	move.l	10(A0),8(A1)
	move.l	18(A0),16(A1)
	move.l	22(A0),20(A1)
	clr.w	26(A1)
	move.l	26(A0),30(A1)
	move.w	6(A0),28(A1)
	tst.l	14(A0)
	bne	JUMP46
	move.w	D3,0(A1)
	move.w	D4,2(A1)
	bra	JUMP47
JUMP46:	movea.l	14(A0),A2
	jsr	(A2)		* ENEMY INIT
JUMP47:	move.w	0(A1),D1
	move.w	2(A1),D2
	move.w	0(A0),D3
	move.w	#1,D4
	bsr	SP_SET
E_RET:	rts

A_SET1:	movem.l	D3-D4,-(SP)
	move.w	#4,D1
	bsr	ENEMY
	movem.l	(SP)+,D3-D4
	move.w	#5,D1
	bsr	ENEMY
	rts

A_SET2:	movem.l	D3-D4,-(SP)
	move.w	#24,D1
	bsr	ENEMY
	movem.l	(SP)+,D3-D4
	movem.l	D3-D4,-(SP)
	move.w	#25,D1
	bsr	ENEMY
	movem.l	(SP)+,D3-D4
	movem.l	D3-D4,-(SP)
	move.w	#26,D1
	bsr	ENEMY
	movem.l	(SP)+,D3-D4
	movem.l	D3-D4,-(SP)
	move.w	#27,D1
	bsr	ENEMY
	movem.l	(SP)+,D3-D4
	move.w	#28,D1
	bsr	ENEMY
	rts

A_SET3:	movem.l	D3-D4,-(SP)
	move.w	#29,D1
	bsr	ENEMY
	movem.l	(SP)+,D3-D4

	movem.l	D3-D4,-(SP)
	move.w	#30,D1
	bsr	ENEMY
	movem.l	(SP)+,D3-D4

	movem.l	D3-D4,-(SP)
	move.w	#31,D1
	bsr	ENEMY
	movem.l	(SP)+,D3-D4

	movem.l	D3-D4,-(SP)
	move.w	#32,D1
	bsr	ENEMY
	movem.l	(SP)+,D3-D4

	movem.l	D3-D4,-(SP)
	move.w	#33,D1
	bsr	ENEMY
	movem.l	(SP)+,D3-D4

	movem.l	D3-D4,-(SP)
	move.w	#34,D1
	bsr	ENEMY
	movem.l	(SP)+,D3-D4

	bsr	T_ASET1
	rts

A_SET4:	move.w	2(A5),D5
	sub.w	Y,D5
	cmp.w	#15,D5
	bpl	A_SET4R
	cmp.w	#-31,D5
	bmi	A_SET4R
	move.w	#24,D1
	bsr	ENEMY
A_SET4R	rts

E_INIT1:move.w	#272,0(A1)
	move.w	#64,2(A1)
	rts

E_INIT2:move.w	#272,0(A1)
	move.w	#208,2(A1)
	rts

E_INIT3:move.w	#272,0(A1)
	move.w	#136,2(A1)
	rts

E_INIT4:move.w	D0,-(SP)
	move.w	#272,0(A1)
	bsr	_RND_
	addq.w	#8,D0
	move.w	D0,2(A1)
	move.w	(SP)+,D0
	rts

E_INIT5:move.w	#272,0(A1)
	move.w	#256,2(A1)
	rts

B_INIT1:move.w	#272,0(A5)
	move.w	#128,2(A5)
	rts

B_INIT2:move.w	#272,0(A5)
	move.w	#192,2(A5)
	rts

B_MOVE:	lea	B_TABLE,A5
	move.w	#16,D0

LOOP29:	tst.w	0(A5)
	beq	JUMP27

	movea.l	6(A5),A2
	tst.w	28(A5)
	bne	JUMP31		* EXEC
	clr.w	D2		* PATTERN
JUMP45:	move.b	(A2)+,D2
	cmp.b	#$88,D2
	bne	JUMP44
	addq.l	#1,A2
	movea.l	(A2),A2
	bra	JUMP45
JUMP44:	move.l	A2,6(A5)
	move.w	26(A5),D3
	tst.w	20(A5)
	beq	JUMP28
	and.w	#$00FF,D3
	add.w	#$0400,D3
	subq.w	#1,20(A5)
JUMP28:	lea	ASD,A3
	mulu	#4,D2
	adda.l	D2,A3
	move.w	(A3)+,D4
	add.w	D4,0(A5)
	move.w	(A3),D4
	add.w	D4,2(A5)
	bra	JUMP32

JUMP31:	jsr	(A2)		* EXEC

JUMP32:	cmpi.w	#272,0(A5)
	bcc	B_LOST
	cmpi.w	#272,2(A5)
	bcc	B_LOST

JUMP30:	bsr	B_SP_S

JUMP27:	lea	38(A5),A5
	addq.w	#8,D0
	cmpi.w	#32,D0
	bne	LOOP29

	rts

B_LOST:	clr.w	0(A5)
	move.w	#272,2(A5)
	bra	JUMP30

E_MOVE:	lea	E_TABLE,A1
	move.w	#96,D0

LOOP12:	tst.w	0(A1)
	beq	JUMP7
	movea.l	8(A1),A2
	tst.w	6(A1)
	bne	JUMP8		* EXEC
	clr.w	D2		* PATTERN
JUMP41:	move.b	(A2)+,D2
	cmp.b	#$88,D2
	bne	JUMP40
	addq.l	#1,A2
	movea.l	(A2),A2
	bra	JUMP41
JUMP40:	move.l	A2,8(A1)
	movea.l	20(A1),A3
JUMP43:	move.w	(A3)+,D3
	cmpi.w	#$FFFF,D3
	bne	JUMP42
	movea.l	(A3),A3
	bra	JUMP43
JUMP42:	tst.w	26(A1)
	beq	JUMP22
	and.w	#$C0FF,D3
	add.w	#$0400,D3
	subq.w	#1,26(A1)
JUMP22:	bsr	SP_SET3
	move.l	A3,20(A1)
	lea	ASD,A3
	mulu	#4,D2
	adda.l	D2,A3
	move.w	(A3)+,D4
	move.w	XSCSP,D5
	sub.w	D5,D4
	addq.w	#1,D4
	add.w	D4,0(A1)
	move.w	(A3),D4
	move.w	YSCSP,D5
	sub.w	D5,D4
	add.w	D4,2(A1)
	bra	JUMP9

JUMP8:	jsr	(A2)		* EXEC
	tst.w	26(A1)
	beq	JUMP70
	and.w	#$C0FF,D3
	add.w	#$0400,D3
	subq.w	#1,26(A1)
JUMP70:	bsr	SP_SET3

JUMP9:	tst.w	0(A1)
	bmi	E_LOST2
	cmpi.w	#272,0(A1)
	bcc	E_LOST2
	tst.w	2(A1)
	bmi	E_LOST2
	cmpi.w	#272,2(A1)
	bcc	E_LOST2

	move.w	0(A1),D1
	move.w	2(A1),D2
	bsr	SP_SET4

JUMP7:	lea	34(A1),A1
	addq.w	#1,D0
	cmpi.w	#128,D0
	bne	LOOP12

	rts

E_LOST2:clr.w	0(A1)
	bsr	SP_OFF
	bra	JUMP7

E_LOST:	clr.w	0(A1)
	bsr	SP_OFF
	rts

E_PROG1:cmpi.w	#192,0(A1)
	beq	JUMP67
	subq.w	#1,0(A1)
	bra	JUMP68
JUMP67:	move.w	2(A1),D1
	cmp.w	Y,D1
	bcc	JUMP69
	addq.w	#1,2(A1)
	bra	JUMP68
JUMP69:	subq.w	#1,2(A1)
JUMP68:	move.w	0(A1),D1
	move.w	2(A1),D2
	bsr	SP_SET4
	rts

E_PROG2:tst.w	20(A1)
	bne	JUMP75
	move.w	0(A1),D1
	cmp.w	X,D1
	bmi	JUMP73
	subq.w	#1,0(A1)
	bra	JUMP74
JUMP73:	tst.w	20(A1)
	bne	JUMP75
	move.w	#1,20(A1)
	move.w	#1,22(A1)
	move.w	2(A1),D2
	cmp.w	Y,D2
	bmi	JUMP75
	subq.w	#2,22(A1)
JUMP75:	move.w	22(A1),D2
	add.w	D2,2(A1)
JUMP74:	move.w	0(A1),D1
	move.w	2(A1),D2
	bsr	SP_SET4
	move.w	#$013C,D3
	rts

_IDIV_:	move.l	D2,-(SP)	* F=I/I
	andi.l	#$0000FFFF,D0	*   D0.L=D0.W/D0.W
	divu	D1,D0
	move.w	D0,D2
	clr.w	D0
	divu	D1,D0
	swap	D2
	move.w	D0,D2
	move.l	D2,D0
	move.l	(SP)+,D2
	rts

_FMUL_:	movem.l	D1-D3,-(SP)	* F=F*F
	move.w	D0,D2		*   D0.L=D0.L*D1.L
	mulu	D1,D2
	clr.w	D2
	swap	D2
	move.l	D0,D3
	clr.w	D3
	swap	D3
	mulu	D1,D3
	add.l	D3,D2

	move.w	D0,D3
	clr.w	D1
	swap	D1
	mulu	D1,D3
	swap	D0
	mulu	D1,D0
	swap	D0
	clr.w	D0
	add.l	D3,D0

	add.l	D2,D0

	movem.l	(SP)+,D1-D3
	rts

_FPMF_:	tst.b	D2		* F=F+-F
	bne	JUMP10		*   D0.L=D0.L+-D1.L
	add.l	D1,D0		*           D2.L
	bra	JUMP11
JUMP10:	sub.l	D1,D0
JUMP11:	rts

_ABS_:	tst.w	D0		* I=ABS(I)
	bpl	ABSRET		*   D0.W=ABS(D0.W)
	not.w	D0
	addq.w	#1,D0
ABSRET:	rts

_SGN_:	tst.w	D0		* SGN(I)
	smi.b	D0		*   SGN(D0.W)
	rts			* RET: D0.B (0:+ $FF:-)

_RND_:	movem.l	D1/A0,-(SP)	* RND()
	movea.l	RNDADDR,A0	*   RND()
	clr.w	D0		*
	move.b	(A0)+,D0	* RET: D0.W (0-255)
	move.l	#RNDEND,D1
	cmp.l	A0,D1
	bne	JUMP53
	lea	RNDSTAT,A0
JUMP53:	move.l	A0,RNDADDR
	movem.l	(SP)+,D1/A0
	rts

T_SPN:	lea	T_TABLE,A2	* TAMA SP NUMBER READ
	move.w	#32,D0		*
LOOP14:	tst.w	0(A2)		* RET
	beq	T_SPNR		*   D0: SP NUMBER(96-127) or ERROR($FFFF)
	cmpi.w	#95,D0		*   A2: T_TABLE(N:D0)
	beq	T_SPNE		* BREAK: D0/A2 (RET ONLY)
	addq.w	#1,D0
	lea	24(A2),A2
	bra	LOOP14
T_SPNE:	move.w	#$FFFF,D0
T_SPNR:	rts

T_SET1:	bsr	T_SPN		* TAMA (NORMAL  1.0)
	bmi	T_RET1		*
	movem.l	D1-D2,-(SP)
	move.w	D1,0(A2)	* CALLED
	clr.w	2(A2)		*   D1.W: ENEMY X
	move.w	D2,4(A2)	*   D2.W: ENEMY Y
	clr.w	6(A2)
	clr.l	12(A2)

	move.w	#$0C18,D3
	move.w	#1,D4
	bsr	SP_SET

	move.w	X,D0
	addq.w	#5,D0
	sub.w	D1,D0
	bsr	_ABS_
	addq.w	#1,D0
	move.w	D0,D3

	move.w	Y,D0
	addq.w	#5,D0
	sub.w	D2,D0
	bsr	_ABS_
	addq.w	#1,D0
	move.w	D0,D4

	move.w	X,D0
	addq.w	#5,D0
	sub.w	D1,D0
	addq.w	#1,D0
	bsr	_SGN_
	move.b	D0,8(A2)

	move.w	Y,D0
	addq.w	#5,D0
	sub.w	D2,D0
	addq.w	#1,D0
	bsr	_SGN_
	move.b	D0,9(A2)

	cmp.w	D3,D4
	scc.b	10(A2)
	bcc	JUMP12

	move.w	D4,D0
	move.w	D3,D1
	bra	JUMP13

JUMP12:	move.w	D3,D0
	move.w	D4,D1

JUMP13:	bsr	_IDIV_
	move.l	TS,D1
	move.l	D1,20(A2)
	bsr	_FMUL_
	move.l	D0,16(A2)

	movem.l	(SP)+,D1-D2
T_RET1:	rts

T_SET2:	move.l	#$FF000000,D3	* TAMA (3 WAY  1.2 & 1.0)
	move.l	#$00000000,D4
	move.l	#$00013000,D5
	bsr	T_FREE
	move.l	#$FFFF0000,D3
	move.l	#$00010000,D4
	move.l	#$00010000,D5
	bsr	T_FREE
	move.l	#$FF000000,D3
	bsr	T_FREE
	rts

T_SET3:	move.l	#$FF000000,D3	* TAMA (8 WAY  1.2 & 1.0)
	move.l	#$00000000,D4
	move.l	#$00013000,D5
	bsr	T_FREE
	move.l	#$00000000,D3
	bsr	T_FREE
	move.l	#$00FFFF00,D3
	bsr	T_FREE
	move.l	#$0000FF00,D3
	bsr	T_FREE
	move.l	#$FFFF0000,D3
	move.l	#$00010000,D4
	move.l	#$00010000,D5
	bsr	T_FREE
	move.l	#$FF000000,D3
	bsr	T_FREE
	move.l	#$00000000,D3
	bsr	T_FREE
	move.l	#$00FF0000,D3
	bsr	T_FREE
	rts

T_SET4:	bsr	T_SET5		* TAMA (NORMAL 1.5  and  3 WAY 1.2 & 1.0)
	bsr	T_SET2
	rts

T_SET5:	bsr	T_SPN		* TAMA (NORMAL  1.5)
	bmi	T_RET5		*
	movem.l	D1-D2,-(SP)
	move.w	D1,0(A2)	* CALLED
	clr.w	2(A2)		*   D1.W: ENEMY X
	move.w	D2,4(A2)	*   D2.W: ENEMY Y
	clr.w	6(A2)
	clr.l	12(A2)

	move.w	#$0C18,D3
	move.w	#1,D4
	bsr	SP_SET

	move.w	X,D0
	addq.w	#5,D0
	sub.w	D1,D0
	bsr	_ABS_
	addq.w	#1,D0
	move.w	D0,D3

	move.w	Y,D0
	addq.w	#5,D0
	sub.w	D2,D0
	bsr	_ABS_
	addq.w	#1,D0
	move.w	D0,D4

	move.w	X,D0
	addq.w	#5,D0
	sub.w	D1,D0
	addq.w	#1,D0
	bsr	_SGN_
	move.b	D0,8(A2)

	move.w	Y,D0
	addq.w	#5,D0
	sub.w	D2,D0
	addq.w	#1,D0
	bsr	_SGN_
	move.b	D0,9(A2)

	cmp.w	D3,D4
	scc.b	10(A2)
	bcc	JUMP55

	move.w	D4,D0
	move.w	D3,D1
	bra	JUMP56

JUMP55:	move.w	D3,D0
	move.w	D4,D1

JUMP56:	bsr	_IDIV_
	move.l	D0,D2
	move.l	TS,D1
	move.l	#$00018000,D0
	bsr	_FMUL_
	move.l	D0,20(A2)
	move.l	D2,D1
	bsr	_FMUL_
	move.l	D0,16(A2)

	movem.l	(SP)+,D1-D2
T_RET5:	rts

T_SET6:	move.l	#$FFFF0000,D3	* TAMA (NORMAL 1.0  and  2 WAY 1.2)
	move.l	#$00010000,D4
	move.l	#$00013000,D5
	bsr	T_FREE
	move.l	#$FF000000,D3
	bsr	T_FREE
	bsr	T_SET1
	rts

T_SET7:	bsr	T_SPN		* TAMA (NORMAL  2.0)
	bmi	T_RET7		*
	movem.l	D1-D2,-(SP)
	move.w	D1,0(A2)	* CALLED
	clr.w	2(A2)		*   D1.W: ENEMY X
	move.w	D2,4(A2)	*   D2.W: ENEMY Y
	clr.w	6(A2)
	clr.l	12(A2)

	move.w	#$0C18,D3
	move.w	#1,D4
	bsr	SP_SET

	move.w	X,D0
	addq.w	#5,D0
	sub.w	D1,D0
	bsr	_ABS_
	addq.w	#1,D0
	move.w	D0,D3

	move.w	Y,D0
	addq.w	#5,D0
	sub.w	D2,D0
	bsr	_ABS_
	addq.w	#1,D0
	move.w	D0,D4

	move.w	X,D0
	addq.w	#5,D0
	sub.w	D1,D0
	addq.w	#1,D0
	bsr	_SGN_
	move.b	D0,8(A2)

	move.w	Y,D0
	addq.w	#5,D0
	sub.w	D2,D0
	addq.w	#1,D0
	bsr	_SGN_
	move.b	D0,9(A2)

	cmp.w	D3,D4
	scc.b	10(A2)
	bcc	JUMP78

	move.w	D4,D0
	move.w	D3,D1
	bra	JUMP79

JUMP78:	move.w	D3,D0
	move.w	D4,D1

JUMP79:	bsr	_IDIV_
	move.l	D0,D2
	move.l	TS,D1
	move.l	#$00020000,D0
	bsr	_FMUL_
	move.l	D0,20(A2)
	move.l	D2,D1
	bsr	_FMUL_
	move.l	D0,16(A2)

	movem.l	(SP)+,D1-D2
T_RET7:	rts

T_FREE:	bsr	T_SPN
	bmi	T_FRET
	movem.l	D3-D4,-(SP)
	movem.l	D0-D1,-(SP)
	move.w	D1,0(A2)
	clr.w	2(A2)
	move.w	D2,4(A2)
	clr.w	6(A2)
	clr.l	12(A2)
	move.l	D3,8(A2)
	move.l	D5,D0
	move.l	TS,D1
	bsr	_FMUL_
	move.l	D0,20(A2)
	move.l	D4,D1
	bsr	_FMUL_
	move.l	D0,16(A2)
	movem.l	(SP)+,D0-D1
	move.w	#$0C18,D3
	move.w	#1,D4
	bsr	SP_SET
	movem.l	(SP)+,D3-D4
T_FRET:	rts

T_CTRL:	lea	E_TABLE,A1
	move.w	#96,D0

LOOP15:	tst.w	0(A1)
	beq	JUMP14

	subq.w	#1,14(A1)
	bne	JUMP14
	move.w	24(A1),14(A1)

	move.w	D0,-(SP)
	move.w	0(A1),D1
	addq.w	#5,D1
	move.w	2(A1),D2
	addq.w	#5,D2
	movea.l	16(A1),A2
	jsr	(A2)
	move.w	(SP)+,D0

JUMP14:	lea	34(A1),A1
	addq.w	#1,D0
	cmpi.w	#128,D0
	bne	LOOP15

	rts

A_CTRL:	lea	B_TABLE,A5
	move.w	#16,D0

LOOP33:	tst.w	0(A5)
	beq	JUMP36

	subq.w	#1,14(A5)
	bne	JUMP36
	move.w	12(A5),14(A5)

	move.w	D0,D6
	move.w	0(A5),D1
	add.w	#30,D1
	move.w	2(A5),D2
	add.w	#16,D2
	movea.l	16(A5),A2
	jsr	(A2)
	move.w	D6,D0

JUMP36:	subq.w	#1,32(A5)
	bne	JUMP37
	move.w	30(A5),32(A5)

	move.w	D0,-(SP)
	move.w	0(A5),D3
	add.w	#24,D3
	move.w	2(A5),D4
	addq.w	#8,D4
	movea.l	34(A5),A2
	jsr	(A2)
	move.w	(SP)+,D0

JUMP37:	lea	38(A5),A5
	addq.w	#8,D0
	cmpi.w	#32,D0
	bne	LOOP33

	rts

T_ASET1:move.w	D3,D1
	addq.w	#6,D1
	move.w	D4,D2
	addq.w	#8,D2
	bsr	T_SET1
	rts

T_MOVE:	lea	T_TABLE,A2
	move.w	#32,D0

LOOP16:	tst.w	0(A2)
	beq	JUMP15

	move.w	D0,D4

	tst.b	10(A2)
	bne	JUMP16

	move.l	0(A2),D0
	move.l	20(A2),D1
	move.b	8(A2),D2
	bsr	_FPMF_
	move.l	XSCSP,D5
	sub.l	D5,D0
	addi.l	#$10000,D0
	move.l	D0,0(A2)
	cmpi.w	#9,0(A2)
	bcs	T_LOST
	cmpi.w	#272,0(A2)
	bcc	T_LOST

	move.l	16(A2),D3
	add.l	D3,12(A2)
	move.l	12(A2),D3
	cmp.l	20(A2),D3
	bcs	JUMP17
	move.l	4(A2),D0
	move.l	20(A2),D1
	move.b	9(A2),D2
	bsr	_FPMF_
	move.l	YSCSP,D5
	sub.l	D5,D0
	move.l	D0,4(A2)
	cmpi.w	#9,4(A2)
	bcs	T_LOST
	cmpi.w	#272,4(A2)
	bcc	T_LOST
	move.l	20(A2),D3
	sub.l	D3,12(A2)
	bra	JUMP17

JUMP16:	move.l	4(A2),D0
	move.l	20(A2),D1
	move.b	9(A2),D2
	bsr	_FPMF_
	move.l	YSCSP,D5
	sub.l	D5,D0
	move.l	D0,4(A2)
	cmpi.w	#9,4(A2)
	bcs	T_LOST
	cmpi.w	#272,4(A2)
	bcc	T_LOST

	move.l	16(A2),D3
	add.l	D3,12(A2)
	move.l	12(A2),D3
	cmp.l	20(A2),D3
	bcs	JUMP17
	move.l	0(A2),D0
	move.l	20(A2),D1
	move.b	8(A2),D2
	bsr	_FPMF_
	move.l	XSCSP,D5
	sub.l	D5,D0
	addi.l	#$10000,D0
	move.l	D0,0(A2)
	cmpi.w	#9,0(A2)
	bcs	T_LOST
	cmpi.w	#272,0(A2)
	bcc	T_LOST
	move.l	20(A2),D3
	sub.l	D3,12(A2)

JUMP17:	move.w	D4,D0
	move.w	0(A2),D1
	move.w	4(A2),D2
	bsr	SP_SET4

JUMP18:	move.w	D4,D0

JUMP15:	lea	24(A2),A2
	addq.w	#1,D0
	cmpi.w	#96,D0
	bne	LOOP16

	rts

T_LOST:	clr.w	0(A2)
	bra	JUMP17

SE_CHK:	lea	S_TABLE,A3
	move.w	#2,D0
LOOP20:	tst.w	0(A3)
	beq	JUMP19

	lea	E_TABLE,A1
	move.w	#96,D1
LOOP21:	move.w	0(A1),D2
	beq	JUMP20
	move.w	2(A1),D3
	move.w	4(A1),D4
	beq	JUMP20
	bmi	JUMP20

	sub.w	0(A3),D2
	sub.w	2(A3),D3
	cmpi.w	#7,D2
	bpl	JUMP20
	cmpi.w	#-14,D2
	bmi	JUMP20
	cmpi.w	#6,D3
	bpl	JUMP20
	cmpi.w	#-14,D3
	bmi	JUMP20

	movea.l	WADRS,A4

	tst.w	4(A4)
	bne	JUMP63
	clr.w	0(A3)
	bsr	SP_OFF

JUMP63:	cmpi.w	#$FFFF,12(A1)
	beq	JUMP20
	move.w	2(A4),D7
	sub.w	D7,12(A1)
	bcs	JUMP65
	bne	JUMP21

JUMP65:	move.w	4(A1),24(A1)
	clr.w	4(A1)
	move.w	#1,6(A1)
	move.l	#BURN1,8(A1)
	clr.w	14(A1)
	movea.l	30(A1),A6
	jsr	(A6)

	move.w	D0,-(SP)
	move.w	28(A1),D0
	bsr	ADDSC
	move.w	(SP)+,D0

	bra	JUMP20

JUMP21:	move.w	#5,26(A1)

JUMP20:	addq.w	#1,D1
	lea	34(A1),A1
	cmp.w	#128,D1
	bne	LOOP21

JUMP19:	addq.w	#1,D0
	lea	14(A3),A3
	cmp.w	#15,D0
	bne	LOOP20

	rts

ADDSC:	movem.l	D0-D1,-(SP)
	move.l	SCORE,D1
	andi.w	#%01111,CCR
	abcd.b	D0,D1
	ror.l	#8,D1
	ror.w	#8,D0
	abcd.b	D0,D1
	ror.l	#8,D1
	clr.b	D0
	abcd.b	D0,D1
	ror.l	#8,D1
	abcd.b	D0,D1
	ror.l	#8,D1
	move.l	D1,SCORE
	bsr	SC_PRN
	movem.l	(SP)+,D0-D1
	rts

BRN_RET:rts

BRN_EAL:movem.l	D0/A1,-(SP)
	lea	E_TABLE,A1
	move.w	#96,D0

LOOP45:	clr.w	4(A1)
	move.w	#1,6(A1)
	move.l	#BURN1,8(A1)
	clr.w	14(A1)
	lea	34(A1),A1
	addq.w	#1,D0
	cmpi.w	#128,D0
	bne	LOOP45

	movem.l	(SP)+,D0/A1
	rts

BURN1:	move.w	#$0319,D3
	move.l	#BURN2,8(A1)
	rts

BURN2:	move.w	#$0319,D3
	move.l	#BURN3,8(A1)
	rts

BURN3:	move.w	#$031A,D3
	move.l	#BURN4,8(A1)
	rts

BURN4:	move.w	#$031A,D3
	move.l	#BURN5,8(A1)
	rts

BURN5:	move.w	#$031B,D3
	move.l	#BURN6,8(A1)
	rts

BURN6:	move.w	#$031B,D3
	move.l	#BURN7,8(A1)
	rts

BURN7:	move.w	#$031C,D3
	move.l	#BURN8,8(A1)
	rts

BURN8:	move.w	#$031C,D3
	move.l	#BURN9,8(A1)
	rts

BURN9:	move.w	#$031D,D3
	move.l	#BURN10,8(A1)
	rts

BURN10:	move.w	#$031D,D3
	move.l	#BURN11,8(A1)
	rts

BURN11:	move.w	D0,-(SP)
	cmpi.w	#RISUN,24(A1)
	beq	ITEMON
	cmpi.w	#RISUN2,24(A1)
	beq	ITEMON
	bsr	_RND_
	cmpi.b	#IR,D0
	bcs	ITEMON
	move.w	(SP)+,D0
	bsr	E_LOST
	bsr	SP_OFF
	rts

ITEMON:	lea	ITEMRND,A6
	bsr	_RND_
	move.b	(A6,D0),D0
	not.w	D0
	move.w	D0,4(A1)
	clr.w	6(A1)
	move.l	#P_ITEM0,8(A1)
	lea	ITEMPC,A6
	not.w	D0
	asl.w	#2,D0
	move.l	(A6,D0),A6
	move.l	A6,20(A1)
	move.w	(SP)+,D0
	clr.w	D3
	bsr	SP_SET3
	rts

SC_PRN:	movem.l	D0-D2/A0,-(SP)	* SCORE PRINT
	lea	BGADDR+10*2,A0	* CALL
	move.l	SCORE,D0
	move.w	#$0500,D2	*   -----
	move.w	#7,D1		*
LOOP23:	rol.l	#4,D0		* BREAK: -----
	move.b	D0,D2
	andi.b	#$0F,D2
	addi.b	#$30,D2
	move.w	D2,(A0)+
	dbf	D1,LOOP23
	movem.l	(SP)+,D0-D2/A0
	rts

ME_CHK:	tst.w	UNDEAD
	bne	ME_CRET
	tst.w	DEAD
	bne	ME_CRET

	lea	E_TABLE,A1
	move.w	#96,D1
LOOP24:	move.w	0(A1),D2
	beq	JUMP23
	move.w	2(A1),D3
	move.w	4(A1),D4
	beq	JUMP23

	sub.w	X,D2
	sub.w	Y,D3
	cmpi.w	#11,D2
	bpl	JUMP23
	cmpi.w	#-12,D2
	bmi	JUMP23
	cmpi.w	#12,D3
	bpl	JUMP23
	cmpi.w	#-9,D3
	bmi	JUMP23

	tst.w	D4
	bmi	POWERUP

	move.w	#1,DEAD

JUMP23:	addq.w	#1,D1
	lea	34(A1),A1
	cmp.w	#128,D1
	bne	LOOP24

ME_CRET:rts

POWERUP:move.w	D1,D0
	bsr	E_LOST
	move.w	#$0100,D0
	bsr	ADDSC
	not.w	D4
	move.w	D4,WEAPON
	bsr	WASET
	bra	JUMP23

MT_CHK:	tst.w	UNDEAD
	bne	MT_CRET
	tst.w	DEAD
	bne	MT_CRET

	lea	T_TABLE,A2
	move.w	#32,D1
LOOP25:	move.w	0(A2),D2
	beq	JUMP25
	move.w	4(A2),D3

	sub.w	X,D2
	sub.w	Y,D3
	cmpi.w	#12,D2
	bpl	JUMP25
	cmpi.w	#-3,D2
	bmi	JUMP25
	cmpi.w	#11,D3
	bpl	JUMP25
	cmpi.w	#2,D3
	bmi	JUMP25

	move.w	#1,DEAD

JUMP25:	addq.w	#1,D1
	lea	24(A2),A2
	cmp.w	#96,D1
	bne	LOOP25

MT_CRET:rts

MB_CHK:	tst.w	DEAD
	bne	MB_CRET
	tst.w	UNDEAD
	bne	MB_CRET

	lea	B_TABLE,A5
	move.w	#16,D1
LOOP30:	move.w	0(A5),D2
	beq	JUMP29
	move.w	2(A5),D3
	move.w	4(A5),D4
	beq	JUMP29

	sub.w	X,D2
	sub.w	Y,D3
	cmpi.w	#5,D2
	bpl	JUMP29
	cmpi.w	#-55,D2
	bmi	JUMP29
	cmpi.w	#14,D3
	bpl	JUMP29
	cmpi.w	#-29,D3
	bmi	JUMP29

	move.w	#1,DEAD

JUMP29:	addq.w	#8,D1
	lea	38(A5),A5
	cmp.w	#32,D1
	bne	LOOP30

MB_CRET:rts

SB_CHK:	lea	S_TABLE,A3
	move.w	#2,D0
LOOP31:	tst.w	0(A3)
	beq	JUMP33

	lea	B_TABLE,A5
	move.w	#16,D1
LOOP32:	move.w	0(A5),D2
	beq	JUMP34
	move.w	2(A5),D3
	move.w	4(A5),D4
	beq	JUMP34

	sub.w	0(A3),D2
	sub.w	2(A3),D3
	cmpi.w	#-1,D2
	bpl	JUMP34
	cmpi.w	#-54,D2
	bmi	JUMP34
	cmpi.w	#7,D3
	bpl	JUMP34
	cmpi.w	#-31,D3
	bmi	JUMP34

	movea.l	WADRS,A4

	clr.w	0(A3)
	bsr	SP_OFF

	move.w	2(A4),D7
	sub.w	D7,10(A5)
	bcs	JUMP66
	bne	JUMP35

JUMP66:	clr.w	4(A5)
	move.w	#1,28(A5)
	move.l	#B_BURN1,6(A5)
	clr.w	14(A5)

	movem.l	D0-D1,-(SP)
	move.l	SCORE,D0
	move.l	22(A5),D1
	andi.w	#%01111,CCR
	abcd.b	D1,D0
	ror.l	#8,D0
	ror.l	#8,D1
	abcd.b	D1,D0
	ror.l	#8,D0
	ror.l	#8,D1
	abcd.b	D1,D0
	ror.l	#8,D0
	ror.l	#8,D1
	abcd.b	D1,D0
	ror.l	#8,D0
	ror.l	#8,D1
	move.l	D0,SCORE
	bsr	SC_PRN
	movem.l	(SP)+,D0-D1

	bra	JUMP34

JUMP35:	move.w	#5,20(A5)

JUMP34:	addq.w	#8,D1
	lea	38(A5),A5
	cmpi.w	#32,D1
	bne	LOOP32

JUMP33:	addq.w	#1,D0
	lea	14(A3),A3
	cmpi.w	#15,D0
	bne	LOOP31

	rts

B_BURN1:movem.l	D0-D2,-(SP)
	move.w	0(A5),D1
	addi.w	#24,D1
	move.w	2(A5),D2
	addq.w	#8,D2
	bsr	E_SPN
	lea	P_ITEM1,A0
	bsr	B_ITEM
	bsr	E_SPN
	lea	P_ITEM2,A0
	bsr	B_ITEM
	bsr	E_SPN
	lea	P_ITEM3,A0
	bsr	B_ITEM
	bsr	E_SPN
	lea	P_ITEM4,A0
	bsr	B_ITEM
	bsr	E_SPN
	lea	P_ITEM5,A0
	bsr	B_ITEM
	bsr	E_SPN
	lea	P_ITEM6,A0
	bsr	B_ITEM
	bsr	E_SPN
	lea	P_ITEM7,A0
	bsr	B_ITEM
	bsr	E_SPN
	lea	P_ITEM8,A0
	bsr	B_ITEM
	movem.l	(SP)+,D0-D2

	move.w	#$0860,D3
	move.l	#B_BURN2,6(A5)
	rts

B_ITEM:	move.w	D0,-(SP)
	move.w	D1,0(A1)
	move.w	D2,2(A1)
	lea	ITEMRND,A6
	bsr	_RND_
	move.b	(A6,D0),D0
	not.w	D0
	move.w	D0,4(A1)
	clr.w	6(A1)
	move.l	A0,8(A1)
	clr.w	14(A1)
	lea	ITEMPC,A6
	not.w	D0
	asl.w	#2,D0
	move.l	(A6,D0),A6
	move.l	A6,20(A1)
	clr.w	26(A1)
	move.w	(SP)+,D0
	clr.w	D3
	move.w	#1,D4
	bsr	SP_SET
	rts

B_BURN2:move.w	#$0860,D3
	move.l	#B_BURN3,6(A5)
	rts
B_BURN3:move.w	#$0860,D3
	move.l	#B_BURN4,6(A5)
	rts
B_BURN4:move.w	#$0860,D3
	move.l	#B_BURN5,6(A5)
	rts
B_BURN5:move.w	#$0860,D3
	move.l	#B_BURN6,6(A5)
	rts
B_BURN6:move.w	#$0860,D3
	move.l	#B_BURN7,6(A5)
	rts
B_BURN7:move.w	#$0860,D3
	move.l	#B_BURN8,6(A5)
	rts
B_BURN8:move.w	#$0860,D3
	move.l	#B_BURN9,6(A5)
	rts

B_BURN9:move.w	#$0864,D3
	move.l	#B_BRN10,6(A5)
	rts
B_BRN10:move.w	#$0864,D3
	move.l	#B_BRN11,6(A5)
	rts
B_BRN11:move.w	#$0864,D3
	move.l	#B_BRN12,6(A5)
	rts
B_BRN12:move.w	#$0864,D3
	move.l	#B_BRN13,6(A5)
	rts
B_BRN13:move.w	#$0864,D3
	move.l	#B_BRN14,6(A5)
	rts
B_BRN14:move.w	#$0864,D3
	move.l	#B_BRN15,6(A5)
	rts
B_BRN15:move.w	#$0864,D3
	move.l	#B_BRN16,6(A5)
	rts
B_BRN16:move.w	#$0864,D3
	move.l	#B_BRN17,6(A5)
	rts

B_BRN17:move.w	#$0870,D3
	move.l	#B_BRN18,6(A5)
	rts
B_BRN18:move.w	#$0870,D3
	move.l	#B_BRN19,6(A5)
	rts
B_BRN19:move.w	#$0870,D3
	move.l	#B_BRN20,6(A5)
	rts
B_BRN20:move.w	#$0870,D3
	move.l	#B_BRN21,6(A5)
	rts
B_BRN21:move.w	#$0870,D3
	move.l	#B_BRN22,6(A5)
	rts
B_BRN22:move.w	#$0870,D3
	move.l	#B_BRN23,6(A5)
	rts
B_BRN23:move.w	#$0870,D3
	move.l	#B_BRN24,6(A5)
	rts
B_BRN24:move.w	#$0870,D3
	move.l	#B_BRN25,6(A5)
	rts

B_BRN25:move.w	#$0874,D3
	move.l	#B_BRN26,6(A5)
	rts
B_BRN26:move.w	#$0874,D3
	move.l	#B_BRN27,6(A5)
	rts
B_BRN27:move.w	#$0874,D3
	move.l	#B_BRN28,6(A5)
	rts
B_BRN28:move.w	#$0874,D3
	move.l	#B_BRN29,6(A5)
	rts
B_BRN29:move.w	#$0874,D3
	move.l	#B_BRN30,6(A5)
	rts
B_BRN30:move.w	#$0874,D3
	move.l	#B_BRN31,6(A5)
	rts
B_BRN31:move.w	#$0874,D3
	move.l	#B_BRN32,6(A5)
	rts
B_BRN32:move.w	#$0874,D3
	move.l	#B_BRN33,6(A5)
	rts

B_BRN33:clr.w	0(A5)
	move.w	#272,2(A5)
	rts

ETC:	lea	ETCADDR,A0
	subi.w	#$F000,D1
	asl.l	#2,D1
	andi.l	#$0003FFFC,D1
	movea.l	(A0,D1.L),A2
	jmp	(A2)

N_STAGE:addq.w	#1,STAGE
	move.w	STAGE,D0
	add.w	#$30,D0
	move.b	D0,MSTN
	addq.w	#1,MYSHIP
	move.w	MYSHIP,D0
	subq.w	#2,D0
	asl.w	#1,D0
	lea	BGADDR+1*128,A0
	move.w	#$013C,(A0,D0.w)

	lea	BGADDR+16*128+12*2,A0
	lea	MSG_ST,A1
	bsr	BG_PRN
	move.w	#192,READYC
	moveq.l	#0,D0
	rts

W_EDEAD:lea	E_TABLE,A1
	move.w	#96,D0

LOOP34:	tst.w	(A1)
	beq	JUMP87
	tst.w	4(A1)
	bpl	JUMP38
JUMP87:	lea	34(A1),A1
	addq.w	#1,D0
	cmpi.w	#128,D0
	bne	LOOP34
	bra	W_EDRET
JUMP38:	subq.l	#2,E_SPPO
W_EDRET:moveq.l	#1,D0
	rts

W_EIDED:lea	E_TABLE,A1
	move.w	#96,D0

LOOP53:	tst.w	(A1)
	bne	JUMP89
	lea	34(A1),A1
	addq.w	#1,D0
	cmpi.w	#128,D0
	bne	LOOP53
	bra	W_EIDRT
JUMP89:	subq.l	#2,E_SPPO
W_EIDRT:moveq.l	#1,D0
	rts

W_E49TP:lea	E_TABLE,A1
	move.w	#96,D0

LOOP54:	tst.w	(A1)
	beq	JUMP90
	cmpi.w	#SNAKEN,4(A1)
	beq	W_E49TR
JUMP90:	lea	34(A1),A1
	addq.w	#1,D0
	cmpi.w	#128,D0
	bne	LOOP54
	bsr	BRN_EAL
W_E49TR:moveq.l	#0,D0
	rts

W_BDEAD:lea	B_TABLE,A5
	move.w	#16,D0

LOOP35:	tst.w	(A5)
	bne	JUMP39
JUMP94:	lea	38(A5),A5
	addq.w	#8,D0
	cmpi.w	#32,D0
	bne	LOOP35
	bra	W_BDRET
JUMP39:	tst.w	4(A5)
	beq	JUMP94
	subq.l	#2,E_SPPO
W_BDRET:moveq.l	#1,D0
	rts

W_EBDED:lea	E_TABLE,A1
	move.w	#96,D0

LOOP37:	tst.w	(A1)
	beq	JUMP88
	tst.w	4(A1)
	bpl	JUMP48
JUMP88:	lea	34(A1),A1
	addq.w	#1,D0
	cmpi.w	#128,D0
	bne	LOOP37
	bra	W_EBDRT

	lea	B_TABLE,A5
	move.w	#16,D0

LOOP38:	tst.w	(A5)
	bne	JUMP48
JUMP95:	lea	38(A5),A5
	addq.w	#8,D0
	cmpi.w	#32,D0
	bne	LOOP38
	bra	W_BDRET
JUMP48:	tst.w	4(A5)
	beq	JUMP95
	subq.l	#2,E_SPPO
W_EBDRT:moveq.l	#1,D0
	rts

W_BCANU:lea	B_TABLE,A5
	move.w	#16,D0

LOOP41:	tst.w	(A5)
	beq	JUMP54
	lea	38(A5),A5
	addq.w	#8,D0
	cmpi.w	#32,D0
	bne	LOOP41
	subq.l	#2,E_SPPO
	moveq.l	#1,D0
	bra	W_BCRET
JUMP54:	moveq.l	#0,D0
W_BCRET:rts

WLOOP:	movea.l	E_SPPO,A0
	move.w	(A0)+,SPWAIT
	move.l	A0,E_SPPO
	moveq.l	#1,D0
	rts

XSCSSET:movea.l	E_SPPO,A0
	move.l	(A0)+,XSCSP
	move.l	A0,E_SPPO
	moveq.l	#1,D0
	rts

YSCSSET:movea.l	E_SPPO,A0
	move.l	(A0)+,YSCSP
	move.l	A0,E_SPPO
	moveq.l	#1,D0
	rts

N_ROUND:clr.w	STAGE
	move.l	#E_SPAT,E_SPPO
	move.l	#$00008000,D0
	add.l	D0,TS
	move.w	#64,X
	move.w	#136,Y
	moveq.l	#1,D0
	rts

HEADER:	moveq.l	#0,D0
	rts

BYEBYE:	addq.w	#4,X
	moveq.l	#1,D0
	rts

PRN_CON:lea	BGADDR+14*128+8*2,A0
	lea	MSG_CON,A1
	bsr	BG_PRN
	moveq.l	#0,D0
	rts

DEL_CON:lea	BGADDR+14*128+8*2,A0
	lea	MSG_CDL,A1
	bsr	BG_PRN
	moveq.l	#0,D0
	rts

***************Å@ÇdÇsÇbÅ@***************

BACK:	subq.w	#1,MYSHIP
	beq	G_OVER
	move.w	MYSHIP,D0
	subq.w	#1,D0
	asl.w	#1,D0
	lea	BGADDR+1*128,A0
	move.w	#$0100,(A0,D0.w)
	move.w	#64,X
	move.w	#136,Y
	clr.w	AF
	clr.w	D0
	bsr	SP_OFFA
	movea.l	E_SPPO,A0
LOOP27:	cmpi.w	#$F000,-(A0)
	beq	JUMP72
	cmpi.w	#$F008,(A0)
	bne	LOOP27
JUMP72:	addq.l	#2,A0
	move.l	A0,E_SPPO
	lea	BGADDR+16*128+12*2,A0
	lea	MSG_RE,A1
	bsr	BG_PRN

	move.w	#192,READYC
	bra	JUMP26

G_OVER:	lea	BGADDR+16*128+12*2,A0
	lea	MSG_GOV,A1
	bsr	BG_PRN
	move.l	#$00020000,D2
LOOP28:
SPACE5:	moveq.l	#_BITSNS,D0
	move.w	#6,D1
	trap	#15
	btst.l	#5,D0
	bne	END
	subq.l	#1,D2
	bne	LOOP28
	lea	BGADDR+16*128+12*2,A0
	lea	MSG_GOD,A1
	bsr	BG_PRN
	bra	TITLE

	.data	************************************************************************

SSPBUF:	dc.l	0
USPBUF:	dc.l	0

SPEED:	dc.w	$2000

SCORE:	dc.l	$00000000

STAGE:	dc.w	0

X:	dc.w	0
Y:	dc.w	0
HX:	dc.l	0
HY:	dc.l	0
AF:	dc.w	0
BC:	dc.w	0
DEAD:	dc.w	0
MYSHIP:	dc.w	0
XSCSP:dc.l	$00010000
YSCSP:dc.l	$00000000

WEAPON:	dc.w	0
WADRS:	dc.l	0

UNDEAD:	dc.w	0

TABFLUG:dc.w	0
ESCFLUG:dc.w	0
CTRLFLG:dc.w	0

READYC:	dc.w	0

PX:	dc.w	0,0,0,0,0,2,2,2
	dc.w	0,-2,-2,-2,0,0,0,0
PY:	dc.w	0,0,0,0,0,2,-2,0
	dc.w	0,2,-2,0,0,2,-2,0

PD:
*		Çf       Çq     Ça    Çh
	dc.w	00_*2048+00_*64+00_*2+0_

	dc.w	13_*2048+27_*64+27_*2+0_
	dc.w	00_*2048+07_*64+27_*2+0_
	dc.w	00_*2048+27_*64+27_*2+0_
	dc.w	00_*2048+00_*64+15_*2+0_
	dc.w	00_*2048+15_*64+15_*2+0_

	dc.w	00_*2048+00_*64+16_*2+0_
	dc.w	00_*2048+00_*64+31_*2+0_
	dc.w	31_*2048+31_*64+31_*2+0_

	dc.w	00_*2048+00_*64+00_*2+0_
	dc.w	00_*2048+00_*64+00_*2+0_
	dc.w	00_*2048+00_*64+00_*2+0_
	dc.w	00_*2048+00_*64+00_*2+0_
	dc.w	00_*2048+00_*64+00_*2+0_
	dc.w	00_*2048+00_*64+00_*2+0_
	dc.w	00_*2048+00_*64+00_*2+0_

BP:	dc.w	$0103,$0104,$0105,$0104

MSG_VER:dc.b	"VALZARD@@V2:00",0
MSG_VDL:dc.b	"@@@@@@@@@@@@@@",0
MSG_TIT:dc.b	"PUSH@TRIGGER",0
MSG_TDL:dc.b	"@@@@@@@@@@@@",0
MSG_SC:	dc.b	"SCORE",0
MSG_ST:	dc.b	"STAGE@"
MSTN:	dc.b	$30
	dc.b	0
MSG_RE:	dc.b	"@@READY@@",0
MSG_RD:	dc.b	"@@@@@@@@@",0
MSG_STD:dc.b	"@@@@@@@@",0
MSG_GOV:dc.b	"GAME@OVER",0
MSG_GOD:dc.b	"@@@@@@@@@",0
MSG_CON:dc.b	"CONGRATULATIONS",0
MSG_CDL:dc.b	"@@@@@@@@@@@@@@@",0
SYM_TIT:dc.b	"VALZARD",0
	.even

SYM_PAR:dc.w	0		*  0: X
	dc.w	0		*  2: Y
	dc.l	SYM_TIT		*  4: STR ADDRESS
	dc.b	2		*  8: H MUL
	dc.b	2		*  9: V MUL
	dc.w	0		* 10: PALET CODE
	dc.b	2		* 12: FONT TYPE
	dc.b	0		* 13: 0ﬂ 90ﬂ 180ﬂ 270ﬂ

SYM_XYP:dc.w	44,52,6
	dc.w	45,52,6
	dc.w	46,52,6
	dc.w	47,52,6

	dc.w	43,53,6
	dc.w	44,53,6
	dc.w	45,53,6
	dc.w	46,53,6

	dc.w	42,48,8
	dc.w	43,48,8
	dc.w	44,48,8
	dc.w	45,48,8

	dc.w	42,49,8
	dc.w	43,49,8
	dc.w	44,49,8
	dc.w	45,49,8

	dc.w	42,50,8
	dc.w	43,50,8
	dc.w	44,50,8
	dc.w	45,50,8

	dc.w	42,51,8
	dc.w	43,51,8
	dc.w	44,51,8
	dc.w	45,51,8

	dc.w	43,49,6
	dc.w	44,49,6
	dc.w	43,50,6
	dc.w	44,50,6

	dc.w	44,50,7

TS:	dc.l	$0001_0000

RNDADDR:dc.l	RNDSTAT

ETCADDR:dc.l	N_STAGE		* $F000
	dc.l	0		* -----
	dc.l	W_EDEAD		* $F002
	dc.l	W_BDEAD		* $F003
	dc.l	W_EBDED		* $F004
	dc.l	W_BCANU		* $F005
	dc.l	WLOOP		* $F006
	dc.l	N_ROUND		* $F007
	dc.l	HEADER		* $F008
	dc.l	BYEBYE		* $F009
	dc.l	PRN_CON		* $F00A
	dc.l	DEL_CON		* $F00B
	dc.l	W_EIDED		* $F00C
	dc.l	W_E49TP		* $F00D
	dc.l	XSCSSET		* $F00E
	dc.l	YSCSSET		* $F00F

SPWAIT:	dc.w	0

E_SPPO:	dc.l	0

MBC:	dc.w	0
	dc.w	$808,$808,$808,$808,$808,$808,$808,$808,$808,$808,$808,$808,$808,$808,$808,$808
	dc.w	$809,$809,$809,$809,$809,$809,$809,$809,$809,$809,$809,$809,$809,$809,$809,$809
	dc.w	$80A,$80A,$80A,$80A,$80A,$80A,$80A,$80A,$80A,$80A,$80A,$80A,$80A,$80A,$80A,$80A
	dc.w	$80B,$80B,$80B,$80B,$80B,$80B,$80B,$80B,$80B,$80B,$80B,$80B,$80B,$80B,$80B,$80B
	dc.w	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.w	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.w	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.w	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.w	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.w	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

POINT1:	dc.b	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	dc.b	$F1,$F1,$F1,$F1,$F1,$F1,$F1,$F1,$F1,$F1,$F1,$F1,$F1,$F1,$F1,$F1
	dc.b	$F1,$F1,$F1,$F1,$F1,$F1,$F1,$F1,$F1,$F1,$F1,$F1,$F1,$F1,$F1,$F1
	dc.b	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	dc.b	$88,0
	dc.l	POINT1

POINT2:	dc.b	$F0,$00
	dc.b	$88,0
	dc.l	POINT2

POINT3:	dc.b	$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE
	dc.b	$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE
L_PO3:	dc.b	$E0,$E0
	dc.b	$88,0
	dc.l	L_PO3

POINT4:	dc.b	$F2,$F2,$F2,$F2,$F2,$F2,$F2,$F2,$F2,$F2,$F2,$F2,$F2,$F2,$F2,$F2
	dc.b	$F2,$F2,$F2,$F2,$F2,$F2,$F2,$F2,$F2,$F2,$F2,$F2,$F2,$F2,$F2,$F2
L_PO4:	dc.b	$E0,$E0
	dc.b	$88,0
	dc.l	L_PO4

POINT5:	dc.b	$F0,$00
	dc.b	$88,0
	dc.l	POINT5

POINT6:	dc.b	$F0,$F0
	dc.b	$88,0
	dc.l	POINT6

POINT7:	dc.b	$E0,$F0
	dc.b	$88,0
	dc.l	POINT7

POINT8:	dc.b	$E0,$E0
	dc.b	$88,0
	dc.l	POINT7

POINT9:	dc.b	$E0,$E0,$D0,$D0,$C0,$C0,$B0,$B0,$A0,$A0,$90,$90,$80,$80,$80,$8F
	dc.b	$8E,$8D,$8D,$8C,$8C,$8A,$87,$98,$A8,$B8,$D8,$E8,$E8,$F8,$F8,$F8
	dc.b	$08,$0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A

POINT10:dc.b	$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0
	dc.b	$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0
	dc.b	$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0
	dc.b	$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0
	dc.b	$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0
	dc.b	$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0
	dc.b	$F0,$F0,$F0,$F0,$F0,$F1,$F0,$F0,$F0,$F1,$F1,$F1,$01,$01,$F1,$02
	dc.b	$02,$12
L_PO10:	dc.b	$11,$22
	dc.b	$88,0
	dc.l	L_PO10

POINT11:dc.b	$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0
	dc.b	$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0
	dc.b	$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0
	dc.b	$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0
	dc.b	$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0
	dc.b	$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0
	dc.b	$F0,$F0,$F0,$F0,$F0,$FF,$F0,$F0,$F0,$FF,$FF,$FF,$0F,$0F,$FF,$0E
	dc.b	$0E,$1E
L_PO11:	dc.b	$1F,$2E
	dc.b	$88,0
	dc.l	L_PO11

POINT12:dc.b	$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0
	dc.b	$F0,$F0,$F0,$F0,$F0,$F0,$F1,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0
	dc.b	$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F1,$F0,$F0
	dc.b	$D0,$D0,$F0,$F1,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F1,$F0,$F0,$F0,$F0
	dc.b	$F0,$F1,$F0,$F0,$F0,$F0,$F1,$F0,$F0,$F0,$F0,$F0,$F0,$F1,$F0,$F0
	dc.b	$F0,$F0,$F1,$F0,$F0,$F0,$F0,$F0,$F1,$F0,$F0,$F0,$F0,$F1,$E0,$F1
	dc.b	$F0,$F0,$F1,$F0,$F0,$F1,$F0,$F0,$F1,$E2,$F1,$F1,$F1,$F1,$F2,$F2
	dc.b	$F2,$F2,$F2,$01,$01,$01,$F1,$01,$01,$01,$01,$F1,$01,$01,$01,$01
	dc.b	$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
	dc.b	$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
	dc.b	$01,$01,$01,$02,$01,$01,$02,$01,$01,$01,$01,$01,$01,$01,$01,$01
	dc.b	$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$F1
	dc.b	$01,$01,$01,$F1,$01,$00,$01,$01,$F1,$01,$01,$F1,$E2,$F1,$F1,$F1
	dc.b	$F1,$F1,$F0,$F1,$F0,$F1,$F1,$F0,$F1,$F0,$F1,$F1,$F0,$F0,$F1,$F0
	dc.b	$F0,$F0,$F1,$F0,$F0,$F0,$F0,$F0,$F1,$F0,$F0,$F0,$F0,$F0,$F0,$F0
	dc.b	$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0
	dc.b	$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$FF
	dc.b	$F0,$F0,$F0,$FF,$F0,$F0,$F0,$FF,$F0,$F0,$FF,$F0,$FF,$F0,$FF,$FF
	dc.b	$FF,$FF,$FF,$FF,$0F,$FF,$0F,$0F,$FF,$0F,$0F,$0F,$0F,$0F,$FF,$0F
	dc.b	$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$FF,$0F
	dc.b	$0F,$0F,$0F,$0F,$0F,$FE,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F
	dc.b	$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F
	dc.b	$0F,$0F,$1F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$1F,$0F,$0F,$0F,$0F,$0F
	dc.b	$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$1F,$0F,$0F,$0F
	dc.b	$0F,$0F,$1F,$0F,$0F,$1F,$0F,$1F,$1F,$1F,$1F,$1F,$1F,$1F,$20,$1F
	dc.b	$30,$1F,$10,$10,$10,$10,$10,$10,$2F,$10,$10,$10,$10,$10,$10,$10
	dc.b	$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10
	dc.b	$10,$10,$10,$10,$10,$10,$20,$10,$10,$10,$10,$10,$10,$10,$10,$11
	dc.b	$10,$10,$10,$10,$11,$10,$10,$10,$11,$20,$11,$11,$11,$11,$11,$01
	dc.b	$11,$12,$11,$01,$11,$01,$01,$11,$01,$01,$01,$01,$01,$01,$11,$01
	dc.b	$01,$01,$01,$01,$11,$01,$01,$01,$01,$01,$01,$11,$01,$01,$01,$01
	dc.b	$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$02,$01,$F1,$F1,$E1,$F1
	dc.b	$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$E0,$E0,$E0
	dc.b	$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0
	dc.b	$E0,$E0,$D0,$D0,$C0,$C0,$C0,$C0,$C0,$B0,$B0,$B0,$B0,$B0,$B0,$B0
	dc.b	$A0,$B0,$B0,$B0,$B0,$B0,$B0,$B0

POINT13:dc.b	$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0
	dc.b	$F0,$F0,$F0,$F0,$F0,$F0,$0F,$0F,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
	dc.b	$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
	dc.b	$0E,$0E,$0E,$0E,$0E,$0E,$E2,$E2,$E2,$E2,$E2,$E2,$E2,$E2,$E2,$E2
	dc.b	$E2,$E2,$E2,$E2,$E2,$E2,$E2,$E2,$E2,$E2,$E2,$E2,$E2,$E2,$E2,$E2
	dc.b	$E2,$E2,$E2,$F1,$F1,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22
	dc.b	$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22
	dc.b	$22,$22,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
	dc.b	$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$DD,$DD
	dc.b	$DD,$DD,$DD,$DD,$DD,$DD,$DD,$DD,$DD,$DD,$DD,$DD,$DD,$DD,$DD,$DD
	dc.b	$DD,$DD,$DD,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04
	dc.b	$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04
	dc.b	$04,$04,$04,$4C,$4C,$4C,$4C,$4C,$4C,$4C,$4C,$4C,$5B,$5B,$4C,$4C
	dc.b	$4C,$4C,$0F,$0F,$B0,$B0,$B0,$B0,$B0,$B0,$A0,$A0,$A0,$90,$90,$80
	dc.b	$90,$90,$90,$A0,$A0,$A0,$C0,$C0,$C0,$08,$08,$08,$08,$08,$08,$08
	dc.b	$08,$08,$08,$08,$08,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07
	dc.b	$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$06
	dc.b	$06,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$0E,$10,$10
	dc.b	$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10
	dc.b	$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$70,$10,$10,$10
	dc.b	$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$20
	dc.b	$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10
	dc.b	$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$20,$10,$10,$10,$10,$10
	dc.b	$10,$10,$00,$00,$00,$07,$07,$07,$07,$07,$07,$00,$00,$00,$00,$00
	dc.b	$00,$07,$07,$07,$07,$07,$00,$00,$00,$00,$00,$00,$00,$07,$07,$07
	dc.b	$07,$07,$07,$07,$07,$2E,$2E,$2E,$2E,$2E,$2E,$22,$22,$22,$22,$22
	dc.b	$22,$2E,$2E,$2E,$2E,$2E,$2F,$22,$22,$22,$22,$22,$22,$3D,$4D,$07

POINT14:dc.b	$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0
	dc.b	$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0
	dc.b	$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0
	dc.b	$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0
	dc.b	$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$E0,$F0,$E0,$F0
	dc.b	$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$11
	dc.b	$22,$11,$22,$11,$22,$11,$22,$11,$22,$11,$22,$11,$22,$11,$22,$11
	dc.b	$22,$11,$22,$11,$22,$11,$22,$11,$22,$11,$22,$11,$22,$11,$22,$11
	dc.b	$22,$11,$22,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0
	dc.b	$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0
	dc.b	$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0
	dc.b	$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$11,$22,$11,$22,$11,$22,$11
	dc.b	$22,$11,$22,$11,$22,$11,$22,$11,$22,$11,$22,$11,$22,$F0,$E0,$F0
	dc.b	$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0
	dc.b	$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0
	dc.b	$E0,$F0,$E0,$F0,$E0,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22
	dc.b	$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$32,$21,$31,$32,$41
	dc.b	$31,$30
L_PO14:	dc.b	$30,$30
	dc.b	$88,0
	dc.l	L_PO14

POINT15:dc.b	$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0
	dc.b	$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0
	dc.b	$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0
	dc.b	$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0
	dc.b	$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$E0,$F0,$E0,$F0
	dc.b	$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$1F
	dc.b	$2E,$1F,$2E,$1F,$2E,$1F,$2E,$1F,$2E,$1F,$2E,$1F,$2E,$1F,$2E,$1F
	dc.b	$2E,$1F,$2E,$1F,$2E,$1F,$2E,$1F,$2E,$1F,$2E,$1F,$2E,$1F,$2E,$1F
	dc.b	$2E,$1F,$2E,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0
	dc.b	$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0
	dc.b	$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0
	dc.b	$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$1F,$2E,$1F,$2E,$1F,$2E,$1F
	dc.b	$2E,$1F,$2E,$1F,$2E,$1F,$2E,$1F,$2E,$1F,$2E,$1F,$2E,$F0,$E0,$F0
	dc.b	$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0
	dc.b	$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0
	dc.b	$E0,$F0,$E0,$F0,$E0,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E
	dc.b	$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E,$3E,$2F,$3F,$3E,$4F
	dc.b	$3F,$30
L_PO15:	dc.b	$30,$30
	dc.b	$88,0
	dc.l	L_PO15

POINT16:dc.b	$F0,$FF,$F0,$F0,$F0,$F0,$F0,$FF,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0
	dc.b	$F0,$F0,$FF,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0
	dc.b	$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$FF,$F0,$F0,$F0,$F0,$F0,$F0,$F0
	dc.b	$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$FF,$F0,$F0,$F0,$F0,$F0
	dc.b	$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$FF,$F0,$F0,$F0,$F0,$F0,$F0
	dc.b	$F0,$F0,$EF,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$FF,$F0,$F0
	dc.b	$F0,$F0,$F0,$F0,$F0,$FF,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0
L_PO16:	dc.b	$E0,$F0
	dc.b	$F0,$F0,$F0,$F0,$FF,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0
	dc.b	$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F1,$F0,$F0,$F0,$F0,$F0,$F0,$F1,$F0
	dc.b	$F0,$F0,$F0,$F1,$F0,$F0,$F1,$F0,$F0,$F0,$F1,$F0,$F0,$F1,$F0,$F1
	dc.b	$F0,$F0,$F1,$F0,$F1,$F0,$F1,$F0,$F1,$F0,$F1,$F1,$F0,$F1,$F0,$F1
	dc.b	$F1,$F0,$F1,$F1,$F1,$F0,$F1,$F1,$F1,$F1,$F1,$F1,$F1,$F1,$F1,$F1
	dc.b	$F1,$F1,$F1,$F1,$F1,$01,$F1,$F1,$F1,$01,$F1,$F1,$01,$F1,$01,$F1
	dc.b	$F1,$01,$F1,$01,$F1,$01,$F1,$01,$F1,$01,$01,$F1,$01,$F1,$01,$01
	dc.b	$F1,$01,$01,$01,$F1,$01,$01,$F1,$01,$01,$01,$01,$F1,$01,$01,$01
	dc.b	$01,$01,$01,$F1,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
	dc.b	$01,$01,$01,$01,$01,$01,$11,$01,$01,$01,$01,$01,$01,$11,$01,$01
	dc.b	$01,$01,$11,$01,$01,$11,$01,$01,$01,$11,$01,$01,$11,$01,$11,$01
	dc.b	$01,$11,$01,$11,$01,$10,$01,$01,$11,$01,$10,$01,$11,$01,$11,$01
	dc.b	$11,$11,$01,$11,$11,$11,$01,$11,$11,$11,$11,$11,$11,$11,$11,$11
	dc.b	$11,$11,$11,$11,$11,$11,$10,$11,$11,$11,$10,$11,$11,$10,$11,$10
	dc.b	$11,$11,$10,$11,$10,$11,$10,$11,$10,$11,$10,$10,$11,$10,$11,$10
	dc.b	$10,$11,$10,$10,$10,$11,$10,$10,$11,$10,$10,$10,$10,$11,$10,$10
	dc.b	$10,$10,$10,$10,$11,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10
	dc.b	$10,$10,$10,$10,$10,$10,$10,$1F,$10,$10,$10,$10,$10,$10,$1F,$10
	dc.b	$10,$10,$10,$1F,$10,$10,$1F,$10,$10,$10,$1F,$10,$10,$1F,$10,$1F
	dc.b	$10,$10,$1F,$10,$1F,$10,$1F,$10,$1F,$10,$1F,$1F,$10,$1F,$10,$1F
	dc.b	$1F,$10,$1F,$1F,$1F,$10,$1F,$1F,$1F,$1F,$1F,$1F,$1F,$1F,$1F,$1F
	dc.b	$1F,$1F,$1F,$1F,$1F,$0F,$1F,$1F,$1F,$0F,$1F,$1F,$0F,$1F,$0F,$1F
	dc.b	$1F,$0F,$1F,$0F,$1F,$0F,$1F,$0F,$1F,$0F,$0F,$1F,$0F,$1F,$0F,$0F
	dc.b	$1F,$0F,$0F,$0F,$1F,$0F,$0F,$1F,$0F,$0F,$0F,$0F,$1F,$0F,$0F,$0F
	dc.b	$0F,$0F,$0F,$1F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F
	dc.b	$0F,$0F,$0F,$0F,$0F,$0F,$FF,$0F,$0F,$0F,$0F,$0F,$0F,$FF,$0F,$0F
	dc.b	$0F,$0F,$FF,$0F,$0F,$FF,$0F,$0F,$0F,$FF,$0F,$0F,$FF,$0F,$FF,$0F
	dc.b	$0F,$FF,$0F,$FF,$0F,$FF,$0F,$FF,$0F,$FF,$FF,$0F,$FF,$0F,$FF,$FF
	dc.b	$0F,$FF,$FF,$FF,$0F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	dc.b	$FF,$FF,$FF,$FF,$F0,$FF,$FF,$FF,$F0,$FF,$FF,$F0,$FF,$F0,$FF,$FF
	dc.b	$F0,$FF,$F0,$FF,$F0,$FF,$F0,$FF,$F0,$F0,$FF,$F0,$FF,$F0,$F0,$FF
	dc.b	$F0,$F0,$F0,$FF,$F0,$F0,$FF,$F0,$F0,$F0,$F0,$FF
	dc.b	$88,0
	dc.l	L_PO16

POINT17:dc.b	$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0
	dc.b	$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0
	dc.b	$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0
	dc.b	$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0
	dc.b	$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0
	dc.b	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	dc.b	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	dc.b	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	dc.b	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	dc.b	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	dc.b	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	dc.b	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	dc.b	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
L_PO17:	dc.b	$20,$10
	dc.b	$88,0
	dc.l	L_PO17

POINT18:dc.b	$F0,$DD,$DD,$DD,$DD,$DD,$DD,$DD,$DD,$DD,$DD,$DD,$DD,$DD,$DD,$DD
	dc.b	$DD,$DD,$DD,$DD,$DD,$DD,$DD,$DD,$DD,$DD,$DD,$DD,$DD,$DD,$DD,$DD
	dc.b	$DD,$DD,$DD,$DD,$DD,$DD,$DD,$DD,$DD,$D3,$D3,$D3,$D3,$D3,$D3,$D3
	dc.b	$D3,$D3,$D3,$D3,$D3,$D3,$D3,$D3,$D3,$D3,$D3,$D3,$D3,$D3,$D3,$D3
	dc.b	$D3,$D3,$D3,$D3,$D3,$D3,$D3,$D3,$D3,$D3,$D3,$D3,$D3,$D3,$D3,$D3
	dc.b	$D3,$D3,$D3,$D3,$D3,$D3,$33,$33,$33,$33,$33,$33,$33,$33,$33,$33
	dc.b	$33,$33,$33,$33,$33,$33,$33,$33,$33,$33,$33,$33,$33,$33,$33,$33
	dc.b	$33,$33,$33,$33,$33,$33,$33,$33,$33,$3D
L_PO18:	dc.b	$3D,$3D
	dc.b	$88,0
	dc.l	L_PO18

POINT19:dc.b	$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0
	dc.b	$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0
	dc.b	$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0
	dc.b	$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0
	dc.b	$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0
	dc.b	$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0
	dc.b	$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0
	dc.b	$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0
	dc.b	$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0
	dc.b	$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0
	dc.b	$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0
	dc.b	$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0
	dc.b	$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F1
	dc.b	$F0,$F0,$F0,$F0,$F0,$F0,$F1,$F0,$F0,$F0,$F0,$F0,$F1,$F0,$F0,$F0
	dc.b	$F1,$F0,$F0,$F1,$F0,$F0,$F1,$F0,$F1,$F0,$F1,$F1,$F1,$F1,$F1,$F1
	dc.b	$F1,$F1,$01,$F1,$01,$F1,$01,$F1,$01,$F1,$01,$F1,$01,$01,$F1,$01
	dc.b	$01,$F2,$01,$01,$01,$F1,$01,$01,$01,$F1,$01,$01,$01,$F1,$01,$01
	dc.b	$01,$01,$F2,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
	dc.b	$01,$01,$01,$01,$01,$01,$01,$01,$01,$11,$01,$01,$01,$01,$11,$01
	dc.b	$01,$01,$11,$01,$01,$01,$11,$01,$01,$01,$11,$01,$01,$11,$01,$01
	dc.b	$11,$01,$01,$11,$01,$11,$01,$11,$01,$11,$11,$11,$11,$11,$10,$11
	dc.b	$10,$10,$10,$11,$10,$10,$10,$11,$10,$10,$10,$10,$10,$10,$10,$10
	dc.b	$10,$10,$10,$10,$10,$10,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	dc.b	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	dc.b	$00,$00,$00,$00,$00,$00,$00,$2D,$2D,$2D,$3D,$3D,$3D,$3E,$3E,$4D
	dc.b	$3E,$3E,$3E,$3E,$3E,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F
	dc.b	$3F,$3F,$3F,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	dc.b	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	dc.b	$07,$07,$07,$07,$07,$07,$07,$07
	dc.b	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	dc.b	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$D1,$D1,$D1
	dc.b	$D1,$D1,$D1,$D1,$D1,$D1,$D1,$D1,$D1,$D1,$D1,$D2,$D2,$D2,$D2,$D2
	dc.b	$C3,$D2,$D2,$D3,$D3,$D3,$D3,$E3,$E3,$00,$00,$00,$00,$00,$00,$00
	dc.b	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	dc.b	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$F0,$F0,$F0,$F0,$F0,$F0
	dc.b	$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$FF,$F0,$F0,$F0,$FF,$F0,$F0,$F0
	dc.b	$FF,$F0,$FF,$FF,$FF,$FF,$FF,$0F,$FF,$0F,$FF,$0F,$FF,$0F,$0F,$FF
	dc.b	$0F,$0F,$FF,$0F,$0F,$FF,$0F,$0F,$0F,$FF,$0F,$0F,$0F,$FF,$0F,$0F
	dc.b	$0F,$FF,$0F,$0F,$0F,$0F,$FF,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F
	dc.b	$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$1E,$0F,$0F
	dc.b	$0F,$0F,$1F,$0F,$0F,$0F,$1F,$0F,$0F,$0F,$1F,$0F,$0F,$0F,$1E,$0F
	dc.b	$0F,$1F,$0F,$0F,$1F,$0F,$1F,$0F,$1F,$0F,$1F,$0F,$1F,$0F,$1F,$1F
	dc.b	$1F,$1F,$1F,$1F,$1F,$1F,$10,$1F,$10,$1F,$10,$10,$1F,$10,$10,$1F
	dc.b	$10,$10,$10,$1F,$10,$10,$10,$10,$10,$1F,$10,$10,$10,$10,$10,$10
	dc.b	$1F,$10
L_PO19:	dc.b	$10,$10
	dc.b	$88,0
	dc.l	L_PO19

POINT20:dc.b	$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0
	dc.b	$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$F0,$E0,$F0
	dc.b	$E0,$F0,$E0,$F0,$E0,$F0,$E1,$F0,$E0,$F1,$E0,$F1,$E0,$F1,$E0,$F1
	dc.b	$E0,$F1,$E0,$F1,$E0,$F1,$E0,$F1,$E0,$F1,$E0,$F1,$E0,$F1,$D0,$D0
	dc.b	$F1,$D0,$F1,$D0,$F1,$E1,$D1,$F1,$E1,$E2,$F0,$E2,$E2,$F2,$E2,$F2
	dc.b	$F2,$F2,$F2,$F2,$02,$F2,$02,$F2,$03,$03,$03,$02,$12,$02,$12,$02
	dc.b	$12,$12,$12,$12,$22,$12,$22,$22,$21,$22,$21,$21,$21,$21,$21,$20
	dc.b	$21,$20,$11,$20,$20,$30,$30,$20,$1F,$30,$1F,$30,$1F,$3F,$1F,$3F
	dc.b	$1F,$2E,$10,$3D,$2E,$0F,$1F,$2E,$0F,$1F,$0F,$1F,$0F,$2D,$1A,$1E
	dc.b	$0D,$0D,$0D,$0D,$FF,$0D,$FF,$0D,$FF,$FE,$FE,$FE,$0F,$EE,$FF,$FE
	dc.b	$EE,$EE,$EF,$EE,$F0,$FF,$DF,$FF,$DF,$CF,$CF,$C0,$D0,$C0,$F1,$D0
	dc.b	$F1,$D0,$F1,$E1,$E1,$E1,$E1,$E2,$F0,$D3,$E2,$01,$D3,$01,$F2,$E4
	dc.b	$F1,$03,$F2,$F5,$03,$03,$03,$13,$02,$12,$02,$12,$12,$23,$01,$33
	dc.b	$01,$33,$22,$10,$33,$75,$75,$75,$74,$74,$75,$74,$73,$74,$73,$73
	dc.b	$73,$74,$73,$74,$73,$44

POINT21:dc.b	$E0,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1
	dc.b	$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1
	dc.b	$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1
	dc.b	$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E2,$F2,$F2,$F2,$01,$02,$02
	dc.b	$02,$02
	dc.b	$02,$02
	dc.b	$02,$02,$01,$12,$12,$12,$22,$21
L_PO21:	dc.b	$21,$21
	dc.b	$88,0
	dc.l	L_PO21

POINT22:dc.b	$E0,$E0,$E0,$E0
L_PO22:	dc.b	$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$FB,$FC
	dc.b	$FD,$EE,$FF,$F0,$F0,$F0,$F0,$F1,$F1,$F2,$F2,$F3,$03,$04,$05,$06
	dc.b	$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07
	dc.b	$07,$07,$07,$06,$05,$04,$F2,$03,$F2,$02,$F2,$F1,$F1,$F0,$F0,$F0
	dc.b	$FF,$FF,$0F,$FF,$0D,$FF,$0C,$FF,$0C,$0B,$0A,$09,$09,$09,$09,$09
	dc.b	$09,$09,$09,$09,$09
	dc.b	$88,0
	dc.l	L_PO22

POINT23:dc.b	$E0,$E0
	dc.b	$88,0
	dc.l	POINT23

POINT24:dc.b	$EF,$EF,$EF,$EF,$EF,$EF,$EF,$EF,$EF,$EF,$EF,$EF,$EF,$EF,$EF,$EF
	dc.b	$EF,$EF,$EF,$EF,$EF,$EF,$EF,$EF,$EF,$EF,$EF,$EF,$EF,$EF,$EF,$EF
L_PO24:	dc.b	$E0,$E0
	dc.b	$88,0
	dc.l	L_PO24

POINT25:dc.b	$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1
	dc.b	$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1
L_PO25:	dc.b	$E0,$E0
	dc.b	$88,0
	dc.l	L_PO25

POINT26:dc.b	$FE,$EE,$FE,$EE,$FE,$EE,$FE,$EE,$FE,$EE,$FE,$EE,$FE,$EE,$FE,$EE
	dc.b	$FE,$EE,$FE,$EE,$FE,$EE,$FE,$EE,$FE,$EE,$FE,$EE,$FE,$EE,$FE,$EE
L_PO26:	dc.b	$E0,$E0
	dc.b	$88,0
	dc.l	L_PO26

POINT27:dc.b	$F2,$E2,$F2,$E2,$F2,$E2,$F2,$E2,$F2,$E2,$F2,$E2,$F2,$E2,$F2,$E2
	dc.b	$F2,$E2,$F2,$E2,$F2,$E2,$F2,$E2,$F2,$E2,$F2,$E2,$F2,$E2,$F2,$E2
L_PO27:	dc.b	$E0,$E0
	dc.b	$88,0
	dc.l	L_PO27

POINT28:dc.b	$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$00,$00,$00,$00,$00,$00,$00,$00
L_PO28:	dc.b	$C0,$C0
	dc.b	$88,0
	dc.l	L_PO28

POINT29:dc.b	$04,$04,$04,$04,$04,$04,$04,$04,$00,$00,$00,$00,$00,$00,$00,$00
L_PO29:	dc.b	$C0,$C0
	dc.b	$88,0
	dc.l	L_PO29

POINT30:dc.b	$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$00,$00,$00,$00
L_PO30:	dc.b	$C0,$C0
	dc.b	$88,0
	dc.l	L_PO30

POINT31:dc.b	$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$00,$00,$00,$00
L_PO31:	dc.b	$C0,$C0
	dc.b	$88,0
	dc.l	L_PO31

POINT32:dc.b	$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C
L_PO32:	dc.b	$C0,$C0
	dc.b	$88,0
	dc.l	L_PO32

POINT33:dc.b	$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04
L_PO33:	dc.b	$C0,$C0
	dc.b	$88,0
	dc.l	L_PO33

POINT34:dc.b	$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0
	dc.b	$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$F0,$E0,$F0
	dc.b	$E0,$F0,$E0,$F0,$E0,$F0,$EF,$F0,$E0,$FF,$E0,$FF,$E0,$FF,$E0,$FF
	dc.b	$E0,$FF,$E0,$FF,$E0,$FF,$E0,$FF,$E0,$FF,$E0,$FF,$E0,$FF,$D0,$D0
	dc.b	$FF,$D0,$FF,$D0,$FF,$EF,$DF,$FF,$EF,$EE,$F0,$EE,$EE,$FE,$EE,$FE
	dc.b	$FE,$FE,$FE,$FE,$0E,$FE,$0E,$FE,$0D,$0D,$0D,$0E,$1E,$0E,$1E,$0E
	dc.b	$1E,$1E,$1E,$1E,$2E,$1E,$2E,$2E,$2F,$2E,$2F,$2F,$2F,$2F,$2F,$20
	dc.b	$2F,$20,$1F,$20,$20,$30,$30,$20,$11,$30,$11,$30,$11,$31,$11,$31
	dc.b	$11,$22,$10,$33,$22,$01,$11,$22,$01,$11,$01,$11,$01,$23,$16,$12
	dc.b	$03,$03,$03,$03,$F1,$03,$F1,$03,$F1,$F2,$F2,$F2,$01,$E2,$F1,$F2
	dc.b	$E2,$E2,$E1,$E2,$F0,$F1,$D1,$F1,$D1,$C1,$C1,$C0,$D0,$C0,$FF,$D0
	dc.b	$FF,$D0,$FF,$EF,$EF,$EF,$EF,$EE,$F0,$DD,$EE,$0F,$DD,$0F,$FE,$EC
	dc.b	$FF,$0D,$FE,$FB,$0D,$0D,$0D,$1D,$0E,$1E,$0E,$1E,$1E,$2D,$0F,$3D
	dc.b	$0F,$3D,$2E,$10,$3D,$7B,$7B,$7B,$7C,$7C,$7B,$7C,$7D,$7C,$7D,$7D
	dc.b	$7D,$7C,$7D,$7C,$7D,$4C

POINT35:dc.b	$F0,$00,$F0,$00,$F0,$00,$F0,$0F
	dc.b	$88,0
	dc.l	POINT35

POINT36:dc.b	$F0,$F0,$F0,$F0,$F0,$F0,$F0,$FF
	dc.b	$88,0
	dc.l	POINT36

POINT37:dc.b	$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0
	dc.b	$88,0
	dc.l	POINT37

POINT38:dc.b	$E0,$E0,$E0,$E0,$E0,$E0,$E0,$EF
	dc.b	$88,0
	dc.l	POINT38

POINT39:dc.b	$F0,$00,$F0,$00,$F0,$00,$F0,$01
	dc.b	$88,0
	dc.l	POINT39

POINT40:dc.b	$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F1
	dc.b	$88,0
	dc.l	POINT40

POINT41:dc.b	$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F1
	dc.b	$88,0
	dc.l	POINT41

POINT42:dc.b	$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E1
	dc.b	$88,0
	dc.l	POINT42

POINT43:dc.b	$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0
L_PO43:	dc.b	$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0
	dc.b	$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0
	dc.b	$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0
	dc.b	$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0
	dc.b	$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0
	dc.b	$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0
	dc.b	$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0
	dc.b	$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0
	dc.b	$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
	dc.b	$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
	dc.b	$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
	dc.b	$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
	dc.b	$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
	dc.b	$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
	dc.b	$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
	dc.b	$20,$20,$20,$20,$20,$20,$20,$20
	dc.b	$88,0
	dc.l	L_PO43

B_PO1:	dc.b	$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0
	dc.b	$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0
L_B_PO1:dc.b	$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
	dc.b	$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
	dc.b	$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
	dc.b	$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
	dc.b	$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
	dc.b	$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
	dc.b	$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
	dc.b	$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
	dc.b	$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
	dc.b	$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
	dc.b	$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
	dc.b	$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
	dc.b	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

	dc.b	$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$E0,$E0,$E0,$E0
	dc.b	$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$D0,$D0,$D0,$D0,$D0,$D0,$D0,$D0
	dc.b	$D0,$D0,$D0,$D0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0
	dc.b	$B0,$B0,$B0,$B0,$B0,$B0,$B0,$B0,$B0,$B0,$B0,$B0,$A0,$A0,$A0,$A0
	dc.b	$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
	dc.b	$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
	dc.b	$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
	dc.b	$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
	dc.b	$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
	dc.b	$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
	dc.b	$20,$20,$20,$20,$20,$20

	dc.b	$88,0
	dc.l	L_B_PO1


B_PO2:	dc.b	$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0
	dc.b	$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0
L_B_PO2:dc.b	$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
	dc.b	$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
	dc.b	$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
	dc.b	$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
	dc.b	$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
	dc.b	$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
	dc.b	$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
	dc.b	$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
	dc.b	$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
	dc.b	$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
	dc.b	$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
	dc.b	$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
	dc.b	$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
	dc.b	$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
	dc.b	$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
	dc.b	$88,0
	dc.l	L_B_PO2

B_PO3:

B_PO5:	dc.b	$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0
	dc.b	$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0
	dc.b	$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0
	dc.b	$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0
L_B_PO5:dc.b	$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0
	dc.b	$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0
	dc.b	$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0
	dc.b	$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0
	dc.b	$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0
	dc.b	$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0
	dc.b	$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0
	dc.b	$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0
	dc.b	$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0
	dc.b	$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0
	dc.b	$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0
	dc.b	$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0
	dc.b	$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F
	dc.b	$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F
	dc.b	$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F
	dc.b	$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F
	dc.b	$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F
	dc.b	$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F
	dc.b	$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F
	dc.b	$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F
	dc.b	$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10
	dc.b	$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10
	dc.b	$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10
	dc.b	$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10
	dc.b	$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10
	dc.b	$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10
	dc.b	$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10
	dc.b	$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10
	dc.b	$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10
	dc.b	$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10
	dc.b	$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10
	dc.b	$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10
	dc.b	$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
	dc.b	$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
	dc.b	$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
	dc.b	$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
	dc.b	$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
	dc.b	$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
	dc.b	$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
	dc.b	$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
	dc.b	$88,0
	dc.l	L_B_PO5

B_PO6:	dc.b	$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0
	dc.b	$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0
	dc.b	$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0
	dc.b	$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0
L_B_PO6:dc.b	$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F
	dc.b	$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F
	dc.b	$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F
	dc.b	$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F
	dc.b	$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F
	dc.b	$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F
	dc.b	$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F
	dc.b	$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
	dc.b	$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
	dc.b	$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
	dc.b	$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
	dc.b	$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
	dc.b	$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
	dc.b	$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
	dc.b	$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
	dc.b	$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
	dc.b	$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
	dc.b	$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
	dc.b	$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
	dc.b	$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
	dc.b	$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
	dc.b	$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F
	dc.b	$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F
	dc.b	$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F
	dc.b	$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F
	dc.b	$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F
	dc.b	$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F
	dc.b	$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F
	dc.b	$88,0
	dc.l	L_B_PO6

PC_PO1:	dc.w	$620,$621
	dc.w	$FFFF
	dc.l	PC_PO1

PC_PO2:	dc.w	$622,$622,$622,$622,$622,$622,$622,$622,$623,$623,$623,$623,$623,$623,$623,$623
	dc.w	$FFFF
	dc.l	PC_PO2

PC_PO3:	dc.w	$130,$131
	dc.w	$FFFF
	dc.l	PC_PO3

PC_PO4:	dc.w	$728,$728
	dc.w	$FFFF
	dc.l	PC_PO4

PC_PO5:	dc.w	$729,$729
	dc.w	$FFFF
	dc.l	PC_PO5

PC_PO6:	dc.w	$72A,$72A
	dc.w	$FFFF
	dc.l	PC_PO6

PC_PO7:	dc.w	$72B,$72B
	dc.w	$FFFF
	dc.l	PC_PO7

PC_PO8:	dc.w	$146,$146
	dc.w	$FFFF
	dc.l	PC_PO8

PC_PO9:	dc.w	$138,$138
	dc.w	$FFFF
	dc.l	PC_PO9

PC_PO10:dc.w	$134,$134,$135,$135,$136,$136,$137,$137
	dc.w	$FFFF
	dc.l	PC_PO10

PC_PO11:dc.w	$C40,$C40
	dc.w	$FFFF
	dc.l	PC_PO11

PC_PO12:dc.w	$139,$139
	dc.w	$FFFF
	dc.l	PC_PO12

PC_PO13:dc.w	$13C,$13C
	dc.w	$FFFF
	dc.l	PC_PO13

PC_PO14:dc.w	$624,$624,$624,$624,$624,$624,$624,$624,$625,$625,$625,$625,$625,$625,$625,$625
	dc.w	$624,$624,$624,$624,$624,$624,$624,$624,$625,$625,$625,$625,$625,$625,$625,$625
	dc.w	$624,$624,$624,$624,$624,$624,$624,$624,$625,$625,$625,$625,$625,$625,$625,$625
	dc.w	$624,$624,$624,$624,$624,$624,$624,$624,$625,$625,$625,$625,$625,$625,$625,$625
	dc.w	$624,$624,$624,$624,$624,$624,$624,$624,$625,$625,$625,$625,$625,$625,$625,$625
	dc.w	$624,$624,$624,$624,$624,$624,$624,$624,$624,$624,$624,$624,$624,$624,$624,$624
	dc.w	$624,$624,$624,$624,$624,$624,$624,$624,$624,$624,$624,$624,$624,$624,$624,$624
	dc.w	$624,$624,$624,$624,$624,$624,$624,$624,$624,$624,$624,$624,$624,$624,$624,$624
	dc.w	$624,$624,$624,$624,$624,$624,$624,$624,$624,$624,$624,$624,$624,$624,$624,$624
	dc.w	$624,$624,$624,$624,$624,$624,$624,$624,$624,$624,$624,$624,$624,$624,$624,$624
	dc.w	$624,$624,$624,$624,$624,$624,$624,$624,$624,$624,$624,$624,$624,$624,$624,$624
	dc.w	$624,$624,$624,$624,$624,$624,$624,$624,$624,$624,$624,$624,$624,$624,$624,$624
	dc.w	$624,$624,$624,$624,$624,$624,$624,$624,$624,$624,$624,$624,$624,$624,$624,$624
L_PCP14:dc.w	$4624,$4624,$4624,$4624,$4624,$4624,$4624,$4624
	dc.w	$4625,$4625,$4625,$4625,$4625,$4625,$4625,$4625
	dc.w	$FFFF
	dc.l	L_PCP14

PC_PO15:dc.w	$13B,$13B
	dc.w	$FFFF
	dc.l	PC_PO15

PC_PO16:dc.w	$13D,$13D
	dc.w	$FFFF
	dc.l	PC_PO16

PC_PO17:dc.w	$13A,$13A
	dc.w	$FFFF
	dc.l	PC_PO17

PC_PO18:dc.w	$144,$144,$144,$144,$144,$144,$144,$144,$144,$144,$144,$144,$144,$144,$144,$144
	dc.w	$144,$144,$144,$144,$144,$144,$144,$144,$144,$144,$144,$144,$144,$144,$144,$144
	dc.w	$144,$144,$144,$144,$144,$144,$144,$144,$144,$144,$144,$144,$144,$144,$144,$144
	dc.w	$144,$144,$144,$144,$144,$144,$144,$144,$144,$144,$144,$144,$144,$144,$144,$144
	dc.w	$144,$144
L_PCP18:dc.w	$4144,$4144
	dc.w	$FFFF
	dc.l	L_PCP18

PC_PO19:dc.w	$145,$145
	dc.w	$FFFF
	dc.l	PC_PO19

PC_PO20:dc.w	$147,$147
	dc.w	$FFFF
	dc.l	PC_PO20

PC_PO21:dc.w	$72C,$72C
	dc.w	$FFFF
	dc.l	PC_PO21

PC_PO22:dc.w	$72D,$72D
	dc.w	$FFFF
	dc.l	PC_PO22

PC_PO23:dc.w	$72E,$72E
	dc.w	$FFFF
	dc.l	PC_PO23

PC_PO24:dc.w	$72F,$72F
	dc.w	$FFFF
	dc.l	PC_PO24

PC_PO25:dc.w	$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43
L_PCP25:dc.w	$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43
	dc.w	$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43
	dc.w	$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43
	dc.w	$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43
	dc.w	$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43
	dc.w	$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43
	dc.w	$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43
	dc.w	$B43,$B43,$B43,$B43,$B43,$B43,$B43,$B43
	dc.w	$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43
	dc.w	$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43
	dc.w	$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43
	dc.w	$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43
	dc.w	$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43
	dc.w	$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43
	dc.w	$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43
	dc.w	$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43,$4B43
	dc.w	$FFFF
	dc.l	L_PCP25

E_DAT:
E_DAT1:	dc.w	$0100		*  0: SPRITE PATTERN CODE
	dc.w	1		*  2: HP
	dc.w	$0000		*  4: TAMA WAIT
	dc.w	$100		*  6: SCORE
	dc.w	0		*  8: 0: PATTERN  1:PROGRAMABLE
	dc.l	POINT1		* 10: POINTER  /  EXEC ADDRESS
				* 12:    ;             ;
	dc.l	E_INIT1		* 14: INIT ADDRESS   0: TRAP
				* 16:      ;
	dc.l	T_SET1		* 18: TAMA SET
				* 20:     ;
	dc.l	PC_PO1		* 22: PC POINTER  /  -----
				* 24:     ;            ;
	dc.l	BRN_RET		* 26: BURN TRAP EXEC ADDRESS
				* 28:           ;

E_DAT2:	dc.w	$0100		*  0: SPRITE PATTERN CODE
	dc.w	1		*  2: HP
	dc.w	$0000		*  4: TAMA WAIT
	dc.w	$100		*  6: SCORE
	dc.w	0		*  8: 0: PATTERN  1:PROGRAMABLE
	dc.l	POINT1		* 10: POINTER  /  EXEC ADDRESS
				* 12:    ;             ;
	dc.l	E_INIT2		* 14: INIT ADDRESS   0: TRAP
				* 16:      ;
	dc.l	T_SET1		* 18: TAMA SET
				* 20:     ;
	dc.l	PC_PO1		* 22: PC POINTER  /  -----
				* 24:     ;            ;
	dc.l	BRN_RET		* 26: BURN TRAP EXEC ADDRESS
				* 28:           ;

E_DAT3:	dc.w	$0100		*  0: SPRITE PATTERN CODE
	dc.w	2		*  2: HP
	dc.w	$00A0		*  4: TAMA WAIT
	dc.w	$500		*  6: SCORE
	dc.w	0		*  8: 0: PATTERN  1:PROGRAMABLE
	dc.l	POINT2		* 10: POINTER  /  EXEC ADDRESS
				* 12:    ;             ;
	dc.l	E_INIT4		* 14: INIT ADDRESS   0: TRAP
				* 16:      ;
	dc.l	T_SET2		* 18: TAMA SET
				* 20:     ;
	dc.l	PC_PO2		* 22: PC POINTER  /  -----
				* 24:     ;            ;
	dc.l	BRN_RET		* 26: BURN TRAP EXEC ADDRESS
				* 28:           ;

E_DAT4:	dc.w	$0100		*  0: SPRITE PATTERN CODE
	dc.w	8		*  2: HP
	dc.w	$0000		*  4: TAMA WAIT
	dc.w	$1000		*  6: SCORE
	dc.w	0		*  8: 0: PATTERN  1:PROGRAMABLE
	dc.l	POINT3		* 10: POINTER  /  EXEC ADDRESS
				* 12:    ;             ;
	dc.l	0		* 14: INIT ADDRESS   0: TRAP
				* 16:      ;
	dc.l	T_SET1		* 18: TAMA SET
				* 20:     ;
	dc.l	PC_PO3		* 22: PC POINTER  /  -----
				* 24:     ;            ;
	dc.l	BRN_RET		* 26: BURN TRAP EXEC ADDRESS
				* 28:           ;

E_DAT5:	dc.w	$0100		*  0: SPRITE PATTERN CODE
	dc.w	8		*  2: HP
	dc.w	$0000		*  4: TAMA WAIT
	dc.w	$1000		*  6: SCORE
	dc.w	0		*  8: 0: PATTERN  1:PROGRAMABLE
	dc.l	POINT4		* 10: POINTER  /  EXEC ADDRESS
				* 12:    ;             ;
	dc.l	0		* 14: INIT ADDRESS   0: TRAP
				* 16:      ;
	dc.l	T_SET1		* 18: TAMA SET
				* 20:     ;
	dc.l	PC_PO3		* 22: PC POINTER  /  -----
				* 24:     ;            ;
	dc.l	BRN_RET		* 26: BURN TRAP EXEC ADDRESS
				* 28:           ;

E_DAT6:	dc.w	$0100		*  0: SPRITE PATTERN CODE
	dc.w	$FFFF		*  2: HP
	dc.w	$0000		*  4: TAMA WAIT
	dc.w	$0000		*  6: SCORE
	dc.w	0		*  8: 0: PATTERN  1:PROGRAMABLE
	dc.l	POINT5		* 10: POINTER  /  EXEC ADDRESS
				* 12:    ;             ;
	dc.l	E_INIT4		* 14: INIT ADDRESS   0: TRAP
				* 16:      ;
	dc.l	T_SET1		* 18: TAMA SET
				* 20:     ;
	dc.l	PC_PO4		* 22: PC POINTER  /  -----
				* 24:     ;            ;
	dc.l	BRN_RET		* 26: BURN TRAP EXEC ADDRESS
				* 28:           ;

E_DAT7:	dc.w	$0100		*  0: SPRITE PATTERN CODE
	dc.w	$FFFF		*  2: HP
	dc.w	$0000		*  4: TAMA WAIT
	dc.w	$0000		*  6: SCORE
	dc.w	0		*  8: 0: PATTERN  1:PROGRAMABLE
	dc.l	POINT6		* 10: POINTER  /  EXEC ADDRESS
				* 12:    ;             ;
	dc.l	E_INIT4		* 14: INIT ADDRESS   0: TRAP
				* 16:      ;
	dc.l	T_SET1		* 18: TAMA SET
				* 20:     ;
	dc.l	PC_PO5		* 22: PC POINTER  /  -----
				* 24:     ;            ;
	dc.l	BRN_RET		* 26: BURN TRAP EXEC ADDRESS
				* 28:           ;

E_DAT8:	dc.w	$0100		*  0: SPRITE PATTERN CODE
	dc.w	$FFFF		*  2: HP
	dc.w	$0000		*  4: TAMA WAIT
	dc.w	$0000		*  6: SCORE
	dc.w	0		*  8: 0: PATTERN  1:PROGRAMABLE
	dc.l	POINT7		* 10: POINTER  /  EXEC ADDRESS
				* 12:    ;             ;
	dc.l	E_INIT4		* 14: INIT ADDRESS   0: TRAP
				* 16:      ;
	dc.l	T_SET1		* 18: TAMA SET
				* 20:     ;
	dc.l	PC_PO6		* 22: PC POINTER  /  -----
				* 24:     ;            ;
	dc.l	BRN_RET		* 26: BURN TRAP EXEC ADDRESS
				* 28:           ;

E_DAT9:	dc.w	$0100		*  0: SPRITE PATTERN CODE
	dc.w	$FFFF		*  2: HP
	dc.w	$0000		*  4: TAMA WAIT
	dc.w	$0000		*  6: SCORE
	dc.w	0		*  8: 0: PATTERN  1:PROGRAMABLE
	dc.l	POINT8		* 10: POINTER  /  EXEC ADDRESS
				* 12:    ;             ;
	dc.l	E_INIT4		* 14: INIT ADDRESS   0: TRAP
				* 16:      ;
	dc.l	T_SET1		* 18: TAMA SET
				* 20:     ;
	dc.l	PC_PO7		* 22: PC POINTER  /  -----
				* 24:     ;            ;
	dc.l	BRN_RET		* 26: BURN TRAP EXEC ADDRESS
				* 28:           ;

E_DAT10:dc.w	$0100		*  0: SPRITE PATTERN CODE
	dc.w	$0002		*  2: HP
	dc.w	$0010		*  4: TAMA WAIT
	dc.w	$1000		*  6: SCORE
	dc.w	0		*  8: 0: PATTERN  1:PROGRAMABLE
	dc.l	POINT9		* 10: POINTER  /  EXEC ADDRESS
				* 12:    ;             ;
	dc.l	E_INIT3		* 14: INIT ADDRESS   0: TRAP
				* 16:      ;
	dc.l	T_SET7		* 18: TAMA SET
				* 20:     ;
	dc.l	PC_PO8		* 22: PC POINTER  /  -----
				* 24:     ;            ;
	dc.l	BRN_RET		* 26: BURN TRAP EXEC ADDRESS
				* 28:           ;

E_DAT11:dc.w	$0100		*  0: SPRITE PATTERN CODE
	dc.w	$0001		*  2: HP
	dc.w	$0000		*  4: TAMA WAIT
	dc.w	$0100		*  6: SCORE
	dc.w	0		*  8: 0: PATTERN  1:PROGRAMABLE
	dc.l	POINT10		* 10: POINTER  /  EXEC ADDRESS
				* 12:    ;             ;
	dc.l	E_INIT1		* 14: INIT ADDRESS   0: TRAP
				* 16:      ;
	dc.l	T_SET1		* 18: TAMA SET
				* 20:     ;
	dc.l	PC_PO9		* 22: PC POINTER  /  -----
				* 24:     ;            ;
	dc.l	BRN_RET		* 26: BURN TRAP EXEC ADDRESS
				* 28:           ;

E_DAT12:dc.w	$0100		*  0: SPRITE PATTERN CODE
	dc.w	$0001		*  2: HP
	dc.w	$0000		*  4: TAMA WAIT
	dc.w	$0100		*  6: SCORE
	dc.w	0		*  8: 0: PATTERN  1:PROGRAMABLE
	dc.l	POINT11		* 10: POINTER  /  EXEC ADDRESS
				* 12:    ;             ;
	dc.l	E_INIT2		* 14: INIT ADDRESS   0: TRAP
				* 16:      ;
	dc.l	T_SET1		* 18: TAMA SET
				* 20:     ;
	dc.l	PC_PO9		* 22: PC POINTER  /  -----
				* 24:     ;            ;
	dc.l	BRN_RET		* 26: BURN TRAP EXEC ADDRESS
				* 28:           ;

E_DAT13:dc.w	$0100		*  0: SPRITE PATTERN CODE
	dc.w	$0001		*  2: HP
	dc.w	$0080		*  4: TAMA WAIT
	dc.w	$0150		*  6: SCORE
	dc.w	0		*  8: 0: PATTERN  1:PROGRAMABLE
	dc.l	POINT12		* 10: POINTER  /  EXEC ADDRESS
				* 12:    ;             ;
	dc.l	E_INIT1		* 14: INIT ADDRESS   0: TRAP
				* 16:      ;
	dc.l	T_SET1		* 18: TAMA SET
				* 20:     ;
	dc.l	PC_PO10		* 22: PC POINTER  /  -----
				* 24:     ;            ;
	dc.l	BRN_RET		* 26: BURN TRAP EXEC ADDRESS
				* 28:           ;

E_DAT14:dc.w	$0100		*  0: SPRITE PATTERN CODE
	dc.w	$000A		*  2: HP
	dc.w	$0080		*  4: TAMA WAIT
	dc.w	$0300		*  6: SCORE
	dc.w	0		*  8: 0: PATTERN  1:PROGRAMABLE
	dc.l	POINT13		* 10: POINTER  /  EXEC ADDRESS
				* 12:    ;             ;
	dc.l	E_INIT3		* 14: INIT ADDRESS   0: TRAP
				* 16:      ;
	dc.l	T_SET1		* 18: TAMA SET
				* 20:     ;
	dc.l	PC_PO11		* 22: PC POINTER  /  -----
				* 24:     ;            ;
	dc.l	BRN_RET		* 26: BURN TRAP EXEC ADDRESS
				* 28:           ;

E_DAT15:dc.w	$0100		*  0: SPRITE PATTERN CODE
	dc.w	$0001		*  2: HP
	dc.w	$0110		*  4: TAMA WAIT
	dc.w	$0100		*  6: SCORE
	dc.w	0		*  8: 0: PATTERN  1:PROGRAMABLE
	dc.l	POINT14		* 10: POINTER  /  EXEC ADDRESS
				* 12:    ;             ;
	dc.l	E_INIT1		* 14: INIT ADDRESS   0: TRAP
				* 16:      ;
	dc.l	T_SET1		* 18: TAMA SET
				* 20:     ;
	dc.l	PC_PO12		* 22: PC POINTER  /  -----
				* 24:     ;            ;
	dc.l	BRN_RET		* 26: BURN TRAP EXEC ADDRESS
				* 28:           ;

E_DAT16:dc.w	$0100		*  0: SPRITE PATTERN CODE
	dc.w	$0001		*  2: HP
	dc.w	$0110		*  4: TAMA WAIT
	dc.w	$0100		*  6: SCORE
	dc.w	0		*  8: 0: PATTERN  1:PROGRAMABLE
	dc.l	POINT15		* 10: POINTER  /  EXEC ADDRESS
				* 12:    ;             ;
	dc.l	E_INIT2		* 14: INIT ADDRESS   0: TRAP
				* 16:      ;
	dc.l	T_SET1		* 18: TAMA SET
				* 20:     ;
	dc.l	PC_PO12		* 22: PC POINTER  /  -----
				* 24:     ;            ;
	dc.l	BRN_RET		* 26: BURN TRAP EXEC ADDRESS
				* 28:           ;

E_DAT17:dc.w	$0100		*  0: SPRITE PATTERN CODE
	dc.w	$0004		*  2: HP
	dc.w	$00B0		*  4: TAMA WAIT
	dc.w	$0500		*  6: SCORE
	dc.w	0		*  8: 0: PATTERN  1:PROGRAMABLE
	dc.l	POINT16		* 10: POINTER  /  EXEC ADDRESS
				* 12:    ;             ;
	dc.l	E_INIT1		* 14: INIT ADDRESS   0: TRAP
				* 16:      ;
	dc.l	T_SET1		* 18: TAMA SET
				* 20:     ;
	dc.l	PC_PO13		* 22: PC POINTER  /  -----
				* 24:     ;            ;
	dc.l	BRN_RET		* 26: BURN TRAP EXEC ADDRESS
				* 28:           ;

E_DAT18:dc.w	$0100		*  0: SPRITE PATTERN CODE
	dc.w	$0008		*  2: HP
	dc.w	$0000		*  4: TAMA WAIT
	dc.w	$1000		*  6: SCORE
	dc.w	0		*  8: 0: PATTERN  1:PROGRAMABLE
	dc.l	POINT17		* 10: POINTER  /  EXEC ADDRESS
				* 12:    ;             ;
	dc.l	E_INIT3		* 14: INIT ADDRESS   0: TRAP
				* 16:      ;
	dc.l	T_SET1		* 18: TAMA SET
				* 20:     ;
	dc.l	PC_PO14		* 22: PC POINTER  /  -----
				* 24:     ;            ;
	dc.l	BRN_RET		* 26: BURN TRAP EXEC ADDRESS
				* 28:           ;

E_DAT19:dc.w	$0100		*  0: SPRITE PATTERN CODE
	dc.w	$0001		*  2: HP
	dc.w	$00C0		*  4: TAMA WAIT
	dc.w	$0150		*  6: SCORE
	dc.w	0		*  8: 0: PATTERN  1:PROGRAMABLE
	dc.l	POINT18		* 10: POINTER  /  EXEC ADDRESS
				* 12:    ;             ;
	dc.l	E_INIT3		* 14: INIT ADDRESS   0: TRAP
				* 16:      ;
	dc.l	T_SET1		* 18: TAMA SET
				* 20:     ;
	dc.l	PC_PO15		* 22: PC POINTER  /  -----
				* 24:     ;            ;
	dc.l	BRN_RET		* 26: BURN TRAP EXEC ADDRESS
				* 28:           ;

E_DAT20:dc.w	$0100		*  0: SPRITE PATTERN CODE
	dc.w	$0001		*  2: HP
	dc.w	$0100		*  4: TAMA WAIT
	dc.w	$0200		*  6: SCORE
	dc.w	0		*  8: 0: PATTERN  1:PROGRAMABLE
	dc.l	POINT19		* 10: POINTER  /  EXEC ADDRESS
				* 12:    ;             ;
	dc.l	E_INIT1		* 14: INIT ADDRESS   0: TRAP
				* 16:      ;
	dc.l	T_SET1		* 18: TAMA SET
				* 20:     ;
	dc.l	PC_PO16		* 22: PC POINTER  /  -----
				* 24:     ;            ;
	dc.l	BRN_RET		* 26: BURN TRAP EXEC ADDRESS
				* 28:           ;

E_DAT21:dc.w	$0100		*  0: SPRITE PATTERN CODE
	dc.w	$0001		*  2: HP
	dc.w	$00C0		*  4: TAMA WAIT
	dc.w	$0200		*  6: SCORE
	dc.w	0		*  8: 0: PATTERN  1:PROGRAMABLE
	dc.l	POINT20		* 10: POINTER  /  EXEC ADDRESS
				* 12:    ;             ;
	dc.l	E_INIT1		* 14: INIT ADDRESS   0: TRAP
				* 16:      ;
	dc.l	T_SET1		* 18: TAMA SET
				* 20:     ;
	dc.l	PC_PO17		* 22: PC POINTER  /  -----
				* 24:     ;            ;
	dc.l	BRN_RET		* 26: BURN TRAP EXEC ADDRESS
				* 28:           ;

E_DAT22:dc.w	$0100		*  0: SPRITE PATTERN CODE
	dc.w	$0002		*  2: HP
	dc.w	$0040		*  4: TAMA WAIT
	dc.w	$0250		*  6: SCORE
	dc.w	0		*  8: 0: PATTERN  1:PROGRAMABLE
	dc.l	POINT21		* 10: POINTER  /  EXEC ADDRESS
				* 12:    ;             ;
	dc.l	E_INIT1		* 14: INIT ADDRESS   0: TRAP
				* 16:      ;
	dc.l	T_SET1		* 18: TAMA SET
				* 20:     ;
	dc.l	PC_PO18		* 22: PC POINTER  /  -----
				* 24:     ;            ;
	dc.l	BRN_RET		* 26: BURN TRAP EXEC ADDRESS
				* 28:           ;

E_DAT23:dc.w	$0100		*  0: SPRITE PATTERN CODE
	dc.w	$0002		*  2: HP
	dc.w	$00C0		*  4: TAMA WAIT
	dc.w	$0500		*  6: SCORE
	dc.w	0		*  8: 0: PATTERN  1:PROGRAMABLE
	dc.l	POINT22		* 10: POINTER  /  EXEC ADDRESS
				* 12:    ;             ;
	dc.l	E_INIT3		* 14: INIT ADDRESS   0: TRAP
				* 16:      ;
	dc.l	T_SET1		* 18: TAMA SET
				* 20:     ;
	dc.l	PC_PO19		* 22: PC POINTER  /  -----
				* 24:     ;            ;
	dc.l	BRN_RET		* 26: BURN TRAP EXEC ADDRESS
				* 28:           ;

E_DAT24:dc.w	$0100		*  0: SPRITE PATTERN CODE
	dc.w	$0006		*  2: HP
	dc.w	$0000		*  4: TAMA WAIT
	dc.w	$2000		*  6: SCORE
	dc.w	0		*  8: 0: PATTERN  1:PROGRAMABLE
	dc.l	POINT23		* 10: POINTER  /  EXEC ADDRESS
				* 12:    ;             ;
	dc.l	0		* 14: INIT ADDRESS   0: TRAP
				* 16:      ;
	dc.l	T_SET1		* 18: TAMA SET
				* 20:     ;
	dc.l	PC_PO3		* 22: PC POINTER  /  -----
				* 24:     ;            ;
	dc.l	BRN_RET		* 26: BURN TRAP EXEC ADDRESS
				* 28:           ;

E_DAT25:dc.w	$0100		*  0: SPRITE PATTERN CODE
	dc.w	$0006		*  2: HP
	dc.w	$0000		*  4: TAMA WAIT
	dc.w	$2000		*  6: SCORE
	dc.w	0		*  8: 0: PATTERN  1:PROGRAMABLE
	dc.l	POINT24		* 10: POINTER  /  EXEC ADDRESS
				* 12:    ;             ;
	dc.l	0		* 14: INIT ADDRESS   0: TRAP
				* 16:      ;
	dc.l	T_SET1		* 18: TAMA SET
				* 20:     ;
	dc.l	PC_PO3		* 22: PC POINTER  /  -----
				* 24:     ;            ;
	dc.l	BRN_RET		* 26: BURN TRAP EXEC ADDRESS
				* 28:           ;

E_DAT26:dc.w	$0100		*  0: SPRITE PATTERN CODE
	dc.w	$0006		*  2: HP
	dc.w	$0000		*  4: TAMA WAIT
	dc.w	$2000		*  6: SCORE
	dc.w	0		*  8: 0: PATTERN  1:PROGRAMABLE
	dc.l	POINT25		* 10: POINTER  /  EXEC ADDRESS
				* 12:    ;             ;
	dc.l	0		* 14: INIT ADDRESS   0: TRAP
				* 16:      ;
	dc.l	T_SET1		* 18: TAMA SET
				* 20:     ;
	dc.l	PC_PO3		* 22: PC POINTER  /  -----
				* 24:     ;            ;
	dc.l	BRN_RET		* 26: BURN TRAP EXEC ADDRESS
				* 28:           ;

E_DAT27:dc.w	$0100		*  0: SPRITE PATTERN CODE
	dc.w	$0006		*  2: HP
	dc.w	$0000		*  4: TAMA WAIT
	dc.w	$2000		*  6: SCORE
	dc.w	0		*  8: 0: PATTERN  1:PROGRAMABLE
	dc.l	POINT26		* 10: POINTER  /  EXEC ADDRESS
				* 12:    ;             ;
	dc.l	0		* 14: INIT ADDRESS   0: TRAP
				* 16:      ;
	dc.l	T_SET1		* 18: TAMA SET
				* 20:     ;
	dc.l	PC_PO3		* 22: PC POINTER  /  -----
				* 24:     ;            ;
	dc.l	BRN_RET		* 26: BURN TRAP EXEC ADDRESS
				* 28:           ;

E_DAT28:dc.w	$0100		*  0: SPRITE PATTERN CODE
	dc.w	$0006		*  2: HP
	dc.w	$0000		*  4: TAMA WAIT
	dc.w	$300		*  6: SCORE
	dc.w	0		*  8: 0: PATTERN  1:PROGRAMABLE
	dc.l	POINT27		* 10: POINTER  /  EXEC ADDRESS
				* 12:    ;             ;
	dc.l	0		* 14: INIT ADDRESS   0: TRAP
				* 16:      ;
	dc.l	T_SET1		* 18: TAMA SET
				* 20:     ;
	dc.l	PC_PO3		* 22: PC POINTER  /  -----
				* 24:     ;            ;
	dc.l	BRN_RET		* 26: BURN TRAP EXEC ADDRESS
				* 28:           ;

E_DAT29:dc.w	$0100		*  0: SPRITE PATTERN CODE
	dc.w	$000A		*  2: HP
	dc.w	$0000		*  4: TAMA WAIT
	dc.w	$1000		*  6: SCORE
	dc.w	0		*  8: 0: PATTERN  1:PROGRAMABLE
	dc.l	POINT28		* 10: POINTER  /  EXEC ADDRESS
				* 12:    ;             ;
	dc.l	0		* 14: INIT ADDRESS   0: TRAP
				* 16:      ;
	dc.l	T_SET1		* 18: TAMA SET
				* 20:     ;
	dc.l	PC_PO3		* 22: PC POINTER  /  -----
				* 24:     ;            ;
	dc.l	BRN_RET		* 26: BURN TRAP EXEC ADDRESS
				* 28:           ;

E_DAT30:dc.w	$0100		*  0: SPRITE PATTERN CODE
	dc.w	$000A		*  2: HP
	dc.w	$0000		*  4: TAMA WAIT
	dc.w	$1000		*  6: SCORE
	dc.w	0		*  8: 0: PATTERN  1:PROGRAMABLE
	dc.l	POINT29		* 10: POINTER  /  EXEC ADDRESS
				* 12:    ;             ;
	dc.l	0		* 14: INIT ADDRESS   0: TRAP
				* 16:      ;
	dc.l	T_SET1		* 18: TAMA SET
				* 20:     ;
	dc.l	PC_PO3		* 22: PC POINTER  /  -----
				* 24:     ;            ;
	dc.l	BRN_RET		* 26: BURN TRAP EXEC ADDRESS
				* 28:           ;

E_DAT31:dc.w	$0100		*  0: SPRITE PATTERN CODE
	dc.w	$000A		*  2: HP
	dc.w	$0000		*  4: TAMA WAIT
	dc.w	$1000		*  6: SCORE
	dc.w	0		*  8: 0: PATTERN  1:PROGRAMABLE
	dc.l	POINT30		* 10: POINTER  /  EXEC ADDRESS
				* 12:    ;             ;
	dc.l	0		* 14: INIT ADDRESS   0: TRAP
				* 16:      ;
	dc.l	T_SET1		* 18: TAMA SET
				* 20:     ;
	dc.l	PC_PO3		* 22: PC POINTER  /  -----
				* 24:     ;            ;
	dc.l	BRN_RET		* 26: BURN TRAP EXEC ADDRESS
				* 28:           ;

E_DAT32:dc.w	$0100		*  0: SPRITE PATTERN CODE
	dc.w	$000A		*  2: HP
	dc.w	$0000		*  4: TAMA WAIT
	dc.w	$1000		*  6: SCORE
	dc.w	0		*  8: 0: PATTERN  1:PROGRAMABLE
	dc.l	POINT31		* 10: POINTER  /  EXEC ADDRESS
				* 12:    ;             ;
	dc.l	0		* 14: INIT ADDRESS   0: TRAP
				* 16:      ;
	dc.l	T_SET1		* 18: TAMA SET
				* 20:     ;
	dc.l	PC_PO3		* 22: PC POINTER  /  -----
				* 24:     ;            ;
	dc.l	BRN_RET		* 26: BURN TRAP EXEC ADDRESS
				* 28:           ;

E_DAT33:dc.w	$0100		*  0: SPRITE PATTERN CODE
	dc.w	$000A		*  2: HP
	dc.w	$0000		*  4: TAMA WAIT
	dc.w	$1000		*  6: SCORE
	dc.w	0		*  8: 0: PATTERN  1:PROGRAMABLE
	dc.l	POINT32		* 10: POINTER  /  EXEC ADDRESS
				* 12:    ;             ;
	dc.l	0		* 14: INIT ADDRESS   0: TRAP
				* 16:      ;
	dc.l	T_SET1		* 18: TAMA SET
				* 20:     ;
	dc.l	PC_PO3		* 22: PC POINTER  /  -----
				* 24:     ;            ;
	dc.l	BRN_RET		* 26: BURN TRAP EXEC ADDRESS
				* 28:           ;

E_DAT34:dc.w	$0100		*  0: SPRITE PATTERN CODE
	dc.w	$000A		*  2: HP
	dc.w	$0000		*  4: TAMA WAIT
	dc.w	$1000		*  6: SCORE
	dc.w	0		*  8: 0: PATTERN  1:PROGRAMABLE
	dc.l	POINT33		* 10: POINTER  /  EXEC ADDRESS
				* 12:    ;             ;
	dc.l	0		* 14: INIT ADDRESS   0: TRAP
				* 16:      ;
	dc.l	T_SET1		* 18: TAMA SET
				* 20:     ;
	dc.l	PC_PO3		* 22: PC POINTER  /  -----
				* 24:     ;            ;
	dc.l	BRN_RET		* 26: BURN TRAP EXEC ADDRESS
				* 28:           ;

E_DAT35:dc.w	$0145		*  0: SPRITE PATTERN CODE
	dc.w	$0001		*  2: HP
	dc.w	$0040		*  4: TAMA WAIT
	dc.w	$0100		*  6: SCORE
	dc.w	1		*  8: 0: PATTERN  1:PROGRAMABLE
	dc.l	E_PROG1		* 10: POINTER  /  EXEC ADDRESS
				* 12:    ;             ;
	dc.l	E_INIT3		* 14: INIT ADDRESS   0: TRAP
				* 16:      ;
	dc.l	T_SET1		* 18: TAMA SET
				* 20:     ;
	dc.l	0		* 22: PC POINTER  /  -----
				* 24:     ;            ;
	dc.l	BRN_RET		* 26: BURN TRAP EXEC ADDRESS
				* 28:           ;

E_DAT36:dc.w	$0100		*  0: SPRITE PATTERN CODE
	dc.w	$0001		*  2: HP
	dc.w	$00C0		*  4: TAMA WAIT
	dc.w	$0200		*  6: SCORE
	dc.w	0		*  8: 0: PATTERN  1:PROGRAMABLE
	dc.l	POINT34		* 10: POINTER  /  EXEC ADDRESS
				* 12:    ;             ;
	dc.l	E_INIT2		* 14: INIT ADDRESS   0: TRAP
				* 16:      ;
	dc.l	T_SET1		* 18: TAMA SET
				* 20:     ;
	dc.l	PC_PO17		* 22: PC POINTER  /  -----
				* 24:     ;            ;
	dc.l	BRN_RET		* 26: BURN TRAP EXEC ADDRESS
				* 28:           ;

E_DAT37:dc.w	$0100		*  0: SPRITE PATTERN CODE
	dc.w	$FFFF		*  2: HP
	dc.w	$0000		*  4: TAMA WAIT
	dc.w	$0000		*  6: SCORE
	dc.w	0		*  8: 0: PATTERN  1:PROGRAMABLE
	dc.l	POINT35		* 10: POINTER  /  EXEC ADDRESS
				* 12:    ;             ;
	dc.l	E_INIT4		* 14: INIT ADDRESS   0: TRAP
				* 16:      ;
	dc.l	T_SET1		* 18: TAMA SET
				* 20:     ;
	dc.l	PC_PO4		* 22: PC POINTER  /  -----
				* 24:     ;            ;
	dc.l	BRN_RET		* 26: BURN TRAP EXEC ADDRESS
				* 28:           ;

E_DAT38:dc.w	$0100		*  0: SPRITE PATTERN CODE
	dc.w	$FFFF		*  2: HP
	dc.w	$0000		*  4: TAMA WAIT
	dc.w	$0000		*  6: SCORE
	dc.w	0		*  8: 0: PATTERN  1:PROGRAMABLE
	dc.l	POINT36		* 10: POINTER  /  EXEC ADDRESS
				* 12:    ;             ;
	dc.l	E_INIT4		* 14: INIT ADDRESS   0: TRAP
				* 16:      ;
	dc.l	T_SET1		* 18: TAMA SET
				* 20:     ;
	dc.l	PC_PO5		* 22: PC POINTER  /  -----
				* 24:     ;            ;
	dc.l	BRN_RET		* 26: BURN TRAP EXEC ADDRESS
				* 28:           ;

E_DAT39:dc.w	$0100		*  0: SPRITE PATTERN CODE
	dc.w	$FFFF		*  2: HP
	dc.w	$0000		*  4: TAMA WAIT
	dc.w	$0000		*  6: SCORE
	dc.w	0		*  8: 0: PATTERN  1:PROGRAMABLE
	dc.l	POINT37		* 10: POINTER  /  EXEC ADDRESS
				* 12:    ;             ;
	dc.l	E_INIT4		* 14: INIT ADDRESS   0: TRAP
				* 16:      ;
	dc.l	T_SET1		* 18: TAMA SET
				* 20:     ;
	dc.l	PC_PO6		* 22: PC POINTER  /  -----
				* 24:     ;            ;
	dc.l	BRN_RET		* 26: BURN TRAP EXEC ADDRESS
				* 28:           ;

E_DAT40:dc.w	$0100		*  0: SPRITE PATTERN CODE
	dc.w	$FFFF		*  2: HP
	dc.w	$0000		*  4: TAMA WAIT
	dc.w	$0000		*  6: SCORE
	dc.w	0		*  8: 0: PATTERN  1:PROGRAMABLE
	dc.l	POINT38		* 10: POINTER  /  EXEC ADDRESS
				* 12:    ;             ;
	dc.l	E_INIT4		* 14: INIT ADDRESS   0: TRAP
				* 16:      ;
	dc.l	T_SET1		* 18: TAMA SET
				* 20:     ;
	dc.l	PC_PO7		* 22: PC POINTER  /  -----
				* 24:     ;            ;
	dc.l	BRN_RET		* 26: BURN TRAP EXEC ADDRESS
				* 28:           ;

E_DAT41:dc.w	$0100		*  0: SPRITE PATTERN CODE
	dc.w	$FFFF		*  2: HP
	dc.w	$0000		*  4: TAMA WAIT
	dc.w	$0000		*  6: SCORE
	dc.w	0		*  8: 0: PATTERN  1:PROGRAMABLE
	dc.l	POINT39		* 10: POINTER  /  EXEC ADDRESS
				* 12:    ;             ;
	dc.l	E_INIT4		* 14: INIT ADDRESS   0: TRAP
				* 16:      ;
	dc.l	T_SET1		* 18: TAMA SET
				* 20:     ;
	dc.l	PC_PO4		* 22: PC POINTER  /  -----
				* 24:     ;            ;
	dc.l	BRN_RET		* 26: BURN TRAP EXEC ADDRESS
				* 28:           ;

E_DAT42:dc.w	$0100		*  0: SPRITE PATTERN CODE
	dc.w	$FFFF		*  2: HP
	dc.w	$0000		*  4: TAMA WAIT
	dc.w	$0000		*  6: SCORE
	dc.w	0		*  8: 0: PATTERN  1:PROGRAMABLE
	dc.l	POINT40		* 10: POINTER  /  EXEC ADDRESS
				* 12:    ;             ;
	dc.l	E_INIT4		* 14: INIT ADDRESS   0: TRAP
				* 16:      ;
	dc.l	T_SET1		* 18: TAMA SET
				* 20:     ;
	dc.l	PC_PO5		* 22: PC POINTER  /  -----
				* 24:     ;            ;
	dc.l	BRN_RET		* 26: BURN TRAP EXEC ADDRESS
				* 28:           ;

E_DAT43:dc.w	$0100		*  0: SPRITE PATTERN CODE
	dc.w	$FFFF		*  2: HP
	dc.w	$0000		*  4: TAMA WAIT
	dc.w	$0000		*  6: SCORE
	dc.w	0		*  8: 0: PATTERN  1:PROGRAMABLE
	dc.l	POINT41		* 10: POINTER  /  EXEC ADDRESS
				* 12:    ;             ;
	dc.l	E_INIT4		* 14: INIT ADDRESS   0: TRAP
				* 16:      ;
	dc.l	T_SET1		* 18: TAMA SET
				* 20:     ;
	dc.l	PC_PO6		* 22: PC POINTER  /  -----
				* 24:     ;            ;
	dc.l	BRN_RET		* 26: BURN TRAP EXEC ADDRESS
				* 28:           ;

E_DAT44:dc.w	$0100		*  0: SPRITE PATTERN CODE
	dc.w	$FFFF		*  2: HP
	dc.w	$0000		*  4: TAMA WAIT
	dc.w	$0000		*  6: SCORE
	dc.w	0		*  8: 0: PATTERN  1:PROGRAMABLE
	dc.l	POINT42		* 10: POINTER  /  EXEC ADDRESS
				* 12:    ;             ;
	dc.l	E_INIT4		* 14: INIT ADDRESS   0: TRAP
				* 16:      ;
	dc.l	T_SET1		* 18: TAMA SET
				* 20:     ;
	dc.l	PC_PO7		* 22: PC POINTER  /  -----
				* 24:     ;            ;
	dc.l	BRN_RET		* 26: BURN TRAP EXEC ADDRESS
				* 28:           ;

E_DAT45:dc.w	$0100		*  0: SPRITE PATTERN CODE
	dc.w	1		*  2: HP
	dc.w	$0000		*  4: TAMA WAIT
	dc.w	$100		*  6: SCORE
	dc.w	0		*  8: 0: PATTERN  1:PROGRAMABLE
	dc.l	POINT1		* 10: POINTER  /  EXEC ADDRESS
				* 12:    ;             ;
	dc.l	E_INIT3		* 14: INIT ADDRESS   0: TRAP
				* 16:      ;
	dc.l	T_SET1		* 18: TAMA SET
				* 20:     ;
	dc.l	PC_PO1		* 22: PC POINTER  /  -----
				* 24:     ;            ;
	dc.l	BRN_RET		* 26: BURN TRAP EXEC ADDRESS
				* 28:           ;

E_DAT46:dc.w	$013C		*  0: SPRITE PATTERN CODE
	dc.w	1		*  2: HP
	dc.w	$0000		*  4: TAMA WAIT
	dc.w	$100		*  6: SCORE
	dc.w	1		*  8: 0: PATTERN  1:PROGRAMABLE
	dc.l	E_PROG2		* 10: POINTER  /  EXEC ADDRESS
				* 12:    ;             ;
	dc.l	E_INIT1		* 14: INIT ADDRESS   0: TRAP
				* 16:      ;
	dc.l	T_SET1		* 18: TAMA SET
				* 20:     ;
	dc.l	0		* 22: PC POINTER  /  -----
				* 24:     ;            ;
	dc.l	BRN_RET		* 26: BURN TRAP EXEC ADDRESS
				* 28:           ;

E_DAT47:dc.w	$013C		*  0: SPRITE PATTERN CODE
	dc.w	1		*  2: HP
	dc.w	$0000		*  4: TAMA WAIT
	dc.w	$100		*  6: SCORE
	dc.w	1		*  8: 0: PATTERN  1:PROGRAMABLE
	dc.l	E_PROG2		* 10: POINTER  /  EXEC ADDRESS
				* 12:    ;             ;
	dc.l	E_INIT2		* 14: INIT ADDRESS   0: TRAP
				* 16:      ;
	dc.l	T_SET1		* 18: TAMA SET
				* 20:     ;
	dc.l	0		* 22: PC POINTER  /  -----
				* 24:     ;            ;
	dc.l	BRN_RET		* 26: BURN TRAP EXEC ADDRESS
				* 28:           ;

E_DAT48:dc.w	$013C		*  0: SPRITE PATTERN CODE
	dc.w	2		*  2: HP
	dc.w	$00C0		*  4: TAMA WAIT
	dc.w	$150		*  6: SCORE
	dc.w	1		*  8: 0: PATTERN  1:PROGRAMABLE
	dc.l	E_PROG2		* 10: POINTER  /  EXEC ADDRESS
				* 12:    ;             ;
	dc.l	E_INIT3		* 14: INIT ADDRESS   0: TRAP
				* 16:      ;
	dc.l	T_SET1		* 18: TAMA SET
				* 20:     ;
	dc.l	0		* 22: PC POINTER  /  -----
				* 24:     ;            ;
	dc.l	BRN_RET		* 26: BURN TRAP EXEC ADDRESS
				* 28:           ;

E_DAT49:dc.w	$0100		*  0: SPRITE PATTERN CODE
	dc.w	$0020		*  2: HP
	dc.w	$0020		*  4: TAMA WAIT
	dc.w	$5000		*  6: SCORE
	dc.w	0		*  8: 0: PATTERN  1:PROGRAMABLE
	dc.l	POINT16		* 10: POINTER  /  EXEC ADDRESS
				* 12:    ;             ;
	dc.l	E_INIT1		* 14: INIT ADDRESS   0: TRAP
				* 16:      ;
	dc.l	T_SET1		* 18: TAMA SET
				* 20:     ;
	dc.l	PC_PO20		* 22: PC POINTER  /  -----
				* 24:     ;            ;
	dc.l	BRN_EAL		* 26: BURN TRAP EXEC ADDRESS
				* 28:           ;

E_DAT50:dc.w	$0100		*  0: SPRITE PATTERN CODE
	dc.w	$FFFF		*  2: HP
	dc.w	$0000		*  4: TAMA WAIT
	dc.w	$0000		*  6: SCORE
	dc.w	0		*  8: 0: PATTERN  1:PROGRAMABLE
	dc.l	POINT16		* 10: POINTER  /  EXEC ADDRESS
				* 12:    ;             ;
	dc.l	E_INIT1		* 14: INIT ADDRESS   0: TRAP
				* 16:      ;
	dc.l	T_SET1		* 18: TAMA SET
				* 20:     ;
	dc.l	PC_PO13		* 22: PC POINTER  /  -----
				* 24:     ;            ;
	dc.l	BRN_RET		* 26: BURN TRAP EXEC ADDRESS
				* 28:           ;

E_DAT51:dc.w	$0100		*  0: SPRITE PATTERN CODE
	dc.w	$0008		*  2: HP
	dc.w	$0000		*  4: TAMA WAIT
	dc.w	$1000		*  6: SCORE
	dc.w	0		*  8: 0: PATTERN  1:PROGRAMABLE
	dc.l	POINT17		* 10: POINTER  /  EXEC ADDRESS
				* 12:    ;             ;
	dc.l	E_INIT4		* 14: INIT ADDRESS   0: TRAP
				* 16:      ;
	dc.l	T_SET1		* 18: TAMA SET
				* 20:     ;
	dc.l	PC_PO14		* 22: PC POINTER  /  -----
				* 24:     ;            ;
	dc.l	BRN_RET		* 26: BURN TRAP EXEC ADDRESS
				* 28:           ;

E_DAT52:dc.w	$0100		*  0: SPRITE PATTERN CODE
	dc.w	$0001		*  2: HP
	dc.w	$0050		*  4: TAMA WAIT
	dc.w	$0500		*  6: SCORE
	dc.w	0		*  8: 0: PATTERN  1:PROGRAMABLE
	dc.l	POINT5		* 10: POINTER  /  EXEC ADDRESS
				* 12:    ;             ;
	dc.l	E_INIT4		* 14: INIT ADDRESS   0: TRAP
				* 16:      ;
	dc.l	T_SET2		* 18: TAMA SET
				* 20:     ;
	dc.l	PC_PO21		* 22: PC POINTER  /  -----
				* 24:     ;            ;
	dc.l	BRN_RET		* 26: BURN TRAP EXEC ADDRESS
				* 28:           ;

E_DAT53:dc.w	$0100		*  0: SPRITE PATTERN CODE
	dc.w	$0001		*  2: HP
	dc.w	$0050		*  4: TAMA WAIT
	dc.w	$0500		*  6: SCORE
	dc.w	0		*  8: 0: PATTERN  1:PROGRAMABLE
	dc.l	POINT6		* 10: POINTER  /  EXEC ADDRESS
				* 12:    ;             ;
	dc.l	E_INIT4		* 14: INIT ADDRESS   0: TRAP
				* 16:      ;
	dc.l	T_SET2		* 18: TAMA SET
				* 20:     ;
	dc.l	PC_PO22		* 22: PC POINTER  /  -----
				* 24:     ;            ;
	dc.l	BRN_RET		* 26: BURN TRAP EXEC ADDRESS
				* 28:           ;

E_DAT54:dc.w	$0100		*  0: SPRITE PATTERN CODE
	dc.w	$0001		*  2: HP
	dc.w	$0030		*  4: TAMA WAIT
	dc.w	$0500		*  6: SCORE
	dc.w	0		*  8: 0: PATTERN  1:PROGRAMABLE
	dc.l	POINT7		* 10: POINTER  /  EXEC ADDRESS
				* 12:    ;             ;
	dc.l	E_INIT4		* 14: INIT ADDRESS   0: TRAP
				* 16:      ;
	dc.l	T_SET2		* 18: TAMA SET
				* 20:     ;
	dc.l	PC_PO23		* 22: PC POINTER  /  -----
				* 24:     ;            ;
	dc.l	BRN_RET		* 26: BURN TRAP EXEC ADDRESS
				* 28:           ;

E_DAT55:dc.w	$0100		*  0: SPRITE PATTERN CODE
	dc.w	$0001		*  2: HP
	dc.w	$0030		*  4: TAMA WAIT
	dc.w	$0500		*  6: SCORE
	dc.w	0		*  8: 0: PATTERN  1:PROGRAMABLE
	dc.l	POINT8		* 10: POINTER  /  EXEC ADDRESS
				* 12:    ;             ;
	dc.l	E_INIT4		* 14: INIT ADDRESS   0: TRAP
				* 16:      ;
	dc.l	T_SET2		* 18: TAMA SET
				* 20:     ;
	dc.l	PC_PO24		* 22: PC POINTER  /  -----
				* 24:     ;            ;
	dc.l	BRN_RET		* 26: BURN TRAP EXEC ADDRESS
				* 28:           ;

E_DAT56:dc.w	$0100		*  0: SPRITE PATTERN CODE
	dc.w	$0002		*  2: HP
	dc.w	$0040		*  4: TAMA WAIT
	dc.w	$0200		*  6: SCORE
	dc.w	0		*  8: 0: PATTERN  1:PROGRAMABLE
	dc.l	POINT43		* 10: POINTER  /  EXEC ADDRESS
				* 12:    ;             ;
	dc.l	E_INIT5		* 14: INIT ADDRESS   0: TRAP
				* 16:      ;
	dc.l	T_SET1		* 18: TAMA SET
				* 20:     ;
	dc.l	PC_PO25		* 22: PC POINTER  /  -----
				* 24:     ;            ;
	dc.l	BRN_RET		* 26: BURN TRAP EXEC ADDRESS
				* 28:           ;

E_DAT57:dc.w	$0100		*  0: SPRITE PATTERN CODE
	dc.w	1		*  2: HP
	dc.w	$007F		*  4: TAMA WAIT
	dc.w	$100		*  6: SCORE
	dc.w	0		*  8: 0: PATTERN  1:PROGRAMABLE
	dc.l	POINT1		* 10: POINTER  /  EXEC ADDRESS
				* 12:    ;             ;
	dc.l	E_INIT1		* 14: INIT ADDRESS   0: TRAP
				* 16:      ;
	dc.l	T_SET1		* 18: TAMA SET
				* 20:     ;
	dc.l	PC_PO1		* 22: PC POINTER  /  -----
				* 24:     ;            ;
	dc.l	BRN_RET		* 26: BURN TRAP EXEC ADDRESS
				* 28:           ;

E_DAT58:dc.w	$0100		*  0: SPRITE PATTERN CODE
	dc.w	1		*  2: HP
	dc.w	$007F		*  4: TAMA WAIT
	dc.w	$100		*  6: SCORE
	dc.w	0		*  8: 0: PATTERN  1:PROGRAMABLE
	dc.l	POINT1		* 10: POINTER  /  EXEC ADDRESS
				* 12:    ;             ;
	dc.l	E_INIT2		* 14: INIT ADDRESS   0: TRAP
				* 16:      ;
	dc.l	T_SET1		* 18: TAMA SET
				* 20:     ;
	dc.l	PC_PO1		* 22: PC POINTER  /  -----
				* 24:     ;            ;
	dc.l	BRN_RET		* 26: BURN TRAP EXEC ADDRESS
				* 28:           ;

E_DAT59:dc.w	$0100		*  0: SPRITE PATTERN CODE
	dc.w	1		*  2: HP
	dc.w	$007F		*  4: TAMA WAIT
	dc.w	$100		*  6: SCORE
	dc.w	0		*  8: 0: PATTERN  1:PROGRAMABLE
	dc.l	POINT1		* 10: POINTER  /  EXEC ADDRESS
				* 12:    ;             ;
	dc.l	E_INIT3		* 14: INIT ADDRESS   0: TRAP
				* 16:      ;
	dc.l	T_SET1		* 18: TAMA SET
				* 20:     ;
	dc.l	PC_PO1		* 22: PC POINTER  /  -----
				* 24:     ;            ;
	dc.l	BRN_RET		* 26: BURN TRAP EXEC ADDRESS
				* 28:           ;

E_DAT60:dc.w	$0100		*  0: SPRITE PATTERN CODE
	dc.w	1		*  2: HP
	dc.w	$0060		*  4: TAMA WAIT
	dc.w	$100		*  6: SCORE
	dc.w	0		*  8: 0: PATTERN  1:PROGRAMABLE
	dc.l	POINT1		* 10: POINTER  /  EXEC ADDRESS
				* 12:    ;             ;
	dc.l	E_INIT1		* 14: INIT ADDRESS   0: TRAP
				* 16:      ;
	dc.l	T_SET1		* 18: TAMA SET
				* 20:     ;
	dc.l	PC_PO1		* 22: PC POINTER  /  -----
				* 24:     ;            ;
	dc.l	BRN_RET		* 26: BURN TRAP EXEC ADDRESS
				* 28:           ;

E_DAT61:dc.w	$0100		*  0: SPRITE PATTERN CODE
	dc.w	1		*  2: HP
	dc.w	$0060		*  4: TAMA WAIT
	dc.w	$100		*  6: SCORE
	dc.w	0		*  8: 0: PATTERN  1:PROGRAMABLE
	dc.l	POINT1		* 10: POINTER  /  EXEC ADDRESS
				* 12:    ;             ;
	dc.l	E_INIT2		* 14: INIT ADDRESS   0: TRAP
				* 16:      ;
	dc.l	T_SET1		* 18: TAMA SET
				* 20:     ;
	dc.l	PC_PO1		* 22: PC POINTER  /  -----
				* 24:     ;            ;
	dc.l	BRN_RET		* 26: BURN TRAP EXEC ADDRESS
				* 28:           ;

E_DAT62:dc.w	$0100		*  0: SPRITE PATTERN CODE
	dc.w	1		*  2: HP
	dc.w	$0060		*  4: TAMA WAIT
	dc.w	$100		*  6: SCORE
	dc.w	0		*  8: 0: PATTERN  1:PROGRAMABLE
	dc.l	POINT1		* 10: POINTER  /  EXEC ADDRESS
				* 12:    ;             ;
	dc.l	E_INIT3		* 14: INIT ADDRESS   0: TRAP
				* 16:      ;
	dc.l	T_SET1		* 18: TAMA SET
				* 20:     ;
	dc.l	PC_PO1		* 22: PC POINTER  /  -----
				* 24:     ;            ;
	dc.l	BRN_RET		* 26: BURN TRAP EXEC ADDRESS
				* 28:           ;
*
* B_DAT
*
* A: POINTER
* W: HP
* W: TAMA_WAIT_MAX
* A: TAMA_SET
* L: SCORE(BCD)
* A: INIT_ADDRESS
* W: PC(LEFT_TOP) 
* W: ATTACK_WAIT_MAX
* A: ATTACK_SET
*
*   28 Bytes
*

B_DAT:
B_DAT1:	dc.l	B_PO1
	dc.w	15
	dc.w	$00A0
	dc.l	T_SET1
	dc.l	$5000
	dc.l	B_INIT1
	dc.w	$0980
	dc.w	$0000
	dc.l	A_SET1

B_DAT2: dc.l	B_PO2
	dc.w	20
	dc.w	$0041
	dc.l	T_SET6
	dc.l	$10000
	dc.l	B_INIT1
	dc.w	$09A0
	dc.w	0
	dc.l	T_ASET1

B_DAT3:	dc.l	B_PO5
	dc.w	20
	dc.w	$0061
	dc.l	T_SET3
	dc.l	$20000
	dc.l	B_INIT2
	dc.w	$09A4
	dc.w	0
	dc.l	T_ASET1

B_DAT4:	dc.l	B_PO2
	dc.w	16
	dc.w	$0029
	dc.l	T_SET1
	dc.l	$6000
	dc.l	B_INIT1
	dc.w	$0984
	dc.w	$001E
	dc.l	T_ASET1

B_DAT5:	dc.l	B_PO6
	dc.w	20
	dc.w	$0000
	dc.l	T_SET1
	dc.l	$10000
	dc.l	B_INIT1
	dc.w	$990
	dc.w	$000C
	dc.l	A_SET4

B_DAT6:	dc.l	B_PO6
	dc.w	25
	dc.w	$0000
	dc.l	T_SET1
	dc.l	$20000
	dc.l	B_INIT1
	dc.w	$0994
	dc.w	$0095
	dc.l	A_SET2

B_DAT7:	dc.l	B_PO2
	dc.w	40
	dc.w	$0026
	dc.l	T_SET4
	dc.l	$300000
	dc.l	B_INIT1
	dc.w	$0AB0
	dc.w	$0061
	dc.l	A_SET3

B_DAT8:	dc.l	B_PO1
	dc.w	20
	dc.w	$0040
	dc.l	T_SET1
	dc.l	$5000
	dc.l	B_INIT1
	dc.w	$0980
	dc.w	$0000
	dc.l	A_SET1

B_DAT9:	dc.l	B_PO2
	dc.w	20
	dc.w	$0027
	dc.l	T_SET4
	dc.l	$10000
	dc.l	B_INIT1
	dc.w	$09A0
	dc.w	0
	dc.l	T_ASET1

B_DAT10:dc.l	B_PO5
	dc.w	30
	dc.w	$0033
	dc.l	T_SET3
	dc.l	$20000
	dc.l	B_INIT2
	dc.w	$09A4
	dc.w	0
	dc.l	T_ASET1

B_DAT11:dc.l	B_PO2
	dc.w	24
	dc.w	$001C
	dc.l	T_SET1
	dc.l	$6000
	dc.l	B_INIT1
	dc.w	$0984
	dc.w	$0018
	dc.l	T_ASET1

B_DAT12:dc.l	B_PO6
	dc.w	25
	dc.w	$0000
	dc.l	T_SET1
	dc.l	$10000
	dc.l	B_INIT1
	dc.w	$0990
	dc.w	$0008
	dc.l	A_SET4

B_DAT13:dc.l	B_PO6
	dc.w	32
	dc.w	$0000
	dc.l	T_SET1
	dc.l	$20000
	dc.l	B_INIT1
	dc.w	$0994
	dc.w	$004D
	dc.l	A_SET2

	.bss	************************************************************************

ASD:	ds.b	4*16*16
ASDEND:

ASD2:	ds.b	4*16*16
ASDEND2:

				* SPRITE PLANE 2-15
S_TABLE:ds.b	14*14		*  0: X (0: DON'T USE)
				*  2: Y
				*  4: PATTERN CODE
				*  6: STR
				*  8: IMPAIL (0: NORMAL  OT: IMPAIL)
				* 10: POINTER
				* 12:    ;
				*
				*         ÅñÇPÇS
				*

				* SPRITE PLANE 16-31 (8*2)
B_TABLE:ds.b	38*2		*  0: X (0: DON'T USE)
				*  2: Y
				*  4: ENEMY NUMBER
				*  6: POINTER  /  EXEC ADDRESS
				*  8:    ;             ;
				* 10: HP
				* 12: TAMA WAIT MAX
				* 14: TAMA WAIT COUNTER
				* 16: TAMA SET
				* 18:    ;
				* 20: 0: NORMAL   1-5:FLASH
				* 22: SCORE
				* 24:   ;
				* 26: PC (LEFT TOP)
				* 28: 0:PATTERN   1:PROGRAMABLE
				* 30: ATTACK WAIT MAX
				* 32: ATTACK WAIT COUNTER
				* 34: ATTACK SET
				* 36:     ;
				*
				*         ÅñÇQ
				*

				* SPRITE PLANE 32-95
T_TABLE:ds.b	24*64		*  0: X ($0000****:DON'T USE)
				*  4: Y
				*  8: XS
				*  9: YS
				* 10: DD/
				* 11: -----
				* 12: P
				* 16: DM
				* 20: M
				*
				*         ÅñÇUÇS
				*


				* SPRITE PLANE 96-127
E_TABLE:ds.b	34*32		*  0: X (0: DON'T USE)
				*  2: Y
				*  4: ENEMY NUMBER
				*  6: 0: PATTERN  1:PROGRAMABLE
				*  8: POINTER  /  EXEC ADDRESS
				* 10:    ;             ;
				* 12: HP
				* 14: TAMA WAIT COUNTER
				* 16: TAMA SET
				* 18:     ;
				* 20: PC POINTER  /  -----
				* 22:     ;            ;
				* 24: TAMA WAIT MAX (ENEMY0: BEFORE ENEMY NUMBER)
				* 26: 0: PATTERN   1-5: FLASH
				* 28: SCORE
				* 30: BURN TRAP EXEC ADDRESS
				* 32:           ;
				*
				*         ÅñÇRÇS
				*

RNDSTAT:ds.b	1024
RNDEND:

	.end


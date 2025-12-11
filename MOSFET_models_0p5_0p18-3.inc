**********************************************************************
* SPICE MOSFET Models to accompany Microelectronic Circuits
*
* Usage:
*	.include MOSFET_models.inc
**********************************************************************

* 		Level-1 Model for PMOS in model 0.5um CMOS Technology
* 		(created by Anas Hamoui & Olivier Trescases)
.model PMOS0P5	PMOS(Level=1 VTO=-0.7 GAMMA=0.45 PHI=0.8
+		LD=0.09E-06 WD=0 UO=115 LAMBDA=0.2 TOX=9.5E-9 PB=0.9 CJ=0.93E-3
+		CJSW=170E-12 MJ=0.5 MJSW=0.35 CGDO=0.35E-9 JS=5E-9 CGBO=0.38E-9
+		CGSO=0.35E-9)

* 		Level-1 Model for NMOS in model 0.5um CMOS Technology
* 		(created by Anas Hamoui & Olivier Trescases)
.model NMOS0P5	NMOS(Level=1 VTO=0.7 GAMMA=0.5 PHI=0.8
+		LD=0.08E-06 WD=0 UO=460 LAMBDA=0.001 TOX=9.5E-9 PB=0.9 CJ=0.57E-3
+		CJSW=120E-12 MJ=0.5 MJSW=0.4 CGDO=0.4E-9 JS=10E-9 CGBO=0.38E-9
+		CGSO=0.4E-9)

* 		Level-1 Model for PMOS in model 0.18um CMOS Technology
.model PMOS0P18	PMOS(Level=1 VTO=-0.5 GAMMA=0.3 PHI=0.8
+		LD=10E-09 WD=0 UO=100 LAMBDA=0.17 TOX=4.08E-9 PB=0.9 CJ=1E-3
+		CJSW=2.04E-10 MJ=0.45 MJSW=0.29 CGDO=3.43E-10 JS=4.0E-7 CGBO=3.5E-10
+		CGSO=3.43E-10)


* 		Level-1 Model for NMOS in model 0.18um CMOS Technology
.model NMOS0P18	NMOS(Level=1 VTO=0.5 GAMMA=0.3 PHI=0.84
+		LD=10E-09 WD=0 UO=450 LAMBDA=0.2 TOX=4.08E-9 PB=0.9 CJ=1.6E-3
+		CJSW=2.04E-10 MJ=0.5 MJSW=0.2 CGDO=3.67E-10 JS=8.38E-6 CGBO=3.8E-10
+		CGSO=3.67E-10)

#!/bin/bash
set -e
out=full_adder_truth_table.csv
echo "A,B,Ci,S,Co,Vs,Vco" > $out
for A in 0 1; do
  for B in 0 1; do
    for Ci in 0 1; do
      cat > tmp_truth.cir <<EOF
.include ./MOSFET_models_0p5_0p18-3.inc
.include ./subcircuits.cir

VDD p_s 0 DC 1.8
VA A 0 DC ${A}
VB B 0 DC ${B}
VCi Ci 0 DC ${Ci}

* Instantiate gates (same sizing)
XX1 p_s A B x1 0 XNOR Wn=0.143u Wp=0.286u
XI1 p_s x1 x1_inv 0 INVERTER Wn=0.226u Wp=0.452u
XX2 p_s x1_inv Ci x2 0 XNOR Wn=0.357u Wp=0.714u
XI2 p_s x2 x2_inv 0 INVERTER Wn=0.567u Wp=1.134u
XI3 p_s x2_inv S 0 INVERTER Wn=0.9u Wp=1.8u

XNA1 p_s A B nab 0 NAND Wn=0.226u Wp=0.452u
XIA1 p_s nab ab 0 INVERTER Wn=0.357u Wp=0.714u
XNA2 p_s x1_inv Ci ncix 0 NAND Wn=0.226u Wp=0.452u
XIA2 p_s ncix cix 0 INVERTER Wn=0.357u Wp=0.714u
XNO p_s ab cix nor_out 0 NOR Wn=0.567u Wp=1.134u
XIO p_s nor_out Co 0 INVERTER Wn=0.9u Wp=1.8u

.op
.print dc V(A) V(B) V(Ci)
.end
EOF
      ngspice -b -o tmp_truth.log tmp_truth.cir || true
      # extract Vs and Vco from the node voltage table
      Vs=$(awk '/^[ 	]*s[ 	]+/ {print $2}' tmp_truth.log || echo "0")
      Vco=$(awk '/^[ 	]*co[ 	]+/ {print $2}' tmp_truth.log || echo "0")
      # default to 0 if empty
      Vs=${Vs:-0}
      Vco=${Vco:-0}
      Ls=0
      if (( $(echo "$Vs >= 0.9" | bc -l) )); then Ls=1; fi
      Lco=0
      if (( $(echo "$Vco >= 0.9" | bc -l) )); then Lco=1; fi
      echo "${A},${B},${Ci},${Ls},${Lco},${Vs},${Vco}" >> $out
    done
  done
done
rm -f tmp_truth.cir tmp_truth.log
echo "Wrote $out"

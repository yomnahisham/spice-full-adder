#!/bin/bash
set -e
out=full_adder_truth_table.csv
echo "A,B,Ci,S,Co,VS,VCo" > $out
for A in 0 1.8; do
  for B in 0 1.8; do
    for Ci in 0 1.8; do
      cat > tmp_truth.cir <<EOF
.include ./MOSFET_models_0p5_0p18-3.inc
.include ./subcircuits.cir

VDD vdd 0 DC 1.8
VA A 0 DC ${A}
VB B 0 DC ${B}
VCi Ci 0 DC ${Ci}

* Instantiate gates (same sizing as full_adder_opt.cir)
XX1 vdd A B xnor1 0 XNOR Wn=0.143u Wp=0.286u
XI1 vdd xnor1 xor1 0 INVERTER Wn=0.226u Wp=0.452u
XX2 vdd xor1 Ci xnor2 0 XNOR Wn=0.357u Wp=0.714u
XI2 vdd xnor2 S 0 INVERTER Wn=0.567u Wp=1.134u

XNA1 vdd A B nab 0 NAND Wn=0.226u Wp=0.452u
XIA1 vdd nab ab 0 INVERTER Wn=0.357u Wp=0.714u
XNA2 vdd xor1 Ci nci_xor1 0 NAND Wn=0.226u Wp=0.452u
XIA2 vdd nci_xor1 ci_xor1 0 INVERTER Wn=0.357u Wp=0.714u
XNO vdd ab ci_xor1 nor_out 0 NOR Wn=0.567u Wp=1.134u
XIO vdd nor_out Co 0 INVERTER Wn=0.9u Wp=1.8u

* Loads to match full_adder_opt.cir
RloadS S S_load 1k
CloadS S_load 0 0.2p
RloadCo Co Co_load 1k
CloadCo Co_load 0 0.2p

.op
.print dc V(A) V(B) V(Ci) V(S) V(Co)
.end
EOF
      ngspice -b -o tmp_truth.log tmp_truth.cir 2>&1 > /dev/null || true
      # Extract voltages from the output
      VS=$(awk '/^[[:space:]]*s[[:space:]]/ {print $2; exit}' tmp_truth.log 2>/dev/null | head -1 || echo "0")
      VCo=$(awk '/^[[:space:]]*co[[:space:]]/ {print $2; exit}' tmp_truth.log 2>/dev/null | head -1 || echo "0")
      # Default to 0 if empty
      VS=${VS:-0}
      VCo=${VCo:-0}
      # Convert input to 0/1 for display
      A_val=$(awk -v a="${A}" 'BEGIN {if (a >= 0.9) print 1; else print 0}')
      B_val=$(awk -v b="${B}" 'BEGIN {if (b >= 0.9) print 1; else print 0}')
      Ci_val=$(awk -v c="${Ci}" 'BEGIN {if (c >= 0.9) print 1; else print 0}')
      echo "${A_val},${B_val},${Ci_val},${VS},${VCo}" >> $out
    done
  done
done
rm -f tmp_truth.cir tmp_truth.log
echo "Wrote $out"

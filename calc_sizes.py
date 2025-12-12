#!/usr/bin/env python3
"""
calc_sizes.py

Simple utility that calculates transistor widths (W) and length (L) for
equal-stage sizing used in the course project. This script only computes
W and L values and writes a compact CSV report; it does NOT modify any
netlists.

Defaults follow the project guidelines:
- 0.18 µm technology: unit NMOS W = 0.9 u, L = 0.18 u
- 0.5 µm technology:  unit NMOS W = 1.25 u, L = 0.5 u

Equal-stage sizing rule used:
  - If p is the total electrical effort and n is the number of stages,
  the optimal stage effort f = p^(1/n).
  - We scale the unit stage widths so that stage i (1..n) has Wn = W_unit * f^(i-n)
  (this matches the sizing used previously in netlists).

Usage examples:
  python3 calc_sizes.py                 # prints table and writes size_report.csv
  python3 calc_sizes.py --tech 0.18 --n 5 --p 10
  python3 calc_sizes.py --tech 0.18 --n 5    # p defaults to 2*n per project (p=2*n)

Output:
  `size_report.csv` in the current directory with columns: stage, Wn_u, Wp_u, L_u

This script only calculates W and L.
"""

import argparse
import csv
from math import pow


TECH_DEFAULTS = {
  '0.18': {'L': 0.18, 'unit_Wn': 0.9},
  '0.5':  {'L': 0.5,  'unit_Wn': 1.25},
}


def compute_equal_stage_sizes(p, n, base_Wn, pm_factor=2.0):
  f = p ** (1.0 / n)
  sizes = []
  for i in range(1, n + 1):
    s = f ** (i - n)
    Wn = base_Wn * s
    Wp = Wn * pm_factor
    sizes.append({'stage': i, 'Wn_u': Wn, 'Wp_u': Wp})
  return sizes


def write_csv(sizes, L_u, out='size_report.csv'):
  with open(out, 'w', newline='') as f:
    w = csv.writer(f)
    w.writerow(['stage', 'Wn_u', 'Wp_u', 'L_u'])
    for s in sizes:
      w.writerow([s['stage'], f"{s['Wn_u']:.6g}", f"{s['Wp_u']:.6g}", f"{L_u:.6g}"])


def print_table(sizes, L_u):
  print(f"L = {L_u} u (channel length)")
  print(f"{'stage':>5}  {'Wn (u)':>10}  {'Wp (u)':>10}")
  for s in sizes:
    print(f"{s['stage']:5d}  {s['Wn_u']:10.6g}  {s['Wp_u']:10.6g}")


def main():
  p = argparse.ArgumentParser()
  p.add_argument('--tech', choices=['0.18', '0.5'], default='0.18', help='Technology (default 0.18)')
  p.add_argument('--n', type=int, default=5, help='Number of stages n (default 5)')
  p.add_argument('--p', type=float, default=None, help='Total product p (default = 2*n)')
  p.add_argument('--pm-factor', type=float, default=2.0, help='PMOS width factor (default 2.0)')
  p.add_argument('--out', default='size_report.csv', help='CSV output filename')
  args = p.parse_args()

  n = args.n
  p_val = args.p if args.p is not None else 2.0 * n
  tech = args.tech
  base = TECH_DEFAULTS[tech]
  base_Wn = base['unit_Wn']
  L_u = base['L']

  sizes = compute_equal_stage_sizes(p_val, n, base_Wn, pm_factor=args.pm_factor)
  print(f"Computing equal-stage sizes for tech {tech}, n={n}, p={p_val}")
  print_table(sizes, L_u)
  write_csv(sizes, L_u, out=args.out)
  print(f"Wrote CSV report: {args.out}")


if __name__ == '__main__':
  main()

Dict{Symbol, DataFrames.DataFrame} with 2 entries:
  :newton => 4×31 DataFrame
 Row │ id     name     nvar   ncon   nequ   status       objective     elapsed_time  iter   dual_feas  primal_feas  neval_obj  neval_grad  neval_cons  neval_jcon  neval_jgrad  neval_jac  neval_jprod  neval_jtprod  neval_hess  neval_hprod  neval_jhess  neval_jhprod  neval_residual  neval_jac_residual  neval_jprod_residual  neval_jtprod_residual  neval_hess_residual  neval_jhess_residual  neval_hprod_residual  extrainfo
     │ Int64  String   Int64  Int64  Int64  Symbol       Float64       Float64       Int64  Float64    Float64      Int64      Int64       Int64       Int64       Int64        Int64      Int64        Int64         Int64       Int64        Int64        Int64         Int64           Int64               Int64                 Int64                  Int64                Int64                 Int64                 String
─────┼────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   1 │     1  Generic      2      0      0  first_order   2.46519e-31      0.665424      1        Inf          0.0          3           4           0           0            0          0            0             0           1            0            0             0               0                   0                     0                      0                    0                     0                     0
   2 │     2  Generic      2      0      0  first_order   3.74398e-21      0.662992     21        Inf          0.0         50          64           0           0            0          0            0             0          21            0            0             0               0                   0                     0                      0                    0                     0                     0
   3 │     3  Generic      2      0      0  max_iter     -8.36356          0.713048    100        Inf          0.0        201         301           0           0            0          0            0             0         100            0            0             0               0                   0                     0                      0                    0                     0                     0
   4 │     4  Generic      2      0      0  first_order   1.43195          0.723688      5        Inf          0.0         12          16           0           0            0          0            0             0           5            0            0             0               0                   0                     0                      0                    0                     0                     0
  :lbfgs => 4×31 DataFrame
 Row │ id     name     nvar   ncon   nequ   status       objective     elapsed_time  iter   dual_feas   primal_feas  neval_obj  neval_grad  neval_cons  neval_jcon  neval_jgrad  neval_jac  neval_jprod  neval_jtprod  neval_hess  neval_hprod  neval_jhess  neval_jhprod  neval_residual  neval_jac_residual  neval_jprod_residual  neval_jtprod_residual  neval_hess_residual  neval_jhess_residual  neval_hprod_residual  extrainfo
     │ Int64  String   Int64  Int64  Int64  Symbol       Float64       Float64       Int64  Float64     Float64      Int64      Int64       Int64       Int64       Int64        Int64      Int64        Int64         Int64       Int64        Int64        Int64         Int64           Int64               Int64                 Int64                  Int64                Int64                 Int64                 String
─────┼─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   1 │     1  Generic      2      0      0  first_order   2.26824e-16    4.69685e-5      8  5.28297e-8          0.0         11          10           0           0            0          0            0             0           0            0            0             0               0                   0                     0                      0                    0                     0                     0
   2 │     2  Generic      2      0      0  first_order   1.44561e-17    8.58307e-5     39  8.41132e-8          0.0         52          45           0           0            0          0            0             0           0            0            0             0               0                   0                     0                      0                    0                     0                     0
   3 │     3  Generic      2      0      0  first_order  -8.37235        3.40939e-5     12  1.60958e-9          0.0         17          15           0           0            0          0            0             0           0            0            0             0               0                   0                     0                      0                    0                     0                     0
   4 │     4  Generic      2      0      0  first_order   1.43195        3.29018e-5      9  4.18646e-9          0.0         11          11           0           0            0          0            0             0           0            0            0             0               0                   0                     0                      0                    0                     0                     0
# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=bdver2 -iterations=100 -resource-pressure=false -timeline -timeline-max-iterations=2 < %s | FileCheck %s

# In this test, the VDIVPS takes 38 cycles to write to register YMM3.  The first
# VADDPS does not depend on the VDIVPS (the WAW dependency is eliminated at
# register renaming stage). So the first VADDPS can be executed in parallel to
# the VDIVPS. That VADDPS also writes to register XMM3, and the upper half of
# YMM3 is implicitly cleared. As a consequence, the definition of YMM3 from the
# VDIVPS is killed, and the subsequent VADDPS instructions don't need to wait
# for the VDIVPS to complete.
# The block reciprocal throughput is limited by the VDIVPS reciprocal throughput
# (which is 38 cycles). The sequence of VADDPS can be executed in parallel on
# the FPA unit; their latency is "hidden" by the long latency of the VDIVPS.

vdivps %ymm0, %ymm1, %ymm3
vaddps %xmm0, %xmm1, %xmm3
vaddps %ymm3, %ymm1, %ymm4
vaddps %ymm3, %ymm1, %ymm4
vaddps %ymm3, %ymm1, %ymm4
vaddps %ymm3, %ymm1, %ymm4
vaddps %ymm3, %ymm1, %ymm4
vaddps %ymm3, %ymm1, %ymm4
vaddps %ymm3, %ymm1, %ymm4
vaddps %ymm3, %ymm1, %ymm4
vaddps %ymm3, %ymm1, %ymm4
vaddps %ymm3, %ymm1, %ymm4
vaddps %ymm3, %ymm1, %ymm4
vaddps %ymm3, %ymm1, %ymm4
vaddps %ymm3, %ymm1, %ymm4
vaddps %ymm3, %ymm1, %ymm4
vaddps %ymm3, %ymm1, %ymm4
vandps %xmm4, %xmm1, %xmm0

# CHECK:      Iterations:        100
# CHECK-NEXT: Instructions:      1800
# CHECK-NEXT: Total Cycles:      4003
# CHECK-NEXT: Total uOps:        3400

# CHECK:      Dispatch Width:    4
# CHECK-NEXT: uOps Per Cycle:    0.85
# CHECK-NEXT: IPC:               0.45
# CHECK-NEXT: Block RThroughput: 31.0

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  2      9     19.00                       vdivps	%ymm0, %ymm1, %ymm3
# CHECK-NEXT:  1      5     1.00                        vaddps	%xmm0, %xmm1, %xmm3
# CHECK-NEXT:  2      5     2.00                        vaddps	%ymm3, %ymm1, %ymm4
# CHECK-NEXT:  2      5     2.00                        vaddps	%ymm3, %ymm1, %ymm4
# CHECK-NEXT:  2      5     2.00                        vaddps	%ymm3, %ymm1, %ymm4
# CHECK-NEXT:  2      5     2.00                        vaddps	%ymm3, %ymm1, %ymm4
# CHECK-NEXT:  2      5     2.00                        vaddps	%ymm3, %ymm1, %ymm4
# CHECK-NEXT:  2      5     2.00                        vaddps	%ymm3, %ymm1, %ymm4
# CHECK-NEXT:  2      5     2.00                        vaddps	%ymm3, %ymm1, %ymm4
# CHECK-NEXT:  2      5     2.00                        vaddps	%ymm3, %ymm1, %ymm4
# CHECK-NEXT:  2      5     2.00                        vaddps	%ymm3, %ymm1, %ymm4
# CHECK-NEXT:  2      5     2.00                        vaddps	%ymm3, %ymm1, %ymm4
# CHECK-NEXT:  2      5     2.00                        vaddps	%ymm3, %ymm1, %ymm4
# CHECK-NEXT:  2      5     2.00                        vaddps	%ymm3, %ymm1, %ymm4
# CHECK-NEXT:  2      5     2.00                        vaddps	%ymm3, %ymm1, %ymm4
# CHECK-NEXT:  2      5     2.00                        vaddps	%ymm3, %ymm1, %ymm4
# CHECK-NEXT:  2      5     2.00                        vaddps	%ymm3, %ymm1, %ymm4
# CHECK-NEXT:  1      2     0.50                        vandps	%xmm4, %xmm1, %xmm0

# CHECK:      Timeline view:
# CHECK-NEXT:                     0123456789          0123456789          0123456789          0123456789
# CHECK-NEXT: Index     0123456789          0123456789          0123456789          0123456789

# CHECK:      [0,0]     DeeeeeeeeeER   .    .    .    .    .    .    .    .    .    .    .    .    .   .   vdivps	%ymm0, %ymm1, %ymm3
# CHECK-NEXT: [0,1]     DeeeeeE----R   .    .    .    .    .    .    .    .    .    .    .    .    .   .   vaddps	%xmm0, %xmm1, %xmm3
# CHECK-NEXT: [0,2]     .D====eeeeeER  .    .    .    .    .    .    .    .    .    .    .    .    .   .   vaddps	%ymm3, %ymm1, %ymm4
# CHECK-NEXT: [0,3]     .D======eeeeeER.    .    .    .    .    .    .    .    .    .    .    .    .   .   vaddps	%ymm3, %ymm1, %ymm4
# CHECK-NEXT: [0,4]     . D=======eeeeeER   .    .    .    .    .    .    .    .    .    .    .    .   .   vaddps	%ymm3, %ymm1, %ymm4
# CHECK-NEXT: [0,5]     . D=========eeeeeER .    .    .    .    .    .    .    .    .    .    .    .   .   vaddps	%ymm3, %ymm1, %ymm4
# CHECK-NEXT: [0,6]     .  D==========eeeeeER    .    .    .    .    .    .    .    .    .    .    .   .   vaddps	%ymm3, %ymm1, %ymm4
# CHECK-NEXT: [0,7]     .  D============eeeeeER  .    .    .    .    .    .    .    .    .    .    .   .   vaddps	%ymm3, %ymm1, %ymm4
# CHECK-NEXT: [0,8]     .   D=============eeeeeER.    .    .    .    .    .    .    .    .    .    .   .   vaddps	%ymm3, %ymm1, %ymm4
# CHECK-NEXT: [0,9]     .   D===============eeeeeER   .    .    .    .    .    .    .    .    .    .   .   vaddps	%ymm3, %ymm1, %ymm4
# CHECK-NEXT: [0,10]    .    D================eeeeeER .    .    .    .    .    .    .    .    .    .   .   vaddps	%ymm3, %ymm1, %ymm4
# CHECK-NEXT: [0,11]    .    D==================eeeeeER    .    .    .    .    .    .    .    .    .   .   vaddps	%ymm3, %ymm1, %ymm4
# CHECK-NEXT: [0,12]    .    .D===================eeeeeER  .    .    .    .    .    .    .    .    .   .   vaddps	%ymm3, %ymm1, %ymm4
# CHECK-NEXT: [0,13]    .    .D=====================eeeeeER.    .    .    .    .    .    .    .    .   .   vaddps	%ymm3, %ymm1, %ymm4
# CHECK-NEXT: [0,14]    .    . D======================eeeeeER   .    .    .    .    .    .    .    .   .   vaddps	%ymm3, %ymm1, %ymm4
# CHECK-NEXT: [0,15]    .    . D========================eeeeeER .    .    .    .    .    .    .    .   .   vaddps	%ymm3, %ymm1, %ymm4
# CHECK-NEXT: [0,16]    .    .  D=========================eeeeeER    .    .    .    .    .    .    .   .   vaddps	%ymm3, %ymm1, %ymm4
# CHECK-NEXT: [0,17]    .    .  D==============================eeER  .    .    .    .    .    .    .   .   vandps	%xmm4, %xmm1, %xmm0
# CHECK-NEXT: [1,0]     .    .   D===============================eeeeeeeeeER   .    .    .    .    .   .   vdivps	%ymm0, %ymm1, %ymm3
# CHECK-NEXT: [1,1]     .    .   D===============================eeeeeE----R   .    .    .    .    .   .   vaddps	%xmm0, %xmm1, %xmm3
# CHECK-NEXT: [1,2]     .    .    D===================================eeeeeER  .    .    .    .    .   .   vaddps	%ymm3, %ymm1, %ymm4
# CHECK-NEXT: [1,3]     .    .    D=====================================eeeeeER.    .    .    .    .   .   vaddps	%ymm3, %ymm1, %ymm4
# CHECK-NEXT: [1,4]     .    .    .D======================================eeeeeER   .    .    .    .   .   vaddps	%ymm3, %ymm1, %ymm4
# CHECK-NEXT: [1,5]     .    .    .D========================================eeeeeER .    .    .    .   .   vaddps	%ymm3, %ymm1, %ymm4
# CHECK-NEXT: [1,6]     .    .    . D=========================================eeeeeER    .    .    .   .   vaddps	%ymm3, %ymm1, %ymm4
# CHECK-NEXT: [1,7]     .    .    . D===========================================eeeeeER  .    .    .   .   vaddps	%ymm3, %ymm1, %ymm4
# CHECK-NEXT: [1,8]     .    .    .  D============================================eeeeeER.    .    .   .   vaddps	%ymm3, %ymm1, %ymm4
# CHECK-NEXT: [1,9]     .    .    .  D==============================================eeeeeER   .    .   .   vaddps	%ymm3, %ymm1, %ymm4
# CHECK-NEXT: [1,10]    .    .    .   D===============================================eeeeeER .    .   .   vaddps	%ymm3, %ymm1, %ymm4
# CHECK-NEXT: [1,11]    .    .    .   D=================================================eeeeeER    .   .   vaddps	%ymm3, %ymm1, %ymm4
# CHECK-NEXT: [1,12]    .    .    .    D==================================================eeeeeER  .   .   vaddps	%ymm3, %ymm1, %ymm4
# CHECK-NEXT: [1,13]    .    .    .    D====================================================eeeeeER.   .   vaddps	%ymm3, %ymm1, %ymm4
# CHECK-NEXT: [1,14]    .    .    .    .D=====================================================eeeeeER  .   vaddps	%ymm3, %ymm1, %ymm4
# CHECK-NEXT: [1,15]    .    .    .    .D=======================================================eeeeeER.   vaddps	%ymm3, %ymm1, %ymm4

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     2     16.5   0.5    0.0       vdivps	%ymm0, %ymm1, %ymm3
# CHECK-NEXT: 1.     2     16.5   0.5    4.0       vaddps	%xmm0, %xmm1, %xmm3
# CHECK-NEXT: 2.     2     20.5   0.0    0.0       vaddps	%ymm3, %ymm1, %ymm4
# CHECK-NEXT: 3.     2     22.5   2.0    0.0       vaddps	%ymm3, %ymm1, %ymm4
# CHECK-NEXT: 4.     2     23.5   4.0    0.0       vaddps	%ymm3, %ymm1, %ymm4
# CHECK-NEXT: 5.     2     25.5   6.0    0.0       vaddps	%ymm3, %ymm1, %ymm4
# CHECK-NEXT: 6.     2     26.5   8.0    0.0       vaddps	%ymm3, %ymm1, %ymm4
# CHECK-NEXT: 7.     2     28.5   10.0   0.0       vaddps	%ymm3, %ymm1, %ymm4
# CHECK-NEXT: 8.     2     29.5   12.0   0.0       vaddps	%ymm3, %ymm1, %ymm4
# CHECK-NEXT: 9.     2     31.5   14.0   0.0       vaddps	%ymm3, %ymm1, %ymm4
# CHECK-NEXT: 10.    2     32.5   16.0   0.0       vaddps	%ymm3, %ymm1, %ymm4
# CHECK-NEXT: 11.    2     34.5   18.0   0.0       vaddps	%ymm3, %ymm1, %ymm4
# CHECK-NEXT: 12.    2     35.5   20.0   0.0       vaddps	%ymm3, %ymm1, %ymm4
# CHECK-NEXT: 13.    2     37.5   22.0   0.0       vaddps	%ymm3, %ymm1, %ymm4
# CHECK-NEXT: 14.    2     38.5   23.5   0.0       vaddps	%ymm3, %ymm1, %ymm4
# CHECK-NEXT: 15.    2     40.5   25.5   0.0       vaddps	%ymm3, %ymm1, %ymm4
# CHECK-NEXT: 16.    2     41.5   27.0   0.0       vaddps	%ymm3, %ymm1, %ymm4
# CHECK-NEXT: 17.    2     46.5   0.0    0.0       vandps	%xmm4, %xmm1, %xmm0

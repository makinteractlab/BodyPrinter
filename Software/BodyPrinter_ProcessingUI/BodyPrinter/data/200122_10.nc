(1001)
(T2  D=1.587 CR=0.381 - ZMIN=0 - bullnose end mill)
G90 G94
G17
G21
G28 G91 Z0
G90

(Trace6)
T2 M6
S10000 M3
G54
M8
G0 X30 Y-14.072
Z15
Z5
G1 Z0 F381
X40
Z5
G0 Y-24.072
G1 Z0 F381
X30
Z5
G0 Z15
M9
G28 G91 Z0
G90
G28 G91 X0 Y0
G90
M5
M30

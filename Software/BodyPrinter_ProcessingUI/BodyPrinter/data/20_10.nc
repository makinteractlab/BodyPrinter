(1001)
(T2  D=1.587 CR=0.381 - ZMIN=0 - bullnose end mill)
G90 G94
G17
G21
G28 G91 Z0
G90

(Trace7)
T2 M6
S10000 M3
G54
M8
G0 X35 Y-15
Z15
Z5
G1 Z0 F381
X45
Z5
G0 Y-25
G1 Z0 F381
X35
Z5
G0 Z15
M9
G28 G91 Z0
G90
G28 G91 X0 Y0
G90
M5
M30
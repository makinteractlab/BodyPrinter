(1001)
(T1  D=1.587 CR=0.381 - ZMIN=0 - bullnose end mill)
G90 G94
G17
G21
G28 G91 Z0
G90

(Trace15)
T1 M6
S10000 M3
G54
M8
G0 X5 Y-5
Z16
Z5
G1 Z0 F381
X25
Z5
G0 Z6
Y-10
Z5
G1 Z0 F381
X5
Z5
G0 Z6
Y-15
Z5
G1 Z0 F381
X25
Z5
G0 Z6
Y-20
Z5
G1 Z0 F381
X5
Z5
G0 Z6
Y-25
Z5
G1 Z0 F381
X25
Z5
G0 Z16
M9
G28 G91 Z0
G90
G28 G91 X0 Y0
G90
M5
M30

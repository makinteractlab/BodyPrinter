%
(1001)
(T1  D=1.587 CR=0.381 - ZMIN=0 - bullnose end mill)
G90 G94
G17
G21
G28 G91 Z0
G90

(2D Contour1)
M9
T1 M6
S10000 M3
G54
M8
G0 X31.432 Y-17.67
Z16
Z6
G1 Z2 F762
Z0
G2 X55.95 Y-19.446 I12.259 J-0.888 F381
X43.691 Y-30.849 I-12.259 J0.888
X31.42 Y-19.257 J12.291
G1 X11.368
G0 Z16
M9
G28 G91 Z0
G90
G28 G91 X0 Y0
G90
M30
%

G21         ; Set units to mm
G90         ; Absolute positioning
G2 Z3.9999999999999996 F2540      ; Move to clearance level

;
; Operation:    0
; Name:         
; Type:         Engrave
; Paths:        4
; Direction:    Conventional
; Cut Depth:    0.01
; Pass Depth:   0.4000000000000001
; Plunge rate:  127
; Cut rate:     1016
;

; Path 0
; Rapid to initial position
G1 X11.4838 Y15.2891 F2540
G3 Z0.0000
; plunge
G4 Z-0.0100 F127
; cut
G1 X9.3424 Y15.2891 F1016
G1 X8.4590 Y2.3330
G1 X10.0650 Y2.3330
G1 X10.4132 Y7.8741
G1 X10.5636 Y10.8690
G1 X10.6540 Y13.6028
G1 X10.6807 Y13.6028
G1 X11.3401 Y11.1969
G1 X12.1798 Y8.5700
G1 X14.2679 Y2.4133
G1 X15.5260 Y2.4133
G1 X17.8280 Y8.7039
G1 X18.7147 Y11.2670
G1 X19.4610 Y13.6294
G1 X19.5146 Y13.6294
G1 X19.5580 Y10.9022
G1 X19.7020 Y8.0348
G1 X20.0500 Y2.3330
G1 X21.6830 Y2.3330
G1 X20.8798 Y15.2891
G1 X18.7383 Y15.2891
G1 X16.4361 Y9.0252
G1 X15.0708 Y4.6617
G1 X15.0175 Y4.6617
G1 X13.7056 Y9.0252
G1 X11.4838 Y15.2891
G1 X11.4838 Y15.2891
; Retract
G2 Z4.0000 F2540

; Path 1
; Rapid to initial position
G1 X27.4650 Y15.2891 F2540
G3 Z0.0000
; plunge
G4 Z-0.0100 F127
; cut
G1 X23.0749 Y2.3330 F1016
G1 X24.8148 Y2.3330
G1 X26.1534 Y6.4019
G1 X30.7307 Y6.4019
G1 X32.1226 Y2.3330
G1 X33.8894 Y2.3330
G1 X29.4726 Y15.2891
G1 X29.4726 Y15.2891
G1 X27.4650 Y15.2891
; Retract
G2 Z4.0000 F2540

; Path 2
; Rapid to initial position
G1 X28.4287 Y13.7900 F2540
G3 Z0.0000
; plunge
G4 Z-0.0100 F127
; cut
G1 X28.4554 Y13.7900 F1016
G1 X28.4554 Y13.7900
G1 X29.1247 Y11.4344
G1 X30.3827 Y7.7135
G1 X30.3827 Y7.6866
G1 X26.5280 Y7.6866
G1 X27.7861 Y11.4344
G1 X28.4287 Y13.7900
; Retract
G2 Z4.0000 F2540

; Path 3
; Rapid to initial position
G1 X35.8168 Y15.2891 F2540
G3 Z0.0000
; plunge
G4 Z-0.0100 F127
; cut
G1 X35.8168 Y2.3864 F1016
G1 X37.4764 Y2.3864
G1 X37.4764 Y7.3119
G1 X38.7078 Y8.7308
G1 X42.9641 Y2.3597
G1 X44.9450 Y2.3597
G1 X39.8856 Y9.8014
G1 X44.5971 Y15.2891
G1 X42.5092 Y15.2891
G1 X38.5206 Y10.4440
G1 X37.5034 Y9.0518
G1 X37.4498 Y9.0518
G1 X37.4498 Y15.2891
G1 X37.4498 Y15.2891
G1 X35.8168 Y15.2891
; Retract
G2 Z4.0000 F2540
M2

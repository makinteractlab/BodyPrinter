void keyPressed() {
    tipIndex();
    CalibrationMap cal = calMap.get(xIndex + yIndex*(column+1));    
    if(keyCode == 38) {    
        cal.calib(0.5);
        Arduino.sendGcode("G91\n");
        Arduino.sendGcode("G1 Z-0.5 F300\n");
        println("Z-1");
        //targetSet(0, 0, -10);
        //tipSet(0, 0, -10);
        //posSet(0, 0, -10);
    } else if(keyCode == 40 ) {
        cal.calib(-0.5);
        Arduino.sendGcode("G91\n");
        Arduino.sendGcode("G1 Z0.5 F300\n");
        println("Z1");
        //targetSet(0, 0, 10);
        //tipSet(0, 0, 10);
        //posSet(0, 0, 10);
    } 

    calMap.set(xIndex + yIndex*(column+1), cal);
    
    if (keyCode == 10 ) {
        // for(CalibrationMap calp : calMap) {
        //     println(calp.zValue);
        // }
        tipIndex();
        CalibrationMap zCal01 = calMap.get(calxIndex + calyIndex*(column+1));
        CalibrationMap zCal02 = calMap.get(calxIndex + 1 + calyIndex*(column+1));
        CalibrationMap zCal03 = calMap.get(calxIndex + (calyIndex+1)*(column+1));
        CalibrationMap zCal04 = calMap.get(calxIndex + 1 +(calyIndex+1)*(column+1));
        println("cal y x " + calyIndex +" " + calxIndex); 
        println("tip " + tip.x + " " + tip.y);
        float a;
        float c;
        if(tip.x/arryColumn >= 1 && tip.x%arryColumn == 0) {
            a = 0;    
        } else {
            a = tip.x% (arryColumn);
        }
        if(tip.y/arryRow >= 1 && tip.y%arryRow == 0) {
            c = 0;
        } else {
            c = tip.y%arryRow;
        }
        float b = arryColumn - a;
        //float c = tip.y % arryRow;
        float d = arryRow - c;

        float zValue = (zCal01.zValue*b*d + zCal02.zValue*a*d + zCal03.zValue*b*c + zCal04.zValue*a*c)/(arryColumn*arryRow);
        
        println(zCal01.zValue + " " + zCal02.zValue + " " + zCal03.zValue + " " + zCal04.zValue);
        println(a + " " + b + " " + c + " " + d);
        println(zValue);
        backgroundIndex(tip.x, tip.y);
        println("bg color index : " + backcalyIndex + " " + backcalxIndex);
        println(zValue(backcalxIndex, backcalyIndex));

    }    
    if(key == '?') {
        //Arduino.currentState();
        //println("x y Index :" + xIndex + " " + yIndex);
        if(pause) {
            pause = false;
            
        } else {
            pause = true;
            stateDraw = true;
            Arduino.sendGcode("G0 Z0 F1500\n");
            delay(30);
        }

    }
}
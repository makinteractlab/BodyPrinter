float zValue(int x, int y) {
    CalibrationMap zCal01 = calMap.get(x + y*(column+1));
    CalibrationMap zCal02 = calMap.get(x + 1 + y*(column+1));
    CalibrationMap zCal03 = calMap.get(x + (y+1)*(column+1));
    CalibrationMap zCal04 = calMap.get(x + 1 +(y+1)*(column+1));

    float a;
    float c;
    if(tip.x/arryColumn >= 1 && tip.x%arryColumn == 0) {
        a = 0;    
    } else {
        a = tip.x % (arryColumn);
    }
    if(tip.y/arryRow >= 1 && tip.y%arryRow == 0) {
        c = 0;    
    } else {
        c = tip.y % (arryRow);
    }   
    //float a = tip.x % (arryColumn);
    float b = (arryColumn) - a;
    //float c = tip.y % (arryRow);
    float d = (arryRow) - c;
    float zValue = (zCal01.zValue*b*d + zCal02.zValue*a*d + zCal03.zValue*b*c + zCal04.zValue*a*c)/(arryColumn*arryRow);
    //println(a + " " + b + " " + c + " " + d);
    return zValue;
}

float backgroundzValue(int x, int y) {
    backgroundIndex(x,y);
    CalibrationMap zCal01 = calMap.get(backcalxIndex + backcalyIndex*(column+1));
    CalibrationMap zCal02 = calMap.get(backcalxIndex + 1 + backcalyIndex*(column+1));
    CalibrationMap zCal03 = calMap.get(backcalxIndex + (backcalyIndex+1)*(column+1));
    CalibrationMap zCal04 = calMap.get(backcalxIndex + 1 +(backcalyIndex+1)*(column+1));
    float a;
    float c;
    if(x/arryColumn >= 1 && x%arryColumn == 0) {
        a = 0;    
    } else {
        a = x % (arryColumn);
    }

    if(y/arryRow >= 1 && y%arryRow == 0) {
        c = 0;    
    } else {
        c = y % (arryRow);
    }
    
    float b = (arryColumn) - a;
    //float c = y % (arryRow);
    float d = (arryRow) - c;

    float zValue = (zCal01.zValue*b*d + zCal02.zValue*a*d + zCal03.zValue*b*c + zCal04.zValue*a*c)/(arryColumn*arryRow);
    //println(a + " " + b + " " + c + " " + d);
    return zValue;
}

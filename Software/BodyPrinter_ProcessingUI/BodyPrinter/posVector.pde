void posInit() {
    tip = new PVector(0,0,0);
    target = new PVector(0,0,0);
    diff = new PVector(0,0,0);
    pos = new PVector(0,0,0);
    xIndex = 0;
    yIndex = 0;
    stateDraw = true;
}

void drawingLine() {
    if(diff.mag() > 3) {
        if(!stateDraw) { //draw state
            if(countDraw % injectPeriod == 0) {
                Arduino.sendGcode("M9\n");
                Arduino.sendGcode("S" + pump + "\n");
                Arduino.sendGcode("M4\n");
                if(countDraw == 0) {
                  delay(500);
                  Arduino.sendGcode("M5\n");
                }
                
            }
            countDraw++;
            diff.normalize();
            diff.mult(3);
            pos = PVector.add(tip, diff);
            tipIndex();
            float zVal = zValue(calxIndex, calyIndex);
            //Arduino.sendGcode("G90\n");
            Arduino.sendGcode("G1 Z"  + -1*zVal + " " + "F1500\n");
            //println("Z value " + zVal + "tip " + tip.x + " " + tip.y);
            delay(20);
            Arduino.sendGcode("G1 X" + pos.x/10 + " " + "Y" + -1*pos.y/10 + " " + "F1500\n" );
            delay(110);
            tip.set(pos);
            pumpOff = 0;  
            Arduino.sendGcode("M5\n");
        } else { // move state
        // if(pumpOffduration == pumpOff) {
        //     Arduino.sendGcode("M9\n");
        //     println("sucking off by steps");
            
        // }
            diff.normalize();
            diff.mult(3);
            pos = PVector.add(tip, diff);
            //Arduino.sendGcode("G90\n");
            Arduino.sendGcode("G1 Z0" +" " + "F1500\n");
            delay(20);
            Arduino.sendGcode("G1 X" + pos.x/10 + " " + "Y" + -1*pos.y/10 + " " + "F1500\n" );
            delay(180);
            tip.set(pos);
            pumpOff++;
            countDraw = 0;
        }
    } else {
        tipIndex();
        tip.set(target);
        scriptLine = true;
    } 
}

void drawingCircle() {
    diff = PVector.sub(target, tip);
    pumpOff = 0;
    if(diff.mag() > 3) {
        if(g2 == true){
            pos.rotate((3/r.mag())); 
        } else if (g3 == true){
            pos.rotate(-1*(3/r.mag())); 
        }
        tip = PVector.add(center,pos); 
        
        if(!stateDraw) { //draw state
            if(countDraw % injectPeriod == 0) {
                Arduino.sendGcode("M9\n");
                Arduino.sendGcode("S" + pump + "\n");
                Arduino.sendGcode("M4\n");
            }
            countDraw++;
            tipIndex();
            float zVal = zValue(calxIndex, calyIndex);
            Arduino.sendGcode("G90\n");
            Arduino.sendGcode("G1 Z"  + -1*zVal + " " + "F1500\n");
            //println("Z value " + zVal);
            delay(20);
            Arduino.sendGcode("G1 X" + tip.x/10 + " " + "Y" + -1*tip.y/10 + " " + "F1500\n" );
            delay(180);
            Arduino.sendGcode("M5\n");
        } else { // move state
            Arduino.sendGcode("G90\n");
            Arduino.sendGcode("G1 Z0" + "F1500\n");
            Arduino.sendGcode("G1 X" + tip.x/10 + " " + "Y" + -1*tip.y/10 + " " + "F1500\n" );
            //println("circle move");
            delay(180);
        }
        
    } else {
        scriptLine = true;
        countG3 = 0;
    }
}

void targetSet(float dx, float dy, float dz) {
    float tx = target.x + dx;
    float ty = target.y + dy;
    float tz = target.z + dz;
    target.set(tx,ty,tz);
}

void tipSet (float dx, float dy, float dz) {
    float x = tip.x + dx;
    float y = tip.y + dy;
    float z = tip.z + dz;
    tip.set(x,y,z);
}

void posSet (float dx, float dy, float dz) {
    float x = pos.x + dx;
    float y = pos.y + dy;
    float z = pos.z + dz;
    pos.set(x,y,z); 
}

void tipIndex() {
    
    xIndex = int(tip.x / (winWid / (column + 1)));
    yIndex = int(tip.y / (winHei / (row+1) ));
    calxIndex = int(tip.x / (winWid / column));
    calyIndex = int(tip.y / (winHei / row));
    mousexIndex = int(mouseX / (winWid / (column + 1)));
    mouseyIndex = int(mouseY / (winHei / (row+1)));
    if (xIndex == (column + 1)) {
        xIndex = column;
    }
    if (yIndex == (row + 1)) { 
        yIndex = row;
    }
    if (calxIndex == column) {
        calxIndex = column - 1;
    }
    if (calyIndex == row) {
        calyIndex = row - 1;
    }
    if(mousexIndex == (column + 1)) {
        mousexIndex = column;
    }
    if (mouseyIndex == (row + 1)) {
        mouseyIndex = row;
    }
}

void backgroundIndex(float x, float y) {
    backcalxIndex = int(x / (winWid / column));
    backcalyIndex = int(y / (winHei / row));
    if(backcalxIndex == column) {
        backcalxIndex = column - 1;
    }
    if(backcalyIndex == row) {
        backcalyIndex = row - 1;
    }
    
}

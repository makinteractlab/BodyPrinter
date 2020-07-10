

public void controlEvent(ControlEvent theEvent) {
  println(theEvent.getController().getName());
  
}

public void UP() {
    Arduino.sendGcode("G91\n");
    Arduino.sendGcode("G1 Y1 F300\n");
    targetSet(0, -10, 0);
    tipSet(0, -10, 0);
    posSet(0, -10,0);
}

public void DOWN() {
    Arduino.sendGcode("G91\n");
    Arduino.sendGcode("G1 Y-1 F300\n");
    targetSet(0, 10, 0);
    tipSet(0, 10, 0);
    posSet(0, 10,0);
}

public void LEFT() {
    Arduino.sendGcode("G91\n");
    Arduino.sendGcode("G1 X-1 F300\n");
    targetSet(-10, 0, 0);
    tipSet(-10, 0, 0);
    posSet(-10, 0,0);
}

public void RIGHT() {
    Arduino.sendGcode("G91\n");
    Arduino.sendGcode("G1 X1 F300\n");
    targetSet(10, 0, 0);
    tipSet(10, 0, 0);
    posSet(10, 0,0);
}

public void ZUP() {
    Arduino.sendGcode("G91\n");
    Arduino.sendGcode("G1 Z1 F300\n");
    targetSet(0, 0, 10);
    tipSet(0, 0, 10);
}

public void ZDW() {
    Arduino.sendGcode("G91\n");
    Arduino.sendGcode("G1 Z-1 F300\n");
    targetSet(0, 0, -10);
    tipSet(0, 0, -10);
    posSet(0, 0,-10);
}

// public void LUP() {
//     Arduino.sendGcode("G91\n");
//     Arduino.sendGcode("G1 X-1 Y1 F300\n");
//     targetSet(-10, -10, 0);
//     tipSet(-10, -10, 0);
//     posSet(-10, -10,0);
// }

// public void LDW() {
//     Arduino.sendGcode("G91\n");
//     Arduino.sendGcode("G1 X-1 Y-1 F300\n");
//     targetSet(-10, 10, 0);
//     tipSet(-10, 10, 0);
//     posSet(-10, 10,0);
// }

// public void RUP() {
//     Arduino.sendGcode("G91\n");
//     Arduino.sendGcode("G1 X1 Y1 F300\n");
//     targetSet(10, -10, 0);
//     tipSet(10, -10, 0);
//     posSet(10, -10,0);
// }

// public void RDW() {
//     Arduino.sendGcode("G91\n");
//     Arduino.sendGcode("G1 X1 Y-1 F300\n");
//     targetSet(10, 10, 0);
//     tipSet(10, 10, 0);
//     posSet(10, 10,0);
// }
public void injecting(int theColor) {
    println("inject period");
    injectPeriod = theColor;
    println(injectPeriod);

}
public void pwm(int theColor) {
    println("test spindle");
    pump = theColor;
    Arduino.sendGcode("S" + pump + "\n");
}

public void sucking(int theColor) {
    println("test sucking");
    pumpOffduration = theColor;
}


public void INIT() {
    posInit();
    background(255);
    XY.clear();
    paths.clear();
}

public void HOME() {
    Arduino.goOrigin();
    posInit();
    
}

public void CALIBRARION() {
    if(stateMap) {
        stateMap = false;
    } else {
        stateMap = true;
    }
    
    
}

public void DRAW() {
    background(255);
    if(stateDraw) {
        stateDraw = false;
    } else {
        stateDraw = true;
    }
}

public void PUMPON() {
    println("pump on");
    Arduino.sendGcode("M9\n");
    Arduino.sendGcode("S500");
    Arduino.sendGcode("M4\n");
}

public void PUMPOFF() {
    println("Pump OFf");
    Arduino.sendGcode("M5\n");
    Arduino.sendGcode("M9\n");
}

public void PUMPSUCKTION() {
    println("Pump Sucking");
    Arduino.sendGcode("M5\n");
    Arduino.sendGcode("M8\n");
}
void row(int theColor) {
    row = theColor;
    makeArraylist();
    println(calMap.size());
}

void column(int theColor) {
    column = theColor;
    makeArraylist();
    println(calMap.size());
}

public void START() {
    Arduino.sendGcode("G90\n");
    //output.println("script Start");
    if(scriptDraw) {
        scriptDraw = false;
        println("script false");
    } else {
        scriptDraw = true;
        println("script true");
    }
}

public void LOAD() {
    if(loadtriger) {
        selectInput("Select a gcode file:", "fileSelected");
    }
    loadtriger = true;
    
}

void makeArraylist() {
    calMap.clear();
    for(int i = 0; i <= row; i++) {
        for(int j = 0; j <= column ; j++) {
            calMap.add(new CalibrationMap(row, column, i, j));
        }
    }
}

void fileSelected(File selection) {
    if (selection == null) {
        println("Window was closed or the user hit cancel.");
    } else {
        println("User selected " + selection.getAbsolutePath());
        script = loadStrings(selection.getAbsolutePath());
        gcodeloader();
    }
}

public void VIEW() {
    println("view clicked");
    for(Path a : paths) {
        println(a.mode +" " + a.pathX + " " + a.pathY + " " + a.pathZ + " " + a.pathI + " "+ a.pathJ);
    }
    if(viewState) {
        viewState = false;
    } else {
        viewState = true;
    }
}
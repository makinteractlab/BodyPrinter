import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.serial.*; 
import controlP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class BodyPrinter extends PApplet {




ArrayList<CalibrationMap> calMap = new ArrayList<CalibrationMap>();
ArrayList<XYtable> XY = new ArrayList<XYtable>();
ArrayList<Path> paths = new ArrayList<Path>();
ArrayList<Path> pathsDraw = new ArrayList<Path>();


conectArduino Arduino;

PrintWriter output;
ControlP5 pad;

int defaultStepX;
int defaultStepY;
int defaultStepZ;

float winWid = 740;
float winHei = 390;

int scriptOn = 0;

int xIndex;
int yIndex;

int mousexIndex;
int mouseyIndex;

int calxIndex;
int calyIndex;

int backxIndex;
int backyIndex;

int backcalxIndex;
int backcalyIndex;
int pump;
float arryRow;
float arryColumn;

int order;

int countG3;
int countG0;
int changeG0;
int pumpOff;
int pumpOffduration;
int countDraw;
int injectPeriod;
int mouseCount;

int row;
int column;
int spindle;
int sucking;
int injecting;

PImage drawing;

PVector tip;
PVector target;
PVector diff;
PVector pos;
PVector center;
PVector r;

String[] script; 
String[] q;


boolean pumpState = false;
boolean stateDraw;
boolean stateMap;
boolean scriptDraw;
boolean scriptLine;
boolean g3;
boolean g2;
boolean loadtriger;
boolean viewState; 
boolean pause;

public void setup() {
     //74mm x 39mm + controlpad area
    background(255);
    printArray(Serial.list());
    Arduino = new conectArduino(this, 3);
    GUIsetup();
    posInit();

    order = 0;
    countG3 = 0;
    countG0 = 0;
    changeG0 = 0;
    pumpOff = 0;
    countDraw = 0;
    
    row = 1;
    column = 1;
    spindle = 500;
    sucking = 30;
    injecting = 10;
    
    pump = 300;
    pumpOffduration = 30;
    injectPeriod = 10;
    mouseCount = 0;

    stateDraw = true;
    stateMap = true;
    scriptDraw = false;
    scriptLine = true;
    g3 = false;
    g2 = false;
    loadtriger = false;
    viewState = false;
    pause = false;

    center = new PVector(0,0);
    output = createWriter("gcode.txt");
}

public void draw() {
    if(!pause) {
        if(scriptDraw) {
            if(scriptLine) {
                scriptLine = false;
                g3 = false;
                g2 = false;
                gcode();
            } else {
            }

            if(g3 == false && g2 == false) {
                diff = PVector.sub(target,tip);
                drawingLine();
                displayTip(false);
            
            } else {
                if(countG3 == 0 ) {
                    pos = PVector.sub(tip, center);
                    Arduino.sendGcode("G90\n");
                    countG3++;
                }
                displayTip(false);
                drawingCircle();
            }
        } else {
            diff = PVector.sub(target,tip);
            if(diff.mag()> 0) {
                drawingLine();
            }
            displayTip(false);
        }
        if (mousePressed == true) {
            if(mouseX < 2*width/3) {
                if(mouseButton == LEFT && stateDraw == false) {
                    if(mouseCount == 0) {
                        Path pMouse = new Path(0.0f,PApplet.parseFloat(pmouseX)/10.0f, PApplet.parseFloat(-1*pmouseY)/10.0f, 0.0f,0.0f,0.0f);
                        output.println(pMouse.mode + " " + pMouse.pathX + " " + pMouse.pathY);
                        Path cMouse = new Path(1.0f,PApplet.parseFloat(mouseX)/10.0f, PApplet.parseFloat(-1*mouseY)/10.0f, 0.0f,0.0f,0.0f);
                        output.println(cMouse.mode + " " + cMouse.pathX + " " + cMouse.pathY);
                        paths.add(pMouse);
                        paths.add(cMouse);
                        println(mouseCount);
                        mouseCount++;
                    
                        
                    } else {
                        Path pMouse = new Path(1.0f,PApplet.parseFloat(pmouseX)/10.0f, PApplet.parseFloat(-1*pmouseY)/10.0f, 0.0f,0.0f,0.0f);
                        output.println(pMouse.mode + " " + pMouse.pathX + " " + pMouse.pathY);
                        Path cMouse = new Path(1.0f,PApplet.parseFloat(mouseX)/10.0f, PApplet.parseFloat(-1*mouseY)/10.0f, 0.0f,0.0f,0.0f);
                        output.println(cMouse.mode + " " + cMouse.pathX + " " + cMouse.pathY);

                        Path lastPoint = paths.get(paths.size()-1);
                        PVector pVector = new PVector(lastPoint.pathX, lastPoint.pathY);
                        PVector cVector = new PVector(cMouse.pathX, cMouse.pathY);
                        PVector resolution = PVector.sub(cVector, pVector);
                        if(resolution.mag() > 0.3f)
                        {
                            //paths.add(pMouse);
                            paths.add(cMouse);
                            println(mouseCount);
                            mouseCount++;
                            println("P : " + pMouse.pathX + " " + pMouse.pathY);
                            println("C : " + pMouse.pathX + " " + pMouse.pathY);
                        }
                        
                    }
                }
            } 
        } else {
            mouseCount = 0;
        }
    } else {
        displayTip(false);
    }
}

public void mousePressed() {
    if(mouseButton == LEFT) {
        if(mouseX < 2*width/3) {
            if(!stateDraw) {
                
            } else {
                target.set(mouseX,mouseY,0);
            }
        }
    } else {
        tipIndex();
        println("index y x " + yIndex + " " + xIndex);
        println(arryRow + " " + arryColumn);
        
        target.set(mousexIndex * arryColumn, mouseyIndex * arryRow);
        Arduino.sendGcode("G90\n");
        Arduino.sendGcode("G1 Z0 " + "F1500\n");
        delay(20);
        Arduino.sendGcode("X" + target.x/10 + " Y" + -1*target.y/10 + " F2000\n");
        tip.set(target.x, target.y);
        println(target.x + " " + target.y);

    } 
 }
 


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
public void row(int theColor) {
    row = theColor;
    makeArraylist();
    println(calMap.size());
}

public void column(int theColor) {
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

public void makeArraylist() {
    calMap.clear();
    for(int i = 0; i <= row; i++) {
        for(int j = 0; j <= column ; j++) {
            calMap.add(new CalibrationMap(row, column, i, j));
        }
    }
}

public void fileSelected(File selection) {
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
class CalibrationMap { 
    int indexR, indexC, maxRow, maxCol;
    float zValue = 0;
    int winW = 740;
    int winH = 390; 

    CalibrationMap (int maxR, int maxC,  int idxR, int idxC) {
        indexR = idxR;
        indexC = idxC;
        maxCol = maxC;
        maxRow = maxR;
    } 
    
    public void calib(float zValue_) {
        zValue += zValue_;
    }

    int c = color(255 - 10*zValue);

}


int c;

public void GUIsetup() {
    pad = new ControlP5(this);
    pad.addButton("UP")
       .setValue(0)
       .setPosition(2*width/3 + 50,10)
       .setSize(50,50)
       ;
    pad.addButton("DOWN")
       .setValue(0)
       .setPosition(2*width/3 + 50,60)
       .setSize(50,50)
       ;
    pad.addButton("LEFT")
       .setValue(0)
       .setPosition(2*width/3 + 100,60)
       .setSize(50,50)
       ;
    pad.addButton("RIGHT")
       .setValue(0)
       .setPosition(2*width/3 + 150,60)
       .setSize(50,50)
       ;
    
    pad.addButton("ZUP")
       .setValue(0)
       .setPosition(2*width/3 + 100 ,10)
       .setSize(50,50)
       ;
    pad.addButton("ZDW")
       .setValue(0)
       .setPosition(2*width/3 + 150, 10)
       .setSize(50,50)
       ;

   pad.addSlider("pwm")
      .setPosition(2*width/3 + 230, 10)
      .setSize(25,200)
      .setRange(0,1000)
      ;
   pad.getController("pwm").getValueLabel().align(ControlP5.LEFT, 200).setPaddingX(5);

   pad.addSlider("sucking")
      .setPosition(2*width/3 + 270, 10)
      .setSize(25,200)
      .setRange(0,200)
      ;
   pad.getController("sucking").getValueLabel().align(ControlP5.LEFT, 200).setPaddingX(5); 

   pad.addSlider("injecting")
      .setPosition(2*width/3 + 310, 10)
      .setSize(25,200)
      .setRange(0,50)
      ;
   pad.getController("injecting").getValueLabel().align(ControlP5.LEFT, 200).setPaddingX(5);
   pad.addButton("INIT")
       .setValue(0)
       .setPosition(2*width/3 + 50,130)
       .setSize(70,30)
       ;
   pad.addButton("HOME")
       .setValue(0)
       .setPosition(2*width/3 + 50,170)
       .setSize(70,30)
       ;
    pad.addButton("CALIBRARION")
       .setValue(0)
       .setPosition(2*width/3 + 50,250)
       .setSize(70,30)
       ;
   pad.addButton("DRAW")
       .setValue(0)
       .setPosition(2*width/3 + 50,210)
       .setSize(70,30)
       ;
   pad.addButton("PUMPOFF")
      .setValue(0)
      .setPosition(2*width/3 + 130, 130)
      .setSize(70,30)
      ;
   pad.addButton("PUMPON")
      .setValue(0)
      .setPosition(2*width/3 + 130, 170)
      .setSize(70,30)
      ;
   pad.addButton("PUMPSUCKTION")
      .setValue(0)
      .setPosition(2*width/3 + 130, 210)
      .setSize(70, 30)
      ;
   pad.addButton("START")
      .setValue(0)
      .setPosition(2*width/3 + 130, 290)
      .setSize(70,30)
      ;
   pad.addButton("LOAD")
      .setValue(0)
      .setPosition(2*width/3 + 130, 250)
      .setSize(70,30)
      ;
   // pad.addButton("VIEW")
   //    .setValue(0)
   //    .setPosition(2*width/3 + 130, 290)
   //    .setSize(70,30)
   //    ;
   pad.addSlider("row")
      .setPosition(2*width/3 + 50, 330)
      .setSize(150,15)
      .setRange(1,10)
      .setNumberOfTickMarks(10)
      ;
   
   pad.getController("row").getCaptionLabel().align(ControlP5.RIGHT, 265);
   
   pad.addSlider("column")
      .setPosition(2*width/3 + 50, 355)
      .setSize(150,15)
      .setRange(1,10)
      .setNumberOfTickMarks(10)
      ;
   pad.getController("column").getCaptionLabel().align(ControlP5.RIGHT, 290);
}

public void displayTipposition(int x, int y, int col_, int r) {
   int[] col = new int[col_];
   int[] rw = new int[r];

   for (int i = 0 ; i < col_ ; i++) {
      col[i] = x + i*30;
   }

   for (int i = 0 ; i < r ; i++) {
      rw[i] = 130 +y + i*20;
   }

   fill(174,214,241);
   rect(2*width/3,0,width,height);
   fill(0);
   tipIndex();
   float z = zValue(calxIndex, calyIndex);
   textAlign(LEFT,TOP);
   textSize(20);
   text("X",col[0], rw[0]);
   text(tip.x/10,col[1]+10, rw[0]);
   text("Y",col[0], rw[1]+10);
   text(tip.y/10,col[1]+10, rw[1]+10);
   text("Z",col[0], rw[2]+20);
   text(z,col[1]+10, rw[2]+20);
   //text(pumpOffduration, 20, 30);
   //text(pumpOff, 50, 30);

   // text("tgX",col[0], rw[3]);
   // text(target.x/10,col[1], rw[3]);
   // text("tgY",col[0], rw[4]);
   // text(target.y/10,col[1], rw[4]);
   // text("tgZ",col[0], rw[5]);
   // text(target.z/10,col[1], rw[5]);

   // text("diX",col[0], rw[6]);
   // text(diff.x/10,col[1], rw[6]);
   // text("diY",col[0], rw[7]);
   // text(diff.y/10,col[1], rw[7]);
   // text("diZ",col[0], rw[8]);
   // text(diff.z/10,col[1], rw[8]);   
}

public void displayTip(boolean viewStatus) {
   if(viewStatus) {
      c = color(40,40,40);
   } else {
      c = color(120,120,120);
   }
   if(stateMap){
      background(255);
      displayMap();
   } else {
      background(255);
   }
   gcodeviewer(); 
   displayTipposition(21*width/24, 130, 2, 9);
   if(stateDraw) {
      for(XYtable XYt : XY) {
         fill(c);
         ellipse(XYt.x, XYt.y, 10,10);
      }
      noStroke();
      fill(174,214,241);
      ellipse(tip.x,tip.y, 10,10); 
   }  else {
      XYtable XYmouse = new XYtable(tip.x,tip.y);
      noStroke();
      XY.add(XYmouse);
      for(XYtable XYt : XY){
         fill(c);
         ellipse(XYt.x,XYt.y,10,10);
      }
      fill(0);
      ellipse(tip.x, tip.y, 10,10);
   }
   if(stateMap){
      displayMapnum();
   } 
}
public void displayMapnum() {
   textSize(10);
   fill(0,0,0);
   for (int j = 0 ; j <= row ; j++ ) {
      for(int i = 0 ; i <= column ; i++) {
         CalibrationMap ztext = calMap.get(i + (column+1)*j);
         if(i == column && j != row) {
            textAlign(RIGHT,TOP);
            text(ztext.zValue,i*arryColumn,j*arryRow);
         } else if ( i != column && j == row) {
            textAlign(LEFT,BOTTOM);
            text(ztext.zValue,i*arryColumn,j*arryRow);
         } else if ( i == column && j == row) {
            textAlign(RIGHT,BOTTOM);
            text(ztext.zValue,i*arryColumn,j*arryRow);
         } else {
            textAlign(LEFT,TOP);
            text(ztext.zValue,i*arryColumn,j*arryRow);
         }
        
      }  
   }
}

public void displayMap() {
   arryRow = (winHei) / row;
   arryColumn = (winWid) / column;
   loadPixels();
   for(int k = 0; k < winHei ; k++) {
      for(int l = 0 ; l < winWid ; l++) {
         
         pixels[l+width*k] = color(255-PApplet.parseInt(10*backgroundzValue(l,k)));
      }
   }
   updatePixels();
}
public void keyPressed() {
    tipIndex();
    CalibrationMap cal = calMap.get(xIndex + yIndex*(column+1));    
    if(keyCode == 38) {    
        cal.calib(0.5f);
        Arduino.sendGcode("G91\n");
        Arduino.sendGcode("G1 Z-0.5 F300\n");
        println("Z-1");
        //targetSet(0, 0, -10);
        //tipSet(0, 0, -10);
        //posSet(0, 0, -10);
    } else if(keyCode == 40 ) {
        cal.calib(-0.5f);
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
class conectArduino
{
    private Serial arduinoPort;
    
    conectArduino (PApplet app, int portNumber) {
        arduinoPort = new Serial(app, Serial.list()[portNumber], 115200);
    }

    public void currentState() {
        arduinoPort.write("?");
        while(arduinoPort.available() > 0 ) {
            String inBuffer = arduinoPort.readString();
            if(inBuffer != null) {
                println(inBuffer);
            }
        }
    }


    public void goOrigin() {
        arduinoPort.write("G0 Z0 F1500\n");
        delay(30);
        arduinoPort.write("G28\n");
    }

    public void sendGcode(String gCode) {
        output.println("Gcode : " + gCode);
        arduinoPort.write(gCode);
    }
}
public void gcodeScript() { 

    Float xp = null;
    Float yp = null;
    Float zp = null;
    Float ip = null;
    Float jp = null;
    g2 = false;
    g3 = false;
    
    q = splitTokens(script[order]," ");
    println("[" + order + "]"+"["+q.length+"]" + script[order]);

    if(q.length > 0) {
        for(int i=0; i < q.length ; i++) {
            switch(q[i].charAt(0)) {
                case 'M':
                    switch(q[i].charAt(1)) {
                        case '8':
                            Arduino.sendGcode("S500");
                            Arduino.sendGcode("M8\n");
                            println("pump on");
                            break;
                        case '9':
                            Arduino.sendGcode("M9\n");
                            println("pump off");
                            break;
                        case '3':
                            Arduino.sendGcode("M3\n");
                            println("sucking off");
                            break;
                        case '4':
                            Arduino.sendGcode("M4\n");
                            println("sucking On");
                            delay(1000);
                            Arduino.sendGcode("M3\n");
                            break;
                    }
                    break;     
                case 'G':
                    switch(q[i].substring(1)) {
                        case "3":
                            g3 = true;
                            println("G3");
                            break;
                        case "2":
                            g2 = true;
                            println("G2");
                            break;
                        default :
                            break;	
                    }
                    break;
                case 'X':
                    xp = PApplet.parseFloat(q[i].substring(1));
                    break;
                case 'Y':
                     yp = PApplet.parseFloat(q[i].substring(1));
                    break;
                case 'Z':
                     zp = PApplet.parseFloat(q[i].substring(1));
                    break;    
                case 'I':
                    ip = PApplet.parseFloat(q[i].substring(1));
                    break;
                case 'J':
                    jp = PApplet.parseFloat(q[i].substring(1));
                    break;   
            }
        }

        if (xp == null && yp == null && zp == null) {
            scriptLine = true;
        } else {
            if (zp == null) {

            } else if (zp > 0.0f){
                stateDraw = true; // move
            } else {
                stateDraw = false; // draw
            }
            
            if(xp != null && yp != null) {
                println("X"+xp + " " +"Y"+yp);
                target.set(xp*10,-1*yp*10, 0);
            } else if(xp != null && yp == null) {
                target.set(xp*10,tip.y,0);
            } else if(xp == null && yp != null) {
                target.set(tip.x,-1*yp*10,0);
            } else {
                scriptLine = true;
            }
            println("ip jp " + ip + " " + jp);
            if(ip != null && jp != null) {
                center.x = tip.x + ip*10;
                center.y = tip.y + jp*10;
            } else if(ip != null && jp == null) {
                center.x = tip.x + ip*10;
                center.y = tip.y;
            } else if(ip == null && jp != null) {
                center.x = tip.x;
                center.y = tip.y + jp*10;
            } else {
                
            }

            
        }        
    } else {
        scriptLine = true;
    }   

    if(order < script.length - 1) {
            order++;
    } else if(order == script.length - 1) {
        order = 0;
        scriptDraw = false;

    }
}
public void gcode() {
    Path current = paths.get(order);
    g2 = false;
    g3 = false;
    if(current.mode == 0){
        if(stateDraw == true) {

        } else {
            stateDraw = true; //move
            Arduino.sendGcode("M5\n");
            println("pump off");    
        }
        if(changeG0 > 0 && countG0 == 0) {
            println("Pump Sucking");
            Arduino.sendGcode("M8\n");
            //Arduino.sendGcode("G0 Z0 F1500\n");
            delay(pumpOffduration*10);
            Arduino.sendGcode("M9\n");
            countG0++;
        }

    } else {
        if(stateDraw == false) {

        } else {
            stateDraw = false; //draw
            Arduino.sendGcode("M9\n");
            println("sucking off");
            //Arduino.sendGcode("S" + pump + "\n");
            //Arduino.sendGcode("M4\n");
            //println("pump on");
            changeG0++;
            countG0 = 0;
            println("chageG0 : " + changeG0);
            println("countG0 : " + countG0);
        }
        
    }

    if(current.mode == 2) {
        g2 = true;
    } else if(current.mode == 3)  {
        g3 = true;
    }

    target.set(current.pathX*10, -1*10*current.pathY);
    if(current.mode == 2 || current.mode == 3) {
        if(current.pathI !=  null && current.pathJ != null) {
            center.x = tip.x + current.pathI*10;
            center.y = tip.y + -1*current.pathJ*10;    
        } else if(current.pathI !=  null && current.pathJ == null) {
            center.x = tip.x + current.pathI*10;
            center.y = tip.y;
        } else if(current.pathI ==  null && current.pathJ != null ) {
            center.x = tip.x;
            center.y = tip.y + -1*current.pathJ*10;    
        }
        r = PVector.sub(target, center);
    }
    if(order < paths.size()-1) {
            order++;
    } else if(order == paths.size() - 1) {
        order = 0;
        tip.set(0,0);
        target.set(0,0);
        scriptDraw = false;
        countG0 = 0;
        changeG0 = 0;

        Arduino.goOrigin();
        Arduino.sendGcode("M8\n");
        println("sucking On");
        delay(2000);
        Arduino.sendGcode("M9\n");
        

    }
}
public void gcodeloader() {
    println("gcodeloader");
    paths.clear();
    String[] qV;
    Float gNum = null;
    Float xNum = null;
    Float yNum = null;
    Float zNum = null;
    
    if(script.length > 0) {
        println("script test");
        for(int i = 0 ; i < script.length ; i++) {

            output.println(script[i]);
            Float iNum = null;
            Float jNum = null;

            if(script[i].equals("")) {
                println("eamty line");
                continue;
            } else if(script[i].charAt(0) != 'G' &&
                      script[i].charAt(0) != 'X' &&
                      script[i].charAt(0) != 'Y' &&
                      script[i].charAt(0) != 'Z') {
                          continue;
            }

            qV = splitTokens(script[i], " ");
            if(qV.length > 0) {
                for(int j = 0 ; j < qV.length ; j ++) {
                    print(qV[j] + " ");
                    switch(qV[j].charAt(0)) {
                        case 'G':
                            gNum = PApplet.parseFloat(qV[j].substring(1));
                            break;
                        case 'X':
                            xNum = PApplet.parseFloat(qV[j].substring(1));
                            break;
                        case 'Y':
                            yNum = PApplet.parseFloat(qV[j].substring(1));
                            break;
                        case 'Z':
                            //println("Z test");
                            zNum = PApplet.parseFloat(qV[j].substring(1));
                            break;
                        case 'I':
                            iNum = PApplet.parseFloat(qV[j].substring(1));
                            break;
                        case 'J':
                            jNum = PApplet.parseFloat(qV[j].substring(1));
                            break;

                    }
                }
            }
            //println("G " + gNum + "X " + xNum + "Y " + yNum + "Z " + zNum + "I " + iNum + "J " + jNum);
            if(gNum == 0 || gNum == 1 || gNum == 2 || gNum == 3) {
                Path currentPath = new Path(gNum, xNum, yNum, zNum, iNum, jNum);
                paths.add(currentPath);
            } 

            
            //println(script[i]);
            
        }   
    }
}   

public void gcodeviewer() {
    PVector tipV = new PVector(0,0,0);
    PVector tgV = new PVector(0,0,0);
    PVector ctV = new PVector(0,0,0);
    PVector rTip = new PVector(0,0,0);
    PVector rTg = new PVector(0,0,0);

    stroke(200); 
    noFill();
    strokeWeight(5);
    
    for(int i = 0 ; i < paths.size() ; i++) {
        Path current = paths.get(i);
        if(current.mode == 0) {
            tipV.x = current.pathX*10;
            tipV.y = -1*current.pathY*10;
        } else if(current.mode == 1) {
            tgV.x = current.pathX*10;
            tgV.y = -1*current.pathY*10;
            line(tipV.x, tipV.y, tgV.x, tgV.y);
            tipV.set(tgV);
        } else if(current.mode == 2 || current.mode == 3) {
            tgV.x = current.pathX*10;
            tgV.y = -1*current.pathY*10;
            if(current.pathI !=  null && current.pathJ != null) {
                ctV.x = tipV.x + current.pathI*10;
                ctV.y = tipV.y + -1*current.pathJ*10;    
            } else if(current.pathI !=  null && current.pathJ == null) {
                ctV.x = tipV.x + current.pathI*10;
                ctV.y = tipV.y;
            } else if(current.pathI ==  null && current.pathJ != null ) {
                ctV.x = tipV.x;
                ctV.y = tipV.y + -1*current.pathJ*10;    
            }
            rTip = PVector.sub(tipV, ctV);
            rTg = PVector.sub(tgV, ctV);
            if(current.mode == 2) {
                if(rTip.heading() < rTg.heading()) {
                    arc(ctV.x, ctV.y, 2*rTg.mag(), 2*rTg.mag(),rTip.heading(), rTg.heading(), OPEN);
                } else {
                    arc(ctV.x, ctV.y, 2*rTg.mag(), 2*rTg.mag(),rTip.heading(), radians(360)+rTg.heading(), OPEN);
                }
            } else {
                if(rTip.heading() > rTg.heading()) {
                    arc(ctV.x, ctV.y, 2*rTg.mag(), 2*rTg.mag(),rTg.heading(), rTip.heading(),OPEN);
                } else {
                    arc(ctV.x, ctV.y, 2*rTg.mag(), 2*rTg.mag(),rTg.heading(), radians(360)+rTip.heading(), OPEN);
                }
            }
            tipV.set(tgV);
            
        }
    }
    noStroke();
}
public void mouseViewer() {
    for (int i = 0; i < XY.size() -1 ; i++) {
        stroke(200);
        strokeWeight(5);
        Path from = paths.get(i);
        Path to = paths.get(i+1);
        //line(from.x, from.y, to.x, to.y);
    }
}
class Path {
    Float mode;
    Float pathX;
    Float pathY;
    Float pathZ;
    Float pathI;
    Float pathJ;

    Path(Float mode_, Float pathX_, Float pathY_, Float pathZ_, Float pathI_, Float pathJ_) {
        mode = mode_;
        pathY = pathY_;
        pathX = pathX_;
        pathZ = pathZ_;
        pathI = pathI_;
        pathJ = pathJ_;
    }

}

public void posInit() {
    tip = new PVector(0,0,0);
    target = new PVector(0,0,0);
    diff = new PVector(0,0,0);
    pos = new PVector(0,0,0);
    xIndex = 0;
    yIndex = 0;
    stateDraw = true;
}

public void drawingLine() {
    if(diff.mag() > 3) {
        if(!stateDraw) { //draw state
            if(countDraw % injectPeriod == 0) {
                Arduino.sendGcode("M9\n");
                Arduino.sendGcode("S" + pump + "\n");
                Arduino.sendGcode("M4\n");
                
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
            delay(180);
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

public void drawingCircle() {
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

public void targetSet(float dx, float dy, float dz) {
    float tx = target.x + dx;
    float ty = target.y + dy;
    float tz = target.z + dz;
    target.set(tx,ty,tz);
}

public void tipSet (float dx, float dy, float dz) {
    float x = tip.x + dx;
    float y = tip.y + dy;
    float z = tip.z + dz;
    tip.set(x,y,z);
}

public void posSet (float dx, float dy, float dz) {
    float x = pos.x + dx;
    float y = pos.y + dy;
    float z = pos.z + dz;
    pos.set(x,y,z); 
}

public void tipIndex() {
    
    xIndex = PApplet.parseInt(tip.x / (winWid / (column + 1)));
    yIndex = PApplet.parseInt(tip.y / (winHei / (row+1) ));
    calxIndex = PApplet.parseInt(tip.x / (winWid / column));
    calyIndex = PApplet.parseInt(tip.y / (winHei / row));
    mousexIndex = PApplet.parseInt(mouseX / (winWid / (column + 1)));
    mouseyIndex = PApplet.parseInt(mouseY / (winHei / (row+1)));
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

public void backgroundIndex(float x, float y) {
    backcalxIndex = PApplet.parseInt(x / (winWid / column));
    backcalyIndex = PApplet.parseInt(y / (winHei / row));
    if(backcalxIndex == column) {
        backcalxIndex = column - 1;
    }
    if(backcalyIndex == row) {
        backcalyIndex = row - 1;
    }
    
}
class XYtable {
    float x;
    float y;

    XYtable (float mouX, float mouY) {
        x = mouX;
        y = mouY;
    }
}
public float zValue(int x, int y) {
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

public float backgroundzValue(int x, int y) {
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
  public void settings() {  size(1110,390); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "BodyPrinter" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}

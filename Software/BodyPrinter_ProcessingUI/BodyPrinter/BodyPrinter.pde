import processing.serial.*;
import controlP5.*;

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

void setup() {
    size(1110,390); //74mm x 39mm + controlpad area
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

void draw() {
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
                        Path pMouse = new Path(0.0,float(pmouseX)/10.0, float(-1*pmouseY)/10.0, 0.0,0.0,0.0);
                        output.println(pMouse.mode + " " + pMouse.pathX + " " + pMouse.pathY);
                        Path cMouse = new Path(1.0,float(mouseX)/10.0, float(-1*mouseY)/10.0, 0.0,0.0,0.0);
                        output.println(cMouse.mode + " " + cMouse.pathX + " " + cMouse.pathY);
                        paths.add(pMouse);
                        paths.add(cMouse);
                        println(mouseCount);
                        mouseCount++;
                    
                        
                    } else {
                        Path pMouse = new Path(1.0,float(pmouseX)/10.0, float(-1*pmouseY)/10.0, 0.0,0.0,0.0);
                        output.println(pMouse.mode + " " + pMouse.pathX + " " + pMouse.pathY);
                        Path cMouse = new Path(1.0,float(mouseX)/10.0, float(-1*mouseY)/10.0, 0.0,0.0,0.0);
                        output.println(cMouse.mode + " " + cMouse.pathX + " " + cMouse.pathY);

                        Path lastPoint = paths.get(paths.size()-1);
                        PVector pVector = new PVector(lastPoint.pathX, lastPoint.pathY);
                        PVector cVector = new PVector(cMouse.pathX, cMouse.pathY);
                        PVector resolution = PVector.sub(cVector, pVector);
                        if(resolution.mag() > 0.3)
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

void mousePressed() {
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
 
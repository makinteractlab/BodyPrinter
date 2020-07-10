

color c;

void GUIsetup() {
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

void displayTipposition(int x, int y, int col_, int r) {
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

void displayTip(boolean viewStatus) {
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
void displayMapnum() {
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

void displayMap() {
   arryRow = (winHei) / row;
   arryColumn = (winWid) / column;
   loadPixels();
   for(int k = 0; k < winHei ; k++) {
      for(int l = 0 ; l < winWid ; l++) {
         
         pixels[l+width*k] = color(255-int(10*backgroundzValue(l,k)));
      }
   }
   updatePixels();
}
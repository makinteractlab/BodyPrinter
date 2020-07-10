void gcode() {
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
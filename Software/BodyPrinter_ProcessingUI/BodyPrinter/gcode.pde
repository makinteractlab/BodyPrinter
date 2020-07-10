void gcodeScript() { 

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
                            delay(100);
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
                    xp = float(q[i].substring(1));
                    break;
                case 'Y':
                     yp = float(q[i].substring(1));
                    break;
                case 'Z':
                     zp = float(q[i].substring(1));
                    break;    
                case 'I':
                    ip = float(q[i].substring(1));
                    break;
                case 'J':
                    jp = float(q[i].substring(1));
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

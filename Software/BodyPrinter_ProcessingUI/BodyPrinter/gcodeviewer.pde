void gcodeloader() {
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
                            gNum = float(qV[j].substring(1));
                            break;
                        case 'X':
                            xNum = float(qV[j].substring(1));
                            break;
                        case 'Y':
                            yNum = float(qV[j].substring(1));
                            break;
                        case 'Z':
                            //println("Z test");
                            zNum = float(qV[j].substring(1));
                            break;
                        case 'I':
                            iNum = float(qV[j].substring(1));
                            break;
                        case 'J':
                            jNum = float(qV[j].substring(1));
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

void gcodeviewer() {
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
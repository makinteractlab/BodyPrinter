class conectArduino
{
    private Serial arduinoPort;
    
    conectArduino (PApplet app, int portNumber) {
        arduinoPort = new Serial(app, Serial.list()[portNumber], 115200);
    }

    void currentState() {
        arduinoPort.write("?");
        while(arduinoPort.available() > 0 ) {
            String inBuffer = arduinoPort.readString();
            if(inBuffer != null) {
                println(inBuffer);
            }
        }
    }


    void goOrigin() {
        arduinoPort.write("G0 Z0 F1500\n");
        delay(30);
        arduinoPort.write("G28\n");
    }

    void sendGcode(String gCode) {
        output.println("Gcode : " + gCode);
        arduinoPort.write(gCode);
    }
}
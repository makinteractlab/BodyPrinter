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
    
    void calib(float zValue_) {
        zValue += zValue_;
    }

    color c = color(255 - 10*zValue);

}
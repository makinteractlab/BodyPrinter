void mouseViewer() {
    for (int i = 0; i < XY.size() -1 ; i++) {
        stroke(200);
        strokeWeight(5);
        Path from = paths.get(i);
        Path to = paths.get(i+1);
        //line(from.x, from.y, to.x, to.y);
    }
}
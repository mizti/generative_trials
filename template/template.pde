import videoExport.*;
VideoExport videoExport;
int seed = int(random( -2147483648, 2147483647));
boolean video_on = false;

void setup() {
    setup_seed();
    
    size(1920,1080);
    background(255);
    frameRate(120);
    smooth();
    noFill();
    
    reset_values();
    
    if (video_on) {
        videoExport = new VideoExport(this, "output/out.mp4");
        videoExport.startMovie();
    }
}

void setup_seed() {
    println("seed: " + seed);
    randomSeed(seed);
    noiseSeed(int(random(seed)));
}

// initialize values here 
void reset_values(){

}

// update values in each frame
void update_values(){

}

void draw() {
    update_values();

    // write here main    

    
    if (video_on) {
        videoExport.saveFrame();
    }
}

void keyPressed() {
    if (keyCode == ENTER) {
        saveFrame("output/out-####.png");
    } else if (key ==  'r') { //reset
        if (video_on) {
            videoExport.dispose();;        
        }
        video_on = false;
        seed = int(random( -2147483648, 2147483647));
        setup();
    } else if (key ==  'e') { //reset with the same seed
        if (video_on) {
            videoExport.dispose();;        
        }
        video_on = false;
        setup();
    } else if (key ==  'w') { //write out
        if (video_on) {
            videoExport.dispose();;        
        }
        video_on = true;
        setup();
    } else if (key ==  's') { //slow
        
    } else if (key ==  'f') { //fast
        
    } else if (key ==  'p') { //pause
        noLoop();
    } else if (key ==  'c') { //continue
        loop();
    } else if (key ==  't') { //text dump
        fill(color(0,0,0));
        text("debug text here", 10, 10);
    }
}
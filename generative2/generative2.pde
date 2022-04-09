import videoExport.*;
VideoExport videoExport;
int seed = int(random( -2147483648, 2147483647));
boolean video_on = false;
PImage img;
int smallPoint, largePoint;
float point_size;
float dotnum = 0;


void setup() {
    setup_seed();
    
    //size(1920,1080);
    //size(1080,1920);
    size(1280,1600);
    //size(800, 600);
    background(0);
    frameRate(120);
    smooth();
    noFill();
    //img = loadImage("input-image.jpg");
    img = loadImage("input-image2.jpg");
    img = loadImage("input-image3.jpg");
    smallPoint = 12;
    largePoint = 200;
    imageMode(CENTER);
    noStroke();
    
    reset_values();
    
    if (video_on) {
        videoExport = new VideoExport(this, "output/out"+month()+day()+hour()+minute()+second()+".mp4");
        videoExport.startMovie();
    }
}

void setup_seed() {
    println("seed: " + seed);
    randomSeed(seed);
    noiseSeed(int(random(seed)));
}

// initialize values here 
void reset_values() {
    point_size = largePoint;
}

// update values in each frame
void update_values() {
    point_size -= 0.12;
    point_size = max(point_size, smallPoint);
}

void draw() {
    update_values();
    
    // write here main    
    //float point_size = map(mouseX, 0, width, smallPoint, largePoint);
    dotnum = float(frameCount) / 20;
    if (frameCount > 600) {
        dotnum = min(4, dotnum);
        
    } else{
        dotnum = min(3, dotnum);
    }
    if (dotnum < 1) {
        if (100.0 / random(0,100) < dotnum) {
            dotnum = 1;
        } else {
            dotnum = 0;
        }
    }
    for (int i = 0; i < dotnum; ++i) {
        int x = int(random(width));
        int y = int(random(height));
        color pix = img.get(x, y);
        fill(pix, 30);
        float final_point_size = point_size + random(-10, 10);
        circle(x, y, final_point_size);        
    }
    
    //println(frameCount);
    
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
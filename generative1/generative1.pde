//import com.hamoid.*;
//VideoExport videoExport;

import videoExport.*;
VideoExport videoExport;


int seed = int(random( -2147483648, 2147483647));
boolean video_on = false;
float _angleNoise, _radiusNoise;
float _xNoise, _yNoise;
float _angle, _radius;
float _strokeCol;
int _strokeChange;

void setup() {
    setup_seed();
    
    size(1920,1080);
    background(255);
    frameRate(120);
    smooth();
    noFill();
    
    // color
    //_strokeCol = 254;
    _strokeCol = color(200, 2, 46);
    _strokeChange = -1;
    
    // position and angle
    _angle = random(254);
    _radius = random(0.1);
    _angleNoise = random(10);
    _radiusNoise = random(10);
    _xNoise = random(10);
    _yNoise = random(10);
    
    if (video_on) {
        videoExport = new VideoExport(this, "output/hello.mp4");
        videoExport.startMovie();
    }
}

void setup_seed() {
    println("seed: " + seed);
    randomSeed(seed);
    noiseSeed(int(random(seed)));
}

void draw() {
    _radiusNoise += 0.005;
    _radius = (noise(_radiusNoise) * 1000) + 100;
    
    _angleNoise += 0.005;
    _angle += (noise(_angleNoise) * 2) - 1;
    if (_angle > 360) {_angle -= 360;}
    if (_angle < 0) {_angle += 360;}
    
    _xNoise += 0.01;
    _yNoise += 0.01;
    float centerX = width / 2 + (noise(_xNoise) * 100) - 50;
    float centerY = height / 2 + (noise(_yNoise) * 100) - 50;
    
    float rad = radians(_angle);
    float x1 = centerX + (_radius * cos(rad) * 2);
    float y1 = centerY + (_radius * sin(rad));
    
    float opprad = rad + PI;
    float x2 = centerX + (_radius * cos(opprad) * 2);
    float y2 = centerY + (_radius * sin(opprad));  
    
    _strokeCol += _strokeChange;
    if (_strokeCol > 254) {_strokeChange = -1;}
    if (_strokeCol < 1) {_strokeChange = 1;}
    stroke(_strokeCol, 10);
    strokeWeight(2);
    line(x1, y1, x2, y2);
    
    if (video_on) {
        videoExport.saveFrame();
    }
    
}

void keyPressed() {
    if (keyCode == ENTER) {
        saveFrame("output/generative1-####.png");
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
        text("hogehoge", width / 2, height / 2);
    }
}
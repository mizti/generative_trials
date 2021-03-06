import videoExport.*;
import toxi.color.*;
import toxi.color.theory.*;

VideoExport videoExport;
int seed = int(random( -2147483648, 2147483647));
boolean video_on = false;
ColorList palette = new ColorList();

color c;

void setup() {
    setup_seed();
    
    size(800, 600);
    background(255);
    frameRate(120);
    smooth();

    loop();
    
    reset_values();
    
    if (video_on) {
        videoExport = new VideoExport(this, "output/out" + month() + day() + hour() + minute() + second() + ".mp4");
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
    colorMode(RGB, 1, 1, 1);

    // Case1. get colors by theme
    //palette = getColorTheme(100,"soft","teal,lilac");

    // Case2. get colors from strategy with picking from theme
    ColorList palette1 = getColorTheme(100,"soft","teal,lilac");
    palette = getColorFromTheory("TetradTheoryStrategy", palette1.get(int(random(0,99))));

    // Case3. get colors from stragety with specific folor
    //TColor col = TColor.newRGBA(2.0/255, 97.0/255, 255.0/255, 1.0);
    //palette = getColorFromTheory("TetradTheoryStrategy", col);
}

// update values in each frame
void update_values() {
    
}

void draw() {
    update_values();
    // write here main    

    translate(x_base, y_base);
    rotate(radians((noise(frameCount*0.05)-0.5)*100));
    println(noise(frameCount)*100);


    noStroke();
    for (int i = 0; i < palette.size(); ++i) {
        /*
        TColor.newRGBA receives value from 0~1.
        But, color takes value 0-255 by default. So you have to adjust color Mode with (RGB, 1, 1, 1) or (HSB, 1, 1, 1).
        */
        
        TColor tc = palette.get(i % palette.size());//.toARGB();

        fill(tc.red(), tc.green(), tc.blue());
        //fill(c);
        circle(random(0,width), random(0,height), 30);
    }
    
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

ColorList getColorTheme(int numOfColors, String colorWeight, String colorName) {
    
    String[] weights = split(colorWeight, ',');
    String[] colors = split(colorName, ',');
    
    ColorTheme theme = new ColorTheme("theme");
    
    for (int i = 0; i < colors.length; i++) {
        String weight = weights[i % weights.length];
        String cName = colors[i];
        theme.addRange(weight + " " + cName,0.5);
    }
    ColorList l = theme.getColors(numOfColors);
    //l.sort();
    return l; 
}

ColorList getColorFromTheory(String colorTheory, TColor sourceColor) {
    ColorTheoryStrategy s = new AnalogousStrategy();;
    if (colorTheory == "AnalogousStrategy") {
        s = new AnalogousStrategy();
    }
    else if (colorTheory == "ComplementaryStrategy") {
        s = new ComplementaryStrategy();
    }
    else if (colorTheory == "CompoundTheoryStrategy") {
        s = new CompoundTheoryStrategy();
    }
    else if (colorTheory == "LeftSplitComplementaryStrategy") {
        s = new LeftSplitComplementaryStrategy();
    }
    else if (colorTheory == "MonochromeTheoryStrategy") {
        s = new MonochromeTheoryStrategy();
    }
    else if (colorTheory == "RightSplitComplementaryStrategy") {
        s = new RightSplitComplementaryStrategy();
    }
    else if (colorTheory == "SingleComplementStrategy") {
        s = new SingleComplementStrategy();
    }
    else if (colorTheory == "SplitComplementaryStrategy") {
        s = new SplitComplementaryStrategy();
    }
    else if (colorTheory == "TetradTheoryStrategy") {
        s = new TetradTheoryStrategy();
    }
    else if (colorTheory == "TriadTheoryStrategy") {
        s = new TriadTheoryStrategy();
    } else {
        println("name error");
    }
    
    ColorList colors = ColorList.createUsingStrategy(s, sourceColor);
    //ColorList moreColors = new ColorRange(colors).getColors(null, 50, 0.05);
    return colors;
}

PVector localToScreen(float x, float y) {
  PVector in = new PVector(x, y);
  PVector out = new PVector();
  PMatrix2D current_matrix = new PMatrix2D();
  getMatrix(current_matrix);  
  current_matrix.mult(in, out);
  return out;
}

PVector screenToLocal(float x, float y) {
  PVector in = new PVector(x, y);
  PVector out = new PVector();
  PMatrix2D current_matrix = new PMatrix2D();
  getMatrix(current_matrix);  
  current_matrix.invert();
  current_matrix.mult(in, out);
  return out;
}
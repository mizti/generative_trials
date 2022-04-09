import videoExport.*;
import toxi.color.*;
import toxi.color.theory.*;

VideoExport videoExport;
int seed = int(random( -2147483648, 2147483647));
boolean video_on = false;
ColorList palette = new ColorList();

float x1_base, x2_base, x3_base, y1_base, y2_base, y3_base;
float[] x_base, y_base;
int w, h;
TColor tc;
PVector v;

void setup() {
    setup_seed();
    
    size(800, 600);
    colorMode(RGB, 255, 255, 255);
    //background(255);
    frameRate(120);
    smooth();
    
    colorMode(RGB, 1, 1, 1);
    loop();
    x_base = new float[3];
    y_base = new float[3];
    
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
    // Case1. get colors by theme
    //palette = getColorTheme(100,"soft","teal,lilac");
    
    TColor t = getColor("weak", "LIGHTSKYBLUE");
    background(t.red(), t.green(), t.blue());
    
    // Case2. get colors from strategy with picking from theme
    ColorList palette1 = getColorTheme(100,"fresh","tomato,gold ");
    palette = getColorFromTheory("LeftSplitComplementaryStrategy", palette1.get(int(random(0,99))));
    
    // Case3. get colors from stragety with specific folor
    //TColor col = TColor.newRGBA(2.0/255, 97.0/255, 255.0/255, 1.0);
    //palette = getColorFromTheory("TetradTheoryStrategy", col);
    x1_base = width * (0.5 / 4);
    x2_base = width * (2.0 / 4);
    x3_base = width * (3.5 / 4);
    
    y1_base = -50;
    y2_base = -50;
    y3_base = -50;
    
    x_base[0] = width * (0.5 / 4);
    x_base[1] = width * (2.0 / 4);
    x_base[2] = width * (3.5 / 4);
    y_base[0] = -50;
    y_base[1] = -50;
    y_base[2] = -50;
    
    w = 50;
    h = 50;
}

// update values in each frame
void update_values() {
    
}

void draw() {
    update_values();
    // write here main
    for (int i = 0; i < 3; ++i) {
        println(i);
        //原点を画面中心に移動
        pushMatrix();
        translate(x_base[i], y_base[i]);
        rotate(radians((noise(random(0,1) * 0.2) - 0.5) * 100));
        
        noStroke();
        tc =palette.get(int(random(0, palette.size() - 1)));
        fill(tc.red(), tc.green(), tc.blue());
        ellipse(0, 0 , w + noise(random(0,1) * 0.3) * 200, h);
        
        v = localToScreen(0,2);
        x_base[i] = v.x;
        y_base[i] = v.y;
        popMatrix();
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

TColor getColor(String colorWeight, String colorName) {
    
    ColorTheme theme = new ColorTheme("theme");    
    theme.addRange(colorWeight + " " + colorName,0.5);
    
    return theme.getColor();
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
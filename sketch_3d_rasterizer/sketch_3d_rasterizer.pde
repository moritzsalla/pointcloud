import controlP5.*; 

ControlP5 cp5; 
PImage img;

float POS_X;
float POS_Y;
float POS_Z;
float TILES;
float THRESH_MIN;
float THRESH_MAX;
float SPEED;
float COLOR_A = 0;
float COLOR_B = 255;
boolean ANIMATION = false;
boolean DISPLAY_PIXEL_COLOR = true;
boolean BG_INVERT = false;

void setup () {
  size(900, 900, P3D);
  frameRate(60);
  noSmooth();
  pixelDensity(2);

  img = loadImage("example3.jpg");
  img.resize(900, 0);

  cp5 = new ControlP5(this);

  cp5.addSlider("TILES").setRange(100, 600).setNumberOfTickMarks(10).setValue(200);
  cp5.addSlider("THRESH_MIN").setRange(1, 0).setValue(1);
  cp5.addSlider("THRESH_MAX").setRange(0, 1).setValue(0);
  cp5.addSlider("SPEED").setRange(-1, 1).setValue(0.1);
  cp5.addSlider("POS_X").setRange(-1000, 1000).setValue(0);
  cp5.addSlider("POS_Y").setRange(-1000, 1000).setValue(0);
  cp5.addSlider("POS_Z").setRange(-1000, 1000).setValue(-500);

  cp5.getController("TILES").getCaptionLabel().align(ControlP5.TOP, ControlP5.TOP_OUTSIDE).setPaddingX(0);
  cp5.getController("THRESH_MIN").getCaptionLabel().align(ControlP5.TOP, ControlP5.TOP_OUTSIDE).setPaddingX(0);
  cp5.getController("THRESH_MAX").getCaptionLabel().align(ControlP5.TOP, ControlP5.TOP_OUTSIDE).setPaddingX(0);
  cp5.getController("SPEED").getCaptionLabel().align(ControlP5.TOP, ControlP5.TOP_OUTSIDE).setPaddingX(0);
  cp5.getController("POS_X").getCaptionLabel().align(ControlP5.TOP, ControlP5.TOP_OUTSIDE).setPaddingX(0);
  cp5.getController("POS_Y").getCaptionLabel().align(ControlP5.TOP, ControlP5.TOP_OUTSIDE).setPaddingX(0);
  cp5.getController("POS_Z").getCaptionLabel().align(ControlP5.TOP, ControlP5.TOP_OUTSIDE).setPaddingX(0);
}

void draw() {
  if (!BG_INVERT) {
    background(COLOR_A);
    fill(COLOR_B);
    stroke(COLOR_B);
  } else {
    background(COLOR_B);
    fill(COLOR_A);
    stroke(COLOR_A);
  }


  // tweak animation here
  if (ANIMATION) TILES = cos(frameCount * 0.001) * TILES + 2;

  float tileSize = height/TILES;

  push();
  translate(width/2 + POS_X, height/2 + POS_Y, POS_Z);
  rotateX(180);
  rotateZ(radians(frameCount * SPEED)); // for upright images, only rotate Y axis

  for (int x = 0; x <= TILES; x++) {
    for (int y = 0; y <= TILES; y++) {
      color c = img.get(int(x * tileSize), int(y * tileSize));
      float b = map(brightness(c), 0, 255, 0, 1);
      float z = map(b, 0, 1, -100, 100);
      push();
      translate(x * tileSize - width/2, y * tileSize - height/2, z);
      if (DISPLAY_PIXEL_COLOR) stroke(c);
      if (b < THRESH_MIN && b > THRESH_MAX) point(0, 0);
      pop();
    }
  }
  pop();
  // saveFrame("portrait1/######.png");
}

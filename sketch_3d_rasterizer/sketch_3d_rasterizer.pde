import controlP5.*;

ControlP5 cp5;
PImage img;

static float POSITION_X;
static float POSITION_Y;
static float POSITION_Z;
static float NUMBER_TILES;
static float BRIGHTNESS_THRESHOLD_MIN;
static float BRIGHTNESS_THRESHOLD_MAX;
static float ROTATION_SPEED;
static float COLOR_A = 255;
static float COLOR_B = 0;

final static boolean GREYSCALE = true;
final static boolean INVERT_BACKGROUND = false;
final static boolean SAVE_OUTPUT = true;

String OUTPUT_DIRECTORY = "output/######.png";

void setup () {
  size(900, 900, P3D);
  frameRate(60);
  noSmooth();
  pixelDensity(2);

  img = loadImage("example1.jpg");
  img.resize(900, 0);

  displayControls();
}

void draw() {
  if (INVERT_BACKGROUND) {
    background(COLOR_B);
    fill(COLOR_A);
    stroke(COLOR_A);
  } else {
    background(COLOR_A);
    fill(COLOR_B);
    stroke(COLOR_B);
  }

  push();

  centerCanvas();
  rotateCanvas();

  float tileSize = height / NUMBER_TILES;

  for (int x = 0; x <= NUMBER_TILES; x++) {
    for (int y = 0; y <= NUMBER_TILES; y++) {
      color c = img.get(int(x * tileSize), int(y * tileSize));
      float b = map(brightness(c), 0, 255, 0, 1);
      float z = map(b, 0, 1, -100, 100);

      push();

      translate(x * tileSize - width/2, y * tileSize - height/2, z);

      if (!GREYSCALE) stroke(c); // Colorize points
      if (b < BRIGHTNESS_THRESHOLD_MIN && b > BRIGHTNESS_THRESHOLD_MAX) point(0, 0);

      pop();
    }
  }

  pop();

  drawControlsBackground();

  if (SAVE_OUTPUT) saveFrame(OUTPUT_DIRECTORY);
}


void displayControls () {
  cp5 = new ControlP5(this);

  cp5.addSlider("NUMBER_TILES").setRange(100, 600).setNumberOfTickMarks(10).setValue(200);
  cp5.addSlider("BRIGHTNESS_THRESHOLD_MIN").setRange(1, 0).setValue(1);
  cp5.addSlider("BRIGHTNESS_THRESHOLD_MAX").setRange(0, 1).setValue(0);
  cp5.addSlider("ROTATION_SPEED").setRange(-1, 1).setValue(0.1);
  cp5.addSlider("POSITION_X").setRange(-1000, 1000).setValue(0);
  cp5.addSlider("POSITION_Y").setRange(-1000, 1000).setValue(0);
  cp5.addSlider("POSITION_Z").setRange(-1000, 1000).setValue(-500);

  cp5.getController("NUMBER_TILES").getCaptionLabel().align(ControlP5.TOP, ControlP5.TOP_OUTSIDE).setPaddingX(0);
  cp5.getController("BRIGHTNESS_THRESHOLD_MIN").getCaptionLabel().align(ControlP5.TOP, ControlP5.TOP_OUTSIDE).setPaddingX(0);
  cp5.getController("BRIGHTNESS_THRESHOLD_MAX").getCaptionLabel().align(ControlP5.TOP, ControlP5.TOP_OUTSIDE).setPaddingX(0);
  cp5.getController("ROTATION_SPEED").getCaptionLabel().align(ControlP5.TOP, ControlP5.TOP_OUTSIDE).setPaddingX(0);
  cp5.getController("POSITION_X").getCaptionLabel().align(ControlP5.TOP, ControlP5.TOP_OUTSIDE).setPaddingX(0);
  cp5.getController("POSITION_Y").getCaptionLabel().align(ControlP5.TOP, ControlP5.TOP_OUTSIDE).setPaddingX(0);
  cp5.getController("POSITION_Z").getCaptionLabel().align(ControlP5.TOP, ControlP5.TOP_OUTSIDE).setPaddingX(0);
}

void drawControlsBackground () {
  push();
  fill(COLOR_B);
  rect(0, 0, width, 65);
  pop();
}

void centerCanvas () {
  float centeredX = width/2 + POSITION_X;
  float centeredY = height/2 + POSITION_Y;
  translate(centeredX, centeredY, POSITION_Z);
}

void rotateCanvas () {
  rotateX(180);
  rotateZ(radians(frameCount * ROTATION_SPEED));
}

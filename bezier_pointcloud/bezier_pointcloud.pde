import controlP5.*;

ControlP5 cp5;
PImage img;

// Constants
static float COLOR_A = 255;
static float COLOR_B = 0;
static float POSITION_X;
static float POSITION_Y;
static float POSITION_Z;
static float NUMBER_TILES;
static float BRIGHTNESS_THRESHOLD_MIN;
static float BRIGHTNESS_THRESHOLD_MAX;
static float ROTATION_SPEED;

// Configuration
final static int DEPTH_RANGE = 100;

final static boolean GREYSCALE = true;
final static boolean INVERT_BACKGROUND = false;
final static boolean SAVE_OUTPUT = false;

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
  setDrawingSettings();

  push();

  centerCanvas();
  rotateCanvas();

  float tileSize = height / NUMBER_TILES;

  for (int x = 0; x <= NUMBER_TILES; x++) {
    for (int y = 0; y <= NUMBER_TILES; y++) {
      drawTile(x, y, tileSize);
    }
  }

  pop();

  drawControlsBackground();

  if (SAVE_OUTPUT) saveFrame(OUTPUT_DIRECTORY);
}

private void setDrawingSettings() {
  if (INVERT_BACKGROUND) {
    background(COLOR_B);
    fill(COLOR_A);
    stroke(COLOR_A);
  } else {
    background(COLOR_A);
    fill(COLOR_B);
    stroke(COLOR_B);
  }
}

private void displayControls () {
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

private void drawTile(int x, int y, float tileSize) {
  // Get pixel brightness..
  color c = img.get(int(x * tileSize), int(y * tileSize));
  // Normalize it
  float b = map(brightness(c), 0, 255, 0, 1);
  // Map it to our depth range
  float z = map(b, 0, 1, -DEPTH_RANGE, DEPTH_RANGE);

  push();

  // Translate our point (that we are yet to draw)
  translate(x * tileSize - width / 2, y * tileSize - height / 2, z);

  // Colorize point if config is set
  if (!GREYSCALE) {
    stroke(c);
  }

  boolean withinBounds =b < BRIGHTNESS_THRESHOLD_MIN && b > BRIGHTNESS_THRESHOLD_MAX;
  if (withinBounds) {
    point(0, 0);
  }

  pop();
}

private void drawControlsBackground () {
  push();
  fill(COLOR_B);
  rect(0, 0, width, 65);
  pop();
}

private void centerCanvas () {
  float centeredX = width/2 + POSITION_X;
  float centeredY = height/2 + POSITION_Y;
  translate(centeredX, centeredY, POSITION_Z);
}

private void rotateCanvas () {
  rotateX(180);
  rotateZ(radians(frameCount * ROTATION_SPEED));
}

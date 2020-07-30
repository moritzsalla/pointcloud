PImage img;

int POS_X = 0;
int POS_Y = 0;
int POS_Z = -500;
float TILES = 600;
float THRESH_MIN = 0;
float THRESH_MAX = 0.5;
float SPEED = 0.1;
int COLOR_A = 0;
int COLOR_B = 255;
boolean ANIMATION = false;

void setup () {
  size(900, 900, P3D);
  frameRate(60);
  img = loadImage("img1.png");
  img.resize(900, 0);
  noSmooth();
  pixelDensity(2);
}
 
void draw() {
if (ANIMATION) TILES = cos(frameCount * 0.001) * TILES + 2;
 
  
  background(COLOR_A);
  fill(COLOR_B);
  stroke(COLOR_B);

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
 
      if (b < THRESH_MAX && b > THRESH_MIN) point(0, 0);
      pop();
    }
  }
  pop();
  
  // saveFrame("portrait1/######.png");
}

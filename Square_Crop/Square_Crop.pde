import java.io.File;
int side = 300;
PImage[] imgs;
int currentImage = 0;
PImage img;
PImage c;
int cropcount;


void setup() {
  pixelDensity(1);
  size(900, 900);
  rectMode(CENTER);
  noFill();
  stroke(255, 0, 0);
  strokeWeight(10);

  File folder = new File(dataPath(""));
  String[] filenames = folder.list();

  imgs = new PImage [filenames.length];
  for ( int i = 0; i < filenames.length; i++) {
    if (filenames[i].endsWith(".jpg") || filenames[i].endsWith(".png")) {
      imgs[i] = loadImage(filenames[i]);
    } else {
      println(filenames[i]+ " ERROR:Data folder contains non image");
      noLoop();
      break;
    }
  }
  File cropsfolder = new File(sketchPath("crops"));
  if (cropsfolder.exists()) {
    String[] cropsfilenames = cropsfolder.list();
    cropcount = cropsfilenames.length ;
  }

  //set initial image
  if (imgs.length > 0) {
    currentImage = 0;
    img = imgs[currentImage];
  }
}

void draw() {
  background(0, 0, 100);
  if (img.width > img.height) {
    img.resize(width, 0);
  } else
    img.resize(0, height);

  image(img, width/2 - img.width/2, height/2 - img.height/2);
  if (mouseX + mouseY > 0) {
    rect(mouseX, mouseY, side, side);
  }
}
void mousePressed() {
  if (mouseButton == RIGHT) {
    currentImage++;
    if (currentImage == imgs.length) {
      currentImage = 0;
    }
    img = imgs[currentImage];
  }
  if (mouseButton == LEFT ) {
    PImage c = img.get(mouseX - side/2, mouseY -side/2, side, side );
    cropcount ++;
    c.save("crops/"+ cropcount +".png");
  }
}

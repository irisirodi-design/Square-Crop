import java.io.File;

int side = 300;
PImage[] imgs;
int currentImage = 0;
PImage img;
int cropcount = 0;
int messageTimer = 0;
String messageText = "";
boolean space = false;
float imgX;
float imgY;


void setup() {
  pixelDensity(1);
  size(600, 600);
  rectMode(CENTER);
  noFill();
  stroke(255, 0, 0);
  strokeWeight(10);

  loadImages();      // Load images from data folder
  loadCropCount();   // Count existing crops

  if (imgs.length > 0) {
    currentImage = 0;
    img = imgs[currentImage];
    imgX = width/2 - img.width/2;
    imgY = height/2 - img.height/2;
  }
}

void draw() {
  background(0, 0, 100);

  drawCurrentImage(); //Drawing the crop rectangle
  drawCropRectangle();//Drawing the currently selected image
  drawNotification(); //Drawing the notification text
}

void mousePressed() {
  if (mouseButton == RIGHT) {
    nextImage();//Switching images
  } else if (mouseButton == LEFT) {
    cropImageAtMouse();//Cropping the current square
  }
}

void loadImages() {
  File folder = new File(dataPath(""));
  String[] filenames = folder.list();
  imgs = new PImage[filenames.length];

  for (int i = 0; i < filenames.length; i++) {
    if (filenames[i].endsWith(".jpg") || filenames[i].endsWith(".png")) {
      imgs[i] = loadImage(filenames[i]);
    } else {
      println(filenames[i] + " ERROR: Data folder contains non-image");
      noLoop();
      break;
    }
  }
}

void loadCropCount() {
  File cropsFolder = new File(sketchPath("crops"));

  if (cropsFolder.exists()) {
    String[] cropsFiles = cropsFolder.list();
    cropcount = cropsFiles.length;
  }
}

void drawCurrentImage() {
  if (img == null) return;
  image(img, imgX, imgY);
}

void drawCropRectangle() {
  rect(mouseX, mouseY, side, side);
}

void drawNotification() {
  if (messageTimer > 0) {
    pushStyle();
    textSize(50);
    textAlign(CENTER, CENTER);

    float x = width/2;
    float y = 70;
    float w = textWidth(messageText);

    noStroke();
    fill(0, 100);
    rect(x, y, w + 20, 70);

    fill(255);
    text(messageText, x, y);

    messageTimer--;
    popStyle();
  }
}

void nextImage() {
  currentImage++;

  if (currentImage >= imgs.length) {
    currentImage = 0;
  }
  img = imgs[currentImage];
  imgX = width/2 - img.width/2;
  imgY = height/2 - img.height/2;
}

void cropImageAtMouse() {
  if (img == null) return;
  if (space) return;

  int cropX = int(mouseX - imgX - side/2);
  int cropY = int(mouseY - imgY - side/2);

  PImage cropped = img.get(cropX, cropY, side, side);
  cropcount++;
  cropped.save("crops/" + cropcount + ".png");

  messageText = "image cropped";
  messageTimer = 60;
}

void keyPressed() {
  if (key == ' ') {
    space = true;
  }
}

void keyReleased() {
  if (key == ' ') {
    space = false;
  }
}

void mouseDragged() {
  if (!space) return;
  int movedX = mouseX - pmouseX;
  int movedY = mouseY - pmouseY;
  imgX = imgX + movedX;
  imgY = imgY + movedY;
}

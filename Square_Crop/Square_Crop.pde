import java.io.File;

int side = 300;
PImage[] imgs;
int currentImage = 0;
PImage img;
int cropcount = 0;
int messageTimer = 0;
String messageText = "";

void setup() {
  pixelDensity(1);
  size(900, 900);
  rectMode(CENTER);
  noFill();
  stroke(255, 0, 0);
  strokeWeight(10);

  loadImages();       // Load images from data folder
  loadCropCount();    // Count existing crops

  if (imgs.length > 0) {
    currentImage = 0;
    img = imgs[currentImage];
  }
}

void draw() {
  background(0, 0, 100);

  drawCurrentImage(); //Drawing the crop rectangle
  drawCropRectangle();//Drawing the currently selected image 
  drawNotification();//Drawing the notification text
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

  if (img.width > img.height) {
    img.resize(width, 0);
  } else {
    img.resize(0, height);
  }

  image(img, width/2 - img.width/2, height/2 - img.height/2);
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
}

void cropImageAtMouse() {
  if (img == null) return;

  PImage cropped = img.get(mouseX - side/2, mouseY - side/2, side, side);
  cropcount++;
  cropped.save("crops/" + cropcount + ".png");

  messageText = "image cropped";
  messageTimer = 60;
}

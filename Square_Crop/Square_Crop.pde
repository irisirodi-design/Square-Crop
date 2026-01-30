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
float zoom = 1.0; // to track how much the image is zoomed in/out


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
  drawInstructions(); // Drawing instructions
}

void mousePressed() {
  if (mouseButton == RIGHT) {
    nextImage();//Switching images
  } else if (mouseButton == CENTER) { // re-centering with the scroll wheel
    recenterImage(); // Reset view
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
  image(img, imgX, imgY, img.width * zoom, img.height * zoom);
  // draws the images scaled by the zoom
}

void drawCropRectangle() {
  rect(mouseX, mouseY, side, side);
}

void drawInstructions() {
  pushStyle();
  String message= "Left click to crop.\nRight click to next image.\nSpace + drag to move image.\nScroll to zoom.";
  textSize(20);
  noStroke();
  fill(0, 100);
  text(message, 31, height - 79);
  fill(255);
  text(message, 30, height - 80);
  popStyle();
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

void recenterImage() {
  if (img == null)
    return;
  zoom = 1.0; // reset to 100%
  imgX = width/2 - img.width/2;
  imgY = height/2 - img.height/2;
}

void nextImage() {
  currentImage++;

  if (currentImage >= imgs.length) {
    currentImage = 0;
  }
  img = imgs[currentImage];
  recenterImage(); // when switching to the next image, it automatically recenters and resets the zoom
}

void cropImageAtMouse() {
  if (img == null) return;
  if (space) return; // no accidental crops when dragging

  float imgMouseX = (mouseX - imgX) / zoom;
  float imgMouseY = (mouseY - imgY) / zoom;

  float cropSize = side / zoom;

  int cropX = int(imgMouseX - cropSize/2);
  int cropY = int(imgMouseY - cropSize/2);

  PImage cropped = img.get(cropX, cropY, int(cropSize), int(cropSize));
  if (cropped.width > 0 && cropped.height > 0) {
    cropped.resize(side, side);
    cropcount++;
    cropped.save("crops/" + cropcount + ".png");
    messageText = "image cropped";
  } else {
    messageText = "crop failed (out of bounds)";
  }

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

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  float zoomFactor = 1.05; // how much it zooms with each scroll

  float oldZoom = zoom; // to later calculate the position

  if (e < 0) { // scroll up
    zoom *= zoomFactor; // zoom in
  } else {
    zoom /= zoomFactor;
  }

  zoom = constrain(zoom, 0.05, 20.0); // limiter

  imgX = mouseX - (mouseX - imgX) * (zoom / oldZoom);
  imgY = mouseY - (mouseY - imgY) * (zoom / oldZoom);
}

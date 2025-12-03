import java.io.File;
int side = 512;
PImage[] imgs;
int currentImage = 0;
PImage img;
int cropcount;

boolean dragging = false;
float dragOffsetX, dragOffsetY;
float imgX, imgY;
float scaleFactor = 1.0;
PImage scaledImg;

String message = "Left Click: Crop Square | Right Click: Next Image | Space + Drag: Move Image | Mouse Wheel: Zoom";


void setup() {
  pixelDensity(1);
  size(1200, 800);
  rectMode(CENTER);
  noFill();
  stroke(255, 100, 0);
  strokeWeight(4);
  textSize(20);

  File folder = new File(dataPath(""));
  String[] filenames = folder.list();

  imgs = new PImage [filenames.length];
  for ( int i = 0; i < filenames.length; i++) {
    if (filenames[i].endsWith(".jpg") || filenames[i].endsWith(".jpeg") || filenames[i].endsWith(".png")) {
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
    cropcount = cropsfilenames.length;
  }

  //set initial image
  if (imgs.length > 0) {
    currentImage = 0;
    img = imgs[currentImage];
    scaledImg = img.copy();
    imgX = (width - img.width) / 2;
    imgY = (height - img.height) / 2;
  }
}

void draw() {
  background(0, 0, 100);
  image(scaledImg, imgX, imgY);
  if (mouseX + mouseY > 0) {
    rect(mouseX, mouseY, side, side);
  }
  fill(200, 255, 200);
  text(message, 10, 30);
  noFill();
}

void mousePressed() {
  if (mouseButton == RIGHT) {
    currentImage++;
    if (currentImage == imgs.length) {
      currentImage = 0;
    }
    img = imgs[currentImage];
    scaledImg = img.copy();
    imgX = (width - img.width) / 2;
    imgY = (height - img.height) / 2;
    scaleFactor = 1.0;
    message = "Left Click: Crop Square | Right Click: Next Image | Space + Drag: Move Image | Mouse Wheel: Zoom";
  }
  if (mouseButton == LEFT && !dragging) {
    if (scaledImg == null) return;
    // Compute top-left of the crop rectangle in scaledImg coordinates
    int sx = int(mouseX - imgX - side/2);
    int sy = int(mouseY - imgY - side/2);

    // Ensure the crop rectangle stays inside the scaled image
    if (scaledImg.width < side || scaledImg.height < side) {
      message = "Scaled image too small to crop";
      println(message);
      return;
    }
    sx = constrain(sx, 0, scaledImg.width - side);
    sy = constrain(sy, 0, scaledImg.height - side);

    PImage c = scaledImg.get(sx, sy, side, side);

    cropcount++;
    c.save("crops/"+ cropcount +".png");
    message = "Cropped and saved crop #" + cropcount;
    println(message);
  }
}

void keyPressed() {
  if (key == ' ') {
    if (mouseX > imgX && mouseX < imgX + scaledImg.width &&
        mouseY > imgY && mouseY < imgY + scaledImg.height) {
      dragging = true;
      dragOffsetX = mouseX - imgX;
      dragOffsetY = mouseY - imgY;
    }
  }
}

void keyReleased() {
  if (key == ' ') {
    dragging = false;
  }
}

void mouseDragged() {
  if (dragging) {
    imgX = mouseX - dragOffsetX;
    imgY = mouseY - dragOffsetY;
  }
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  scaleFactor -= e * 0.05;
  int newW = int(img.width * scaleFactor);
  int newH = int(img.height * scaleFactor);
  if (newW > 50 && newH > 50 && newW < width*4 && newH < height*4) {
    float relX = (mouseX - imgX) / scaledImg.width;
    float relY = (mouseY - imgY) / scaledImg.height;
    scaledImg = img.copy();
    scaledImg.resize(newW, newH);
    imgX = mouseX - relX * scaledImg.width;
    imgY = mouseY - relY * scaledImg.height;
  } else {
    scaleFactor += e * 0.05;
  }
}
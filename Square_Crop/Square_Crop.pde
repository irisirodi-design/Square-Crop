int side = 300;
PImage img;

void setup() {
  size(900, 900);
  img = loadImage("Ginger-Kitten.png");
  print(img.width);
  if(img.width > img.height){
    img.resize(width, 0);
  }
  else
    img.resize(0, height);
  rectMode(CENTER);
  noFill(); 
  stroke(255, 0, 0); 
  strokeWeight(10); 
}

void draw() {
  background(0, 0, 100);
  image(img, width/2 - img.width/2, height/2 - img.height/2); 
  if (mouseX + mouseY > 0){
    rect(mouseX, mouseY, side, side);
  } 
}

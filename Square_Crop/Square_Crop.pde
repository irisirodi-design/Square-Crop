
int side = 300;
PImage[] imgs;
int currentImage = 0;
PImage img;

String[] filenames = {
  "Ginger-Kitten.png",
  "freiren.jpg",
  "Puppy.jpg",
  "red-dragon.jpg"
};

void setup() {
  size(900, 900);
   rectMode(CENTER);
  noFill(); 
  stroke(255, 0, 0); 
  strokeWeight(10); 
  
  imgs = new PImage [filenames.length];
  for ( int i = 0; i < filenames.length; i++){
    imgs[i] = loadImage(filenames[i]);
    
  }
  
    
  //set initial image
   if (imgs.length > 0){
     currentImage = 0;
     img = imgs[currentImage];
   }
}

void draw() {
  background(0, 0, 100);
  if(img.width > img.height){
    img.resize(width, 0);
  }
  else
    img.resize(0, height);
    
  image(img, width/2 - img.width/2, height/2 - img.height/2); 
  if (mouseX + mouseY > 0){
    rect(mouseX, mouseY, side, side);
  } 
}
void mousePressed() {
  if(mouseButton == RIGHT) {
    currentImage++;
    if (currentImage == imgs.length){
     currentImage = 0;
    }
    img = imgs[currentImage];
  }
}

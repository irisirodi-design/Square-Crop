int side = 300; //setarea unei variabila

//ordinea pasilor - setarile principale

void setup() {
  size(900, 900); // dimensiunea suprafetei
  // fullScreen(); // intra automat in modul fullscreen
  print(width); // scrie datele in consola - util pentru programator // nu se vede
  rectMode(CENTER);
  noFill(); //patratul sa fie gol
  stroke(255, 0, 0); //culoare laturii
  strokeWeight(20); //grosimea laturii
}

//ordinea pasilor - ce se deseneaza si ordinea parametrilor definiti

void draw() {
  background(0, 0, 100); //fundal albastru inchis
  if (mouseX + mouseY > 0){ //both should be positive, so use arithmetics
    rect(mouseX, mouseY, side, side); //cursorul sa fie in centru
  } 
}

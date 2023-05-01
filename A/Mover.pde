class Mover {
 PVector location; 
 PVector velocity;
 PVector acceleration;
 float mass;
 ArrayList<PVector> path;
 boolean exploded = false;
 boolean getPath = true;

PImage img_satelite;
PImage img_exploded;

int previousTime = 0;

Mover(float m, float x , float y, PVector initialVel) {
  location = new PVector(x, y);
  velocity = initialVel;
  acceleration = new PVector(0,0);
  mass = m;
  path = new ArrayList<PVector>();
  img_satelite = loadImage("sate.png");
  img_exploded = loadImage("explo.png");
}

 void applyForce(PVector force) {
  PVector f = PVector.div(force,mass);
  acceleration.add(f);
 }

 void update() {
  /*velocity.add(acceleration);
  location.add(velocity);
  acceleration.mult(0);*/
  if(!exploded) { // Movimiento mientras no explote y Cada frame añadimos la localizacion actual a una lista
    velocity.add(acceleration);
    location.add(velocity);
    acceleration.mult(0);
    if (getPath){
      int currentTime = millis(); // Get the current time in milliseconds
      int elapsedTime = currentTime - previousTime; // Calculate the elapsed time since the last draw call
      if (elapsedTime >= 300) { // Check if the elapsed time is greater than or equal to X milliseconds
        //println(frameRate + "Time elapsed: " + (currentTime - previousTime) + " ms");

        path.add(new PVector(location.x, location.y));
        previousTime = currentTime; // Update the previous time variable to the current time
      }
    }
  }
 }
 
 void display() {
   
   // Mostramos como una linea algunos de los puntos guardados en path
    stroke(127);
    strokeWeight(5);
    strokeCap(ROUND);

    for(int i = 0; i < path.size(); i++) { 
      point(path.get(i).x, path.get(i).y);
    }
    
   // La imagen del satelite varia en funcion de si hay colision
   PImage img;
   if(!exploded) {
     image(img_satelite, location.x - 5, location.y - 12, mass * 22, mass * 22);
   
   } else {
     image(img_exploded, location.x - 15, location.y - 15, mass * 35, mass * 35);
   }
    
  }

  void explode(PVector attractorLocation){
    // Comprovamos si el mover esta tocando a el Attractor
    if (attractorLocation.x > (this.location.x - 20) && attractorLocation.x < (this.location.x + 20)){
      if (attractorLocation.y > (this.location.y - 20) && attractorLocation.y < (this.location.y + 20)){
        exploded = true;
      }
    }
  }
  
}

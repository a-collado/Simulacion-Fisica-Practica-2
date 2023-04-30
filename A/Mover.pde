class Mover {
 PVector location; 
 PVector velocity;
 PVector acceleration;
 float mass;
 ArrayList<PVector> path;
 boolean exploded = false;
 boolean getPath = true;

Mover(float m, float x , float y, PVector initialVel) {
  location = new PVector(x, y);
  velocity = initialVel;
  acceleration = new PVector(0,0);
  mass = m;
  path = new ArrayList<PVector>();
}

 void applyForce(PVector force) {
  PVector f = PVector.div(force,mass);
  acceleration.add(f);
 }

 void update() {
  /*velocity.add(acceleration);
  location.add(velocity);
  acceleration.mult(0);*/
  if(!exploded || !getPath) { // Movimiento mientras no explote y Cada frame añadimos la localizacion actual a una lista
    velocity.add(acceleration);
    location.add(velocity);
    acceleration.mult(0);
    path.add(new PVector(location.x, location.y));
  }
 }
 
 void display() {
   
   // Mostramos como una linea algunos de los puntos guardados en path
    stroke(127);
    strokeWeight(5);
    strokeCap(ROUND);
    for(int i = 1; i < path.size(); i = i + 15) { 
      line(path.get(i-1).x, path.get(i-1).y, path.get(i).x, path.get(i).y);
    }
    
   // La imagen del satelite varia en funcion de si hay colision
   PImage img;
   if(!exploded) {
     img = loadImage("sate.png");
     image(img, location.x - 5, location.y - 12, mass * 22, mass * 22);
   
   } else {
     img = loadImage("explo.png");
     image(img, location.x - 15, location.y - 15, mass * 35, mass * 35);
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

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
  velocity.add(acceleration);
  location.add(velocity);
  acceleration.mult(0);
  if(!exploded || !getPath) { // Cada frame añadimos la localizacion actual a una lista
    path.add(new PVector(location.x, location.y));
  }
 }
 
 void display() {
   if(!exploded) {
     stroke(0);
     fill(175);
     ellipse(location.x,location.y,mass*16,mass*16);
   }
    
    for(int i = 1; i < path.size(); i++) { // Mostramos como una linea todos los puntos guardados en path
      line(path.get(i-1).x, path.get(i-1).y, path.get(i).x, path.get(i).y);
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

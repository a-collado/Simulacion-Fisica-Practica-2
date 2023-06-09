class Attractor {
  float mass;
  float radius;
  PVector location;
  float G;

  PImage img;
  
  Attractor(float m) {
    location = new PVector(width/2,height/2);
    mass = m;
    radius = mass*2;
    G = 0.4;
    img = loadImage("tierra.png");
  }
  
  PVector attract(Mover m) {
    PVector force = PVector.sub(location,m.location);
    float distance = force.mag();
    //distance = constrain(distance,5,25);
    
    force.normalize();
    float strength = (G * mass * m.mass) / (distance * distance);
    force.mult(strength);

    return force;
  }
  
  void display() {
    /*stroke(0);
    fill(175,200);
    circle(location.x,location.y,radius);*/
   
   // Imagen tierra
     image(img, location.x - 25, location.y - 24, mass*2, mass*2);
  }
}

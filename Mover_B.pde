class Mover_B {
 PVector location; 
 PVector velocity;
 PVector acceleration;
 float mass;
 ArrayList<PVector> path;
 boolean exploded;
 
 float a;
 float b;
 float e;
 float theta;
 float r;

Mover_B(float m, float x , float y, float a, float b) {
  location = new PVector(x, y);
  this.a = a;
  this.b = b;
  acceleration = new PVector(0,0);
  mass = m;
  path = new ArrayList<PVector>();
  exploded = false;
}

 void applyForce(PVector force) {
   PVector f = PVector.div(force,mass);
   acceleration.add(f);
 }

 void update() {
  e = sqrt(1 - (b*b)/(a*a));
  for (theta = 0; theta <= TWO_PI; theta += 0.01) {
    location.x = a*cos(theta);
    location.y = b*sin(theta);
  }

  // acceleration.mult(0);
  if(!exploded) {
    path.add(new PVector(location.x, location.y));
  }
 }
 
 void display() {
   if(!exploded) {
     stroke(0);
     fill(175);
     ellipse(location.x,location.y,mass*16,mass*16);
   }
    
    for(int i = 1; i<path.size(); i++) {
        line(path.get(i-1).x, path.get(i-1).y, path.get(i).x, path.get(i).y);
    }
    
  }
  
  void explode(PVector attractorLocation){
        if (attractorLocation.x > (this.location.x - 20) && attractorLocation.x < (this.location.x + 20)){
          if (attractorLocation.y > (this.location.y - 20) && attractorLocation.y < (this.location.y + 20)){
            exploded = true;
          }
        }
  }


}

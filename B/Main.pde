 Mover m;
 float x = 50;
 float y = 300;
 float vx = 50;
 float vy = -60;
 float dt = 0.1;
 float g = 9.81;
 float t = 0;

void setup(){
  size(640,360);
  m = new Mover(1, x, y, new PVector(vx,vy));
  
}

void draw(){
  background(255);
  
  // Analytical solution
  stroke(0);
  beginShape();
  for (float i = 0; i <= 2 * vx / g; i += 0.1) {
    float x_analytic = vx * i;
    float y_analytic = vy * i + 0.5 * g * i * i;
    vertex(x_analytic, y_analytic);
  }
  endShape();
  
  // Numerical solution
  PVector gravity = new PVector(0, g);  // create a PVector for gravity
  m.applyForce(gravity);  // apply gravity to the ball
  m.update();             // update the ball's position and velocity
  m.display();            // display the ball on the screen
  
  t += dt;
}

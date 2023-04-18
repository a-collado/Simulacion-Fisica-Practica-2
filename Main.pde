 Mover m;
 Attractor a;
 char exercise;
 
 float rMax;
 float rMin;

void setup(){
  size(640,360);
  exercise = 'B';
  m = new Mover(1, 250, 250, new PVector(0.3,0.05));
  a = new Attractor(25);
  
  rMax = 0.0;
  rMin = 999.0;
    
  switch(exercise){
    case 'A': 
    break;
    case 'B':

    break;
    
  }
}

void draw(){
  
  switch(exercise){
    case 'A': 
    exerciseA();
    break;
    case 'B': 
    exerciseB();
    break;
  }
    
}

void exerciseA(){
  background(255);
  
  PVector f = a.attract(m);
  m.applyForce(f);
  m.update();
  m.explode(a.location);
  
  a.display();
  m.display();
}

void exerciseB(){
  background(255);
  
  PVector f = a.attract(m);
  m.applyForce(f);
  m.update();
  m.explode(a.location);
  
  a.display();
  m.display();
 
  float d = dist(m.location.x, m.location.y, a.location.x, a.location.y);
  if (d > rMax) {
    rMax = d;
  }
  if (d < rMin) {
    rMin = d;
  }
  
  float p = (rMax + rMin) / 2;
  float e = (rMax - rMin) / (rMax + rMin);
  fill(0);
  text("Radio máximo: " + rMax + "px", 10, 20 );
  text("Radio mínimo: " + rMin + "px", 10, 40);
  text("Excentricidad: " + e, 10, 60);


}

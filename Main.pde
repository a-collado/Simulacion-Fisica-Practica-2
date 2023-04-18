 Mover m;
 Attractor a;
 Mover_B mB;
 char exercise;

void setup(){
  size(640,360);
  exercise = 'A';
  
  switch(exercise){
    case 'A': 
    m = new Mover(1, 0, 0, new PVector(0.4,0));
    a = new Attractor(25);
    break;
    case 'B':
    mB = new Mover_B(1,0,0,200,100);
    a = new Attractor(25);
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
  
  mB.update();
  mB.explode(a.location);
  
  a.display();
  mB.display();
}

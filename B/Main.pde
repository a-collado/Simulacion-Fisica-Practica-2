 Mover m;

 // Guardamos todos los valores para poder usarlos en el metodo analitico y en el numerico.
 float mass = 1;                 // Masa del Mover.
 float x = 50;                // Posicion inicial en X
 float y = 300;               // Posicion inicial en Y
 float vx = 50;               // Velocidad inicial en X
 float vy = -60;              // Velocidad inicial en Y
 float g = 9.81;              // Aceleracion de la gravedad

void setup(){
  size(640,360);

  // Inicializamos el mover con los valores que hemos designado.
  m = new Mover(mass, x, y, new PVector(vx,vy));

  frameRate(20);         // Relentizamos el framerate para poder ver bien el lanzamiento.

}

void draw(){
  background(255);
  
  // Solucion analitica:
  stroke(0);
  beginShape();
  // Hay que comprobar que estos calculos estan hechos con la formula que nos pide el profe.
  for (float i = 0; i <= 2 * vx / g; i += 0.1) {
    float x_analytic = vx * i;
    float y_analytic = vy * i + g/2 * i * i;
    vertex(x_analytic, y_analytic);
  }
  endShape();
  
  // Solucion numerica:
  PVector gravity = new PVector(0, g);
  m.applyForce(gravity);  
  m.update();             
  m.display();            
  

}

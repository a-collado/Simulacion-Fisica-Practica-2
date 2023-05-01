 Mover m;
 int screen_height = 360;

float angle = radians(70); // Ángulo de lanzamiento
float v0 = 70; // Velocidad inicial
float v0x = v0 * cos(angle);
float v0y = v0 * sin(angle);
float g = 9.81; // Aceleración gravitatoria
float mass = 1;

ArrayList<PVector> analyticalPath = new ArrayList<PVector>(); // Trayectoria analítica

float x = 20, y = 300; // Posición inicial
float tMax = v0 * sin(angle) + sqrt((v0*sin(angle)) + 2 * g * (screen_height - y)) / g; // Tiempo que pasara la bola en el aire.
float dt = 0.01; // Incremento de tiempo para calcular la solicon analitica

void setup(){
  size(640,360);
  // Inicializamos el mover con los valores que hemos designado.
  m = new Mover(mass, x, y, new PVector(v0x, -v0y));    // La vy0 la invertimos para que la velocidad apunte hacia arriba en Processing
  frameRate(1);         // Relentizamos el framerate para poder ver bien el lanzamiento.

  // Solucion analítica
  for (float t = 0; t <= tMax; t += dt) {
    // Utilizamos la formula del desplazamiento para calcular la posicion en cada momento del tiempo
    float x_analityc = x-10 + v0 * cos(angle) * t;
    float y_analityc = (screen_height - y)-30 + v0 * sin(angle) * t - g/2 * pow(t, 2);   // Restamos screen height - y porque en el sistema de coordenadas que usa processing, el punto más alto de la pantalla es el 0.
    analyticalPath.add(new PVector(x_analityc, y_analityc));
  }


}

void draw(){
  background(255);

  // Simulación numérica

  // Calcular nueva posición y velocidad
  strokeWeight(1);
  PVector fuerza_acelaracion = new PVector(0, g).mult(m.mass);  // Calculamos la fuerza de la aceleracion.
  m.applyForce(fuerza_acelaracion);                             // Usamos la segunda ley de Newton para calcular la acelaracion en la funcion applyForce.
  m.update();                                     // El calculo de la velocidad utilizando la aceleracion se esta haciendo en la funcion update del Mover.     
  m.display();       
  
  
  // Dibujar trayectoria analítica
  /*stroke(0, 0, 255);
  noFill();
  for (PVector p : analyticalPath) {
    point(p.x, screen_height - p.y);
  }*/
  stroke(127);
  strokeWeight(5);
  strokeCap(ROUND);
  for(int i = 0; i < analyticalPath.size(); i = i + 30) { 
    if (m.location.x > analyticalPath.get(i).x) {
      point(analyticalPath.get(i).x, screen_height - analyticalPath.get(i).y);
    }
  }

  fill(0);
  text("Angle de llançament: " +  round(degrees(angle)) + " graus", 10, 20 );
  text("Velocitat inicial : " + int(v0) + " px/s", 10, 40);

}

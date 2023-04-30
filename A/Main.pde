 Mover m;
 Attractor a;
 char exercise;   // Que ejericio se va a ejecutar
 
 // Ejercicio 'B'
 float rMax;          // Radio maximo de la orbita.
 float rMin;          // Radio minimo del a orbita.
 
 // Ejercicio 'C'
 PVector initialPos;
 // Booleans para marcar diferentes estados.
 boolean complete = false;
 boolean enter = false;
 boolean calculated = false;
 boolean firtsLap = false;
 
int areaTime = 70;    // Cuantas poisiciones (puntos en la lista 'path') utilizaremos para calcular el area.
int areas;            // Cuantas areas se van a calcular.
int[][] points;       // Los puntos de la orbita con los que vamos a calular cada area.
float[] areaTrapecio; // Todas las areas calculadas con el metodo del trapecio.
float[] areaSimpson;  // Todas las areas calculadas con el metodo Simpson.
int[] colors;         // Esta por ahora no se sta usando.

int sections = 20; // number of sections to divide the path
 
 // Ejercicio 'D'

void setup(){
  size(640,360);
  exercise = 'C';
  a = new Attractor(25);
  m = new Mover(1, 250, 70, new PVector(0.3,0.05));
  if (exercise == 'D'){
    m.location = new PVector(width/2+100,height/2);
    m.velocity = new PVector (0,sqrt(a.G * a.mass / dist(m.location.x, m.location.y, a.location.x, a.location.y)));
  }

  // Ponemos el valor más bajo y más alto posible.
  rMax = 0.0;
  rMin = 999.0;
    
  initialPos = m.location.copy();
  areas = int(random(2,6)); // Se calculara un numero aleatorio de areas entre 2 y 4.
  points = new int[areas][2];
  areaTrapecio = new float[areas];
  areaSimpson = new float[areas];

  frameRate(600);         // Aumentamos el framerate para que la orbita se complete antes.
  
}

void draw(){
  background(255);
  
  switch(exercise){
    case 'A': 
    exerciseA();
    break;
    case 'B': 
    exerciseB();
    break;
    case 'C':
    exerciseC();
    break;
    case 'D':
    exerciseD();
    break;
  }
    
}

void exerciseA(){

  PVector f = a.attract(m);
  m.applyForce(f);
  m.update();
  m.explode(a.location);
  
  a.display();
  m.display();
}

void exerciseB(){
  exerciseA();

  float d = dist(m.location.x, m.location.y, a.location.x, a.location.y); // Calculamos la distancia entre el Attractor y el Mover.
  if (d > rMax) {                                                         // Guardamos la distancia minima y maxima.
    rMax = d;
  }
  if (d < rMin) {
    rMin = d;
  }                                 

  float e = (rMax - rMin) / (rMax + rMin);                                // Calculamos la excentricidad y lo mostramos todo por pantlla.
  fill(0);
  text("Radi màxim: " + int(rMax) + "px", 10, 20 );
  text("Radi mínim: " + int(rMin) + "px", 10, 40);
  text("Excentricitad: " + e, 10, 60);

}

void exerciseC(){
  exerciseA();

  if(!complete || !firtsLap){                                         // Calculamos el tiempo transcurrido desde que se ha iniciado el programa
    PVector position = m.location.copy();
    // Si el Mover ha completado una vuelta
    if (int(initialPos.x) == int(position.x) && int(initialPos.y) == int(position.y)) {
      if (firtsLap) {
        // Marcamos la orbita como completada y dejamos de guardar los puntos de la orbita.
        complete = true;
        m.getPath = false;
      } 
    } else {
        firtsLap = true;
    }
  } else if (!enter){
    fill(0,0,0);
    text("Presiona Enter para calcular áreas.", 10, 40);
  }
  
  if (enter){
    if (!calculated){
      int sectionLength = m.path.size() / sections; // length of each section
      
      int[][] indexes = new int[sections][2];
      for (int i = 0; i < sections; i++) {
        indexes[i][0] = i * sectionLength; // start index of the section
        indexes[i][1] = (i + 1) * sectionLength - 1; // end index of the section
      }

      int previousNumber = -1;
      int count = 0;
      int[] numbersSelected = new int[areas];
      while (count < areas) {
        int randomNumber = int(random(0,sections));
        if (randomNumber != previousNumber && !isIn(numbersSelected, randomNumber) ) {
          points[count] = indexes[randomNumber];
          previousNumber = randomNumber;
          numbersSelected[count] = randomNumber;
          count++;
        }
      }

      for(int i = 0; i < points.length; i++){
        // Calcular la distancia entre los dos puntos
        float dist = m.path.get(points[i][1]).dist(m.path.get(points[i][0]));
        // TODO: Creo que las formulas estan mal. Hay que buscar las formulas correctas.
        
        // Calcular el área usando el método del trapecio
        areaTrapecio[i] = dist * (m.path.get(points[i][1]).y + m.path.get(points[i][0]).y) / 2;
        
        // Calcular el área usando el método de Simpson
        //areaSimpson[i] = dist / 6 * (m.path.get(points[i][0]).y + 4 * m.path.get((points[i][0] + points[i][1]) / 2).y + m.path.get(points[i][1]).y);
        float dx = (m.path.get(points[i][1]).x - m.path.get(points[i][0]).x) / 10;
        areaSimpson[i] = simpsonArea(m.path.get(points[i][0]), m.path.get(points[i][1]), a.location, dx);

      }
      calculated = true;
    }
    
    text("Método del trapecio: ", 10, 40);
    text("Método de Simpson: ", 150, 40);
    for(int i = 0; i < areas; i++){
      // Dibujamos las areas que hemos calculado.
      for (int e = points[i][0]; e < points[i][1]; e++){
        stroke(255, 153, 153); 
        line(a.location.x, a.location.y, m.path.get(e).x, m.path.get(e).y);
      }
      
      circle(m.path.get(points[i][0]).x, m.path.get(points[i][0]).y, 10.0f);
      circle(m.path.get(points[i][1]).x, m.path.get(points[i][1]).y, 10.0f);
    }
    
    for(int i = 0; i < areas; i++){
      // Mostrar los resultados
      text(areaTrapecio[i], 10, 60 + 20 * i);
      text(areaSimpson[i], 150, 60 + 20 * i);
    }
  }
}

void exerciseD(){
  exerciseA();

  // Los calculos importantes para el ejercicio D se han hecho dentro de un if en la funcion setup().
}

void keyPressed() {
  if (keyCode == ENTER) {
      if (complete){                  // Solo se calcularan las areas si ya se ha completado la orbita.
        enter = true;
      }
  } 
}

float simpsonArea(PVector p1, PVector p2, PVector c, float dx) {
  float sum = 0;
  for (float x = p1.x + dx; x < p2.x; x += dx) {
    PVector p = new PVector(x, -x*x/100);
    float area = dx/3 * (distance(c, p1) + 4*distance(c, p) + distance(c, p2));
    sum += area;
  }
  return sum;
}

float distance(PVector p1, PVector p2) {
  return p1.dist(p2);
}

boolean isIn(int[] array, int value) {
  for (int i = 0; i < array.length; i++) {
    if (array[i] == value) {
      return true;
    } 
    if (array[i] == value + 1) {
      return true;
    } 

    if (array[i] == value - 1) {
      return true;
    } 
  }
  return false;
}

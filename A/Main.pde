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
  //areas = 1;
  points = new int[areas][2];
  areaTrapecio = new float[areas];
  areaSimpson = new float[areas];

  frameRate(200);         // Aumentamos el framerate para que la orbita se complete antes.
  
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
        // Calcular el área usando el método del trapecio
        areaTrapecio[i] = trapezoidArea(points[i][0], points[i][1]);
        
        // Calcular el área usando el método de Simpson
        areaSimpson[i] = simpsonArea(points[i][0], points[i][1]);

      }
      calculated = true;
    }
    
    text("Método del trapecio: ", 10, 40);
    text("Método de Simpson: ", 150, 40);

    for(int i = 0; i < areas; i++){
      // Dibujamos las areas que hemos calculado.
      for (int e = points[i][0]; e < points[i][1]; e ++){
        stroke(255, 153, 153); 
        line(a.location.x, a.location.y, m.path.get(e).x, m.path.get(e).y);
        point(m.path.get(e).x, m.path.get(e).y);
      }
      line(a.location.x, a.location.y, m.path.get(points[i][1]).x, m.path.get(points[i][1]).y);
      point( m.path.get(points[i][1]).x, m.path.get(points[i][1]).y);

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

float trapezoidArea(int p1Index, int p2Index) {
  float area = 0;
  PVector p1 = m.path.get(p1Index).copy();
  PVector p2 = m.path.get(p2Index).copy();
  PVector c = a.location.copy();
  int secciones = 10;

  PVector[] a = new PVector[secciones+1];
  a[0] = p1;
    PVector[] b = new PVector[secciones+1];
  b[0] = p2;
  
  for (int i = 1; i <= secciones; i++) {
    // Calcular el punto intermedio
    float t1 = (float) i / (float) secciones; // Calcular el valor de t
    a[i] = PVector.lerp(p1, c, t1); // Calcular el punto intermedio usando la función lerp
    float t2 = (float) i / (float) secciones; 
    b[i] = PVector.lerp(p2, c, t2); // Calcular el punto intermedio usando la función lerp

    //float t = a[i-1].dist(a[i])/2;
    PVector midA = PVector.lerp(a[i-1], a[i], 0.5);
    //ellipse(midA.x, midA.y, 1, 1);
    PVector midB = PVector.lerp(b[i-1], b[i], 0.5);
    //ellipse(midB.x, midB.y, 1, 1);

    /*
    float baseA = a[i-1].dist(a[i]);
    float baseB = b[i-1].dist(b[i]);
    float h = midA.dist(midB);
    */

    float h = a[i-1].dist(a[i]);
    float baseA = a[i-1].dist(b[i-1]);
    float baseB = a[i].dist(b[i]);

    area += (baseA + baseB)*h/2;
  }
  
  return area;
}


float simpsonArea(int p1Index, int p2Index) {
  float area = 0;

  PVector p1 = m.path.get(p1Index).copy();
  PVector p2 = m.path.get(p2Index).copy();
  PVector c = a.location.copy();
  int secciones = 6;

  PVector[] a = new PVector[secciones+1];
  a[0] = p1;
    PVector[] b = new PVector[secciones+1];
  b[0] = p2;
  
  for (int i = 1; i <= secciones; i++) {
    // Calcular el punto intermedio
    float t1 = (float) i / (float) secciones; // Calcular el valor de t
    a[i] = PVector.lerp(p1, c, t1); // Calcular el punto intermedio usando la función lerp
    float t2 = (float) i / (float) secciones; 
    b[i] = PVector.lerp(p2, c, t2); // Calcular el punto intermedio usando la función lerp

    PVector midA = PVector.lerp(a[i-1], a[i], 0.5);
    PVector midB = PVector.lerp(b[i-1], b[i], 0.5);

    float h = a[i-1].dist(midA);
    float df = a[i-1].dist(b[i-1]);
    float dm = midA.dist(midB);
    float dl = a[i].dist(b[i]);

    area += h/3 * (df + 4*dm + dl);
  }

  return area;
}
void pruebas(int p1Index, int p2Index)
{
  PVector p1 = m.path.get(p1Index).copy();
  PVector p2 = m.path.get(p2Index).copy();
  PVector c = a.location.copy();
   int secciones = 10;
   stroke(255, 153, 153); 

  PVector[] a = new PVector[secciones+1];
  a[0] = p1;
    PVector[] b = new PVector[secciones+1];
  b[0] = p2;
  
  for (int i = 1; i <= secciones; i++) {
    // Calcular el punto intermedio
    float t = (float) i / (float) secciones; // Calcular el valor de t
    a[i] = PVector.lerp(p1, c, t); // Calcular el punto intermedio usando la función lerp
    // Dibujar el punto
    ellipse(a[i-1].x, a[i-1].y, 5, 5);
  }


  for (int i = 1; i <= secciones; i++) {
    // Calcular el punto intermedio
    float t = (float) i / (float) secciones; // Calcular el valor de t
    b[i] = PVector.lerp(p2, c, t); // Calcular el punto intermedio usando la función lerp
    ellipse(b[i-1].x, b[i-1].y, 5, 5);
  }
  stroke(0, 165, 200); 
  float area = 0;
  for (int i = 1; i <= secciones; i++) {
    //float t = a[i-1].dist(a[i])/2;
    PVector midA = PVector.lerp(a[i-1], a[i], 0.5);
    //ellipse(midA.x, midA.y, 1, 1);
    PVector midB = PVector.lerp(b[i-1], b[i], 0.5);
    //ellipse(midB.x, midB.y, 1, 1);
    float baseA = a[i-1].dist(a[i]);
    float baseB = b[i-1].dist(b[i]);
    float h = midA.dist(midB);
    area += (baseA + baseB)*h/2;
    quad(a[i-1].x, a[i-1].y, a[i].x, a[i].y, b[i].x, b[i].y, b[i-1].x, b[i-1].y);
  }
  //println(area);
  stroke(255, 153, 153); 
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

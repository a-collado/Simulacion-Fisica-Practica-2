 Mover m;
 Attractor a;
 char exercise;   // Que ejericio se va a ejecutar
 
 // Ejercicio 'B'
 float rMax;          // Radio maximo de la orbita.
 float rMin;          // Radio minimo del a orbita.
 
 // Ejercicio 'C'
 float time;          // Tiempo actual en milisegundos.
 float time_ini;      // Tiempo en el instante inicial de la ejecucion del programa en milisegundos.
 PVector initialPos;
 // Booleans para marcar diferentes estados.
 boolean complete = false;
 boolean enter = false;
 boolean calculated = false;
 
int areaTime = 70;    // Cuantas poisiciones (puntos en la lista 'path') utilizaremos para calcular el area.
int areas;            // Cuantas areas se van a calcular.
int[][] points;       // Los puntos de la orbita con los que vamos a calular cada area.
float[] areaTrapecio; // Todas las areas calculadas con el metodo del trapecio.
float[] areaSimpson;  // Todas las areas calculadas con el metodo Simpson.
int[] colors;         // Esta por ahora no se sta usando.
 
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
    
  time_ini = millis();      // Momento actual en miliseungos.
  initialPos = m.location.copy();
  areas = int(random(1,4)); // Se calculara un numero aleatorio de areas entre 2 y 4.
  areaTrapecio = new float[areas];
  areaSimpson = new float[areas];
  points = new int[areas][2];

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

  if(!complete){
    time = millis() - time_ini;                                           // Calculamos el tiempo transcurrido desde que se ha iniciado el programa
    PVector position = m.location.copy();
    // Si el Mover ha completado una vuelta
    if (time > 100 && int(initialPos.x) == int(position.x) && int(initialPos.y) == int(position.y)){
    // Marcamos la orbita como completada y dejamos de guardar los puntos de la orbita.
      complete = true;
      m.getPath = false;
    }
  }else if (!enter){
    text("Presiona Enter para calcular áreas.", 10, 40);
  }
  
  if (enter){
    if (!calculated){
      for(int i = 0; i < areas; i++){
      // Obtener dos índices aleatorios
      if (i == 0){
        points[i][0] = int(random(m.path.size()/4));                        // Dividimos el total entre 4 para asegurar que la primera area estara en el primer cuarto de la orbita.
      } else {
        points[i][0] = int(random(points[i-1][1], m.path.size() - areaTime ));
      }
      points[i][1] = points[i][0] + areaTime;

      // Nos aseguramos que el area que vayamos a calcular este dentro de la orbita.
      //TODO: Creo que aqui hay un bug que hace que a veces haya 2 areas iguales.
      if (points[i][1] > m.path.size()) {
        points[i][1] = m.path.size() - 1;
        points[i][0] = points[i][1] - areaTime;
      }
      
      // Calcular la distancia entre los dos puntos
      float dist = m.path.get(points[i][1]).dist(m.path.get(points[i][0]));
      // TODO: Creo que las formulas estan mal. Hay que buscar las formulas correctas.

      // Calcular el área usando el método del trapecio
      areaTrapecio[i] = dist * (m.path.get(points[i][1]).y + m.path.get(points[i][0]).y) / 2;
      
      // Calcular el área usando el método de Simpson
      areaSimpson[i] = dist / 6 * (m.path.get(points[i][0]).y + 4 * m.path.get((points[i][0] + points[i][1]) / 2).y + m.path.get(points[i][1]).y);


      }
      calculated = true;
    }
    text("Método del trapecio: ", 10, 40);
    text("Método de Simpson: ", 150, 40);
    for(int i = 0; i < areas; i++){
      // Mostrar los resultados
       text(areaTrapecio[i], 10, 60 + 20 * i);
       text(areaSimpson[i], 150, 60 + 20 * i);
      
      stroke(255, 0, 0);
      // Dibujamos las areas que hemos calculado.
      for (int e = points[i][0]; e < points[i][1]; e++){
        line(a.location.x, a.location.y, m.path.get(e).x, m.path.get(e).y);
      }
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

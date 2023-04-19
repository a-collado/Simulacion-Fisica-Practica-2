 Mover m;
 Attractor a;
 char exercise;
 
 // Ejercicio 'B'
 float rMax;
 float rMin;
 
 // Ejercicio 'C'
 float t;
 float t0;
 PVector initialPos;
 boolean complete = false;
 boolean enter = false;
 boolean calculated = false;
 
int areaTime = 70;
int areas;
int[][] points;
float[] areaTrapecio;
float[] areaSimpson;
int[] colors;
 
 // Ejercicio 'D'

void setup(){
  size(640,360);
  exercise = 'D';
  a = new Attractor(25);
  m = new Mover(1, width/2+100,height/2, new PVector(0.3,0.05));
  if (exercise == 'D'){
    // Hay que preguntar si la localizacion inicial tiene que ser perpendicular
    m.velocity = new PVector (0,sqrt(a.G * a.mass / dist(m.location.x, m.location.y, a.location.x, a.location.y)));
  }


  
  rMax = 0.0;
  rMin = 999.0;
    
  t0 = millis(); // momento actual
  initialPos = m.location.copy();
  areas = int(random(2,5));
  areaTrapecio = new float[areas];
  areaSimpson = new float[areas];
  points = new int[areas][2];
  
}

void draw(){
  background(255);
  
  PVector f = a.attract(m);
  m.applyForce(f);
  m.update();
  m.explode(a.location);
  
  a.display();
  m.display();
  
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

}

void exerciseB(){
 
  float d = dist(m.location.x, m.location.y, a.location.x, a.location.y);
  if (d > rMax) {
    rMax = d;
  }
  if (d < rMin) {
    rMin = d;
  }
  
  float e = (rMax - rMin) / (rMax + rMin);
  fill(0);
  text("Radi màxim: " + int(rMax) + "px", 10, 20 );
  text("Radi mínim: " + int(rMin) + "px", 10, 40);
  text("Excentricitad: " + e, 10, 60);


}

void exerciseC(){
 
  if(!complete){
    t = millis() - t0; // tiempo transcurrido
    PVector position = m.location.copy();
    // Si el Mover ha completado una vuelta
    if (t > 100 && int(initialPos.x) == int(position.x) && int(initialPos.y) == int(position.y)){
      // Mostrar mensaje para calcular áreas
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
        points[i][0] = int(random(m.path.size()/4));
      } else {
        points[i][0] = int(random(points[i-1][1], m.path.size() - areaTime ));
      }
      points[i][1] = points[i][0] + areaTime;
      if (points[i][1] > m.path.size()) {
        points[i][1] = m.path.size() - 1;
        points[i][0] = points[i][1] - areaTime;
      }
      
      // Calcular la distancia entre los dos puntos
      float dist = m.path.get(points[i][1]).dist(m.path.get(points[i][0]));
      
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
      
      for (int e = points[i][0]; e < points[i][1]; e++){
        line(a.location.x, a.location.y, m.path.get(e).x, m.path.get(e).y);
      }
    }
  }
  
  
  
  
}

void exerciseD(){
  
}

void keyPressed() {
  if (keyCode == ENTER) {
      if (complete){
        enter = true;
      }
  } 
}

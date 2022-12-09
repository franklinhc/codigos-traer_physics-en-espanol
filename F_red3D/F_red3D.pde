/*
simulación para demostrar fuerzas de atracción y repulsión en tres dimensiones
 con la biblioteca traer.physics (http://murderandcreate.com/physics/)
 
 ph.d. franklin hernández-castro | tec costa rica | HfG gmuend | junio 2022
 www.skizata.com
 */

// biblioteca
import traer.physics.*;
import peasy.*;


PeasyCam laCamara;

ParticleSystem mundoVirtual; // ambiente de la simulación
Particle  puntero; // esta es la particula que se mueve con el mouse para atraer a las demas
Particle[] arrayDeParticulas;  // lista de todas las partículas
Spring [] arrayDeResortes; // lista de los resortes

// varaibles de la red
int cantidadDeParticulasEnX = 50;
int cantidadDeParticulasEnY = 30;
int cantidadTotalDeParticulas = cantidadDeParticulasEnX * cantidadDeParticulasEnY;
float anchoDeRed, altoDeRed, pasoEnX, pasoEnY, borde;
int tamagno = 4; // tamagno de los puntos

//---------------------------------------------------------------------------
void setup() {
  size(1150, 650, P3D);
  smooth();
  laCamara = new PeasyCam(this, 0, 0, 0, 600);

  // para ordenar la cuadricula
  borde = 20;
  anchoDeRed = width -2*borde;
  altoDeRed = height-2*borde;
  pasoEnX = anchoDeRed / (cantidadDeParticulasEnX-1);
  pasoEnY = altoDeRed / (cantidadDeParticulasEnY-1);

  // Creación del mundo
  mundoVirtual = new ParticleSystem(0, 0.1, 0.5, 0.1);

  // creación de la partícula que sigue al mouse
  puntero = mundoVirtual.makeParticle();
  puntero.makeFixed(); // makeFixed la libera de actuar según las fuerzas del ambiente
  mouseX = width/2;
  mouseY = height/2;

  // inicialización de los arrays
  arrayDeParticulas = new Particle[cantidadTotalDeParticulas]; // particle array
  arrayDeResortes = new Spring [2920]; // spring array

  // en este ciclo doble se crean las partículas y los resortes
  // como las listas de partículas son de una dimensión y se crean en este array de dos dimensiones
  // se unsa el índice "a" para meter las partículas en la lista
  int a = 0; //indice uniDimensional
  for (int y=0; y<cantidadDeParticulasEnY; y++) {  // recorremos todas las columnas
    for (int x=0; x<cantidadDeParticulasEnX; x++) { // recorremos todas las filas
      float xPos = x*pasoEnX+borde;
      float yPos = y*pasoEnY+borde;
      arrayDeParticulas[a] = mundoVirtual.makeParticle(0.8, xPos, yPos, 0); // crea la partícula móvil
      if (y==0 || x==0 || y==cantidadDeParticulasEnY-1 || x==cantidadDeParticulasEnX-1) arrayDeParticulas[a].makeFixed();

      // se define la atracción o repulsión entre cada partícula y la partícula que se mueve con el mose llamada puntero
      //makeAttraction( Particle a, Particle b, float strength, float minimumDistance )
      mundoVirtual.makeAttraction(arrayDeParticulas[a], puntero, 25000, 100);
      //mundoVirtual.makeAttraction(arrayDeParticulasMoviles[a], puntero, 8000, 100); // 50000, 100
      a++;
    }
  } // end del doble ciclo for

  // crea resortes
  // para lineas horizontales
  int count = 0;
  for (int i = 0; i < arrayDeParticulas.length; i++) {
    if ( i < arrayDeParticulas.length-1 && ((i+1) % cantidadDeParticulasEnX != 0)) {
      arrayDeResortes[count] = mundoVirtual.makeSpring(arrayDeParticulas[i], arrayDeParticulas[i+1], 0.2, 0.01, pasoEnX/2 ); // 0.2,0.1
      count++;
    }
  } // end for de lineas horizontales

  // para lineas verticales
  for (int i = 0; i < cantidadDeParticulasEnX; i++) {
    for (int j = i+((cantidadDeParticulasEnX * (cantidadDeParticulasEnY-1))); j > i; j=j-cantidadDeParticulasEnX) {
      arrayDeResortes[count] = mundoVirtual.makeSpring(arrayDeParticulas[j], arrayDeParticulas[j-cantidadDeParticulasEnX], 0.2, 0.01, pasoEnY/2 );
      count++;
    }
  }  // end for de lineas verticales
  
} // end setup()



void draw() { //--------------------------------------------------------------------------
  background(64); // gris 25%
  mundoVirtual.tick(); // reloj del mundo virtual
  
  // se coloca la particula "puntero" en la posición del mouse
  puntero.position().set(mouseX, mouseY, 0 ); // tracking mouse
  
  translate (-width/2, -height/2); // porque estamos en 3D y tenemos que posicionar el dibujo en frente de la cámara

  // se dibujan los resortes preguntando dobre la posisión de sus extremos
  for (int n =0; n < arrayDeResortes.length; n++) {
    float x1 = arrayDeResortes[n].getOneEnd().position().x();
    float y1 = arrayDeResortes[n].getOneEnd().position().y();
    float x2 = arrayDeResortes[n].getTheOtherEnd().position().x();
    float y2 = arrayDeResortes[n].getTheOtherEnd().position().y();
    stroke(#2D79AA, 82);
    line (x1, y1, x2, y2);
  }

  // se dibujan todas las partículas móviles
  float posx, posy;
  for (int n=0; n<arrayDeParticulas.length; n++) {
    posx = arrayDeParticulas[n].position().x();
    posy = arrayDeParticulas[n].position().y();
    fill(#689DBC);
    noStroke();
    ellipse(posx, posy, tamagno, tamagno);
  }

} // end draw

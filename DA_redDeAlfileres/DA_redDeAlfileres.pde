/*
simulación para demostrar una representación de humo
 con la biblioteca traer.physics (http://murderandcreate.com/physics/)
 
 ph.d. franklin hernández-castro | tec costa rica | HfG gmuend | junio 2022
 www.skizata.com
 */

// biblioteca
import traer.physics.*;

// varaibles para albergar particulas
ParticleSystem mundoVirtual; // ambiente de la simulación
Particle puntero; // esta es la particula que se mueve con el mouse para atraer a las demas
Particle[] arrayDeParticulasMoviles;  // lista de las partículas que se mueven
Particle[] arrayDeParticulasFijas;   // lista de las partículas fijas
Spring [] arrayDeResortes; // lista de los resortes
PImage imagenDelHumo;


// variables para organizar lsa posiciones de las partículas en cuadrícula
int cantidadDeParticulasEnX = 100;
int cantidadDeParticulasEnY = 50;
int cantidadTotalDeParticulas = cantidadDeParticulasEnX * cantidadDeParticulasEnY;
float anchoDeRed, altoDeRed, pasoEnX, pasoEnY, borde;
int tamagno = 4; // tamaño en que se dibujaran las partículas móviles


//---------------------------------------------------------------------------
void setup() {
  size(1000, 500);
  smooth();
  imageMode(CENTER);
  imagenDelHumo = loadImage( "fadeBlanco.jpg" );

  // creando el ambiente virtual de la simulación
  mundoVirtual = new ParticleSystem(0, 0.05); // gravedad y friccion

  // variables y cáculos para hacer la red
  borde = 1;
  anchoDeRed = width -2*borde;
  altoDeRed = height-2*borde;
  pasoEnX = anchoDeRed / (cantidadDeParticulasEnX-1);
  pasoEnY = altoDeRed / (cantidadDeParticulasEnY-1);


  // creación de la partícula que sigue al mouse
  puntero = mundoVirtual.makeParticle(1, width/2, height/2, 0);
  puntero.makeFixed(); // makeFixed la libera de actuar según las fuerzas del ambiente
  mouseX = width/2;
  mouseY = height/2;

  // inicialización de los arrays
  arrayDeParticulasMoviles    = new Particle[cantidadTotalDeParticulas]; // particle array
  arrayDeParticulasFijas = new Particle[cantidadTotalDeParticulas]; // fixed particle array
  arrayDeResortes = new Spring [cantidadTotalDeParticulas]; // spring array

  // en este ciclo doble se crean las partículas y los resortes
  // como las listas de partículas son de una dimensión y se crean en este array de dos dimensiones
  // se unsa el índice "a" para meter las partículas en la lista
  int a = 0; //indice uniDimensional
  for (int y=0; y<cantidadDeParticulasEnY; y++) {  // recorremos todas las columnas
    for (int x=0; x<cantidadDeParticulasEnX; x++) { // recorremos todas las filas
      float xPos = x*pasoEnX+borde;
      float yPos = y*pasoEnY+borde;
      arrayDeParticulasMoviles[a] = mundoVirtual.makeParticle(0.8, xPos, yPos, 0); // crea la partícula móvil
      arrayDeParticulasFijas[a] = mundoVirtual.makeParticle(0.8, xPos, yPos, 0);  // crea la partícula fija
      arrayDeParticulasFijas[a].makeFixed(); // la hace fija
      // hace el resorte entre ambas partículas
      arrayDeResortes[a]= mundoVirtual.makeSpring(arrayDeParticulasMoviles[a], arrayDeParticulasFijas[a], 0.2, 0.1, 10 );

      // se define la atracción o repulsión entre cada partícula y la partícula que se mueve con el mose llamada puntero
      mundoVirtual.makeAttraction(arrayDeParticulasMoviles[a], puntero, 800, 50); // 50000, 100
      a++;
    }
  } // end del doble ciclo for
} // end setup()




void draw() { //--------------------------------------------------------------------------
  background(64); // gris 25%
  mundoVirtual.tick(); // reloj del mundo virtual
  
  // se coloca la particula "puntero" en la posición del mouse
  puntero.position().set(mouseX, mouseY, 0 ); // tracking mouse

  // se dibujan todas las partículas móviles
  float posx, posy;
  for (int n=0; n<arrayDeParticulasMoviles.length; n++) {
    posx = arrayDeParticulasMoviles[n].position().x();
    posy = arrayDeParticulasMoviles[n].position().y();
    //fill(#689DBC);
    fill(0);
    noStroke();
    ellipse(posx, posy, tamagno, tamagno);
    tint( 255, 5 );
    image (imagenDelHumo, posx, posy );
  }

} // end draw

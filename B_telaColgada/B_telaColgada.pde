/*
simulación simple de tela con la biblioteca traer.physics (http://murderandcreate.com/physics/)
código ejemplo de la biblioteca
 
 modificado por:
 ph.d. franklin hernández-castro | tec costa rica | HfG gmuend | junio 2022
 www.skizata.com
 */

import traer.physics.*;

Particle[][] arrayDeParticulas; // un array de dos dimensiones que contiene las partículas
int cantidadDeParticulasPorLado = 20;
ParticleSystem mundoVirtual;

float durezaDeResortes = 0.1;
float elasticidadDeResortes = 0.1;

//---------------------------------------------------------------------------
void setup() { 
  size(600, 600);
  smooth();

  // creando el ambiente virtual de la simulación
  mundoVirtual = new ParticleSystem(0.01, 0.0001); // gravedad y friccion
  
  // inicializando la matriz bidimensional
  arrayDeParticulas = new Particle[cantidadDeParticulasPorLado][cantidadDeParticulasPorLado];
  // usando la mitad del espacio se define la distancia que separa a las partículas
  float pasoEnX = (width / 2) / cantidadDeParticulasPorLado;
  float pasoEnY = (height / 2) / cantidadDeParticulasPorLado;
  
  // hace las partículas y los resortes horizontales
  for (int i = 0; i < cantidadDeParticulasPorLado; i++) {
    for (int j = 0; j < cantidadDeParticulasPorLado; j++) {
      arrayDeParticulas[i][j] = mundoVirtual.makeParticle(0.2, (width/4) + j * pasoEnX, 20 + i * pasoEnY, 0.0); // ( float mass, float x, float y, float z )
      if (j > 0) mundoVirtual.makeSpring(arrayDeParticulas[i][j - 1], arrayDeParticulas[i][j], durezaDeResortes, elasticidadDeResortes, pasoEnX);
    }
  }
  // hace los resortes verticales
  for (int j = 0; j < cantidadDeParticulasPorLado; j++){
    for (int i = 1; i < cantidadDeParticulasPorLado; i++){
      mundoVirtual.makeSpring(arrayDeParticulas[i - 1][j], arrayDeParticulas[i][j], durezaDeResortes, elasticidadDeResortes, pasoEnY);
    }
  }
  // declarando las dos partículas que actúan como puntos fijos de los que cuelga la tela
  arrayDeParticulas[0][0].makeFixed();
  arrayDeParticulas[0][cantidadDeParticulasPorLado - 1].makeFixed();


} // end setup()



// ---------------------------------------------------------------------------------
void draw() { 
  background(64); // gris 25%
  noFill();
  stroke(#689DBC); // color celeste
  mundoVirtual.tick();// reloj del mundo virtual
  
  // dibuja las líneas horizontales  
  for (int i = 0; i < cantidadDeParticulasPorLado; i++) {
    beginShape();
    curveVertex(arrayDeParticulas[i][0].position().x(), arrayDeParticulas[i][0].position().y());
    for (int j = 0; j < cantidadDeParticulasPorLado; j++) {
      curveVertex(arrayDeParticulas[i][j].position().x(), arrayDeParticulas[i][j].position().y());
    }
    curveVertex(arrayDeParticulas[i][cantidadDeParticulasPorLado - 1].position().x(), arrayDeParticulas[i][cantidadDeParticulasPorLado - 1].position().y());
    endShape();
  } // end for
  
  // dibuja las líneas verticales
  for (int j = 0; j < cantidadDeParticulasPorLado; j++) {
    beginShape();
    curveVertex(arrayDeParticulas[0][j].position().x(), arrayDeParticulas[0][j].position().y());
    for (int i = 0; i < cantidadDeParticulasPorLado; i++) {
      curveVertex(arrayDeParticulas[i][j].position().x(), arrayDeParticulas[i][j].position().y());
    }
    curveVertex(arrayDeParticulas[cantidadDeParticulasPorLado - 1][j].position().x(), arrayDeParticulas[cantidadDeParticulasPorLado - 1][j].position().y());
    endShape();
  } // end for
  
}  // end draw





// inputs ---------------------------------------------------------------------------------
void mouseDragged () {
  arrayDeParticulas[0][cantidadDeParticulasPorLado - 1].position().set(mouseX, mouseY, 0);
}

void mouseReleased() {
  arrayDeParticulas[0][cantidadDeParticulasPorLado - 1].position().set(mouseX, mouseY, 0);
}

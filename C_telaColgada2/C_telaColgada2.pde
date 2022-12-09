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

float durezaDeResortes = 0.2;
float elasticidadDeResortes = 0.1;

//---------------------------------------------------------------------------
void setup() { 
  size(600, 600);
  smooth();

  // creando el ambiente virtual de la simulación
  mundoVirtual = new ParticleSystem(0.01, 0.001); // (0.3, 0.001) gravedad y friccion
  
  // inicializando la matris bidimensional
  arrayDeParticulas = new Particle[cantidadDeParticulasPorLado][cantidadDeParticulasPorLado];
  // usando la mitad del espacio se define la distancia que separa a las partículas
  float pasoEnX = (float) ((width / 2) / cantidadDeParticulasPorLado);
  float pasoEnY = (float) ((height / 2) / cantidadDeParticulasPorLado);
  
  // making particles & horizontal springs
  for (int i = 0; i < cantidadDeParticulasPorLado; i++) {
    for (int j = 0; j < cantidadDeParticulasPorLado; j++) {
      arrayDeParticulas[i][j] = mundoVirtual.makeParticle(0.2, (width/4) + j * pasoEnX, 20 + i * pasoEnY, 0.0); // ( float mass, float x, float y, float z )
      if (j > 0) mundoVirtual.makeSpring(arrayDeParticulas[i][j - 1], arrayDeParticulas[i][j], durezaDeResortes, elasticidadDeResortes, pasoEnX);
    }
  }
  // making vertical springs
  for (int j = 0; j < cantidadDeParticulasPorLado; j++){
    for (int i = 1; i < cantidadDeParticulasPorLado; i++){
      mundoVirtual.makeSpring(arrayDeParticulas[i - 1][j], arrayDeParticulas[i][j], durezaDeResortes, elasticidadDeResortes, pasoEnY);
    }
  }
  // declaring fixed particles
  arrayDeParticulas[0][0].makeFixed();
  arrayDeParticulas[0][cantidadDeParticulasPorLado - 1].makeFixed();


} // end setup()



// ---------------------------------------------------------------------------------
void draw() { 
  background(64); // gris 25%
  noStroke();
  mundoVirtual.tick();// reloj del mundo virtual
  
  // draw rects
  fill(#689DBC, 150); // color celeste
  for (int j = 0; j < cantidadDeParticulasPorLado-1; j++) {
    for (int i = 0; i < cantidadDeParticulasPorLado-1; i++) {
      beginShape();
      vertex(arrayDeParticulas[i][j].position().x(), arrayDeParticulas[i][j].position().y());
      vertex(arrayDeParticulas[i+1][j].position().x(), arrayDeParticulas[i+1][j].position().y());
      vertex(arrayDeParticulas[i+1][j+1].position().x(), arrayDeParticulas[i+1][j+1].position().y());
      vertex(arrayDeParticulas[i][j+1].position().x(), arrayDeParticulas[i][j+1].position().y());
      vertex(arrayDeParticulas[i][j].position().x(), arrayDeParticulas[i][j].position().y());
      endShape();
    }
  }
  
}  // end draw





// inputs ---------------------------------------------------------------------------------
void mouseDragged () {
  arrayDeParticulas[0][cantidadDeParticulasPorLado - 1].position().set(mouseX, mouseY, 0);
}

void mouseReleased() {
  arrayDeParticulas[0][cantidadDeParticulasPorLado - 1].position().set(mouseX, mouseY, 0);
}

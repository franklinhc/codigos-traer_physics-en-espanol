/*
simple péndulo con la biblioteca traer.physics (http://murderandcreate.com/physics/)
 
 ph.d. franklin hernández-castro | tec costa rica | HfG gmuend | junio 2022
 www.skizata.com
 */

import traer.physics.*;

ParticleSystem mundoVirtual; // ambiente de la simulación
Particle clavo, pendulo; // punto de donde cuelga el péndulo y so peso
Spring hilo; // "hilo" o resorte del que cuelga el péndulo


//---------------------------------------------------------------------------
void setup() { 
  size(600, 600);
  smooth();

  mundoVirtual = new ParticleSystem(0.3, 0); // (0.3, 0.001) gravedad y friccion

  // Particle makeParticle( float mass, float x, float y, float z )
  clavo = mundoVirtual.makeParticle(1, width/2, 150, 0);
  clavo.makeFixed();

  pendulo = mundoVirtual.makeParticle(1, 25, 250, 0);

  //makeSpring( Particle a, Particle b, float strength, float damping, float restLength )
  hilo = mundoVirtual.makeSpring(clavo, pendulo, 0.1, 0.1, 292 );
} // end setup()



//---------------------------------------------------------------------------
void draw() {
  background(64); // gris 25%
  mundoVirtual.tick(); // reloj del mundo virtual

  // pregunta sobre las posiciones en ese momento de las dos partículas
  float clavoX, clavoY, penduloX, penduloY;
  penduloX = pendulo.position().x();
  penduloY = pendulo.position().y();
  clavoX = clavo.position().x();
  clavoY = clavo.position().y();

  // dibujando el hilo
  stroke(128);
  line(clavoX, clavoY, penduloX, penduloY);
  

  // dibujando las dos partículas
  noStroke();
  fill(#689DBC); // color celeste
  ellipse(clavoX, clavoY, 10, 10);
  fill(#FCC703); // color mostaza
  ellipse(penduloX, penduloY, 20, 20);
  
} // end draw()

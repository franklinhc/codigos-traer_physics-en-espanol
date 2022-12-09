/*
ejercicio con la biblioteca traer.physics (http://murderandcreate.com/physics/)

 ph.d. franklin hernández-castro | tec costa rica | HfG gmuend | junio 2022
 www.skizata.com
 */


import traer.physics.*;
Particle mouse;            // particle on mouse position
Particle[] particles;      // the moving particle
Particle[] orgParticles;   // original particles - fixed
Spring [] mySprings;
ParticleSystem myParticleSystem;    // the particle system

// initial parameters
int nodesCount = 200;
float gridSizeX, gridSizeY, gapX, gapY, border;
int radio; // point size
boolean cortina= false;

void setup() { //---------------------------------------------------------------------------
  size(640, 600);
  smooth();
  border = 40;
  radio = height/4;

  myParticleSystem = new ParticleSystem(0.0, 0.03); // 0,0.05

  mouse = myParticleSystem.makeParticle(1, width/2, height/2, 0);            // create a particle for the mouse
  mouse.makeFixed();                         // don't let forces move it
  particles    = new Particle[nodesCount]; // particle array
  orgParticles = new Particle[nodesCount]; // fixed particle array
  mySprings = new Spring [nodesCount]; // spring array

  mouseX =width/2;
  mouseY =height/2;
  float gradStep = TWO_PI / nodesCount;

  for (int x=0; x<nodesCount; x++) {    
    float xPos =  width/2 + radio * sin (x*gradStep) ;
    float yPos = height/2 + radio * cos (x*gradStep);

    particles[x]    = myParticleSystem.makeParticle(0.8, xPos, yPos, 0);
    orgParticles[x] = myParticleSystem.makeParticle(0.8, xPos, yPos, 0);
    orgParticles[x].makeFixed();
    // making springs between both arrays
    mySprings[x]= myParticleSystem.makeSpring(particles[x], orgParticles[x], 0.2, 0.1, 80 );
    // make interaction between mouse and particles
    myParticleSystem.makeAttraction(particles[x], mouse, 100000, 500); // 50000, 100
  }
} // end setup

void draw() { //--------------------------------------------------------------------------
  background(64); // gris 25%

  myParticleSystem.tick();
  mouse.position().set(mouseX, mouseY, 0 ); // tracking mouse

  float posx, posy;

  for (int x=0; x<nodesCount; x++) {         // go through all rows
    posx = particles[x].position().x();
    posy = particles[x].position().y();
    fill(#689DBC);
    fill(#FCC703); // color mostaza
    noStroke();
    ellipse(posx, posy, 4, 4);
  } // end ciclos for

  // drawing springs
  for (int n =0; n < mySprings.length; n++) {
    float x1 = mySprings[n].getOneEnd().position().x();
    float y1 = mySprings[n].getOneEnd().position().y();
    float x2 = mySprings[n].getTheOtherEnd().position().x();
    float y2 = mySprings[n].getTheOtherEnd().position().y();
    stroke(#689DBC);
    line (x1, y1, x2, y2);
  }
} // end draw

//--------------------------------------------------------------------------

void keyPressed () {
  //cortina=!cortina;
  //setup();
}

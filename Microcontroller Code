#include <SoftwareSerial.h>  // libreria que permite establecer pines digitalespara comunicacion serie
SoftwareSerial miBT(10, 11);  // pin 10 como RX, pin 11 como TX

#include <AccelStepper.h>
AccelStepper ejeX(1, 3, 4); // pin 3 = step, pin 4 = direction
AccelStepper ejeY(1, 5, 6); // pin 5 = step, pin 6 = direction

char DATO = 0;
int tramo1=0;
int tramo2=0;
int tramo3=0;
int tramo4=0;
int tramo5=0;

int postemporalx;
int postemporaly;
int objtemporalx;
int objtemporaly;

int movimiento_automatico=0;
int pare=0;

int helice_usuario=500;
int flujo_usuario=500;
int rodillo_usuario=500;

float helice=0;
float control_motor_1 = 0;
float control_motor_2 = 0;
float posicion_motor_1 = 0;
float posicion_motor_2 = 0;
float flujo = 0;
float velocidad_del_rodillo = 0;
char control_motor_1_text[30];
char control_motor_2_text[30];
char posicion_motor_1_text[30];
char posicion_motor_2_text[30];
char flujo_text[30];
char velocidad_del_rodillo_text[30];

int contador=0;

int altura=530;
int ancho=265;

void setup() {
  miBT.begin(38400);    // comunicacion serie entre Arduino y el modulo a 38400 bps
  Serial.begin(115200);
  Serial1.begin(115200);
  ejeX.setAcceleration(20);
  ejeY.setAcceleration(20);
  ejeX.setMaxSpeed(200);
  ejeY.setMaxSpeed(200);
  ejeX.setMinPulseWidth(20);
  ejeY.setMinPulseWidth(20);
}

void loop() {

  if (miBT.available()){      // si hay informacion disponible desde modulo
    DATO = http://miBT.read();   // almacena en DATO el caracter recibido desde modulo
    if( DATO == 'A' ) {  
        movimiento_automatico=1;
    }
    if( DATO == 'B' ) {
        parar();
    }
    if( DATO == 'C' ) {
        arriba();
    }
    if( DATO == 'D' ) {
        abajo();
    }
    if( DATO == 'E' ) {
        izquierda();
    }
    if( DATO == 'F' ) {
        derecha();
    }

    if( DATO == 'M' ) {
        home();
    }
    if( DATO == 'I' ) {
        helice_usuario=helice_usuario+10;
        flujo=flujo_usuario;
        velocidad_del_rodillo=rodillo_usuario;
        helice=helice_usuario;
    }
    if( DATO == 'J' ) {
        helice_usuario=helice_usuario-10;
        flujo=flujo_usuario;
        velocidad_del_rodillo=rodillo_usuario;
        helice=helice_usuario;
    }
    if( DATO == 'G' ) {
        flujo_usuario=flujo_usuario+10;
        flujo=flujo_usuario;
        velocidad_del_rodillo=rodillo_usuario;
        helice=helice_usuario;
    }

    if( DATO == 'H' ) {
        flujo_usuario=flujo_usuario-10;
        flujo=flujo_usuario;
        velocidad_del_rodillo=rodillo_usuario;
        helice=helice_usuario;
    }
    if( DATO == 'K' ) {
        rodillo_usuario=rodillo_usuario+10;
        flujo=flujo_usuario;
        velocidad_del_rodillo=rodillo_usuario;
        helice=helice_usuario;
    }

    if( DATO == 'L' ) {
        rodillo_usuario=rodillo_usuario-10;
        flujo=flujo_usuario;
        velocidad_del_rodillo=rodillo_usuario;
        helice=helice_usuario;
    }
  }
  
  automatico();

    http://ejeX.run();
    http://ejeY.run();

  control_motor_1= ejeX.targetPosition();
  control_motor_2= ejeY.targetPosition();
  posicion_motor_1= ejeX.currentPosition();
  posicion_motor_2 =ejeY.currentPosition();
  dtostrf(control_motor_1, 10, 10, control_motor_1_text);
  dtostrf(control_motor_2, 10, 10, control_motor_2_text);
  dtostrf(posicion_motor_1, 10, 10, posicion_motor_1_text);
  dtostrf(posicion_motor_2, 10, 10, posicion_motor_2_text);
  dtostrf(flujo, 10, 10, flujo_text);
  dtostrf(velocidad_del_rodillo, 10, 10, velocidad_del_rodillo_text);
  char text[187];
  snprintf(text, 187, "%s,%s,%s,%s,%s,%s", control_motor_1_text, control_motor_2_text, posicion_motor_1_text, posicion_motor_2_text, flujo_text, velocidad_del_rodillo_text);
  Serial.println(text);

contador=contador+1;

if (contador==50){
  contador=0;
  Serial1.print(control_motor_1); 
  Serial1.print(" ");
  Serial1.print(posicion_motor_1); 
  Serial1.print(" ");
  Serial1.print( control_motor_2); 
  Serial1.print(" ");
  Serial1.print(posicion_motor_2); 
  Serial1.print(" ");
  Serial1.print(flujo); 
  Serial1.print(" ");
  Serial1.print(velocidad_del_rodillo);
  Serial1.print(" ");
  Serial1.println(helice);  

  }
}

void home(){

      flujo=0;
      velocidad_del_rodillo=0;
      helice=0;

      ejeX.setAcceleration(50);
      ejeY.setAcceleration(50);
      tramo1=0;
      tramo2=0;
      tramo3=0;
      tramo4=0;
      tramo5=0;
      movimiento_automatico=0;
      ejeX.moveTo(0);
      ejeY.moveTo(0);
      pare=0;
  
  }

void automatico(){

  if(movimiento_automatico==1){

    flujo=flujo_usuario;
    velocidad_del_rodillo=rodillo_usuario;
    helice=helice_usuario;

    if(pare==1){
    ejeX.setCurrentPosition(postemporalx); 
    ejeY.setCurrentPosition(postemporaly);
    ejeX.moveTo(objtemporalx);
    ejeY.moveTo(objtemporaly);
    pare=0;
    
    }
//
      ejeX.setAcceleration(20);
      ejeY.setAcceleration(20);

      if (tramo1==0 && tramo2==0 && tramo3==0 && tramo4==0 && tramo5==0){
    
      tramo1=1;
      ejeY.moveTo(altura);
    
      }
      if (ejeY.distanceToGo()==0 && tramo1==1 && tramo2==0 && tramo3==0 && tramo4==0 && tramo5==0){

      tramo1=0;
      tramo2=1;
      ejeX.moveTo(ancho/2);
  
      }
      if (ejeX.distanceToGo()==0 && tramo1==0 && tramo2==1 && tramo3==0 && tramo4==0 && tramo5==0){

      tramo2=0;
      tramo3=1;
      ejeY.moveTo(0);
  
      }
      if (ejeY.distanceToGo()==0 && tramo1==0 && tramo2==0 && tramo3==1 && tramo4==0 && tramo5==0){

      tramo3=0;
      tramo4=1;
      ejeX.moveTo(ancho);
  
      }
      if (ejeX.distanceToGo()==0 && tramo1==0 && tramo2==0 && tramo3==0 && tramo4==1 && tramo5==0){

      tramo4=0;
      tramo5=1;
      ejeY.moveTo(altura);
  
      }
      if (ejeY.distanceToGo()==0 && tramo1==0 && tramo2==0 && tramo3==0 && tramo4==0 && tramo5==1){

      home();
  
      }
    }
  
  }

  void parar(){

    flujo=0;
    velocidad_del_rodillo=0;
    helice=0;
    
    pare=1;
    movimiento_automatico=0;

      ejeX.setAcceleration(1000);
      ejeY.setAcceleration(1000);
    
    postemporalx=ejeX.currentPosition();
    postemporaly=ejeY.currentPosition();
    objtemporalx= ejeX.targetPosition();
    objtemporaly= ejeY.targetPosition();
    
    ejeX.moveTo(ejeX.currentPosition());
    ejeY.moveTo(ejeY.currentPosition());
    
    http://ejeX.run();
    http://ejeY.run();
    
    }

   void arriba(){

    flujo=flujo_usuario;
    velocidad_del_rodillo=rodillo_usuario;
    helice=helice_usuario;
      
    movimiento_automatico=0;
    pare=0;

    tramo1=0;
    tramo2=0;
    tramo3=0;
    tramo4=0;
    tramo5=0;
    
    ejeY.moveTo(ejeY.currentPosition()+10);
    ejeX.setAcceleration(100);
    ejeY.setAcceleration(100);
      
    }
   void abajo(){

    flujo=flujo_usuario;
    velocidad_del_rodillo=rodillo_usuario;
    helice=helice_usuario;
      
    movimiento_automatico=0;
    pare=0;
//
    
    tramo1=0;
    tramo2=0;
    tramo3=0;
    tramo4=0;
    tramo5=0;
    
    ejeY.moveTo(ejeY.currentPosition()-10);
    ejeX.setAcceleration(100);
    ejeY.setAcceleration(100);
      
    }
   void izquierda(){

    flujo=flujo_usuario;
    velocidad_del_rodillo=rodillo_usuario;
    helice=helice_usuario;
      
    movimiento_automatico=0;
    pare=0;

    tramo1=0;
    tramo2=0;
    tramo3=0;
    tramo4=0;
    tramo5=0;
    
    ejeX.moveTo(ejeX.currentPosition()-10);
    ejeX.setAcceleration(100);
    ejeY.setAcceleration(100);
      
    }
    void derecha(){

    flujo=flujo_usuario;
    velocidad_del_rodillo=rodillo_usuario;
    helice=helice_usuario;
      
    movimiento_automatico=0;
    pare=0;

    tramo1=0;
    tramo2=0;
    tramo3=0;
    tramo4=0;
    tramo5=0;
    
    ejeX.moveTo(ejeX.currentPosition()+10);
    ejeX.setAcceleration(100);
    ejeY.setAcceleration(100);
      
    }

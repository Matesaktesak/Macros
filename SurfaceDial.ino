#include "HID-Project.h"

// input pins for encoder channel A and channel B
int pinA = 0;
int pinB = 1;

// input pin for pushbutton
int pinButton = 2;

volatile bool previousButtonValue = false;

volatile int previous = 0;
volatile int counter = 0;

void setup() {
  pinMode(pinA, INPUT); 
  pinMode(pinB, INPUT);

  pinMode(pinButton, INPUT);

  attachInterrupt(digitalPinToInterrupt(pinA), changed, CHANGE); 
  attachInterrupt(digitalPinToInterrupt(pinB), changed, CHANGE);
  
  SurfaceDial.begin();
  Serial.begin(9600);
}

void changed() {
  int A = digitalRead(pinA); 
  int B = digitalRead(pinB);

  int current = (A << 1) | B;
  int combined  = (previous << 2) | current;
   
  if(combined == 0b0010 || 
     combined == 0b1011 ||
     combined == 0b1101 || 
     combined == 0b0100) {
    counter++;
  }
   
  if(combined == 0b0001 ||
     combined == 0b0111 ||
     combined == 0b1110 ||
     combined == 0b1000) {
    counter--;
  }
  delay(10);
  previous = current;
}

void loop(){ 
  bool buttonValue = digitalRead(pinButton);
  if(buttonValue != previousButtonValue){
    if(!buttonValue) {
      SurfaceDial.press();
      Serial.println("pressed");
    } else {
      SurfaceDial.release();
      Serial.println("released");
    }    
    previousButtonValue = buttonValue;
    delay(30);
  }

  if(counter >= 1) {
    SurfaceDial.rotate(-10);
    Serial.println("cclock");
    counter -= 1;
  } else if(counter <= -1) {
    SurfaceDial.rotate(10);
    Serial.println("clock");
    counter += 1;
  } 
}

#include <LiquidCrystal.h>

const int button1Pin = 10;
const int button2Pin = 9;

const int MAX_SCREEN = 2;

LiquidCrystal lcd(12, 11, 5, 4, 3, 2);

int buttonState1 = 0;
int buttonState2 = 0;

int buttonOpen1 = 0;
int buttonOpen2 = 0;

int currentScreen = 0;
int timesWrite = 0;

void setup(){
  pinMode(button1Pin, INPUT);
  pinMode(button2Pin, INPUT);
  
  lcd.begin(16, 2);
  writeScreen(0);
  
}

void loop(){
  buttonState1 = digitalRead(button1Pin);
  buttonState2 = digitalRead(button2Pin);
 
 if( buttonState1 == HIGH){
   if(buttonOpen1 == 0){
     buttonOpen1 = 1;
     currentScreen = currentScreen + 1;
     if(currentScreen > MAX_SCREEN ){
       currentScreen = 0;
     }
     writeScreen(currentScreen); 
   }  
 } else{
   buttonOpen1 = 0;
 }
 
 if( buttonState2 == HIGH ){
   if(buttonOpen2 == 0){
     buttonOpen2 = 1;
     currentScreen = currentScreen - 1;
     if(currentScreen < 0){
       currentScreen = MAX_SCREEN;
     }
     writeScreen(currentScreen);  
   }
 }else{
   buttonOpen2 = 0;
 }
}

void Router(int pin){
 
 //Buttons 
 
 //If( gameMode == )
     //buttons
     //if(pin, and not pressed
  
  
  
  
}

void writeScreen(int i){
  timesWrite = timesWrite + 1;
  lcd.setCursor(0, 0);
  if(i == 0){
     lcd.print("Screen 0!");
  } else if( i == 1){
      lcd.print("Screen 1!");
  } else if(i == 2){
      lcd.print("Screen 2!");
  }
  lcd.setCursor(0,1);
  lcd.print(timesWrite);
}

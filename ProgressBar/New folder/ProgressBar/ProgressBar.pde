#include <LiquidCrystal.h>

LiquidCrystal lcd(12, 11, 5, 4, 3, 2);

byte prog0[8] = { B00000,B00000,B00000,B00000,
	            B00000,B00000,B00000,B00000};
byte prog1[8] = { B10000,B10000,B10000,B10000,
	            B10000,B10000,B10000,B10000};
byte prog2[8] = { B11000,B11000,B11000,B11000,
	            B11000,B11000,B11000,B11000};
byte prog3[8] = { B11100,B11100,B11100,B11100,
	            B11100,B11100,B11100,B11100};
byte prog4[8] = { B11110,B11110,B11110,B11110,
	            B11110,B11110,B11110,B11110};
byte prog5[8] = { B11111,B11111,B11111,B11111,
	            B11111,B11111,B11111,B11111};


const int CTRL_PIN = 10;
boolean ctrlPressed = false;

const int RESET_PIN = 9;
boolean resetPressed = false;

boolean runProgress = false;
int progressCount;

long previousMillis = 0; 
long interval = 75; 

int startX = 0;
int startY = 0;
int length = 10;


void setup(){  
  lcd.createChar(0, prog0);
  lcd.createChar(1, prog1);
  lcd.createChar(2, prog2);
  lcd.createChar(3, prog3);
  lcd.createChar(4, prog4);
  lcd.createChar(5, prog5);  
  
  pinMode(CTRL_PIN, INPUT);
  pinMode(RESET_PIN, INPUT);
  lcd.begin(16,2);  
  
  ResetProgress();
  
  lcd.setCursor(0,1);
  lcd.print("Progress Bar Yo");
  
  
}

void loop(){
  
  if(digitalRead(CTRL_PIN) == HIGH){
    if(!ctrlPressed){
     ctrlPressed = true;
     //toggle running the progress bar or not
     runProgress = !runProgress;
    }
  }else if(ctrlPressed){
   ctrlPressed = false;
  }
  
  if(digitalRead(RESET_PIN) == HIGH){
    if(!resetPressed){
     resetPressed = true;
     //reset the progress bar
     ResetProgress();
     runProgress = false;
    }
  }else if(resetPressed){
   resetPressed = false;
  } 
  
  if( runProgress){
    unsigned long currentMillis = millis();
    if(currentMillis - previousMillis > interval) {
      previousMillis = currentMillis; 
      CountDown(1);
    }        
  }  
}

void ResetProgress(){
 
  progressCount = length * 5;
  
  for(int i = 0; i <length; i++){
    lcd.setCursor(startX + i, startY);
    lcd.write(5);
  }  
}

void CountDown(int dmg){

  for( int i = dmg; i> 0; i--){
    progressCount = progressCount -1;
    if(progressCount >= 0){      
      lcd.setCursor(startX + progressCount / 5, startY);
      lcd.write(progressCount % 5);
    }
  }
  
}

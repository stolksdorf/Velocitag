#include <LiquidCrystal.h>
#include "Progress.h"
#include "Button.h"





LiquidCrystal lcd(12, 11, 5, 4, 3, 2);

Progress bar(0,0,10);

Button ctrl(10);
Button reset(9);

boolean runProgress = false;

long previousMillis = 0; 
long interval = 75; 

void setup(){
	lcd.begin(16,2);
	
	bar.SetLCD(lcd);
	bar.Reset();
}

void loop(){

	if(ctrl.Pressed()){
		runProgress = !runProgress;
                lcd.print("awesome!");
	}
	
	if(reset.Pressed()){
//		bar.Reset();
		runProgress = false;
	}
	
	if(runProgress){
		unsigned long currentMillis = millis();
		if(currentMillis - previousMillis > interval) {
			previousMillis = currentMillis; 
//			bar.Update(-1);
		}
	}
}

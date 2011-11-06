#include <LiquidCrystal.h>

//http://www.arduino.cc/en/Hacking/LibraryTutorial

#include "WProgram.h"
#include "Progress.h"



//Build the partial display segments
byte seg0[8] = { B00000,B00000,B00000,B00000,
	            B00000,B00000,B00000,B00000};
byte seg1[8] = { B10000,B10000,B10000,B10000,
	            B10000,B10000,B10000,B10000};
byte seg2[8] = { B11000,B11000,B11000,B11000,
	            B11000,B11000,B11000,B11000};
byte seg3[8] = { B11100,B11100,B11100,B11100,
	            B11100,B11100,B11100,B11100};
byte seg4[8] = { B11110,B11110,B11110,B11110,
	            B11110,B11110,B11110,B11110};
byte seg5[8] = { B11111,B11111,B11111,B11111,	           
                    B11111,B11111,B11111,B11111};


Progress::Progress(int x, int y, int progSize){
	_x = x;
	_y = y;
	_size = progSize;
}

//Resets the progress bar at full
void Progress::Reset(){
  for(int i = 0; i <_size; i++){
    _lcd.setCursor(_x + i, _y);
    _lcd.write(5);
  }
  _value = _size * 5;
}

//Zeroes out the Progress bar 
void Progress::Clear(){
  for(int i = 0; i <_size; i++){
    _lcd.setCursor(_x+ i, _y);
    _lcd.write(0);
  }
  _value = 0;
}

//Provides a LiquidCrystal object for our library
void Progress::SetLCD(LiquidCrystal &lcd){
	_lcd = &lcd;
	_lcd.createChar(0, seg0);
	_lcd.createChar(1, seg1);
	_lcd.createChar(2, seg2);
	_lcd.createChar(3, seg3);
	_lcd.createChar(4, seg4);
	_lcd.createChar(5, seg5);
}

void Progress::Update(int amount){
  for(int i = abs(amount); i> 0; i--){
    _value = _value + amount/abs(amount);
    if(_value >= 0 || _value <= _size*5){      
      _lcd.setCursor(_x + _value / 5, _y);
      _lcd.write(_value % 5);
    }
  }
}

int Progress::Value(){
	return _value;
}


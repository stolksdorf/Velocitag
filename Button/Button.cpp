#include "Button.h"

Button::Button(int pin){
	_pin = pin;
	_btnDown = false;
	pinMode(_pin, INPUT);
}

boolean Button::Pressed(){
	if(digitalRead(_pin) == HIGH){
		if(!_btnDown){
			_btnDown = true;
			return true;
		}
	}else if(_btnDown){
		_btnDown = false;
	}
	return false;
}
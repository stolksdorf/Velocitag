#ifndef Button_H
#define Button_H

#include <WProgram.h>

class Button {
	public:
		Button(int pin);
                boolean Pressed();
	private:
		int _pin;
		boolean _btnDown;
};
#endif

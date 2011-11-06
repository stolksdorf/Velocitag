/*
  Progress.h 
  A header for easily creating a manipulating 
  progress bars on the screen
*/
#ifndef Progress_h
#define Progress_h

#include "WProgram.h"
#include <LiquidCrystal.h>

class Progress
{
  public:
    Progress(int x, int y, int size);
    void Clear();
    void Reset();
    void SetLCD(LiquidCrystal lcd);
    void Update(int amount);
    int Value();
  private:
    LiquidCrystal _lcd;
    int _x;
    int _y;
    int _size;
    int _value;
    byte seg0;
    byte seg1;
    byte seg2;
    byte seg3;
    byte seg4;
    byte seg5;
};

#endif

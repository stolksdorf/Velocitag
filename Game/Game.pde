#include <LiquidCrystal.h>
#include "Button.h"

//GUN STATS
char gunName[] = "Big Bad Bow"; //max of 12 char
char gunOwner[] = "Katie"; //max of 9 char
int maxHealth = 130; 
int fireRate = 4300;
int damage = 120;
int reloadSpeed = 1300;
int clipSize = 15;
int gunType = 6; 
int burstCount = 1; //0 - auto, 1 - single shot, X - burst fire

//Buttons!
Button reload(9);
Button trigger(8);
Button onHit(10);

//Constants!
const char * GUN_TYPES[] = {"SMG", "RIFLE", "ASSLT", "SHTGN", "SNPR" ,"PSTL" , "BOW"};
const int MAX_TEAMS = 4;


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

//Setup Variables
int time = 10;
int team = 4;
LiquidCrystal lcd(12, 11, 5, 4, 3, 2);
int timerMinutes;
int timerSeconds;
int bullets;
int health;
boolean gamePlaying = true;
//int gameState = 1 ; //0 - pre-game, 1 - playing, 2 - reloading, 3 - Game Over, 

//progressbar variables
int pbSize = 12;
int pbValue = 12*5;

//Simple function to save a bunch of lines
void lcdp(int x, int y, char str[]){
    lcd.setCursor(x,y);
    lcd.print(str);
}
void lcdp(int x, int y, int str){
    lcd.setCursor(x,y);
    lcd.print(str);
}

void gameTimeOut(){
    gamePlaying = false;
    lcd.clear();
    lcdp(0,0,"Time's Up!");    
}

void gameOver(){
    gamePlaying = false;
    lcd.clear();
    lcdp(0,0,"Game Over!!");
}

void setup(){
	lcd.begin(16,2);

        //Load in custom characters for progress bars
        lcd.createChar(0, seg0);
	lcd.createChar(1, seg1);
	lcd.createChar(2, seg2);
	lcd.createChar(3, seg3);
	lcd.createChar(4, seg4);
	lcd.createChar(5, seg5);

        timerMinutes = time;
        timerSeconds = 0;    
        health = maxHealth;            
        bullets = clipSize;             
	drawGameScreen();  
}

long last =0;


long blinkLast = 0;
int blinkDelay = 500;
boolean blinkState = true;

boolean blinkClip = false;
boolean blinkTimer = false;
boolean blinkHealth = false;

void loop(){
    if(gamePlaying){
           //blink stuff that needs blinking
           if(millis() - blinkLast >= blinkDelay){
               blinkLast = millis();   
               blinkState = !blinkState;
               
               if(blinkTimer) toggleTimer(blinkState);
               if(blinkClip) toggleClip(blinkState);
               if(blinkHealth) toggleHealth(blinkState);
           }
           
           //Pull trigger
           if(trigger.Pressed()){
               //Add the fire rate code and fire type code
              updateClip(-1);
           }
           
           //Reload the gun
           if(reload.Pressed()){
               //Add the reload timer
              updateClip(clipSize);
           }
           
           //Ouch! Got hit!
           if(onHit.Pressed()){
               sensorHit(11);
           }   
            
           //Update Timer
           if(millis() - last >= 1000){
               last = millis();
               updateTimer(-1);
           }    
     }
}

void drawGameScreen(){   
    //draw team if it exists
    if(team != 0){
        lcdp(7,1,"T");
        lcdp(8,1, team);
    }
    toggleClip(true);
    toggleTimer(true);
    toggleHealth(true);   
    updateHealth(0);
}

void updateTimer(int val){    
    timerSeconds = timerSeconds + val;
    if(timerSeconds == -1){
       timerMinutes--;
       timerSeconds = 59;
    }            
    if(timerMinutes == 0 && timerSeconds < 30) blinkTimer = true;
    //Draw the timer
    if(timerMinutes < 10){
       lcdp(11,1," ");
       lcd.print(timerMinutes);
    } else lcdp(11,1,timerMinutes);
    
    if(timerSeconds < 10){
        lcdp(14,1,"0");
        lcd.print(timerSeconds);
    } else {
        lcdp(14,1,timerSeconds);
    }   
    
    //Time Out!!!!
    if(timerSeconds == 0 && timerMinutes == 0){
        gameTimeOut();
    }
}

void toggleTimer(boolean state){
    if(state){
        lcdp(13,1,":"); 
        updateTimer(0);
    } else lcdp(11,1,"     ");
}

void sensorHit(int damage){
    updateHealth(damage);    
}

void updateHealth(int damage){
  health = health - damage;
  if(health <= 0 ) gameOver();
  if(health > maxHealth) health = maxHealth;
  
  //blinks the health if it's less then 20%
  blinkHealth = health * 10 / maxHealth <= 2;
  
  lcdp(0,0,"   ");
  lcdp(0,0,health);  
  
  //update the progress bar
  int amount = (pbSize * 5 * health) / maxHealth;   
  for(int i = 0; i < pbSize; i++){    
    lcd.setCursor(4 + i, 0);
    if(amount >= 5) lcd.write(5);
    else if(amount <= 0) lcd.write(0);
    else lcd.write(amount % 5);    
    amount -=5;
  }    
}

void toggleHealth(boolean state){
    if(state) lcdp(0,0,health);
    else lcdp(0,0,"    ");
}

void updateClip(int val){
    bullets = bullets + val;
    if(bullets < 0) bullets = 0;
    if(bullets > clipSize) bullets = clipSize;
    
    //Fix some artifacts
    if(bullets<10) lcdp(4,1," ");
    
    //Blinks your ammo count it is dips below 20%
    if(bullets * 10 /clipSize <= 2) blinkClip = true;
    else blinkClip = false;
    
    lcdp(0,1,bullets);    
    lcd.print("/");
    lcd.print(clipSize);
}

void toggleClip(boolean state){
    if(state){
        lcdp(0,1,bullets);    
        lcd.print("/");
        lcd.print(clipSize);
    } else lcdp(0,1,"     ");
}

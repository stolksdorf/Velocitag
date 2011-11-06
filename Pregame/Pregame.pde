#include <LiquidCrystal.h>
#include "Button.h"

//GUN STATS
char gunName[] = "Vera"; //max of 12 char
char gunOwner[] = "Skaught"; //max of 9 char
int health = 120; 
int fireRate = 80;
int damage = 3;
int reloadSpeed = 4300;
int clipSize = 80;
int gunType = 0; 
int burstCount = 0; //0 - auto, 1 - single shot, X - burst fire

//Buttons!
Button ctrlUp(9);
Button ctrlDown(8);
Button trigger(10);

//Constants!
const int MAX_TIME = 30;
const int MIN_TIME = 5;
const int TIME_INCREMENT = 5;
const int START_TIME = 10;
const char * GUN_TYPES[] = {"SMG", "RIFLE", "ASSLT", "SHTGN", "SNPR" ,"PSTL" , "BOW"};
const int MAX_TEAMS = 4;

//Screens
const int STATS = 0;
const int TIME = 1;
const int TEAM = 2;
const int CONFIRM = 3;

//Setup Variables
int screen = 0;
int time = START_TIME;
int team = 0;
int statScreen = 0;
boolean confirmSelected = false;
LiquidCrystal lcd(12, 11, 5, 4, 3, 2);

//Simple function to save a bunch of lines
void lcdp(int x, int y, char str[]){
    lcd.setCursor(x,y);
    lcd.print(str);
}
void lcdp(int x, int y, int str){
    lcd.setCursor(x,y);
    lcd.print(str);
}

void setup(){
	lcd.begin(16,2);
	drawStatScreen(0);
}


void loop(){
	if(ctrlUp.Pressed()){
		if(screen == TIME){
			updateTimer(TIME_INCREMENT);
		} else if(screen == TEAM){
			updateTeam(1); 
		} else if(screen == STATS){
			statScreen++;
			drawStatScreen(statScreen % 3);
		}else if (screen == CONFIRM){
			updateConfirm(!confirmSelected);
		}
	}

	if(ctrlDown.Pressed()){
		if(screen == TIME){
			updateTimer(-TIME_INCREMENT);
		} else if(screen == TEAM){
			updateTeam(-1); 
		} else if(screen == STATS){
			statScreen--;
			drawStatScreen(statScreen % 3);
		} else if (screen == CONFIRM){
			updateConfirm(!confirmSelected);
		}
	}
  
	if(trigger.Pressed()){
		statScreen = 0; //Reset the stats screen to the name/owner one		
		//Check to see if the player wants to begin the game
		if(screen == CONFIRM && confirmSelected){
			//Start Screen!
			lcd.clear();
			lcd.print("GO GO GO GO");
		}else{ //If not move to the next screen
			confirmSelected = false;
			screen = (screen + 1) % 4;
		}

		if(screen == STATS){
			drawStatScreen(statScreen);
		} else if(screen == TIME){
			drawTimerScreen();
		} else if(screen == TEAM){
			drawTeamScreen();
		} else if(screen == CONFIRM & !confirmSelected){
			drawConfirmScreen();
		}
	}  
}

////TEAM SCREEN
void drawTeamScreen(){
  lcd.clear();
  lcdp(0,0,"Set Team");  
  updateTeam(0); 
}

void updateTeam(int val){
	team = (team + val) % (MAX_TEAMS + 1);
	//Draw team number to screen
	if(team == 0){
		lcdp(2,1,"Death Match!");
	} else{
                lcdp(2,1 ,"   Team     ");
		lcdp(10,1,team);
	}
}

///TIMER SCREEN

void drawTimerScreen(){
	lcd.clear();
	lcdp(0,0,"Set Time Limit");
	lcdp(3,1,"<    min >"); //leave a space to draw the time
	updateTimer(0);  
}

void updateTimer(int val){
        time = time + val;
        if(time < MIN_TIME) time = MAX_TIME;
        else if(time > MAX_TIME) time = MIN_TIME;
        lcdp(5,1,"  "); //removes artifacts
        lcdp(5,1,time);        	
}

//Converts the fire rate (milliseconds between shots) into bullets per second
void printBulletsPerSecond(int fireRate){
        int bullets = 1000/fireRate;
        int decibullets = 10000/fireRate - bullets*10;
        lcd.print(bullets);
        lcd.print(".");
        lcd.print(decibullets);
}

//Takes how long in milliseconds it takes to reload, and converts it into seconds
void printReloadInSeconds(int reloadRate){
    int sec = reloadRate/1000;
    int decisec = reloadRate/100 - sec*10;
    lcd.print(sec);
    lcd.print(".");
    lcd.print(decisec);
}

//STATS SCREEN
void drawStatScreen(int screenNum){
	lcd.clear();
	lcdp(15,1,">");
	if(screenNum == 0){
		lcdp(0,0,"Nme:");
                lcd.print(gunName);
                lcdp(0,1,"Ownr:");
                lcd.print(gunOwner);
	} else if(screenNum == 1){
		lcdp(0,0,"HP:");
                lcd.print(health);
                
                lcdp(7,0,"GUN:");
                lcd.print(GUN_TYPES[gunType]);
                
		lcd.setCursor(0,1);
		if(burstCount == 0){
			lcd.print("FIRE:AUTO");
		}else if(burstCount == 1){
			lcd.print("FIRE:SINGLE");
		} else {
			lcd.print("FIRE:  BURST");
                        lcd.setCursor(5,1);
                        lcd.print(burstCount);
		}
	} else{                
		lcdp(0,0, "ROF:");
                printBulletsPerSecond(fireRate);
                
		lcdp(9,0, "RLD:"); 
                printReloadInSeconds(reloadSpeed);
               
		lcdp(8,1,"MAG:");
                lcd.print(clipSize);
                
		lcdp(0,1,"DMG:");
                lcd.print(damage);
	}
}

//CONFIRM SCREEN
void drawConfirmScreen(){
	lcd.clear();
	lcdp(0,0, "Start Game?  Yes");
	lcdp(0,1,"  min Team   >No");
	lcdp(0,1,time);
        if(team !=0) lcdp(11,1,team);
        else lcdp(6,1,"NoTeam");
}

void updateConfirm(boolean val){
//	if(val != confirmSelected){
		confirmSelected = val;		
		lcd.setCursor(12,0);
		if(val) lcd.print(">");
		else    lcd.print(" ");
		
		lcd.setCursor(13,1);
		if(val) lcd.print(" ");
		else    lcd.print(">");
//	}
}



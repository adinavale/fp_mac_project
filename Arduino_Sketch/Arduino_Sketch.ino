//EE271SP22-Gr#1-Aditya/Deepak/Eric

// include the library code:
#include <LiquidCrystal.h>
//Defines pin assingments on Arduino board from 6 through 10

#define pin6 6
#define pin7 7
#define pin8 8
#define pin9 9
#define pin10 10

// initialize the library by associating any needed LCD interface pin
// with the arduino pin number it is connected to
const int rs = 12, en = 11, d4 = 5, d5 = 4, d6 = 3, d7 = 2;
LiquidCrystal lcd(rs, en, d4, d5, d6, d7);

void setup() {
  // set up the LCD's number of columns and rows:
  lcd.begin(16, 2);

//Assigns pins 6-10 as inputs
    pinMode(6, INPUT);
    pinMode(7,INPUT);
    pinMode(8,INPUT);
    pinMode(9,INPUT);
    pinMode(10,INPUT);
  
}
void loop() {
  //Reset
  if( (digitalRead(pin10) == 0) && (digitalRead(pin9) == 0))
  {
    lcd.setCursor(0, 0);
    lcd.write("         ");
    lcd.setCursor(0, 1);
    lcd.write("Reset    ");
  }

  //SRAM_A
  else if(digitalRead(pin10) == 0 && digitalRead(pin9) == 1) 
  {
    
    lcd.setCursor(0, 0);
    lcd.write("SRAM_A    ");
    lcd.setCursor(0, 1);

    if(digitalRead(pin8) == 0 && digitalRead(pin7) == 0 && digitalRead(pin6) == 0)      { lcd.write("Input#0:  ");}
    else if(digitalRead(pin8) == 0 && digitalRead(pin7) == 0 && digitalRead(pin6) == 1) { lcd.write("Input#1:  ");}
    else if(digitalRead(pin8) == 0 && digitalRead(pin7) == 1 && digitalRead(pin6) == 0) { lcd.write("Input#2:  ");}
    else if(digitalRead(pin8) == 0 && digitalRead(pin7) == 1 && digitalRead(pin6) == 1) { lcd.write("Input#3:  ");}
    else if(digitalRead(pin8) == 1 && digitalRead(pin7) == 0 && digitalRead(pin6) == 0) { lcd.write("Input#4:  ");}
    else if(digitalRead(pin8) == 1 && digitalRead(pin7) == 0 && digitalRead(pin6) == 1) { lcd.write("Input#5:  ");}
    else if(digitalRead(pin8) == 1 && digitalRead(pin7) == 1 && digitalRead(pin6) == 0) { lcd.write("Input#6:  ");}
    else if(digitalRead(pin8) == 1 && digitalRead(pin7) == 1 && digitalRead(pin6) == 1) { lcd.write("Input#7:  ");}   
    
  }
  //SRAM_B
  else if(digitalRead(pin10) == 1 && digitalRead(pin9) == 0) 
  {
    
    lcd.setCursor(0, 0);
    lcd.write("SRAM_B    ");
    lcd.setCursor(0, 1);

    if(digitalRead(pin8) == 0 && digitalRead(pin7) == 0 && digitalRead(pin6) == 0)      { lcd.write("Input#0:  ");}
    else if(digitalRead(pin8) == 0 && digitalRead(pin7) == 0 && digitalRead(pin6) == 1) { lcd.write("Input#1:  ");}
    else if(digitalRead(pin8) == 0 && digitalRead(pin7) == 1 && digitalRead(pin6) == 0) { lcd.write("Input#2:  ");}
    else if(digitalRead(pin8) == 0 && digitalRead(pin7) == 1 && digitalRead(pin6) == 1) { lcd.write("Input#3:  ");}
    else if(digitalRead(pin8) == 1 && digitalRead(pin7) == 0 && digitalRead(pin6) == 0) { lcd.write("Input#4:  ");}
    else if(digitalRead(pin8) == 1 && digitalRead(pin7) == 0 && digitalRead(pin6) == 1) { lcd.write("Input#5:  ");}
    else if(digitalRead(pin8) == 1 && digitalRead(pin7) == 1 && digitalRead(pin6) == 0) { lcd.write("Input#6:  ");}
    else if(digitalRead(pin8) == 1 && digitalRead(pin7) == 1 && digitalRead(pin6) == 1) { lcd.write("Input#7:  ");}   
    
  }
  else if( (digitalRead(pin10) == 1) && (digitalRead(pin9) == 1))
  {
    lcd.setCursor(0, 0);
    lcd.write("         ");
    lcd.setCursor(0, 1);
    lcd.write("Result    ");
  }
  
}

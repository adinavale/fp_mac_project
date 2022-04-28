//EE271SP22-Gr#1-Aditya/Deepak/Eric

// include the library code:
#include <LiquidCrystal.h>
#define pin8 8
#define pin9 9

// initialize the library by associating any needed LCD interface pin
// with the arduino pin number it is connected to
const int rs = 12, en = 11, d4 = 5, d5 = 4, d6 = 3, d7 = 2;
LiquidCrystal lcd(rs, en, d4, d5, d6, d7);

void setup() {
  // set up the LCD's number of columns and rows:
  lcd.begin(16, 2);

  pinMode(8,INPUT);
  pinMode(9,INPUT);
  
}

void loop() {
  
  //Reset
  if( (digitalRead(pin8) == 0) && (digitalRead(pin9) == 0))
  {
    lcd.setCursor(0, 1);
    lcd.write("Reset  ");
  }

  //Input_1
  if( (digitalRead(pin8) == 0) && (digitalRead(pin9) == 1))
  {
    lcd.setCursor(0, 1);
    lcd.write("Input_1  ");
  }

  //Input_2
  if( (digitalRead(pin8) == 1) && (digitalRead(pin9) == 0))
  {
    lcd.clear();
    lcd.setCursor(0, 1);
    lcd.write("Input_2  ");
  }

  //Result
  if( (digitalRead(pin8) == 1) && (digitalRead(pin9) == 1) )
  {
    lcd.clear();
    lcd.setCursor(0, 1);
    lcd.write("Result  ");
  }
}

#define CS 10 // Assignment of the CS pin

#include <SPI.h> // call library

void setup()
{
  Serial.begin(9600); // initialization of serial communication
  SPI.begin(); // initialization of SPI port
  SPI.setDataMode(SPI_MODE0); // configuration of SPI communication in mode 0
  SPI.setClockDivider(SPI_CLOCK_DIV8); // configuration of clock at 1MHz
  pinMode(CS, OUTPUT); //configure pin connected to chip select as output
}

void loop()
{
  byte intensity = 0;
  digitalWrite(CS, LOW); // activation of CS line
  intensity = SPI.transfer(0) << 4; // Aquisition of first 5 bits of data without leading zeros
  intensity |= (SPI.transfer(0) >> 4); //Aquisition of last 3 bits of data and appending
  digitalWrite(CS, HIGH);

  //display result
  Serial.print("Light intensity = ");
  Serial.println(intensity);
  delay(1000);
  
  // alternate way	
  // digitalWrite(CS, LOW);
  // for(i = 0; i < 2; i = i + 1)
  // {
  //   recu[i] = SPI.transfer(0);
  // }

  // digitalWrite(CS, HIGH);
  // for(i = 0; i < 2; i = i + 1)
  // {
  //   Serial.print("i");
  //   Serial.print(i);
  //   Serial.print("=")
  //   Serial.println(recu[i]);
  // }

  // lumiere = (recu[0]<<3) | (recu[1]<<4);
  // Serial.print("Lumiere=");
  // Serial.println(lumiere);
  // delay(1000);
}

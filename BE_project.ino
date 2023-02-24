#include "gps.h"
#include "gsm.h"
#include "mqtt.h"
#include "nvs.h"
#include "sensors.h"
#include "wifi.h"
#include "mqtt.h"



void setup() {
  nvs_flash_init();
  preferences.begin("my-app", false);
  Serial.begin(115200);
  dht.begin();
  wifiConnect();
  mqttConnect();
 
  delay(1000);
}



void loop() {
  alcoholDetection();
  cabinTemperature();
  cabinHumidity();
  engineTemperature();
  delay(5000);

}

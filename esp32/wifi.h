#ifndef WIFI_H
#define WIFI_H

#include <WiFi.h>

#define WIFI_SSID "lol"
#define WIFI_PASSWORD "Casio@123"

WiFiClient  client;


void wifiConnect() {
  if (WiFi.status() != WL_CONNECTED) {
    Serial.print("Attempting to connect to SSID: ");
    while (WiFi.status() != WL_CONNECTED) {
      WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
      Serial.print(".");
      delay(5000);
    }
    Serial.println("\nConnected.");
  }
}



#endif

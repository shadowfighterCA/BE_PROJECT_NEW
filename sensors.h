#ifndef SENSORS_H
#define SENSORS_H
#include "DHT.h"
#include "max6675.h"
#include "nvs.h"
#include "mqtt.h"

#define alcoholPin  34
#define dhtPin 4
#define dhtType DHT11
#define SO  23
#define CS  5
#define sck  18


DHT dht(dhtPin, dhtType);
MAX6675 module(sck, CS, SO);


int alcoholDetection(void) {
  String str = "Alcohol concentration is " + String(analogRead(alcoholPin));
  Serial.println(str);
  preferences.putFloat(ALCOHOL_KEY, analogRead(alcoholPin));
  clientel.publish(MQTT_TOPIC, str.c_str());
  return analogRead(alcoholPin);
}

float cabinTemperature(void) {
  float temp = dht.readTemperature();
  String str = "Cabin Temperature is " + String(temp);
  Serial.println(str);
  clientel.publish(MQTT_TOPIC, str.c_str());
  preferences.putFloat(CABIN_TEMP_KEY, temp);
  return temp;
}

int cabinHumidity(void) {
  int temp = dht.readHumidity();
  String str = "Cabin Humidity is " + String(temp);
  Serial.println(str);
  clientel.publish(MQTT_TOPIC, str.c_str());
  preferences.putUInt(CABIN_HUMIDITY_KEY, temp);
  return temp;
}

float engineTemperature(void) {
  float temp = module.readCelsius();
  String str = "Engine temperature is  " + String(temp);
  Serial.println(str);
  clientel.publish(MQTT_TOPIC, str.c_str());
  preferences.putFloat(ENGINE_TEMP_KEY, temp);
  return temp;
}

#endif

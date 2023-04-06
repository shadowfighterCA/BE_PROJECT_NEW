#ifndef MQTT_H
#define MQTT_H
#include <PubSubClient.h>
#include "wifi.h"

#define MQTT_BROKER_URI "broker.emqx.io"
#define MQTT_TOPIC  "esp32/test"
#define MQTT_USERNAME  "emqx"
#define MQTT_PASSWORD "public"
#define MQTT_PORT  1883

PubSubClient clientel(client);

void mqttConnect() {
  clientel.setServer(MQTT_BROKER_URI, MQTT_PORT);
  while (!clientel.connected()) {
    String client_id = "esp32-client-";
    client_id += String(WiFi.macAddress());
    Serial.printf("The client %s connects to the public mqtt broker\n", client_id.c_str());
    if (clientel.connect(client_id.c_str(), MQTT_USERNAME, MQTT_PASSWORD)) {
      Serial.println("Public emqx mqtt broker connected");
    } else {
      Serial.print("failed with state ");
      Serial.print(clientel.state());
      delay(2000);
    }
  }


}


#endif

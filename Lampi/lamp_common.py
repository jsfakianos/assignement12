import paho.mqtt.client

# MQTT Topic Names
TOPIC_SET_LAMP_CONFIG = "/lamp/set_config"
TOPIC_LAMP_CHANGE_NOTIFICATION = "/lamp/changed"


def client_state_topic(client_id):
    return '/lamp/connection/{}/state'.format(client_id)

# MQTT Broker Connection info
MQTT_VERSION = paho.mqtt.client.MQTTv311
MQTT_BROKER_HOST = "localhost"
MQTT_BROKER_PORT = 1883
MQTT_BROKER_KEEP_ALIVE_SECS = 60

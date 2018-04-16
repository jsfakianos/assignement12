import json
import random
from random import randint
import resource
from locust import TaskSet, task
from mqtt_locust import MQTTLocust

resource.setrlimit(resource.RLIMIT_NOFILE, (999999, 999999))
device_id = "Unknown"

TIMEOUT = 6
REPEAT = 100

class MyTaskSet(TaskSet):

    def on_start(self):
        d1 = randint (0, 15)
        d2 = randint (0, 15)
        d3 = randint (0, 15)
        d4 = randint (0, 15)
        array = [d1, d2, d3, d4]
        for i in range(len(array)):
            if array[i] == 10:
                array[i] = "a"
            elif array[i] == 11:
                array[i] = "b"
            elif array[i] == 12:
                array[i] = "c"
            elif array[i] == 13:
                array[i] = "d"
            elif array[i] == 14:
                array[i] = "e"
            elif array[i] == 15:
                array[i] = "f"

        self.device_id = "1e000000" + str(array[0]) + str(array[1]) + str(array[2]) + str(array[3])

    @task(1)
    def task1 (self):
        self.client.publish(
                '/devices/' + self.device_id + '/lamp/changed', self.payload(),
                qos=1, retain=True, timeout=TIMEOUT, repeat=REPEAT, name='/lamp/changed')

    @task(1)
    def task2 (self):
        self.client.publish(
                '/devices/' + self.device_id + '/lamp/connection/lamp_ui/state',
                random.choice(["0", "1"]), qos=1, retain=True, timeout=TIMEOUT,
                repeat=REPEAT, name='/lamp/connection')

    def payload(self):
        payload = {
            'on': random.choice(['true', 'false']),
            'color': {
                'h': random.random(),
                's': random.random(),
            },
            'brightness': random.random(),
            'client': 'locust',
        }
        return json.dumps(payload)

class MyLocust(MQTTLocust):
    task_set = MyTaskSet
    min_wait = 5000
    max_wait = 15000

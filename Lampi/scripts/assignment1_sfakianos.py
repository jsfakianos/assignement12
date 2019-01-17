# Written by aks164 - Alexander Sfakianos
# Jan 17 2019
# EECS 377 assignment 1

import pigpio
from time import sleep

def main():
	pi = pigpio.pi()
	# R, G, B channel pins
	leds = [19, 26, 13]
	# Setting up the PWM frequency (50Hz) and range (100)
	for color in leds:
		pi.set_PWM_frequency(color, 50)
		pi.set_PWM_range(color, 100)
		# PWM off
		pi.set_PWM_dutycycle(color, 0)

	while True:
		# Turning off all of the leds
		for color in leds:
			pi.write(color, 0)

		# Delay 1s
		sleep(1)

		# Turning R, G, B on and off in order
		for color in leds:
			pi.write(color, 1)
			# Increment up
			for i in range(101):
				# Increment to 100% PWM
				pi.set_PWM_dutycycle(color, i)
				# Delay by 0.005s -> 0.5s to 100%
				sleep(0.005)
			# Increment back down
			for i in range(101);
				pi.set_PWM_dutycycle(color, 100 - i)
				sleep(0.005)

		# Control white light by changing all of the leds...
		# PWM dutycycle up
		for i in range(101):
			for color in leds:
				pi.set_PWM_dutycycle(color, i)
			sleep(0.005)

		# PWM dutycycle down
		for i in range(101):
			for color in leds:
				pi.set_PWM_dutycycle(color, 100 - i)
			sleep(0.005)

main()

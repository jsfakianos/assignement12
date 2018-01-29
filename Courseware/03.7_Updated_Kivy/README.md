# Updating your Kivy UI to use Pub/Sub

In the last two sections you built a simple command-line client and a Lamp service.  The service responds to configuration change requests on an MQTT topic, and notifies any subscribers of changes that have taken effect on a different topic.

In this section, you will update your Kivy application from Assignment 2 to use MQTT Pub/Sub

## Assignment Part 3
A solution for Assignment 2 is provided in the repository for Assignment 3.

Update the Kivy application provided, removing any *pigpio* code, and adding MQTT message publications to make lamp configuration changes, and subscribing to the change notifications to update the Kivy UI.

*Note:* since there is now more than one client making changes to the hardware configuration, the Kivy application cannot assume it is the SPOT any longer, but is just another client of the service.

Next up: go to [What to Turn in](../03.8_Assignment/README.md)

&copy; 2015-18 LeanDog, Inc. and Nick Barendt

# Automatic Emergency Braking System Using MIPS Instruction Code
Hello Everyone we from KICT in IIUM, this repository is from our group project for Computer Architecture Assembly Language
Our group consist of 4 members which:
1. Aiman bin Farizal Yee-Ar 2219069
2. Mas Azlan Hafiz bin Maslan 2210793
3. Megat Arif Ilham bin Isnin 2213969
4. Shafreez Karlreezwan bin Mhd Saiful Anuar 2217105

Our title is Automatic Emergency Braking System. 

To simulate this project, we use 3 Sensors and 3 actuators.
SENSORS
1. Radar: To know the distance with obstacles in front.
2. Wheel Speed Sensor: To know the current speed of the car.
3. Camera: To identify the obstacle (eg: vehicle, hazard, pedestrian, traffic light).
   
ACTUATORS
1. Dashboard Indicator: Alert the driver, ready for emergency brake.
2. Brake: To stop or reduce the velocity of the car
3. Rear Emergency Brake Light: Give a warning to other drivers.

To calculate and trigger the Automatic Emergency Brake, we use Time to Colission (TTC) calculation. This calculation involved the current speed of the car and its distance towards the obstacle.
If the TTC > 2 seconds, the system will trigger the Automatic Emergency Brake. If not, it will just give warning towards the driver to brake manually.


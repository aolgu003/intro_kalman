
Contents
==================
This folder contains 1 file from IMU tests performed on 03/31/2015 @ 11:14pm.
 - epson_20150331_230142_1_raw.mat

Test Set-up
==================
The IMU was placed in a temperature constant location, secured to a concrete slab of the bottom floor of a large commercial building, late in the evening to ensure little to no foot traffic.

The IMU was given 30 minutes to reach a stable state for internal (electrical noise & temperature) & external (constant temperature).

The IMU was powered by a battery to ensure a constant (low-noise) power source.

Data was collected for a period of 10.5 minutes.

Data recording was delayed by 1 minute, after "record" command was issued to the Data Acquisition System (DAQ), to ensure that motion associated with entering the room, starting the DAQ, etc., was not present in the data.  The last 0.5 minutes of data is to allow for post processing to remove any data with motion present due to the same reasons.

The "epson_20150331_230142_1.mat" was recorded to a microSD card on a custom DAQ designed by the author for use on military UAV systems. This data is in Matlab .MAT format, already converted from HEX and scaled to correct engineering units.

Post-Processing
==================
A Matlab script is provided to import, plot, and save the data for further analysis.
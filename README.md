# VIAtari

**Welcome to the VIAtari wiki!**

**Introduction**
Inspiration for this mode I found on Daryl's Computer Hobby Page. Daryl made Composite Video Text/Graphics Display based on ATMEGA8 and drive by VIA6522. This article will show how to build, assembly and connect VIA 6522 IC to Atari and use 2 additional 8-bit parallel ports and serial interface. This is my own project build from scratch but it's nothing modern - this IC was used in C64 to communicate with disk drive. It will be used as additional PIA for manage other equipment.

Notice:
This implementation is designed for Atari 65/130XE with CART/ECI ports available. It's called VIAtariXE

**Why?**
Well, on the market you may find a few sellers which have VIA6522, but...
- this IC is discontinued, don't wait so much time, buy it!
- it's still very useful and may be good alternative for PIA 6520(6521).
- topology and registers covering PIA 6520, so you may use it as equivalent for it. (some pins should be swapped)
- very cheap IC (~2$/piece).

**Best sources**
Original source:
https://systemembedded.eu/viewtopic.php?f=28&t=41

#ifndef TIMEDIFF_H
#define TIMEDIFF_H

#define NANO                1000000000L
#define MICRO              	1000000L
#define MILLI              	1000L
#define CLOCK_ID            CLOCK_MONOTONIC_RAW

timespec getTimeDiff(timespec start, timespec end);

#endif /* TIMEDIFF_H */
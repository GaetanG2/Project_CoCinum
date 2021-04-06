
#ifndef SEGMENT_DISPLAY_H_
#define SEGMENT_DISPLAY_H_

#include <stdint.h>

typedef uint32_t SegmentDisplay;

void SegmentDisplay_show(SegmentDisplay *display, uint16_t digits, uint16_t points);

#endif


#include "SegmentDisplay.h"

void SegmentDisplay_show(SegmentDisplay *display, uint16_t digits, uint16_t points) {
    *display = (points << 16) | digits;
}

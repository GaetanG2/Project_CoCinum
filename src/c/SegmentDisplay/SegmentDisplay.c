
#include "SegmentDisplay.h"

void SegmentDisplay_show(SegmentDisplay *display, const uint8_t digits[], const uint8_t points[]) {
    for (size_t i = 0; i < display->width; i++) {
        display->data[i] = digits[i] | (points[i] << 4);
    }
}

#include "deferred_count.h"
extern "C" int32_t dc_run(uint64_t capacity, uint64_t selected, dc_result* result) {
    if (!result || selected > capacity) return -1;
    result->status = -2;
    result->elapsed_ms = 0.0f;
    result->selected = selected;
    return -2; // Not implemented: never report placeholder timing as measurement.
}

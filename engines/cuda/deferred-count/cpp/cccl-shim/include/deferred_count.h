#ifndef DEFERRED_COUNT_H
#define DEFERRED_COUNT_H
#include <stdint.h>
#ifdef __cplusplus
extern "C" {
#endif
typedef struct { int32_t status; float elapsed_ms; uint64_t selected; } dc_result;
// Placeholder: returns -2 until CUDA policies are implemented.
int32_t dc_run(uint64_t capacity, uint64_t selected, dc_result* result);
#ifdef __cplusplus
}
#endif
#endif

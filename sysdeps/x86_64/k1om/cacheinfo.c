#define is_intel 1
#define is_amd 0
#define OVERRIDE_MAX_CPUID(max_cpuid) (max_cpuid) = 4

#include <sysdeps/x86_64/cacheinfo.c>

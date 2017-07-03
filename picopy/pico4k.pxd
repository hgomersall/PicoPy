# Henry Gomersall
# heng@kedevelopments.co.uk
#

from pico_status cimport PICO_STATUS, PICO_INFO
from libc.stdint cimport (
    int16_t, uint16_t, int32_t, uint32_t, int64_t, uint64_t)

# Simple constants replicated from ps4000Api.h

cdef extern from 'ps4000Api.h':
    cdef int PS4000A_MAX_OVERSAMPLE_12BIT = 16
    cdef int PS4000A_MAX_OVERSAMPLE_8BIT = 256

    cdef int PS4XXX_MAX_ETS_CYCLES = 250
    cdef int PS4XXX_MAX_INTERLEAVE = 50

    cdef int PS4000_MAX_VALUE = 32764
    cdef int PS4000_MIN_VALUE = -32764
    cdef int PS4000_LOST_DATA = -32768

    cdef int PS4000_EXT_MAX_VALUE = 32767
    cdef int PS4000_EXT_MIN_VALUE = -32767

    cdef int MAX_PULSE_WIDTH_QUALIFIER_COUNT = 16777215
    cdef int MAX_DELAY_COUNT = 8388607

    cdef float MIN_SIG_GEN_FREQ = 0.0
    cdef float MAX_SIG_GEN_FREQ = 2000000.0

    cdef int MAX_SIG_GEN_BUFFER_SIZE = 8192
    cdef int MIN_SIG_GEN_BUFFER_SIZE = 10
    cdef int MIN_DWELL_COUNT = 10
    cdef int MAX_SWEEPS_SHOTS = 536870912 #((1 << 30) - 1)

    cdef float PS4000_SINE_MAX_FREQUENCY = 2000000.0
    cdef float PS4000_SQUARE_MAX_FREQUENCY = 2000000.0
    cdef float PS4000_TRIANGLE_MAX_FREQUENCY = 2000000.0
    cdef float PS4000_SINC_MAX_FREQUENCY = 2000000.0
    cdef float PS4000_RAMP_MAX_FREQUENCY = 2000000.0
    cdef float PS4000_HALF_SINE_MAX_FREQUENCY = 2000000.0
    cdef float PS4000_GAUSSIAN_MAX_FREQUENCY = 2000000.0
    cdef float PS4000_MIN_FREQUENCY = 0.03

ctypedef enum PS4000_COUPLING:
    PS4000_AC = 0
    PS4000_DC = 1

ctypedef enum PS4000_EXTRA_OPERATIONS:
    PS4000_ES_OFF = 0
    PS4000_WHITENOISE = 1

cdef extern from 'ps4000Api.h':

    ctypedef enum PS4000_CHANNEL_BUFFER_INDEX:
        PS4000_CHANNEL_A_MAX
        PS4000_CHANNEL_A_MIN
        PS4000_CHANNEL_B_MAX
        PS4000_CHANNEL_B_MIN
        PS4000_CHANNEL_C_MAX
        PS4000_CHANNEL_C_MIN
        PS4000_CHANNEL_D_MAX
        PS4000_CHANNEL_D_MIN
        PS4000_MAX_CHANNEL_BUFFERS

    ctypedef enum PS4000_CHANNEL:
        PS4000_CHANNEL_A
        PS4000_CHANNEL_B
        PS4000_CHANNEL_C
        PS4000_CHANNEL_D
        PS4000_EXTERNAL
        PS4000_MAX_CHANNELS = PS4000_EXTERNAL
        PS4000_TRIGGER_AUX
        PS4000_MAX_TRIGGER_SOURCES

    ctypedef enum PS4000_RANGE:
        PS4000_10MV
        PS4000_20MV
        PS4000_50MV
        PS4000_100MV
        PS4000_200MV
        PS4000_500MV
        PS4000_1V
        PS4000_2V
        PS4000_5V
        PS4000_10V
        PS4000_20V
        PS4000_50V
        PS4000_100V
        PS4000_MAX_RANGES

    ctypedef enum PS4000_PROBE:
       P_NONE
       P_CURRENT_CLAMP_10A
       P_CURRENT_CLAMP_1000A
       P_TEMPERATURE_SENSOR
       P_CURRENT_MEASURING_DEVICE
       P_PRESSURE_SENSOR_50BAR
       P_PRESSURE_SENSOR_5BAR
       P_OPTICAL_SWITCH
       P_UNKNOWN
       P_MAX_PROBES = P_UNKNOWN


    ctypedef enum PS4000_CHANNEL_INFO:
        CI_RANGES
        CI_RESISTANCES
        CI_ACCELEROMETER
        CI_PROBES
        CI_TEMPERATURES

    ctypedef enum PS4000_ETS_MODE:
        PS4000_ETS_OFF             #ETS disabled
        PS4000_ETS_FAST
        PS4000_ETS_SLOW
        PS4000_ETS_MODES_MAX

    ctypedef enum PS4000_TIME_UNITS:
        PS4000_FS
        PS4000_PS
        PS4000_NS
        PS4000_US
        PS4000_MS
        PS4000_S
        PS4000_MAX_TIME_UNITS

    ctypedef enum SWEEP_TYPE:
        UP
        DOWN
        UPDOWN
        DOWNUP
        MAX_SWEEP_TYPES

    ctypedef enum WAVE_TYPE:
        PS4000_SINE
        PS4000_SQUARE
        PS4000_TRIANGLE
        PS4000_RAMP_UP
        PS4000_RAMP_DOWN
        PS4000_SINC
        PS4000_GAUSSIAN
        PS4000_HALF_SINE
        PS4000_DC_VOLTAGE
        PS4000_WHITE_NOISE
        MAX_WAVE_TYPES

    ctypedef enum SIGGEN_TRIG_TYPE:
        SIGGEN_RISING,
        SIGGEN_FALLING,
        SIGGEN_GATE_HIGH,
        SIGGEN_GATE_LOW

    ctypedef enum SIGGEN_TRIG_SOURCE:
        SIGGEN_NONE
        SIGGEN_SCOPE_TRIG
        SIGGEN_AUX_IN
        SIGGEN_EXT_IN
        SIGGEN_SOFT_TRIG

    ctypedef enum INDEX_MODE:
        SINGLE
        DUAL
        QUAD
        MAX_INDEX_MODES

    ctypedef enum THRESHOLD_MODE:
        LEVEL
        WINDOW

    ctypedef enum THRESHOLD_DIRECTION:
        ABOVE #using upper threshold
        BELOW
        RISING # using upper threshold
        FALLING # using upper threshold
        RISING_OR_FALLING # using both threshold
        ABOVE_LOWER # using lower threshold
        BELOW_LOWER # using lower threshold
        RISING_LOWER # using upper threshold
        FALLING_LOWER # using upper threshold

        # Windowing using both thresholds
        INSIDE = ABOVE
        OUTSIDE = BELOW
        ENTER = RISING
        EXIT = FALLING
        ENTER_OR_EXIT = RISING_OR_FALLING
        POSITIVE_RUNT = 9
        NEGATIVE_RUNT

        # no trigger set
        NONE = RISING

    ctypedef enum TRIGGER_STATE:
        CONDITION_DONT_CARE
        CONDITION_TRUE
        CONDITION_FALSE
        CONDITION_MAX

    ctypedef struct TRIGGER_CONDITIONS:
        TRIGGER_STATE channelA
        TRIGGER_STATE channelB
        TRIGGER_STATE channelC
        TRIGGER_STATE channelD
        TRIGGER_STATE external
        TRIGGER_STATE aux
        TRIGGER_STATE pulseWidthQualifier

    ctypedef struct PWQ_CONDITIONS:
        TRIGGER_STATE channelA
        TRIGGER_STATE channelB
        TRIGGER_STATE channelC
        TRIGGER_STATE channelD
        TRIGGER_STATE external
        TRIGGER_STATE aux

    ctypedef struct TRIGGER_CHANNEL_PROPERTIES:
        int16_t thresholdUpper
        uint16_t thresholdUpperHysteresis
        int16_t thresholdLower
        uint16_t thresholdLowerHysteresis
        PS4000_CHANNEL channel
        THRESHOLD_MODE thresholdMode

    ctypedef enum RATIO_MODE:
        RATIO_MODE_NONE
        RATIO_MODE_AGGREGATE = 1
        RATIO_MODE_AVERAGE = 2

    ctypedef enum PULSE_WIDTH_TYPE:
        PW_TYPE_NONE
        PW_TYPE_LESS_THAN
        PW_TYPE_GREATER_THAN
        PW_TYPE_IN_RANGE
        PW_TYPE_OUT_OF_RANGE

    ctypedef enum PS4000_HOLDOFF_TYPE:
        PS4000_TIME
        PS4000_MAX_HOLDOFF_TYPE

    ctypedef enum PS4000_FREQUENCY_COUNTER_RANGE:
        FC_2K

    ctypedef void (*ps4000BlockReady)(
            int16_t handle, PICO_STATUS status, void *pParameter) nogil

    ctypedef void (*ps4000StreamingReady)(
            int16_t handle,
            int32_t noOfSamples,
            uint32_t startIndex,
            int16_t overflow,
            uint32_t triggerAt,
            int16_t triggered,
            int16_t autoStop,
            void * pParameter) nogil

    ctypedef void (*ps4000DataReady)(
            int16_t handle,
            uint32_t noOfSamples,
            int16_t overflow,
            uint32_t triggerAt,
            int16_t triggered,
            void * pParameter) nogil

    PICO_STATUS ps4000OpenUnit(
            int16_t * handle) nogil

    PICO_STATUS ps4000OpenUnitAsync(
            int16_t * status) nogil

    PICO_STATUS ps4000OpenUnitEx(
            int16_t * handle,
            char * serial) nogil

    PICO_STATUS ps4000OpenUnitAsyncEx(
            int16_t * status,
            char * serial) nogil

    PICO_STATUS ps4000OpenUnitProgress(
            int16_t * handle,
            int16_t * progressPercent,
            int16_t * complete) nogil

    PICO_STATUS ps4000GetUnitInfo(
            int16_t handle,
            char * string,
            int16_t stringLength,
            int16_t * requiredSize,
            PICO_INFO info) nogil

    PICO_STATUS ps4000FlashLed(
            int16_t handle,
            int16_t start) nogil

    PICO_STATUS ps4000CloseUnit(
            int16_t handle) nogil

    PICO_STATUS ps4000MemorySegments(
            int16_t handle,
            uint16_t nSegments,
            int32_t * nMaxSamples) nogil

    PICO_STATUS ps4000SetChannel(
            int16_t handle,
            PS4000_CHANNEL channel,
            int16_t enabled,
            int16_t dc,
            PS4000_RANGE range) nogil

    PICO_STATUS ps4000SetNoOfCaptures(
            int16_t handle,
            uint16_t nCaptures) nogil

    PICO_STATUS ps4000GetTimebase(
            int16_t handle,
            uint32_t timebase,
            int32_t noSamples,
            int32_t * timeIntervalNanoseconds,
            int16_t oversample,
            int32_t * maxSamples,
            uint16_t segmentIndex) nogil

    PICO_STATUS ps4000GetTimebase2(
            int16_t handle,
            uint32_t timebase,
            int32_t noSamples,
            float * timeIntervalNanoseconds,
            int16_t oversample,
            int32_t * maxSamples,
            uint16_t segmentIndex) nogil

    PICO_STATUS ps4000SetSigGenArbitrary(
            int16_t handle,
            int32_t offsetVoltage,
            uint32_t pkToPk,
            uint32_t startDeltaPhase,
            uint32_t stopDeltaPhase,
            uint32_t deltaPhaseIncrement,
            uint32_t dwellCount,
            int16_t * arbitraryWaveform,
            int32_t arbitraryWaveformSize,
            SWEEP_TYPE sweepType,
            int16_t whiteNoise,
            INDEX_MODE indexMode,
            uint32_t shots,
            uint32_t sweeps,
            SIGGEN_TRIG_TYPE triggerType,
            SIGGEN_TRIG_SOURCE triggerSource,
            int16_t extInThreshold) nogil

    PICO_STATUS ps4000SetSigGenBuiltIn(
            int16_t handle,
            int32_t offsetVoltage,
            uint32_t pkToPk,
            int16_t waveType,
            float startFrequency,
            float stopFrequency,
            float increment,
            float dwellTime,
            SWEEP_TYPE sweepType,
            int16_t whiteNoise,
            uint32_t shots,
            uint32_t sweeps,
            SIGGEN_TRIG_TYPE triggerType,
            SIGGEN_TRIG_SOURCE triggerSource,
            int16_t extInThreshold) nogil

    PICO_STATUS ps4000SigGenSoftwareControl(
            int16_t handle,
            int16_t state) nogil

    PICO_STATUS ps4000SetEts(
            int16_t handle,
            PS4000_ETS_MODE mode,
            int16_t etsCycles,
            int16_t etsInterleave,
            int32_t * sampleTimePicoseconds) nogil

    PICO_STATUS ps4000SetSimpleTrigger(
            int16_t handle,
            int16_t enable,
            PS4000_CHANNEL source,
            int16_t threshold,
            THRESHOLD_DIRECTION direction,
            uint32_t delay,
            int16_t autoTrigger_ms) nogil

    PICO_STATUS ps4000SetTriggerChannelProperties(
            int16_t handle,
            TRIGGER_CHANNEL_PROPERTIES * channelProperties,
            int16_t nChannelProperties,
            int16_t auxOutputEnable,
            int32_t autoTriggerMilliseconds) nogil

    PICO_STATUS ps4000SetTriggerChannelConditions(
            int16_t handle,
            TRIGGER_CONDITIONS * conditions,
            int16_t nConditions) nogil

    PICO_STATUS ps4000SetTriggerChannelDirections(
            int16_t handle,
            THRESHOLD_DIRECTION channelA,
            THRESHOLD_DIRECTION channelB,
            THRESHOLD_DIRECTION channelC,
            THRESHOLD_DIRECTION channelD,
            THRESHOLD_DIRECTION ext,
            THRESHOLD_DIRECTION aux) nogil

    PICO_STATUS ps4000SetTriggerDelay(
            int16_t handle,
            uint32_t delay) nogil

    PICO_STATUS ps4000SetPulseWidthQualifier(
            int16_t handle,
            PWQ_CONDITIONS * conditions,
            int16_t nConditions,
            THRESHOLD_DIRECTION direction,
            uint32_t lower,
            uint32_t upper,
            PULSE_WIDTH_TYPE type) nogil

    PICO_STATUS ps4000IsTriggerOrPulseWidthQualifierEnabled(
            int16_t handle,
            int16_t * triggerEnabled,
            int16_t * pulseWidthQualifierEnabled) nogil

    PICO_STATUS ps4000GetTriggerTimeOffset(
            int16_t handle,
            uint32_t * timeUpper,
            uint32_t * timeLower,
            PS4000_TIME_UNITS * timeUnits,
            uint16_t segmentIndex ) nogil

    PICO_STATUS ps4000GetTriggerTimeOffset64(
            int16_t handle,
            int64_t * time,
            PS4000_TIME_UNITS * timeUnits,
            uint16_t segmentIndex ) nogil

    PICO_STATUS ps4000GetValuesTriggerTimeOffsetBulk(
            int16_t handle,
            uint32_t * timesUpper,
            uint32_t * timesLower,
            PS4000_TIME_UNITS * timeUnits,
            uint16_t fromSegmentIndex,
            uint16_t toSegmentIndex) nogil

    PICO_STATUS ps4000GetValuesTriggerTimeOffsetBulk64(
            int16_t handle,
            int64_t * times,
            PS4000_TIME_UNITS * timeUnits,
            uint16_t fromSegmentIndex,
            uint16_t toSegmentIndex) nogil

    PICO_STATUS ps4000SetDataBufferBulk(
            int16_t handle,
            PS4000_CHANNEL channel,
            int16_t *buffer,
            int32_t bufferLth,
            uint16_t waveform) nogil

    PICO_STATUS ps4000SetDataBuffers(
            int16_t handle,
            PS4000_CHANNEL channel,
            int16_t * bufferMax,
            int16_t * bufferMin,
            int32_t bufferLth) nogil

    PICO_STATUS ps4000SetDataBufferWithMode(
            int16_t handle,
            PS4000_CHANNEL channel,
            int16_t * buffer,
            int32_t bufferLth,
            RATIO_MODE mode) nogil

    PICO_STATUS ps4000SetDataBuffersWithMode(
            int16_t handle,
            PS4000_CHANNEL channel,
            int16_t * bufferMax,
            int16_t * bufferMin,
            int32_t bufferLth,
            RATIO_MODE mode) nogil

    PICO_STATUS ps4000SetEtsTimeBuffer(
            int16_t handle,
            int64_t * buffer,
            int32_t bufferLth) nogil

    PICO_STATUS ps4000SetEtsTimeBuffers(
            int16_t handle,
            uint32_t * timeUpper,
            uint32_t * timeLower,
            int32_t bufferLth) nogil

    PICO_STATUS ps4000IsReady(
            int16_t handle,
            int16_t * ready) nogil

    PICO_STATUS ps4000RunBlock(
            int16_t handle,
            int32_t noOfPreTriggerSamples,
            int32_t noOfPostTriggerSamples,
            uint32_t timebase,
            int16_t oversample,
            int32_t * timeIndisposedMs,
            uint16_t segmentIndex,
            ps4000BlockReady lpReady,
            void * pParameter) nogil

    PICO_STATUS ps4000RunStreaming(
            int16_t handle,
            uint32_t * sampleInterval,
            PS4000_TIME_UNITS sampleIntervalTimeUnits,
            uint32_t maxPreTriggerSamples,
            uint32_t maxPostPreTriggerSamples,
            int16_t autoStop,
            uint32_t downSampleRatio,
            uint32_t overviewBufferSize) nogil

    PICO_STATUS ps4000RunStreamingEx(
            int16_t handle,
            uint32_t * sampleInterval,
            PS4000_TIME_UNITS sampleIntervalTimeUnits,
            uint32_t maxPreTriggerSamples,
            uint32_t maxPostPreTriggerSamples,
            int16_t autoStop,
            uint32_t downSampleRatio,
            RATIO_MODE downSampleRatioMode,
            uint32_t overviewBufferSize) nogil

    PICO_STATUS ps4000GetStreamingLatestValues(
            int16_t handle,
            ps4000StreamingReady lpPs4000aReady,
            void * pParameter) nogil

    PICO_STATUS ps4000NoOfStreamingValues(
            int16_t handle,
            uint32_t * noOfValues) nogil

    PICO_STATUS ps4000GetMaxDownSampleRatio(
            int16_t handle,
            uint32_t noOfUnaggreatedSamples,
            uint32_t * maxDownSampleRatio,
            RATIO_MODE downSampleRatioMode,
            uint16_t segmentIndex) nogil

    PICO_STATUS ps4000GetValues(
            int16_t handle,
            uint32_t startIndex,
            uint32_t * noOfSamples,
            uint32_t downSampleRatio,
            RATIO_MODE downSampleRatioMode,
            uint16_t segmentIndex,
            int16_t * overflow) nogil

    PICO_STATUS ps4000GetValuesBulk(
            int16_t handle,
            uint32_t * noOfSamples,
            uint16_t fromSegmentIndex,
            uint16_t toSegmentIndex,
            int16_t * overflow) nogil

    PICO_STATUS ps4000GetValuesAsync(
            int16_t handle,
            uint32_t startIndex,
            uint32_t noOfSamples,
            uint32_t downSampleRatio,
            int16_t downSampleRatioMode,
            uint16_t segmentIndex,
            void * lpDataReady,
            void * pParameter) nogil

    PICO_STATUS ps4000Stop(
            int16_t handle) nogil

    PICO_STATUS ps4000HoldOff(
            int16_t handle,
            uint64_t holdoff,
            PS4000_HOLDOFF_TYPE type) nogil

    PICO_STATUS ps4000GetChannelInformation(
            int16_t handle,
            PS4000_CHANNEL_INFO info,
            int probe,
            int * ranges,
            int * length,
            int channels) nogil

    PICO_STATUS ps4000EnumerateUnits(
            int16_t * count,
            char * serials,
            int16_t * serialLth) nogil


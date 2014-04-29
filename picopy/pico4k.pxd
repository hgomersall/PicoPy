# Henry Gomersall
# heng@kedevelopments.co.uk
#

from pico_status cimport PICO_STATUS, PICO_INFO
from libc.stdint cimport int64_t, uint64_t

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
        SINE
        SQUARE
        TRIANGLE
        RAMP_UP
        RAMP_DOWN
        SINC
        GAUSSIAN
        HALF_SINE
        DC_VOLTAGE
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
        short thresholdUpper
        unsigned short thresholdUpperHysteresis 
        short thresholdLower
        unsigned short thresholdLowerHysteresis
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
            short handle, PICO_STATUS status, void *pParameter) nogil

    ctypedef void (*ps4000StreamingReady)(
            short handle,
            long noOfSamples,
            unsigned long startIndex,
            short overflow,
            unsigned long triggerAt,
            short triggered,
            short autoStop,
            void * pParameter) nogil

    ctypedef void (*ps4000DataReady)(
            short handle,
            unsigned long noOfSamples,
            short overflow,
            unsigned long triggerAt,
            short triggered,
            void * pParameter) nogil

    PICO_STATUS ps4000OpenUnit(
            short * handle) nogil

    PICO_STATUS ps4000OpenUnitAsync(
            short * status) nogil
 
    PICO_STATUS ps4000OpenUnitEx(
            short * handle,
            char * serial) nogil

    PICO_STATUS ps4000OpenUnitAsyncEx(
            short * status,
            char * serial) nogil

    PICO_STATUS ps4000OpenUnitProgress(
            short * handle,
            short * progressPercent,
            short * complete) nogil 

    PICO_STATUS ps4000GetUnitInfo(
            short handle, 
            char * string,
            short stringLength,
            short * requiredSize,
            PICO_INFO info) nogil

    PICO_STATUS ps4000FlashLed(
            short handle,
            short start) nogil
    
    PICO_STATUS ps4000CloseUnit(
            short handle) nogil
    
    PICO_STATUS ps4000MemorySegments(
            short handle,
            unsigned short nSegments,
            long * nMaxSamples) nogil
    
    PICO_STATUS ps4000SetChannel(
            short handle,
            PS4000_CHANNEL channel,
            short enabled,
            short dc, 
            PS4000_RANGE range) nogil

    PICO_STATUS ps4000SetNoOfCaptures(
            short handle,
            unsigned short nCaptures) nogil
    
    PICO_STATUS ps4000GetTimebase(
            short handle,
            unsigned long timebase,
            long noSamples,
            long * timeIntervalNanoseconds,
            short oversample,
            long * maxSamples,
            unsigned short segmentIndex) nogil
    
    PICO_STATUS ps4000GetTimebase2(
            short handle,
            unsigned long timebase,
            long noSamples,
            float * timeIntervalNanoseconds,
            short oversample,
            long * maxSamples,
            unsigned short segmentIndex) nogil
    
    PICO_STATUS ps4000SetSigGenArbitrary(
            short handle,
            long offsetVoltage,
            unsigned long pkToPk,
            unsigned long startDeltaPhase,
            unsigned long stopDeltaPhase,
            unsigned long deltaPhaseIncrement, 
            unsigned long dwellCount,
            short * arbitraryWaveform, 
            long arbitraryWaveformSize,
            SWEEP_TYPE sweepType,
            short whiteNoise,
            INDEX_MODE indexMode,
            unsigned long shots,
            unsigned long sweeps,
            SIGGEN_TRIG_TYPE triggerType,
            SIGGEN_TRIG_SOURCE triggerSource,
            short extInThreshold) nogil
    
    PICO_STATUS ps4000SetSigGenBuiltIn(
            short handle,
            long offsetVoltage,
            unsigned long pkToPk,
            short waveType,
            float startFrequency,
            float stopFrequency,
            float increment,
            float dwellTime,
            SWEEP_TYPE sweepType,
            short whiteNoise,
            unsigned long shots,
            unsigned long sweeps,
            SIGGEN_TRIG_TYPE triggerType,
            SIGGEN_TRIG_SOURCE triggerSource,
            short extInThreshold) nogil
    
    PICO_STATUS ps4000SigGenSoftwareControl(
            short handle,
            short state) nogil
    
    PICO_STATUS ps4000SetEts(
            short handle,
            PS4000_ETS_MODE mode,
            short etsCycles,
            short etsInterleave,
            long * sampleTimePicoseconds) nogil
    
    PICO_STATUS ps4000SetSimpleTrigger(
            short handle,
            short enable,
            PS4000_CHANNEL source,
            short threshold,
            THRESHOLD_DIRECTION direction,
            unsigned long delay,
            short autoTrigger_ms) nogil
    
    PICO_STATUS ps4000SetTriggerChannelProperties(
            short handle,
            TRIGGER_CHANNEL_PROPERTIES * channelProperties,
            short nChannelProperties,
            short auxOutputEnable,
            long autoTriggerMilliseconds) nogil
    
    PICO_STATUS ps4000SetTriggerChannelConditions(
            short handle,
            TRIGGER_CONDITIONS * conditions,
            short nConditions) nogil
    
    PICO_STATUS ps4000SetTriggerChannelDirections(
            short handle,
            THRESHOLD_DIRECTION channelA,
            THRESHOLD_DIRECTION channelB,
            THRESHOLD_DIRECTION channelC,
            THRESHOLD_DIRECTION channelD,
            THRESHOLD_DIRECTION ext,
            THRESHOLD_DIRECTION aux) nogil
    
    PICO_STATUS ps4000SetTriggerDelay(
            short handle,
            unsigned long delay) nogil
    
    PICO_STATUS ps4000SetPulseWidthQualifier(
            short handle,
            PWQ_CONDITIONS * conditions,
            short nConditions,
            THRESHOLD_DIRECTION direction,
            unsigned long lower,
            unsigned long upper,
            PULSE_WIDTH_TYPE type) nogil
    
    PICO_STATUS ps4000IsTriggerOrPulseWidthQualifierEnabled(
            short handle,
            short * triggerEnabled,
            short * pulseWidthQualifierEnabled) nogil
    
    PICO_STATUS ps4000GetTriggerTimeOffset(
            short handle,
            unsigned long * timeUpper,
            unsigned long * timeLower,
            PS4000_TIME_UNITS * timeUnits,
            unsigned short segmentIndex ) nogil
    
    PICO_STATUS ps4000GetTriggerTimeOffset64(
            short handle,
            int64_t * time,
            PS4000_TIME_UNITS * timeUnits,
            unsigned short segmentIndex ) nogil
    
    PICO_STATUS ps4000GetValuesTriggerTimeOffsetBulk(
            short handle,
            unsigned long * timesUpper,
            unsigned long * timesLower,
            PS4000_TIME_UNITS * timeUnits,
            unsigned short fromSegmentIndex,
            unsigned short toSegmentIndex) nogil
    
    PICO_STATUS ps4000GetValuesTriggerTimeOffsetBulk64(
            short handle,
            int64_t * times,
            PS4000_TIME_UNITS * timeUnits,
            unsigned short fromSegmentIndex,
            unsigned short toSegmentIndex) nogil
    
    PICO_STATUS ps4000SetDataBufferBulk(
            short handle,
            PS4000_CHANNEL channel,
            short *buffer,
            long bufferLth,
            unsigned short waveform) nogil

    PICO_STATUS ps4000SetDataBuffers(
            short handle,
            PS4000_CHANNEL channel,
            short * bufferMax,
            short * bufferMin,
            long bufferLth) nogil
    
    PICO_STATUS ps4000SetDataBufferWithMode(
            short handle,
            PS4000_CHANNEL channel,
            short * buffer,
            long bufferLth,
            RATIO_MODE mode) nogil

    PICO_STATUS ps4000SetDataBuffersWithMode(
            short handle,
            PS4000_CHANNEL channel,
            short * bufferMax,
            short * bufferMin,
            long bufferLth,
            RATIO_MODE mode) nogil
    
    PICO_STATUS ps4000SetEtsTimeBuffer(
            short handle,
            int64_t * buffer,
            long bufferLth) nogil
    
    PICO_STATUS ps4000SetEtsTimeBuffers(
            short handle,
            unsigned long * timeUpper,
            unsigned long * timeLower,
            long bufferLth) nogil
    
    PICO_STATUS ps4000IsReady(
            short handle,
            short * ready) nogil
    
    PICO_STATUS ps4000RunBlock(
            short handle,
            long noOfPreTriggerSamples,
            long noOfPostTriggerSamples,
            unsigned long timebase,
            short oversample,
            long * timeIndisposedMs,
            unsigned short segmentIndex,
            ps4000BlockReady lpReady,
            void * pParameter) nogil
    
    PICO_STATUS ps4000RunStreaming(
            short handle,
            unsigned long * sampleInterval, 
            PS4000_TIME_UNITS sampleIntervalTimeUnits,
            unsigned long maxPreTriggerSamples,
            unsigned long maxPostPreTriggerSamples,
            short autoStop,
            unsigned long downSampleRatio,
            unsigned long overviewBufferSize) nogil

    PICO_STATUS ps4000RunStreamingEx(
            short handle,
            unsigned long * sampleInterval, 
            PS4000_TIME_UNITS sampleIntervalTimeUnits,
            unsigned long maxPreTriggerSamples,
            unsigned long maxPostPreTriggerSamples,
            short autoStop,
            unsigned long downSampleRatio,
            RATIO_MODE downSampleRatioMode,
            unsigned long overviewBufferSize) nogil
    
    PICO_STATUS ps4000GetStreamingLatestValues(
            short handle, 
            ps4000StreamingReady lpPs4000aReady,
            void * pParameter) nogil 
    
    PICO_STATUS ps4000NoOfStreamingValues(
            short handle,
            unsigned long * noOfValues) nogil
    
    PICO_STATUS ps4000GetMaxDownSampleRatio(
            short handle,
            unsigned long noOfUnaggreatedSamples,
            unsigned long * maxDownSampleRatio,
            RATIO_MODE downSampleRatioMode,
            unsigned short segmentIndex) nogil
    
    PICO_STATUS ps4000GetValues(
            short handle,
            unsigned long startIndex,
            unsigned long * noOfSamples,
            unsigned long downSampleRatio,
            RATIO_MODE downSampleRatioMode,
            unsigned short segmentIndex,
            short * overflow) nogil
    
    PICO_STATUS ps4000GetValuesBulk(
            short handle,
            unsigned long * noOfSamples,
            unsigned short fromSegmentIndex,
            unsigned short toSegmentIndex,
            short * overflow) nogil
    
    PICO_STATUS ps4000GetValuesAsync(
            short handle,
            unsigned long startIndex,
            unsigned long noOfSamples,
            unsigned long downSampleRatio,
            short downSampleRatioMode,
            unsigned short segmentIndex,
            void * lpDataReady,
            void * pParameter) nogil
    
    PICO_STATUS ps4000Stop(
            short handle) nogil
    
    PICO_STATUS ps4000HoldOff(
            short handle, 
            uint64_t holdoff,
            PS4000_HOLDOFF_TYPE type) nogil
    
    PICO_STATUS ps4000GetChannelInformation(
            short handle, 
            PS4000_CHANNEL_INFO info, 
            int probe, 
            int * ranges,
            int * length,
            int channels) nogil
    
    PICO_STATUS ps4000EnumerateUnits(
            short * count,
            char * serials,
            short * serialLth) nogil
    

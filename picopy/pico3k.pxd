# Henry Gomersall
# heng@kedevelopments.co.uk
#

from pico_status cimport PICO_STATUS, PICO_INFO
from libc.stdint cimport int64_t, uint64_t

# Simple constants replicated from ps3000aApi.h

cdef int PS3000A_MAX_OVERSAMPLE = 256

cdef int PS3206A_MAX_ETS_CYCLES = 500
cdef int PS3206A_MAX_INTERLEAVE = 40

cdef int PS3205A_MAX_ETS_CYCLES = 250
cdef int PS3205A_MAX_INTERLEAVE = 20

cdef int PS3204A_MAX_ETS_CYCLES = 125
cdef int PS3204A_MAX_INTERLEAVE = 10

cdef int PS3000A_EXT_MAX_VALUE = 32767
cdef int PS3000A_EXT_MIN_VALUE = -32767

cdef float MIN_SIG_GEN_FREQ = 0.0
cdef float MAX_SIG_GEN_FREQ = 20000000.0

cdef int PS3206B_MAX_SIG_GEN_BUFFER_SIZE = 16384
cdef int MAX_SIG_GEN_BUFFER_SIZE = 8192
cdef int MIN_SIG_GEN_BUFFER_SIZE = 1
cdef int MIN_DWELL_COUNT = 10
cdef int MAX_SWEEPS_SHOTS = 536870912 #((1 << 30) - 1)

cdef float MAX_ANALOGUE_OFFSET_50MV_200MV = 0.250
cdef float MIN_ANALOGUE_OFFSET_50MV_200MV = -0.250
cdef float MAX_ANALOGUE_OFFSET_500MV_2V = 2.500
cdef float MIN_ANALOGUE_OFFSET_500MV_2V = -2.500
cdef float MAX_ANALOGUE_OFFSET_5V_20V = 20.0
cdef float MIN_ANALOGUE_OFFSET_5V_20V = -20.0

cdef float PS3000A_SINE_MAX_FREQUENCY = 1000000.0
cdef float PS3000A_SQUARE_MAX_FREQUENCY = 1000000.0
cdef float PS3000A_TRIANGLE_MAX_FREQUENCY = 1000000.0
cdef float PS3000A_SINC_MAX_FREQUENCY = 1000000.0
cdef float PS3000A_RAMP_MAX_FREQUENCY = 1000000.0
cdef float PS3000A_HALF_SINE_MAX_FREQUENCY = 1000000.0
cdef float PS3000A_GAUSSIAN_MAX_FREQUENCY = 1000000.0
cdef float PS3000A_PRBS_MAX_FREQUENCY = 1000000.0
cdef float PS3000A_PRBS_MIN_FREQUENCY = 0.03
cdef float PS3000A_MIN_FREQUENCY = 0.03


cdef extern from 'libps3000a-1.0/ps3000aApi.h':

    ctypedef enum PS3000A_CHANNEL_BUFFER_INDEX:
        PS3000A_CHANNEL_A_MAX
        PS3000A_CHANNEL_A_MIN
        PS3000A_CHANNEL_B_MAX
        PS3000A_CHANNEL_B_MIN
        PS3000A_CHANNEL_C_MAX
        PS3000A_CHANNEL_C_MIN
        PS3000A_CHANNEL_D_MAX
        PS3000A_CHANNEL_D_MIN
        PS3000A_MAX_CHANNEL_BUFFERS

    ctypedef enum PS3000A_CHANNEL:
        PS3000A_CHANNEL_A
        PS3000A_CHANNEL_B
        PS3000A_CHANNEL_C
        PS3000A_CHANNEL_D
        PS3000A_EXTERNAL
        PS3000A_MAX_CHANNELS = PS3000A_EXTERNAL
        PS3000A_TRIGGER_AUX
        PS3000A_MAX_TRIGGER_SOURCES

    ctypedef enum PS3000A_RANGE:
        PS3000A_10MV
        PS3000A_20MV
        PS3000A_50MV
        PS3000A_100MV
        PS3000A_200MV
        PS3000A_500MV
        PS3000A_1V
        PS3000A_2V
        PS3000A_5V
        PS3000A_10V
        PS3000A_20V
        PS3000A_50V
        PS3000A_MAX_RANGES

    ctypedef enum  PS3000A_COUPLING:
        PS3000A_AC
        PS3000A_DC

    ctypedef enum PS3000A_CHANNEL_INFO:
        PS3000A_CI_RANGES

    ctypedef enum PS3000A_ETS_MODE:
        PS3000A_ETS_OFF             #ETS disabled
        PS3000A_ETS_FAST
        PS3000A_ETS_SLOW
        PS3000A_ETS_MODES_MAX

    ctypedef enum PS3000A_TIME_UNITS:
        PS3000A_FS
        PS3000A_PS
        PS3000A_NS
        PS3000A_US
        PS3000A_MS
        PS3000A_S
        PS3000A_MAX_TIME_UNITS

    ctypedef enum PS3000A_SWEEP_TYPE:
        PS3000A_UP
        PS3000A_DOWN
        PS3000A_UPDOWN
        PS3000A_DOWNUP
        PS3000A_MAX_SWEEP_TYPES

    ctypedef enum PS3000A_WAVE_TYPE:
        PS3000A_SINE
        PS3000A_SQUARE
        PS3000A_TRIANGLE
        PS3000A_RAMP_UP
        PS3000A_RAMP_DOWN
        PS3000A_SINC
        PS3000A_GAUSSIAN
        PS3000A_HALF_SINE
        PS3000A_DC_VOLTAGE
        PS3000A_MAX_WAVE_TYPES

    ctypedef enum PS3000A_EXTRA_OPERATIONS:
        PS3000A_ES_OFF
        PS3000A_WHITENOISE
        PS3000A_PRBS # Pseudo-Random Bit Stream 

    ctypedef enum PS3000A_SIGGEN_TRIG_TYPE:
        PS3000A_SIGGEN_RISING,
        PS3000A_SIGGEN_FALLING,
        PS3000A_SIGGEN_GATE_HIGH,
        PS3000A_SIGGEN_GATE_LOW

    ctypedef enum PS3000A_SIGGEN_TRIG_SOURCE:
        PS3000A_SIGGEN_NONE
        PS3000A_SIGGEN_SCOPE_TRIG
        PS3000A_SIGGEN_AUX_IN
        PS3000A_SIGGEN_EXT_IN
        PS3000A_SIGGEN_SOFT_TRIG

    ctypedef enum PS3000A_INDEX_MODE:
        PS3000A_SINGLE
        PS3000A_DUAL
        PS3000A_QUAD
        PS3000A_MAX_INDEX_MODES

    ctypedef enum PS3000A_THRESHOLD_MODE:
        PS3000A_LEVEL
        PS3000A_WINDOW

    ctypedef enum PS3000A_THRESHOLD_DIRECTION:
        PS3000A_ABOVE #using upper threshold
        PS3000A_BELOW 
        PS3000A_RISING # using upper threshold
        PS3000A_FALLING # using upper threshold
        PS3000A_RISING_OR_FALLING # using both threshold
        PS3000A_ABOVE_LOWER # using lower threshold
        PS3000A_BELOW_LOWER # using lower threshold
        PS3000A_RISING_LOWER # using upper threshold
        PS3000A_FALLING_LOWER # using upper threshold

        # Windowing using both thresholds
        PS3000A_INSIDE = PS3000A_ABOVE 
        PS3000A_OUTSIDE = PS3000A_BELOW
        PS3000A_ENTER = PS3000A_RISING 
        PS3000A_EXIT = PS3000A_FALLING 
        PS3000A_ENTER_OR_EXIT = PS3000A_RISING_OR_FALLING
        PS3000A_POSITIVE_RUNT = 9
        PS3000A_NEGATIVE_RUNT

        # no trigger set
        PS3000A_NONE = PS3000A_RISING 

    ctypedef enum PS3000A_TRIGGER_STATE:
        PS3000A_CONDITION_DONT_CARE
        PS3000A_CONDITION_TRUE
        PS3000A_CONDITION_FALSE
        PS3000A_CONDITION_MAX

    ctypedef struct PS3000A_TRIGGER_CONDITIONS:
        PS3000A_TRIGGER_STATE channelA
        PS3000A_TRIGGER_STATE channelB
        PS3000A_TRIGGER_STATE channelC
        PS3000A_TRIGGER_STATE channelD
        PS3000A_TRIGGER_STATE external
        PS3000A_TRIGGER_STATE aux
        PS3000A_TRIGGER_STATE pulseWidthQualifier

    ctypedef struct PS3000A_PWQ_CONDITIONS:
        PS3000A_TRIGGER_STATE channelA
        PS3000A_TRIGGER_STATE channelB
        PS3000A_TRIGGER_STATE channelC
        PS3000A_TRIGGER_STATE channelD
        PS3000A_TRIGGER_STATE external
        PS3000A_TRIGGER_STATE aux

    ctypedef struct PS3000A_TRIGGER_CHANNEL_PROPERTIES:
        short thresholdUpper
        unsigned short thresholdUpperHysteresis 
        short thresholdLower
        unsigned short thresholdLowerHysteresis
        PS3000A_CHANNEL channel
        PS3000A_THRESHOLD_MODE thresholdMode

    ctypedef enum PS3000A_RATIO_MODE:
        PS3000A_RATIO_MODE_NONE
        PS3000A_RATIO_MODE_AGGREGATE = 1
        PS3000A_RATIO_MODE_DECIMATE = 2
        PS3000A_RATIO_MODE_AVERAGE = 4

    ctypedef enum PS3000A_PULSE_WIDTH_TYPE:
        PS3000A_PW_TYPE_NONE
        PS3000A_PW_TYPE_LESS_THAN
        PS3000A_PW_TYPE_GREATER_THAN
        PS3000A_PW_TYPE_IN_RANGE
        PS3000A_PW_TYPE_OUT_OF_RANGE

    ctypedef enum PS3000A_HOLDOFF_TYPE:
        PS3000A_TIME
        PS3000A_EVENT
        PS3000A_MAX_HOLDOFF_TYPE

    ctypedef void (*ps3000aBlockReady)(
            short handle, PICO_STATUS status, void *pParameter) nogil

    ctypedef void (*ps3000aStreamingReady)(
            short handle,
            long noOfSamples,
            unsigned long startIndex,
            short overflow,
            unsigned long triggerAt,
            short triggered,
            short autoStop,
            void * pParameter) nogil

    ctypedef void (*ps3000aDataReady)(
            short handle,
            PICO_STATUS status,
            unsigned long noOfSamples,
            short overflow,
            void * pParameter) nogil
    
    PICO_STATUS ps3000aOpenUnit(
            short * handle,
            char * serial)

    PICO_STATUS ps3000aOpenUnitAsync(
            short * status,
            char * serial)

    PICO_STATUS ps3000aOpenUnitProgress(
            short * handle,
            short * progressPercent,
            short * complete) 

    PICO_STATUS ps3000aGetUnitInfo(
            short handle, 
            char * string,
            short stringLength,
            short * requiredSize,
            PICO_INFO info)

    PICO_STATUS ps3000aFlashLed(
            short handle,
            short start)
    
    PICO_STATUS ps3000aCloseUnit(
            short handle)
    
    PICO_STATUS ps3000aMemorySegments(
            short handle,
            unsigned short nSegments,
            long * nMaxSamples)
    
    PICO_STATUS ps3000aSetChannel(
            short handle,
            PS3000A_CHANNEL channel,
            short enabled,
            PS3000A_COUPLING type, 
            PS3000A_RANGE range,
            float analogOffset)

    PICO_STATUS ps3000aSetNoOfCaptures(
            short handle,
            unsigned short nCaptures)
    
    PICO_STATUS ps3000aGetTimebase(
            short handle,
            unsigned long timebase,
            long noSamples,
            long * timeIntervalNanoseconds,
            short oversample,
            long * maxSamples,
            unsigned short segmentIndex)
    
    PICO_STATUS ps3000aGetTimebase2(
            short handle,
            unsigned long timebase,
            long noSamples,
            float * timeIntervalNanoseconds,
            short oversample,
            long * maxSamples,
            unsigned short segmentIndex)
    
    PICO_STATUS ps3000aSetSigGenArbitrary(
            short handle,
            long offsetVoltage,
            unsigned long pkToPk,
            unsigned long startDeltaPhase,
            unsigned long stopDeltaPhase,
            unsigned long deltaPhaseIncrement, 
            unsigned long dwellCount,
            short * arbitraryWaveform, 
            long arbitraryWaveformSize,
            PS3000A_SWEEP_TYPE sweepType,
            PS3000A_EXTRA_OPERATIONS operation,
            PS3000A_INDEX_MODE indexMode,
            unsigned long shots,
            unsigned long sweeps,
            PS3000A_SIGGEN_TRIG_TYPE triggerType,
            PS3000A_SIGGEN_TRIG_SOURCE triggerSource,
            short extInThreshold)
    
    PICO_STATUS ps3000aSetSigGenBuiltIn(
            short handle,
            long offsetVoltage,
            unsigned long pkToPk,
            short waveType,
            float startFrequency,
            float stopFrequency,
            float increment,
            float dwellTime,
            PS3000A_SWEEP_TYPE sweepType,
            PS3000A_EXTRA_OPERATIONS operation,
            unsigned long shots,
            unsigned long sweeps,
            PS3000A_SIGGEN_TRIG_TYPE triggerType,
            PS3000A_SIGGEN_TRIG_SOURCE triggerSource,
            short extInThreshold)
    
    PICO_STATUS ps3000aSigGenSoftwareControl(
            short handle,
            short state)
    
    PICO_STATUS ps3000aSetEts(
            short handle,
            PS3000A_ETS_MODE mode,
            short etsCycles,
            short etsInterleave,
            long * sampleTimePicoseconds)
    
    PICO_STATUS ps3000aSetSimpleTrigger(
            short handle,
            short enable,
            PS3000A_CHANNEL source,
            short threshold,
            PS3000A_THRESHOLD_DIRECTION direction,
            unsigned long delay,
            short autoTrigger_ms)
    
    PICO_STATUS ps3000aSetTriggerChannelProperties(
            short handle,
            PS3000A_TRIGGER_CHANNEL_PROPERTIES * channelProperties,
            short nChannelProperties,
            short auxOutputEnable,
            long autoTriggerMilliseconds)
    
    PICO_STATUS ps3000aSetTriggerChannelConditions(
            short handle,
            PS3000A_TRIGGER_CONDITIONS * conditions,
            short nConditions)
    
    PICO_STATUS ps3000aSetTriggerChannelDirections(
            short handle,
            PS3000A_THRESHOLD_DIRECTION channelA,
            PS3000A_THRESHOLD_DIRECTION channelB,
            PS3000A_THRESHOLD_DIRECTION channelC,
            PS3000A_THRESHOLD_DIRECTION channelD,
            PS3000A_THRESHOLD_DIRECTION ext,
            PS3000A_THRESHOLD_DIRECTION aux)
    
    PICO_STATUS ps3000aSetTriggerDelay(
            short handle,
            unsigned long delay)
    
    PICO_STATUS ps3000aSetPulseWidthQualifier(
            short handle,
            PS3000A_PWQ_CONDITIONS * conditions,
            short nConditions,
            PS3000A_THRESHOLD_DIRECTION direction,
            unsigned long lower,
            unsigned long upper,
            PS3000A_PULSE_WIDTH_TYPE type)
    
    PICO_STATUS ps3000aIsTriggerOrPulseWidthQualifierEnabled(
            short handle,
            short * triggerEnabled,
            short * pulseWidthQualifierEnabled)
    
    PICO_STATUS ps3000aGetTriggerTimeOffset(
            short handle,
            unsigned long * timeUpper,
            unsigned long * timeLower,
            PS3000A_TIME_UNITS * timeUnits,
            unsigned short segmentIndex )
    
    PICO_STATUS ps3000aGetTriggerTimeOffset64(
            short handle,
            int64_t * time,
            PS3000A_TIME_UNITS * timeUnits,
            unsigned short segmentIndex )
    
    PICO_STATUS ps3000aGetValuesTriggerTimeOffsetBulk(
            short handle,
            unsigned long * timesUpper,
            unsigned long * timesLower,
            PS3000A_TIME_UNITS * timeUnits,
            unsigned short fromSegmentIndex,
            unsigned short toSegmentIndex)
    
    PICO_STATUS ps3000aGetValuesTriggerTimeOffsetBulk64(
            short handle,
            int64_t * times,
            PS3000A_TIME_UNITS * timeUnits,
            unsigned short fromSegmentIndex,
            unsigned short toSegmentIndex)
    
    PICO_STATUS ps3000aGetNoOfCaptures(
            short handle,
            unsigned long * nCaptures)
    
    PICO_STATUS ps3000aGetNoOfProcessedCaptures(
            short handle,
            unsigned long * nProcessedCaptures)
    
    PICO_STATUS ps3000aSetDataBuffer(
            short handle,
            PS3000A_CHANNEL channel,
            short * buffer,
            long bufferLth,
            unsigned short segmentIndex,
            PS3000A_RATIO_MODE mode)
    
    PICO_STATUS ps3000aSetDataBuffers(
            short handle,
            PS3000A_CHANNEL channel,
            short * bufferMax,
            short * bufferMin,
            long bufferLth,
            unsigned short segmentIndex,
            PS3000A_RATIO_MODE mode)
    
    PICO_STATUS ps3000aSetEtsTimeBuffer(
            short handle,
            int64_t * buffer,
            long bufferLth)
    
    PICO_STATUS ps3000aSetEtsTimeBuffers(
            short handle,
            unsigned long * timeUpper,
            unsigned long * timeLower,
            long bufferLth)
    
    PICO_STATUS ps3000aIsReady(
            short handle,
            short * ready)
    
    PICO_STATUS ps3000aRunBlock(
            short handle,
            long noOfPreTriggerSamples,
            long noOfPostTriggerSamples,
            unsigned long timebase,
            short oversample,
            long * timeIndisposedMs,
            unsigned short segmentIndex,
            ps3000aBlockReady lpReady,
            void * pParameter)
    
    PICO_STATUS ps3000aRunStreaming(
            short handle,
            unsigned long * sampleInterval, 
            PS3000A_TIME_UNITS sampleIntervalTimeUnits,
            unsigned long maxPreTriggerSamples,
            unsigned long maxPostPreTriggerSamples,
            short autoStop,
            unsigned long downSampleRatio,
            PS3000A_RATIO_MODE downSampleRatioMode,
            unsigned long overviewBufferSize)
    
    PICO_STATUS ps3000aGetStreamingLatestValues(
            short handle, 
            ps3000aStreamingReady lpPs3000aReady,
            void * pParameter) 
    
    PICO_STATUS ps3000aNoOfStreamingValues(
            short handle,
            unsigned long * noOfValues)
    
    PICO_STATUS ps3000aGetMaxDownSampleRatio(
            short handle,
            unsigned long noOfUnaggreatedSamples,
            unsigned long * maxDownSampleRatio,
            PS3000A_RATIO_MODE downSampleRatioMode,
            unsigned short segmentIndex)
    
    PICO_STATUS ps3000aGetValues(
            short handle,
            unsigned long startIndex,
            unsigned long * noOfSamples,
            unsigned long downSampleRatio,
            PS3000A_RATIO_MODE downSampleRatioMode,
            unsigned short segmentIndex,
            short * overflow)
    
    PICO_STATUS ps3000aGetValuesBulk(
            short handle,
            unsigned long * noOfSamples,
            unsigned short fromSegmentIndex,
            unsigned short toSegmentIndex,
            unsigned long downSampleRatio,
            PS3000A_RATIO_MODE downSampleRatioMode,
            short * overflow)
    
    PICO_STATUS ps3000aGetValuesAsync(
            short handle,
            unsigned long startIndex,
            unsigned long noOfSamples,
            unsigned long downSampleRatio,
            short downSampleRatioMode,
            unsigned short segmentIndex,
            void * lpDataReady,
            void * pParameter)
    
    PICO_STATUS ps3000aGetValuesOverlapped(
            short handle,
            unsigned long startIndex,
            unsigned long * noOfSamples,
            unsigned long downSampleRatio,
            PS3000A_RATIO_MODE downSampleRatioMode,
            unsigned short segmentIndex,
            short * overflow)
    
    PICO_STATUS ps3000aGetValuesOverlappedBulk(
            short handle,
            unsigned long startIndex,
            unsigned long * noOfSamples,
            unsigned long downSampleRatio,
            PS3000A_RATIO_MODE downSampleRatioMode,
            unsigned short fromSegmentIndex,
            unsigned short toSegmentIndex,
            short * overflow)
    
    PICO_STATUS ps3000aStop(
            short handle)
    
    PICO_STATUS ps3000aHoldOff(
            short handle, 
            uint64_t holdoff,
            PS3000A_HOLDOFF_TYPE type)
    
    PICO_STATUS ps3000aGetChannelInformation(
            short handle, 
            PS3000A_CHANNEL_INFO info, 
            int probe, 
            int * ranges,
            int * length,
            int channels)
    
    PICO_STATUS ps3000aEnumerateUnits(
            short * count,
            char * serials,
            short * serialLth)
    
    PICO_STATUS ps3000aPingUnit(
            short handle)
    
    PICO_STATUS ps3000aMaximumValue(
            short handle,
            short * value)
    
    PICO_STATUS ps3000aMinimumValue(
            short handle,
            short * value)
    
    PICO_STATUS ps3000aGetAnalogueOffset(
            short handle, 
            PS3000A_RANGE range,
            PS3000A_COUPLING coupling,
            float * maximumVoltage,
            float * minimumVoltage)
    
    PICO_STATUS ps3000aGetMaxSegments(
            short handle,
            unsigned short * maxSegments)
    

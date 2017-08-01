from pico_status cimport PICO_STATUS, PICO_INFO
from libc.stdint cimport long, uint64_t


cdef extern from 'ps5000aApi.h':
    cdef int PS5000A_MAX_VALUE_8BIT = 32512
    cdef int PS5000A_MIN_VALUE_8BIT = -32512

    cdef int PS5000A_MAX_VALUE_16BIT = 32767
    cdef int PS5000A_MIN_VALUE_16BIT = -32767

    cdef int PS5000A_LOST_DATA = -32768

    cdef int PS5000A_EXT_MAX_VALUE = 32767
    cdef int PS5000A_EXT_MIN_VALUE = -32767

    cdef int MAX_PULSE_WIDTH_QUALIFIER_COUNT = 16777215
    cdef int MAX_DELAY_COUNT                 =  8388607

    # covers the 5242A/B and 5442A/B
    cdef int PS5X42A_MAX_SIG_GEN_BUFFER_SIZE = 16384
    # covers the 5243A/B and 5443A/B
    cdef int PS5X43A_MAX_SIG_GEN_BUFFER_SIZE = 32768
    # covers the 5244A/B and 5444A/B
    cdef int PS5X44A_MAX_SIG_GEN_BUFFER_SIZE = 49152

    cdef int MIN_SIG_GEN_BUFFER_SIZE = 1
    cdef int MIN_DWELL_COUNT	=	3
    cdef int MAX_SWEEPS_SHOTS	=	((1 << 30) - 1)
    cdef int AWG_DAC_FREQUENCY	=	200e6
    cdef int AWG_PHASE_ACCUMULATOR = 4294967296.0

    cdef int MAX_ANALOGUE_OFFSET_50MV_200MV = 0.250
    cdef int MIN_ANALOGUE_OFFSET_50MV_200MV = -0.250
    cdef int MAX_ANALOGUE_OFFSET_500MV_2V   = 2.500
    cdef int MIN_ANALOGUE_OFFSET_500MV_2V   = -2.500
    cdef int MAX_ANALOGUE_OFFSET_5V_20V     =  20.
    cdef int MIN_ANALOGUE_OFFSET_5V_20V     = -20.
    
    cdef int PS5244A_MAX_ETS_CYCLES = 500  # PS5242A, PS5242B, PS5442A, PS5442B
    cdef int PS5244A_MAX_ETS_INTERLEAVE = 40

    cdef int PS5243A_MAX_ETS_CYCLES = 250  # PS5243A, PS5243B, PS5443A, PS5443B
    cdef int PS5243A_MAX_ETS_INTERLEAVE = 20

    cdef int PS5242A_MAX_ETS_CYCLES = 125  # PS5242A, PS5242B, PS5442A, PS5442B
    cdef int PS5242A_MAX_ETS_INTERLEAVE = 10

    cdef int PS5000A_SHOT_SWEEP_TRIGGER_CONTINUOUS_RUN = 0xFFFFFFFF

    ctypedef enum PS5000A_DEVICE_RESOLUTION:
        PS5000A_DR_8BIT
        PS5000A_DR_12BIT
        PS5000A_DR_14BIT
        PS5000A_DR_15BIT
        PS5000A_DR_16BIT
        
    ctypedef enum PS5000A_EXTRA_OPERATIONS:
        PS5000A_ES_OFF
        PS5000A_WHITENOISE
        PS5000A_PRBS # Pseudo-Random Bit Stream

    ctypedef enum PS5000A_BANDWIDTH_LIMITER:
        PS5000A_BW_FULL
        PS5000A_BW_20MHZ
        
    ctypedef enum PS5000A_COUPLING:
        PS5000A_AC
        PS5000A_DC

    ctypedef enum PS5000A_CHANNEL:
        PS5000A_CHANNEL_A
        PS5000A_CHANNEL_B
        PS5000A_CHANNEL_C
        PS5000A_CHANNEL_D
        PS5000A_EXTERNAL
        PS5000A_MAX_CHANNELS = PS5000A_EXTERNAL
        PS5000A_TRIGGER_AUX
        PS5000A_MAX_TRIGGER_SOURCES

    ctypedef enum PS5000A_CHANNEL_BUFFER_INDEX:
        PS5000A_CHANNEL_A_MAX
        PS5000A_CHANNEL_A_MIN
        PS5000A_CHANNEL_B_MAX
        PS5000A_CHANNEL_B_MIN
        PS5000A_CHANNEL_C_MAX
        PS5000A_CHANNEL_C_MIN
        PS5000A_CHANNEL_D_MAX
        PS5000A_CHANNEL_D_MIN
        PS5000A_MAX_CHANNEL_BUFFERS

    ctypedef enum PS5000A_RANGE:
        PS5000A_10MV
        PS5000A_20MV
        PS5000A_50MV
        PS5000A_100MV
        PS5000A_200MV
        PS5000A_500MV
        PS5000A_1V
        PS5000A_2V
        PS5000A_5V
        PS5000A_10V
        PS5000A_20V
        PS5000A_50V
        PS5000A_MAX_RANGES
        
        
        
    ctypedef enum PS5000A_ETS_MODE:
        PS5000A_ETS_OFF  # ETS disabled
        PS5000A_ETS_FAST # Return ready as soon as requested no of interleaves is available
        PS5000A_ETS_SLOW # Return ready every time a new set of no_of_cycles is collected
        PS5000A_ETS_MODES_MAX

    ctypedef enum PS5000A_TIME_UNITS:
        PS5000A_FS
        PS5000A_PS
        PS5000A_NS
        PS5000A_US
        PS5000A_MS
        PS5000A_S
        PS5000A_MAX_TIME_UNITS

    ctypedef enum PS5000A_SWEEP_TYPE:
        PS5000A_UP
        PS5000A_DOWN
        PS5000A_UPDOWN
        PS5000A_DOWNUP
        PS5000A_MAX_SWEEP_TYPES

    ctypedef enum PS5000A_WAVE_TYPE:
        PS5000A_SINE
        PS5000A_SQUARE
        PS5000A_TRIANGLE
        PS5000A_RAMP_UP
        PS5000A_RAMP_DOWN
        PS5000A_SINC
        PS5000A_GAUSSIAN
        PS5000A_HALF_SINE
        PS5000A_DC_VOLTAGE
        PS5000A_WHITE_NOISE
        PS5000A_MAX_WAVE_TYPES

    cdef float PS5000A_SINE_MAX_FREQUENCY     =  20000000.
    cdef float PS5000A_SQUARE_MAX_FREQUENCY   =  20000000.
    cdef float PS5000A_TRIANGLE_MAX_FREQUENCY =  20000000.
    cdef float PS5000A_SINC_MAX_FREQUENCY     =  20000000.
    cdef float PS5000A_RAMP_MAX_FREQUENCY     =  20000000.
    cdef float PS5000A_HALF_SINE_MAX_FREQUENCY=  20000000.
    cdef float PS5000A_GAUSSIAN_MAX_FREQUENCY =  20000000.
    cdef float PS5000A_MIN_FREQUENCY          =       0.03

    ctypedef enum PS5000A_SIGGEN_TRIG_TYPE:
        PS5000A_SIGGEN_RISING
        PS5000A_SIGGEN_FALLING
        PS5000A_SIGGEN_GATE_HIGH
        PS5000A_SIGGEN_GATE_LOW

    ctypedef enum PS5000A_SIGGEN_TRIG_SOURCE:
        PS5000A_SIGGEN_NONE
        PS5000A_SIGGEN_SCOPE_TRIG
        PS5000A_SIGGEN_AUX_IN
        PS5000A_SIGGEN_EXT_IN
        PS5000A_SIGGEN_SOFT_TRIG

    ctypedef enum PS5000A_INDEX_MODE:
        PS5000A_SINGLE
        PS5000A_DUAL
        PS5000A_QUAD
        PS5000A_MAX_INDEX_MODES

    ctypedef enum PS5000A_THRESHOLD_MODE:
        PS5000A_LEVEL
        PS5000A_WINDOW

    ctypedef enum PS5000A_THRESHOLD_DIRECTION:
        PS5000A_ABOVE #using upper threshold
        PS5000A_BELOW #using upper threshold
        PS5000A_RISING # using upper threshold
        PS5000A_FALLING # using upper threshold
        PS5000A_RISING_OR_FALLING # using both threshold
        PS5000A_ABOVE_LOWER # using lower threshold
        PS5000A_BELOW_LOWER # using lower threshold
        PS5000A_RISING_LOWER   # using lower threshold
        PS5000A_FALLING_LOWER  # using lower threshold

        # Windowing using both thresholds
        PS5000A_INSIDE = PS5000A_ABOVE
        PS5000A_OUTSIDE = PS5000A_BELOW
        PS5000A_ENTER = PS5000A_RISING
        PS5000A_EXIT = PS5000A_FALLING
        PS5000A_ENTER_OR_EXIT = PS5000A_RISING_OR_FALLING
        PS5000A_POSITIVE_RUNT = 9
        PS5000A_NEGATIVE_RUNT

        # no trigger set
        PS5000A_NONE = PS5000A_RISING


    ctypedef enum PS5000A_TRIGGER_STATE:
        PS5000A_CONDITION_DONT_CARE
        PS5000A_CONDITION_TRUE
        PS5000A_CONDITION_FALSE
        PS5000A_CONDITION_MAX

    ctypedef enum PS5000A_TRIGGER_WITHIN_PRE_TRIGGER:
        PS5000A_DISABLE
        PS5000A_ARM

    ctypedef struct PS5000A_TRIGGER_INFO:
        PICO_STATUS		status
        unsigned int 	segmentIndex
        unsigned int 	triggerIndex
        long		triggerTime
        short		timeUnits
        short		reserved0
        unsigned short  	reserved1	

    ctypedef struct PS5000A_TRIGGER_CONDITIONS:
        PS5000A_TRIGGER_STATE channelA
        PS5000A_TRIGGER_STATE channelB
        PS5000A_TRIGGER_STATE channelC
        PS5000A_TRIGGER_STATE channelD
        PS5000A_TRIGGER_STATE external
        PS5000A_TRIGGER_STATE aux
        PS5000A_TRIGGER_STATE pulseWidthQualifier
  
    ctypedef struct PS5000A_PWQ_CONDITIONS:
    
        PS5000A_TRIGGER_STATE channelA
        PS5000A_TRIGGER_STATE channelB
        PS5000A_TRIGGER_STATE channelC
        PS5000A_TRIGGER_STATE channelD
        PS5000A_TRIGGER_STATE external
        PS5000A_TRIGGER_STATE aux
    
    ctypedef struct PS5000A_TRIGGER_CHANNEL_PROPERTIES:
        short                   thresholdUpper
        unsigned short          thresholdUpperHysteresis
        short                   thresholdLower
        unsigned short          thresholdLowerHysteresis
        PS5000A_CHANNEL         channel
        PS5000A_THRESHOLD_MODE  thresholdMode
    
    ctypedef enum PS5000A_RATIO_MODE:
        PS5000A_RATIO_MODE_NONE         = 0
        PS5000A_RATIO_MODE_AGGREGATE    = 1
        PS5000A_RATIO_MODE_DECIMATE     = 2
        PS5000A_RATIO_MODE_AVERAGE      = 4
        PS5000A_RATIO_MODE_DISTRIBUTION = 8

    ctypedef enum PS5000A_PULSE_WIDTH_TYPE:
        PS5000A_PW_TYPE_NONE
        PS5000A_PW_TYPE_LESS_THAN
        PS5000A_PW_TYPE_GREATER_THAN
        PS5000A_PW_TYPE_IN_RANGE
        PS5000A_PW_TYPE_OUT_OF_RANGE
    
    ctypedef enum PS5000A_CHANNEL_INFO:
        PS5000A_CI_RANGES
    
    ctypedef void (*ps5000aBlockReady)( 
        short handle, PICO_STATUS status, void *pParameter) nogil

    ctypedef void (*ps5000aStreamingReady)(
        short handle,
        long noOfSamples,
        unsigned long startIndex,
        short overflow,
        unsigned long triggerAt,
        short triggered,
        short autoStop,
        void * pParameter) nogil

    ctypedef void (*ps5000aDataReady)(
        short          handle,
        PICO_STATUS    status,
        unsigned int   noOfSamples,
        short          overflow,
        void           *pParameter) nogil

    PICO_STATUS ps5000aOpenUnit(
        short                     *handle,
        char                      *serial,
        PS5000A_DEVICE_RESOLUTION  resolution) nogil
    

    PICO_STATUS ps5000aOpenUnitAsync(
        short                     *status,
        char                      *serial,
        PS5000A_DEVICE_RESOLUTION  resolution) nogil

    PICO_STATUS   ps5000aOpenUnitProgress(
        short *handle,
        short *progressPercent,
        short *complete) nogil

    PICO_STATUS ps5000aGetUnitInfo(
        short      handle,
        char		*  string,
        short      stringLength,
        short     *requiredSize,
        PICO_INFO  info) nogil

    PICO_STATUS ps5000aFlashLed(
        short  handle,
        short  start) nogil

    PICO_STATUS ps5000aIsLedFlashing(
        short  handle,
        short *status) nogil

    PICO_STATUS ps5000aCloseUnit(
        short  handle) nogil

    PICO_STATUS ps5000aMemorySegments(
        short          handle,
        unsigned int  nSegments,
        int          *nMaxSamples) nogil

    PICO_STATUS ps5000aSetChannel(
        short             handle,
        PS5000A_CHANNEL   channel,
        short             enabled,
        PS5000A_COUPLING  type,
        PS5000A_RANGE     range,
        float             analogOffset) nogil

    PICO_STATUS ps5000aSetBandwidthFilter(
        short                      handle,
        PS5000A_CHANNEL            channel,
        PS5000A_BANDWIDTH_LIMITER  bandwidth) nogil

    PICO_STATUS ps5000aGetTimebase(
        short          handle,
        unsigned int  timebase,
        int           noSamples,
        int          *timeIntervalNanoseconds,
        int          *maxSamples,
        unsigned int  segmentIndex) nogil

    PICO_STATUS ps5000aGetTimebase2(
        short          handle,
        unsigned int  timebase,
        int           noSamples,
        float         *timeIntervalNanoseconds,
        int          *maxSamples,
        unsigned int  segmentIndex) nogil

    PICO_STATUS ps5000aSetSigGenArbitrary(
        short                       handle,
        int                        offsetVoltage,
        unsigned int               pkToPk,
        unsigned int               startDeltaPhase,
        unsigned int               stopDeltaPhase,
        unsigned int               deltaPhaseIncrement,
        unsigned int               dwellCount,
        short                      *arbitraryWaveform,
        int                        arbitraryWaveformSize,
        PS5000A_SWEEP_TYPE          sweepType,
        PS5000A_EXTRA_OPERATIONS    operation,
        PS5000A_INDEX_MODE          indexMode,
        unsigned int               shots,
        unsigned int               sweeps,
        PS5000A_SIGGEN_TRIG_TYPE    triggerType,
        PS5000A_SIGGEN_TRIG_SOURCE  triggerSource,
        short                       extInThreshold) nogil

    PICO_STATUS ps5000aSetSigGenBuiltIn(
        short                       handle,
        int                        offsetVoltage,
        unsigned int               pkToPk,
        PS5000A_WAVE_TYPE           waveType,
        float                       startFrequency,
        float                       stopFrequency,
        float                       increment,
        float                       dwellTime,
        PS5000A_SWEEP_TYPE          sweepType,
        PS5000A_EXTRA_OPERATIONS    operation,
        unsigned int               shots,
        unsigned int               sweeps,
        PS5000A_SIGGEN_TRIG_TYPE    triggerType,
        PS5000A_SIGGEN_TRIG_SOURCE  triggerSource,
        short                       extInThreshold) nogil

    PICO_STATUS ps5000aSetSigGenBuiltInV2(
        short                       handle,
        int                        offsetVoltage,
        unsigned int               pkToPk,
        PS5000A_WAVE_TYPE           waveType,
        double                       startFrequency,
        double                       stopFrequency,
        double                       increment,
        double                       dwellTime,
        PS5000A_SWEEP_TYPE          sweepType,
        PS5000A_EXTRA_OPERATIONS    operation,
        unsigned int               shots,
        unsigned int               sweeps,
        PS5000A_SIGGEN_TRIG_TYPE    triggerType,
        PS5000A_SIGGEN_TRIG_SOURCE  triggerSource,
        short                       extInThreshold) nogil

    PICO_STATUS ps5000aSetSigGenPropertiesArbitrary(
        short                       handle,
        unsigned int               startDeltaPhase,
        unsigned int               stopDeltaPhase,
        unsigned int               deltaPhaseIncrement,
        unsigned int               dwellCount,
        PS5000A_SWEEP_TYPE          sweepType,
        unsigned int               shots,
        unsigned int               sweeps,
        PS5000A_SIGGEN_TRIG_TYPE    triggerType,
        PS5000A_SIGGEN_TRIG_SOURCE  triggerSource,
        short                       extInThreshold) nogil

    PICO_STATUS  ps5000aSetSigGenPropertiesBuiltIn(
        short                       handle,
        double                       startFrequency,
        double                       stopFrequency,
        double                       increment,
        double                       dwellTime,
        PS5000A_SWEEP_TYPE          sweepType,
        unsigned int               shots,
        unsigned int               sweeps,
        PS5000A_SIGGEN_TRIG_TYPE    triggerType,
        PS5000A_SIGGEN_TRIG_SOURCE  triggerSource,
        short                       extInThreshold) nogil

    PICO_STATUS ps5000aSigGenFrequencyToPhase(
        short						handle,
        double						frequency,
        PS5000A_INDEX_MODE			indexMode,
        unsigned int				bufferLength,
        unsigned int				* phase) nogil

    PICO_STATUS ps5000aSigGenArbitraryMinMaxValues(
        short			handle,
        short		*	minArbitraryWaveformValue,
        short		*	maxArbitraryWaveformValue,
        unsigned int	* minArbitraryWaveformSize,
        unsigned int	*	maxArbitraryWaveformSize) nogil

    PICO_STATUS ps5000aSigGenSoftwareControl(
        short  handle,
        short  state) nogil

    PICO_STATUS ps5000aSetEts(
        short             handle,
        PS5000A_ETS_MODE  mode,
        short             etsCycles,
        short             etsInterleave,
        int             *sampleTimePicoseconds) nogil

    PICO_STATUS ps5000aSetTriggerChannelProperties(
        short                               handle,
        PS5000A_TRIGGER_CHANNEL_PROPERTIES *channelProperties,
        short                               nChannelProperties,
        short                               auxOutputEnable,
        int                                autoTriggerMilliseconds) nogil

    PICO_STATUS ps5000aSetTriggerChannelConditions(
        short                       handle,
        PS5000A_TRIGGER_CONDITIONS *conditions,
        short                       nConditions) nogil

    PICO_STATUS ps5000aSetTriggerChannelDirections(
        short                        handle,
        PS5000A_THRESHOLD_DIRECTION  channelA,
        PS5000A_THRESHOLD_DIRECTION  channelB,
        PS5000A_THRESHOLD_DIRECTION  channelC,
        PS5000A_THRESHOLD_DIRECTION  channelD,
        PS5000A_THRESHOLD_DIRECTION  ext,
        PS5000A_THRESHOLD_DIRECTION  aux) nogil

    PICO_STATUS ps5000aSetSimpleTrigger(
        short                        handle,
        short                        enable,
        PS5000A_CHANNEL              source,
        short                        threshold,
        PS5000A_THRESHOLD_DIRECTION  direction,
        unsigned int                delay,
        short                        autoTrigger_ms) nogil

    PICO_STATUS ps5000aSetTriggerDelay(
        short          handle,
        unsigned int  delay) nogil

    PICO_STATUS ps5000aSetPulseWidthQualifier(
        short                        handle,
        PS5000A_PWQ_CONDITIONS      *conditions,
        short                        nConditions,
        PS5000A_THRESHOLD_DIRECTION  direction,
        unsigned int                lower,
        unsigned int                upper,
        PS5000A_PULSE_WIDTH_TYPE     type) nogil

    PICO_STATUS ps5000aIsTriggerOrPulseWidthQualifierEnabled(
        short  handle,
        short *triggerEnabled,
        short *pulseWidthQualifierEnabled) nogil

    PICO_STATUS ps5000aGetTriggerTimeOffset(
        short               handle,
        unsigned int      *timeUpper,
        unsigned int      *timeLower,
        PS5000A_TIME_UNITS *timeUnits,
        unsigned int       segmentIndex) nogil

    PICO_STATUS ps5000aGetTriggerTimeOffset64(
        short               handle,
        long            *time,
        PS5000A_TIME_UNITS *timeUnits,
        unsigned int       segmentIndex) nogil

    PICO_STATUS ps5000aGetValuesTriggerTimeOffsetBulk(
        short               handle,
        unsigned int      *timesUpper,
        unsigned int      *timesLower,
        PS5000A_TIME_UNITS *timeUnits,
        unsigned int       fromSegmentIndex,
        unsigned int       toSegmentIndex) nogil

    PICO_STATUS ps5000aGetValuesTriggerTimeOffsetBulk64(
        short               handle,
        long            *times,
        PS5000A_TIME_UNITS *timeUnits,
        unsigned int       fromSegmentIndex,
        unsigned int       toSegmentIndex) nogil

    PICO_STATUS ps5000aSetDataBuffers(
        short               handle,
        PS5000A_CHANNEL     channel,
        short              *bufferMax,
        short              *bufferMin,
        int                bufferLth,
        unsigned int       segmentIndex,
        PS5000A_RATIO_MODE  mode) nogil

    PICO_STATUS ps5000aSetDataBuffer(
        short               handle,
        PS5000A_CHANNEL     channel,
        short              *buffer,
        int                bufferLth,
        unsigned int       segmentIndex,
        PS5000A_RATIO_MODE  mode) nogil

    PICO_STATUS ps5000aSetEtsTimeBuffer(
        short     handle,
        long  *buffer,
        int      bufferLth) nogil

    PICO_STATUS ps5000aSetEtsTimeBuffers(
        short          handle,
        unsigned int *timeUpper,
        unsigned int *timeLower,
        int           bufferLth) nogil

    PICO_STATUS ps5000aIsReady(
        short handle,
        short * read) nogil

    PICO_STATUS ps5000aRunBlock(
        short              handle,
        int               noOfPreTriggerSamples,
        int               noOfPostTriggerSamples,
        unsigned int      timebase,
        int              *timeIndisposedMs,
        unsigned int      segmentIndex,
        ps5000aBlockReady  lpReady,
        void              *pParameter) nogil

    PICO_STATUS ps5000aRunStreaming(
        short               handle,
        unsigned int      *sampleInterval,
        PS5000A_TIME_UNITS  sampleIntervalTimeUnits,
        unsigned int       maxPreTriggerSamples,
        unsigned int       maxPostTriggerSamples,
        short               autoStop,
        unsigned int       downSampleRatio,
        PS5000A_RATIO_MODE  downSampleRatioMode,
        unsigned int       overviewBufferSize) nogil

    PICO_STATUS ps5000aGetStreamingLatestValues(
        short                  handle,
        ps5000aStreamingReady  lpPs5000aReady,
        void                  *pParameter) nogil

    PICO_STATUS ps5000aNoOfStreamingValues(
        short          handle,
        unsigned int *noOfValues) nogil

    PICO_STATUS ps5000aGetMaxDownSampleRatio(
        short               handle,
        unsigned int       noOfUnaggreatedSamples,
        unsigned int      *maxDownSampleRatio,
        PS5000A_RATIO_MODE  downSampleRatioMode,
        unsigned int       segmentIndex) nogil

    PICO_STATUS ps5000aGetValues(
        short               handle,
        unsigned int       startIndex,
        unsigned int      *noOfSamples,
        unsigned int       downSampleRatio,
        PS5000A_RATIO_MODE  downSampleRatioMode,
        unsigned int       segmentIndex,
        short              *overflow) nogil

    PICO_STATUS ps5000aGetValuesAsync(
        short               handle,
        unsigned int       startIndex,
        unsigned int       noOfSamples,
        unsigned int       downSampleRatio,
        PS5000A_RATIO_MODE  downSampleRatioMode,
        unsigned int       segmentIndex,
        void               *lpDataReady,
        void               *pParameter) nogil

    PICO_STATUS ps5000aGetValuesBulk(
        short               handle,
        unsigned int      *noOfSamples,
        unsigned int       fromSegmentIndex,
        unsigned int       toSegmentIndex,
        unsigned int       downSampleRatio,
        PS5000A_RATIO_MODE  downSampleRatioMode,
        short              *overflow) nogil

    PICO_STATUS ps5000aGetValuesOverlapped(
        short               handle,
        unsigned int       startIndex,
        unsigned int      *noOfSamples,
        unsigned int       downSampleRatio,
        PS5000A_RATIO_MODE  downSampleRatioMode,
        unsigned int       segmentIndex,
        short              *overflow) nogil

    PICO_STATUS ps5000aGetValuesOverlappedBulk(
        short               handle,
        unsigned int       startIndex,
        unsigned int      *noOfSamples,
        unsigned int       downSampleRatio,
        PS5000A_RATIO_MODE  downSampleRatioMode,
        unsigned int       fromSegmentIndex,
        unsigned int       toSegmentIndex,
        short              *overflow) nogil

    PICO_STATUS ps5000aTriggerWithinPreTriggerSamples(
        short handle,
        PS5000A_TRIGGER_WITHIN_PRE_TRIGGER state) nogil

    PICO_STATUS ps5000aGetTriggerInfoBulk(
        short										handle,
        PS5000A_TRIGGER_INFO	*	triggerInfo,
        unsigned int						fromSegmentIndex,
        unsigned int						toSegmentIndex) nogil

    PICO_STATUS ps5000aEnumerateUnits(
        short *count,
        char  *serials,
        short *serialLth) nogil

    PICO_STATUS ps5000aGetChannelInformation(
        short                 handle,
        PS5000A_CHANNEL_INFO  info,
        int                   probe,
        int                  *ranges,
        int                  *length,
        int                   channels) nogil

    PICO_STATUS ps5000aMaximumValue(
        short  handle,
        short *value) nogil

    PICO_STATUS ps5000aMinimumValue(
        short  handle,
        short * value) nogil

    PICO_STATUS ps5000aGetAnalogueOffset(
        short             handle,
        PS5000A_RANGE     range,
        PS5000A_COUPLING  coupling,
        float            *maximumVoltage,
        float            *minimumVoltage) nogil

    PICO_STATUS ps5000aGetMaxSegments(
        short          handle,
        unsigned int *maxSegments) nogil

    PICO_STATUS ps5000aChangePowerSource(
        short        handle,
        PICO_STATUS  powerState) nogil

    PICO_STATUS ps5000aCurrentPowerSource(
        short  handle) nogil

    PICO_STATUS ps5000aStop(
        short  handle) nogil

    PICO_STATUS ps5000aPingUnit(
        short handle) nogil

    PICO_STATUS ps5000aSetNoOfCaptures(
        short          handle,
        unsigned int  nCaptures) nogil

    PICO_STATUS ps5000aGetNoOfCaptures(
        short          handle,
        unsigned int *nCaptures) nogil

    PICO_STATUS ps5000aGetNoOfProcessedCaptures(
        short          handle,
        unsigned int *nProcessedCaptures) nogil

    PICO_STATUS ps5000aSetDeviceResolution(
        short                      handle,
        PS5000A_DEVICE_RESOLUTION  resolution) nogil

    PICO_STATUS ps5000aGetDeviceResolution(
        short                      handle,
        PS5000A_DEVICE_RESOLUTION *resolution) nogil
        
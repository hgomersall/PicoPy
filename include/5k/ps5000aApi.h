/****************************************************************************
  *
  * Filename:    ps5000Api.h
  * Copyright:   Pico Technology Limited 2002 - 2013
  * Author:      MAS
  * Description:
  *
  * This header defines the interface to driver routines for the
  * PicoScope5000 range of PC Oscilloscopes.
  *
  ****************************************************************************/
#ifndef __PS5000AAPI_H__
#define __PS5000AAPI_H__

#include <stdint.h>

#include "PicoStatus.h"

#ifdef PREF0
  #undef PREF0
#endif
#ifdef PREF1
  #undef PREF1
#endif
#ifdef PREF2
  #undef PREF2
#endif
#ifdef PREF3
  #undef PREF3
#endif

#ifdef __cplusplus
  #define PREF0 extern "C"
#else
  #define PREF0
#endif

#ifdef WIN32
/* If you are dynamically linking PS5000.DLL into your project #define DYNLINK here
  */
  #ifdef DYNLINK
    #define PREF1 typedef
    #define PREF2
    #define PREF3(x) (__stdcall *x)
  #else
    #define PREF1
    #ifdef _USRDLL
      #define PREF2 __declspec(dllexport) __stdcall
    #else
      #define PREF2 __declspec(dllimport) __stdcall
    #endif
    #define PREF3(x) x
  #endif
  #define PREF4 __stdcall
#else

  /* Define a 64-bit integer type */
  #ifdef DYNLINK
    #define PREF1 typedef
    #define PREF2
    #define PREF3(x) (*x)
  #else
    #ifdef _USRDLL
      #define PREF1 __attribute__((visibility("default")))
    #else
      #define PREF1
    #endif
      #define PREF2
      #define PREF3(x) x
  #endif
  #define PREF4
#endif

#define PS5000A_MAX_VALUE_8BIT  32512
#define PS5000A_MIN_VALUE_8BIT -32512

#define PS5000A_MAX_VALUE_16BIT  32767
#define PS5000A_MIN_VALUE_16BIT -32767

#define PS5000A_LOST_DATA -32768

#define PS5000A_EXT_MAX_VALUE  32767
#define PS5000A_EXT_MIN_VALUE -32767

#define MAX_PULSE_WIDTH_QUALIFIER_COUNT  16777215L
#define MAX_DELAY_COUNT                   8388607L

// covers the 5242A/B and 5442A/B
#define PS5X42A_MAX_SIG_GEN_BUFFER_SIZE  16384
// covers the 5243A/B and 5443A/B
#define PS5X43A_MAX_SIG_GEN_BUFFER_SIZE  32768
// covers the 5244A/B and 5444A/B
#define PS5X44A_MAX_SIG_GEN_BUFFER_SIZE  49152

#define MIN_SIG_GEN_BUFFER_SIZE		        1
#define MIN_DWELL_COUNT				            3
#define MAX_SWEEPS_SHOTS		((1 << 30) - 1)
#define	AWG_DAC_FREQUENCY							200e6
#define	AWG_PHASE_ACCUMULATOR  4294967296.0

#define MAX_ANALOGUE_OFFSET_50MV_200MV  0.250f
#define MIN_ANALOGUE_OFFSET_50MV_200MV -0.250f
#define MAX_ANALOGUE_OFFSET_500MV_2V    2.500f
#define MIN_ANALOGUE_OFFSET_500MV_2V   -2.500f
#define MAX_ANALOGUE_OFFSET_5V_20V        20.f
#define MIN_ANALOGUE_OFFSET_5V_20V       -20.f

#define PS5244A_MAX_ETS_CYCLES 500  // PS5242A, PS5242B, PS5442A, PS5442B
#define PS5244A_MAX_ETS_INTERLEAVE  40

#define PS5243A_MAX_ETS_CYCLES 250  // PS5243A, PS5243B, PS5443A, PS5443B
#define PS5243A_MAX_ETS_INTERLEAVE  20

#define PS5242A_MAX_ETS_CYCLES 125    // PS5242A, PS5242B, PS5442A, PS5442B
#define PS5242A_MAX_ETS_INTERLEAVE  10

#define PS5000A_SHOT_SWEEP_TRIGGER_CONTINUOUS_RUN 0xFFFFFFFF

typedef enum enPS5000ADeviceResolution
{
  PS5000A_DR_8BIT,
  PS5000A_DR_12BIT,
  PS5000A_DR_14BIT,
  PS5000A_DR_15BIT,
  PS5000A_DR_16BIT
} PS5000A_DEVICE_RESOLUTION;

typedef enum enPS5000AExtraOperations
{
  PS5000A_ES_OFF,
  PS5000A_WHITENOISE,
  PS5000A_PRBS // Pseudo-Random Bit Stream
} PS5000A_EXTRA_OPERATIONS;

typedef enum enPS5000ABandwidthLimiter
{
  PS5000A_BW_FULL,
  PS5000A_BW_20MHZ,
} PS5000A_BANDWIDTH_LIMITER;

typedef enum enPS5000ACoupling
{
  PS5000A_AC,
  PS5000A_DC
} PS5000A_COUPLING;

typedef enum enPS5000AChannel
{
  PS5000A_CHANNEL_A,
  PS5000A_CHANNEL_B,
  PS5000A_CHANNEL_C,
  PS5000A_CHANNEL_D,
  PS5000A_EXTERNAL,
  PS5000A_MAX_CHANNELS = PS5000A_EXTERNAL,
  PS5000A_TRIGGER_AUX,
  PS5000A_MAX_TRIGGER_SOURCES
} PS5000A_CHANNEL;

typedef enum enPS5000AChannelBufferIndex
{
  PS5000A_CHANNEL_A_MAX,
  PS5000A_CHANNEL_A_MIN,
  PS5000A_CHANNEL_B_MAX,
  PS5000A_CHANNEL_B_MIN,
  PS5000A_CHANNEL_C_MAX,
  PS5000A_CHANNEL_C_MIN,
  PS5000A_CHANNEL_D_MAX,
  PS5000A_CHANNEL_D_MIN,
  PS5000A_MAX_CHANNEL_BUFFERS
} PS5000A_CHANNEL_BUFFER_INDEX;

typedef enum enPS5000ARange
{
  PS5000A_10MV,
  PS5000A_20MV,
  PS5000A_50MV,
  PS5000A_100MV,
  PS5000A_200MV,
  PS5000A_500MV,
  PS5000A_1V,
  PS5000A_2V,
  PS5000A_5V,
  PS5000A_10V,
  PS5000A_20V,
  PS5000A_50V,
  PS5000A_MAX_RANGES
} PS5000A_RANGE;


typedef enum enPS5000AEtsMode
{
  PS5000A_ETS_OFF,             // ETS disabled
  PS5000A_ETS_FAST,            // Return ready as soon as requested no of interleaves is available
  PS5000A_ETS_SLOW,            // Return ready every time a new set of no_of_cycles is collected
  PS5000A_ETS_MODES_MAX
} PS5000A_ETS_MODE;

typedef enum enPS5000ATimeUnits
{
  PS5000A_FS,
  PS5000A_PS,
  PS5000A_NS,
  PS5000A_US,
  PS5000A_MS,
  PS5000A_S,
  PS5000A_MAX_TIME_UNITS,
} PS5000A_TIME_UNITS;

typedef enum enPS5000ASweepType
{
  PS5000A_UP,
  PS5000A_DOWN,
  PS5000A_UPDOWN,
  PS5000A_DOWNUP,
  PS5000A_MAX_SWEEP_TYPES
} PS5000A_SWEEP_TYPE;

typedef enum enPS5000AWaveType
{
  PS5000A_SINE,
  PS5000A_SQUARE,
  PS5000A_TRIANGLE,
  PS5000A_RAMP_UP,
  PS5000A_RAMP_DOWN,
  PS5000A_SINC,
  PS5000A_GAUSSIAN,
  PS5000A_HALF_SINE,
  PS5000A_DC_VOLTAGE,
  PS5000A_WHITE_NOISE,
  PS5000A_MAX_WAVE_TYPES
} PS5000A_WAVE_TYPE;

#define PS5000A_SINE_MAX_FREQUENCY       20000000.f
#define PS5000A_SQUARE_MAX_FREQUENCY     20000000.f
#define PS5000A_TRIANGLE_MAX_FREQUENCY   20000000.f
#define PS5000A_SINC_MAX_FREQUENCY       20000000.f
#define PS5000A_RAMP_MAX_FREQUENCY       20000000.f
#define PS5000A_HALF_SINE_MAX_FREQUENCY  20000000.f
#define PS5000A_GAUSSIAN_MAX_FREQUENCY   20000000.f
#define PS5000A_MIN_FREQUENCY                 0.03f

typedef enum enPS5000ASigGenTrigType
{
  PS5000A_SIGGEN_RISING,
  PS5000A_SIGGEN_FALLING,
  PS5000A_SIGGEN_GATE_HIGH,
  PS5000A_SIGGEN_GATE_LOW
} PS5000A_SIGGEN_TRIG_TYPE;

typedef enum enPS5000ASigGenTrigSource
{
  PS5000A_SIGGEN_NONE,
  PS5000A_SIGGEN_SCOPE_TRIG,
  PS5000A_SIGGEN_AUX_IN,
  PS5000A_SIGGEN_EXT_IN,
  PS5000A_SIGGEN_SOFT_TRIG
} PS5000A_SIGGEN_TRIG_SOURCE;

typedef enum enPS5000AIndexMode
{
  PS5000A_SINGLE,
  PS5000A_DUAL,
  PS5000A_QUAD,
  PS5000A_MAX_INDEX_MODES
} PS5000A_INDEX_MODE;

typedef enum enPS5000AThresholdMode
{
  PS5000A_LEVEL,
  PS5000A_WINDOW
} PS5000A_THRESHOLD_MODE;

typedef enum enPS5000AThresholdDirection
{
  PS5000A_ABOVE, //using upper threshold
  PS5000A_BELOW, //using upper threshold
  PS5000A_RISING, // using upper threshold
  PS5000A_FALLING, // using upper threshold
  PS5000A_RISING_OR_FALLING, // using both threshold
  PS5000A_ABOVE_LOWER, // using lower threshold
  PS5000A_BELOW_LOWER, // using lower threshold
  PS5000A_RISING_LOWER,    // using lower threshold
  PS5000A_FALLING_LOWER,   // using lower threshold

  // Windowing using both thresholds
  PS5000A_INSIDE = PS5000A_ABOVE,
  PS5000A_OUTSIDE = PS5000A_BELOW,
  PS5000A_ENTER = PS5000A_RISING,
  PS5000A_EXIT = PS5000A_FALLING,
  PS5000A_ENTER_OR_EXIT = PS5000A_RISING_OR_FALLING,
  PS5000A_POSITIVE_RUNT = 9,
   PS5000A_NEGATIVE_RUNT,

  // no trigger set
  PS5000A_NONE = PS5000A_RISING} PS5000A_THRESHOLD_DIRECTION;


typedef enum enPS5000ATriggerState
{
  PS5000A_CONDITION_DONT_CARE,
  PS5000A_CONDITION_TRUE,
  PS5000A_CONDITION_FALSE,
  PS5000A_CONDITION_MAX
} PS5000A_TRIGGER_STATE;

typedef enum enPS5000ATriggerWithinPreTrigger
{
  PS5000A_DISABLE,
  PS5000A_ARM
} PS5000A_TRIGGER_WITHIN_PRE_TRIGGER;

#pragma pack(1)
typedef struct tPS5000ATriggerInfo
{
	PICO_STATUS		status;
	uint32_t 	segmentIndex;
	uint32_t 	triggerIndex;
	int64_t		triggerTime;
	int16_t		timeUnits;
	int16_t		reserved0;
	uint64_t	reserved1;	
} PS5000A_TRIGGER_INFO;

typedef struct tPS5000ATriggerConditions
{
  PS5000A_TRIGGER_STATE channelA;
  PS5000A_TRIGGER_STATE channelB;
  PS5000A_TRIGGER_STATE channelC;
  PS5000A_TRIGGER_STATE channelD;
  PS5000A_TRIGGER_STATE external;
  PS5000A_TRIGGER_STATE aux;
  PS5000A_TRIGGER_STATE pulseWidthQualifier;
} PS5000A_TRIGGER_CONDITIONS;
#pragma pack()

#pragma pack(1)
typedef struct tPS5000APwqConditions
{
  PS5000A_TRIGGER_STATE channelA;
  PS5000A_TRIGGER_STATE channelB;
  PS5000A_TRIGGER_STATE channelC;
  PS5000A_TRIGGER_STATE channelD;
  PS5000A_TRIGGER_STATE external;
  PS5000A_TRIGGER_STATE aux;
} PS5000A_PWQ_CONDITIONS;
#pragma pack()

#pragma pack(1)
typedef struct tPS5000ATriggerChannelProperties
{
  int16_t                   thresholdUpper;
  uint16_t          thresholdUpperHysteresis;
  int16_t                   thresholdLower;
  uint16_t          thresholdLowerHysteresis;
  PS5000A_CHANNEL         channel;
  PS5000A_THRESHOLD_MODE  thresholdMode;
} PS5000A_TRIGGER_CHANNEL_PROPERTIES;
#pragma pack()

typedef enum enPS5000ARatioMode
{
  PS5000A_RATIO_MODE_NONE         = 0,
  PS5000A_RATIO_MODE_AGGREGATE    = 1,
  PS5000A_RATIO_MODE_DECIMATE     = 2,
  PS5000A_RATIO_MODE_AVERAGE      = 4,
  PS5000A_RATIO_MODE_DISTRIBUTION = 8
} PS5000A_RATIO_MODE;

typedef enum enPS5000APulseWidthType
{
  PS5000A_PW_TYPE_NONE,
  PS5000A_PW_TYPE_LESS_THAN,
  PS5000A_PW_TYPE_GREATER_THAN,
  PS5000A_PW_TYPE_IN_RANGE,
  PS5000A_PW_TYPE_OUT_OF_RANGE
} PS5000A_PULSE_WIDTH_TYPE;

typedef enum enPS5000AChannelInfo
{
  PS5000A_CI_RANGES,
} PS5000A_CHANNEL_INFO;


typedef void (PREF4 *ps5000aBlockReady)
(
  int16_t        handle,
  PICO_STATUS  status,
  void        *pParameter
);

typedef void (PREF4 *ps5000aStreamingReady)
(
  int16_t          handle,
  int32_t           noOfSamples,
  uint32_t  startIndex,
  int16_t          overflow,
  uint32_t  triggerAt,
  int16_t          triggered,
  int16_t          autoStop,
  void          *pParameter
);

// see if this is actually used
typedef void (PREF4 *ps5000aDataReady)
(
  int16_t          handle,
  PICO_STATUS    status,
  uint32_t  noOfSamples,
  int16_t          overflow,
  void          *pParameter
);

PREF0 PREF1 PICO_STATUS PREF2 PREF3 (ps5000aOpenUnit)(
  int16_t                     *handle,
  int8_t                      *serial,
  PS5000A_DEVICE_RESOLUTION  resolution
);

PREF0 PREF1 PICO_STATUS PREF2 PREF3 (ps5000aOpenUnitAsync)
(
  int16_t                     *status,
  int8_t                      *serial,
  PS5000A_DEVICE_RESOLUTION  resolution
);

PREF0 PREF1 PICO_STATUS PREF2 PREF3 (ps5000aOpenUnitProgress)
(
  int16_t *handle,
  int16_t *progressPercent,
  int16_t *complete
);

PREF0 PREF1 PICO_STATUS PREF2 PREF3 (ps5000aGetUnitInfo)
(
  int16_t      handle,
  int8_t		*  string,
  int16_t      stringLength,
  int16_t     *requiredSize,
  PICO_INFO  info
);

PREF0 PREF1 PICO_STATUS PREF2 PREF3 (ps5000aFlashLed)
(
  int16_t  handle,
  int16_t  start
);

PREF0 PREF1 PICO_STATUS PREF2 PREF3 (ps5000aIsLedFlashing)
(
  int16_t  handle,
  int16_t *status
);

PREF0 PREF1 PICO_STATUS PREF2 PREF3 (ps5000aCloseUnit)
(
  int16_t  handle
);

PREF0 PREF1 PICO_STATUS PREF2 PREF3 (ps5000aMemorySegments)
(
  int16_t          handle,
  uint32_t  nSegments,
  int32_t          *nMaxSamples
);

PREF0 PREF1 PICO_STATUS PREF2 PREF3 (ps5000aSetChannel)
(
  int16_t             handle,
  PS5000A_CHANNEL   channel,
  int16_t             enabled,
  PS5000A_COUPLING  type,
  PS5000A_RANGE     range,
  float             analogOffset
);

PREF0 PREF1 PICO_STATUS PREF2 PREF3 (ps5000aSetBandwidthFilter)
(
  int16_t                      handle,
  PS5000A_CHANNEL            channel,
  PS5000A_BANDWIDTH_LIMITER  bandwidth
);

PREF0 PREF1 PICO_STATUS PREF2 PREF3 (ps5000aGetTimebase)
(
  int16_t          handle,
  uint32_t  timebase,
  int32_t           noSamples,
  int32_t          *timeIntervalNanoseconds,
  int32_t          *maxSamples,
  uint32_t  segmentIndex
);

PREF0 PREF1 PICO_STATUS PREF2 PREF3 (ps5000aGetTimebase2)
(
  int16_t          handle,
  uint32_t  timebase,
  int32_t           noSamples,
  float         *timeIntervalNanoseconds,
  int32_t          *maxSamples,
  uint32_t  segmentIndex
);

PREF0 PREF1 PICO_STATUS PREF2 PREF3 (ps5000aSetSigGenArbitrary)
(
  int16_t                       handle,
  int32_t                        offsetVoltage,
  uint32_t               pkToPk,
  uint32_t               startDeltaPhase,
  uint32_t               stopDeltaPhase,
  uint32_t               deltaPhaseIncrement,
  uint32_t               dwellCount,
  int16_t                      *arbitraryWaveform,
  int32_t                        arbitraryWaveformSize,
  PS5000A_SWEEP_TYPE          sweepType,
  PS5000A_EXTRA_OPERATIONS    operation,
  PS5000A_INDEX_MODE          indexMode,
  uint32_t               shots,
  uint32_t               sweeps,
  PS5000A_SIGGEN_TRIG_TYPE    triggerType,
  PS5000A_SIGGEN_TRIG_SOURCE  triggerSource,
  int16_t                       extInThreshold
);

PREF0 PREF1 PICO_STATUS PREF2 PREF3(ps5000aSetSigGenBuiltIn)
(
  int16_t                       handle,
  int32_t                        offsetVoltage,
  uint32_t               pkToPk,
  PS5000A_WAVE_TYPE           waveType,
  float                       startFrequency,
  float                       stopFrequency,
  float                       increment,
  float                       dwellTime,
  PS5000A_SWEEP_TYPE          sweepType,
  PS5000A_EXTRA_OPERATIONS    operation,
  uint32_t               shots,
  uint32_t               sweeps,
  PS5000A_SIGGEN_TRIG_TYPE    triggerType,
  PS5000A_SIGGEN_TRIG_SOURCE  triggerSource,
  int16_t                       extInThreshold
);

PREF0 PREF1 PICO_STATUS PREF2 PREF3(ps5000aSetSigGenBuiltInV2)
(
  int16_t                       handle,
  int32_t                        offsetVoltage,
  uint32_t               pkToPk,
  PS5000A_WAVE_TYPE           waveType,
  double                       startFrequency,
  double                       stopFrequency,
  double                       increment,
  double                       dwellTime,
  PS5000A_SWEEP_TYPE          sweepType,
  PS5000A_EXTRA_OPERATIONS    operation,
  uint32_t               shots,
  uint32_t               sweeps,
  PS5000A_SIGGEN_TRIG_TYPE    triggerType,
  PS5000A_SIGGEN_TRIG_SOURCE  triggerSource,
  int16_t                       extInThreshold
);

PREF0 PREF1 PICO_STATUS PREF2 PREF3 (ps5000aSetSigGenPropertiesArbitrary)
(
  int16_t                       handle,
  uint32_t               startDeltaPhase,
  uint32_t               stopDeltaPhase,
  uint32_t               deltaPhaseIncrement,
  uint32_t               dwellCount,
  PS5000A_SWEEP_TYPE          sweepType,
  uint32_t               shots,
  uint32_t               sweeps,
  PS5000A_SIGGEN_TRIG_TYPE    triggerType,
  PS5000A_SIGGEN_TRIG_SOURCE  triggerSource,
  int16_t                       extInThreshold
);

PREF0 PREF1 PICO_STATUS PREF2 PREF3(ps5000aSetSigGenPropertiesBuiltIn)
(
  int16_t                       handle,
	double                       startFrequency,
	double                       stopFrequency,
	double                       increment,
	double                       dwellTime,
  PS5000A_SWEEP_TYPE          sweepType,
  uint32_t               shots,
  uint32_t               sweeps,
  PS5000A_SIGGEN_TRIG_TYPE    triggerType,
  PS5000A_SIGGEN_TRIG_SOURCE  triggerSource,
  int16_t                       extInThreshold
);

PREF0 PREF1 PICO_STATUS PREF2 PREF3(ps5000aSigGenFrequencyToPhase)
	(
	int16_t												handle,
	double												frequency,
	PS5000A_INDEX_MODE						indexMode,
	uint32_t											bufferLength,
	uint32_t										* phase
	);

PREF0 PREF1 PICO_STATUS PREF2 PREF3(ps5000aSigGenArbitraryMinMaxValues)
	(
	int16_t			handle,
	int16_t		*	minArbitraryWaveformValue,
	int16_t		*	maxArbitraryWaveformValue,
	uint32_t	* minArbitraryWaveformSize,
	uint32_t	*	maxArbitraryWaveformSize
	);

PREF0 PREF1 PICO_STATUS PREF2 PREF3 (ps5000aSigGenSoftwareControl)
(
  int16_t  handle,
  int16_t  state
);

PREF0 PREF1 PICO_STATUS PREF2 PREF3 (ps5000aSetEts)
(
  int16_t             handle,
  PS5000A_ETS_MODE  mode,
  int16_t             etsCycles,
  int16_t             etsInterleave,
  int32_t             *sampleTimePicoseconds
);

PREF0 PREF1 PICO_STATUS PREF2 PREF3 (ps5000aSetTriggerChannelProperties)
(
  int16_t                               handle,
  PS5000A_TRIGGER_CHANNEL_PROPERTIES *channelProperties,
  int16_t                               nChannelProperties,
  int16_t                               auxOutputEnable,
  int32_t                                autoTriggerMilliseconds
);

PREF0 PREF1 PICO_STATUS PREF2 PREF3 (ps5000aSetTriggerChannelConditions)
(
  int16_t                       handle,
  PS5000A_TRIGGER_CONDITIONS *conditions,
  int16_t                       nConditions
);

PREF0 PREF1 PICO_STATUS PREF2 PREF3 (ps5000aSetTriggerChannelDirections)
(
  int16_t                        handle,
  PS5000A_THRESHOLD_DIRECTION  channelA,
  PS5000A_THRESHOLD_DIRECTION  channelB,
  PS5000A_THRESHOLD_DIRECTION  channelC,
  PS5000A_THRESHOLD_DIRECTION  channelD,
  PS5000A_THRESHOLD_DIRECTION  ext,
  PS5000A_THRESHOLD_DIRECTION  aux
);

PREF0 PREF1 PICO_STATUS PREF2 PREF3 (ps5000aSetSimpleTrigger)
(
  int16_t                        handle,
  int16_t                        enable,
  PS5000A_CHANNEL              source,
  int16_t                        threshold,
  PS5000A_THRESHOLD_DIRECTION  direction,
  uint32_t                delay,
  int16_t                        autoTrigger_ms
);

PREF0 PREF1 PICO_STATUS PREF2 PREF3 (ps5000aSetTriggerDelay)
(
   int16_t          handle,
   uint32_t  delay
);

PREF0 PREF1 PICO_STATUS PREF2 PREF3 (ps5000aSetPulseWidthQualifier)
(
  int16_t                        handle,
  PS5000A_PWQ_CONDITIONS      *conditions,
  int16_t                        nConditions,
  PS5000A_THRESHOLD_DIRECTION  direction,
  uint32_t                lower,
  uint32_t                upper,
  PS5000A_PULSE_WIDTH_TYPE     type
);

PREF0 PREF1 PICO_STATUS PREF2 PREF3 (ps5000aIsTriggerOrPulseWidthQualifierEnabled)
(
  int16_t  handle,
  int16_t *triggerEnabled,
  int16_t *pulseWidthQualifierEnabled
);

PREF0 PREF1 PICO_STATUS PREF2 PREF3 (ps5000aGetTriggerTimeOffset)
(
  int16_t               handle,
  uint32_t      *timeUpper,
  uint32_t      *timeLower,
  PS5000A_TIME_UNITS *timeUnits,
  uint32_t       segmentIndex
);

PREF0 PREF1 PICO_STATUS PREF2 PREF3 (ps5000aGetTriggerTimeOffset64)
(
  int16_t               handle,
  int64_t            *time,
  PS5000A_TIME_UNITS *timeUnits,
  uint32_t       segmentIndex
);

PREF0 PREF1 PICO_STATUS PREF2 PREF3 (ps5000aGetValuesTriggerTimeOffsetBulk)
(
  int16_t               handle,
  uint32_t      *timesUpper,
  uint32_t      *timesLower,
  PS5000A_TIME_UNITS *timeUnits,
  uint32_t       fromSegmentIndex,
  uint32_t       toSegmentIndex
);

PREF0 PREF1 PICO_STATUS PREF2 PREF3 (ps5000aGetValuesTriggerTimeOffsetBulk64)
(
  int16_t               handle,
  int64_t            *times,
  PS5000A_TIME_UNITS *timeUnits,
  uint32_t       fromSegmentIndex,
  uint32_t       toSegmentIndex
);

PREF0 PREF1 PICO_STATUS PREF2 PREF3 (ps5000aSetDataBuffers)
(
  int16_t               handle,
  PS5000A_CHANNEL     channel,
  int16_t              *bufferMax,
  int16_t              *bufferMin,
  int32_t                bufferLth,
  uint32_t       segmentIndex,
  PS5000A_RATIO_MODE  mode
);

PREF0 PREF1 PICO_STATUS PREF2 PREF3 (ps5000aSetDataBuffer)
(
  int16_t               handle,
  PS5000A_CHANNEL     channel,
  int16_t              *buffer,
  int32_t                bufferLth,
  uint32_t       segmentIndex,
  PS5000A_RATIO_MODE  mode
);

PREF0 PREF1 PICO_STATUS PREF2 PREF3 (ps5000aSetEtsTimeBuffer)
(
  int16_t     handle,
  int64_t  *buffer,
  int32_t      bufferLth
);

PREF0 PREF1 PICO_STATUS PREF2 PREF3 (ps5000aSetEtsTimeBuffers)
(
  int16_t          handle,
  uint32_t *timeUpper,
  uint32_t *timeLower,
  int32_t           bufferLth
);

PREF0 PREF1 PICO_STATUS PREF2 PREF3 (ps5000aIsReady)
(
		int16_t handle,
		int16_t * ready
);

PREF0 PREF1 PICO_STATUS PREF2 PREF3 (ps5000aRunBlock)
(
  int16_t              handle,
  int32_t               noOfPreTriggerSamples,
  int32_t               noOfPostTriggerSamples,
  uint32_t      timebase,
  int32_t              *timeIndisposedMs,
  uint32_t      segmentIndex,
  ps5000aBlockReady  lpReady,
  void              *pParameter
);

PREF0 PREF1 PICO_STATUS PREF2 PREF3 (ps5000aRunStreaming)
(
  int16_t               handle,
  uint32_t      *sampleInterval,
  PS5000A_TIME_UNITS  sampleIntervalTimeUnits,
  uint32_t       maxPreTriggerSamples,
  uint32_t       maxPostTriggerSamples,
  int16_t               autoStop,
  uint32_t       downSampleRatio,
  PS5000A_RATIO_MODE  downSampleRatioMode,
  uint32_t       overviewBufferSize
);

PREF0 PREF1 PICO_STATUS PREF2 PREF3 (ps5000aGetStreamingLatestValues)
(
  int16_t                  handle,
  ps5000aStreamingReady  lpPs5000aReady,
  void                  *pParameter
);

PREF0 PREF1 PICO_STATUS PREF2 PREF3 (ps5000aNoOfStreamingValues)
(
  int16_t          handle,
  uint32_t *noOfValues
);

PREF0 PREF1 PICO_STATUS PREF2 PREF3 (ps5000aGetMaxDownSampleRatio)
(
  int16_t               handle,
  uint32_t       noOfUnaggreatedSamples,
  uint32_t      *maxDownSampleRatio,
  PS5000A_RATIO_MODE  downSampleRatioMode,
  uint32_t       segmentIndex
);

PREF0 PREF1 PICO_STATUS PREF2 PREF3 (ps5000aGetValues)
(
  int16_t               handle,
  uint32_t       startIndex,
  uint32_t      *noOfSamples,
  uint32_t       downSampleRatio,
  PS5000A_RATIO_MODE  downSampleRatioMode,
  uint32_t       segmentIndex,
  int16_t              *overflow
);

PREF0 PREF1 PICO_STATUS PREF2 PREF3 (ps5000aGetValuesAsync)
(
  int16_t               handle,
  uint32_t       startIndex,
  uint32_t       noOfSamples,
  uint32_t       downSampleRatio,
  PS5000A_RATIO_MODE  downSampleRatioMode,
  uint32_t       segmentIndex,
  void               *lpDataReady,
  void               *pParameter
);

PREF0 PREF1 PICO_STATUS PREF2 PREF3 (ps5000aGetValuesBulk)
(
  int16_t               handle,
  uint32_t      *noOfSamples,
  uint32_t       fromSegmentIndex,
  uint32_t       toSegmentIndex,
  uint32_t       downSampleRatio,
  PS5000A_RATIO_MODE  downSampleRatioMode,
  int16_t              *overflow
);

PREF0 PREF1 PICO_STATUS PREF2 PREF3 (ps5000aGetValuesOverlapped)
(
  int16_t               handle,
  uint32_t       startIndex,
  uint32_t      *noOfSamples,
  uint32_t       downSampleRatio,
  PS5000A_RATIO_MODE  downSampleRatioMode,
  uint32_t       segmentIndex,
  int16_t              *overflow
);

PREF0 PREF1 PICO_STATUS PREF2 PREF3 (ps5000aGetValuesOverlappedBulk)
(
  int16_t               handle,
  uint32_t       startIndex,
  uint32_t      *noOfSamples,
  uint32_t       downSampleRatio,
  PS5000A_RATIO_MODE  downSampleRatioMode,
  uint32_t       fromSegmentIndex,
  uint32_t       toSegmentIndex,
  int16_t              *overflow
);

PREF0 PREF1 PICO_STATUS PREF2 PREF3 (ps5000aTriggerWithinPreTriggerSamples)
(
  int16_t handle,
  PS5000A_TRIGGER_WITHIN_PRE_TRIGGER state
);

PREF0 PREF1 PICO_STATUS PREF2 PREF3 (ps5000aGetTriggerInfoBulk)
(
  int16_t										handle,
  PS5000A_TRIGGER_INFO	*	triggerInfo,
  uint32_t						fromSegmentIndex,
  uint32_t						toSegmentIndex
);

PREF0 PREF1 PICO_STATUS PREF2 PREF3 (ps5000aEnumerateUnits)
(
  int16_t *count,
  int8_t  *serials,
  int16_t *serialLth
);

PREF0 PREF1 PICO_STATUS PREF2 PREF3 (ps5000aGetChannelInformation)
(
  int16_t                 handle,
  PS5000A_CHANNEL_INFO  info,
  int32_t                   probe,
  int32_t                  *ranges,
  int32_t                  *length,
  int32_t                   channels
);

PREF0 PREF1 PICO_STATUS PREF2 PREF3 (ps5000aMaximumValue)
(
  int16_t  handle,
  int16_t *value
);

PREF0 PREF1 PICO_STATUS PREF2 PREF3 (ps5000aMinimumValue)
(
  int16_t  handle,
  int16_t * value
);

PREF0 PREF1 PICO_STATUS PREF2 PREF3 (ps5000aGetAnalogueOffset)
(
  int16_t             handle,
  PS5000A_RANGE     range,
  PS5000A_COUPLING  coupling,
  float            *maximumVoltage,
  float            *minimumVoltage
);

PREF0 PREF1 PICO_STATUS PREF2 PREF3 (ps5000aGetMaxSegments)
(
  int16_t          handle,
  uint32_t *maxSegments
);

PREF0 PREF1 PICO_STATUS PREF2 PREF3 (ps5000aChangePowerSource)
(
  int16_t        handle,
  PICO_STATUS  powerState
);

PREF0 PREF1 PICO_STATUS PREF2 PREF3 (ps5000aCurrentPowerSource)
(
  int16_t  handle
);

PREF0 PREF1 PICO_STATUS PREF2 PREF3 (ps5000aStop)
(
  int16_t  handle
);

PREF0 PREF1 PICO_STATUS PREF2 PREF3 (ps5000aPingUnit)
(
  int16_t handle
);

PREF0 PREF1 PICO_STATUS PREF2 PREF3 (ps5000aSetNoOfCaptures)
(
  int16_t          handle,
  uint32_t  nCaptures
);

PREF0 PREF1 PICO_STATUS PREF2 PREF3 (ps5000aGetNoOfCaptures)
(
  int16_t          handle,
  uint32_t *nCaptures
);

PREF0 PREF1 PICO_STATUS PREF2 PREF3 (ps5000aGetNoOfProcessedCaptures)
(
  int16_t          handle,
  uint32_t *nProcessedCaptures
);

PREF0 PREF1 PICO_STATUS PREF2 PREF3 (ps5000aSetDeviceResolution)
(
  int16_t                      handle,
  PS5000A_DEVICE_RESOLUTION  resolution
);

PREF0 PREF1 PICO_STATUS PREF2 PREF3 (ps5000aGetDeviceResolution)
(
  int16_t                      handle,
  PS5000A_DEVICE_RESOLUTION *resolution
);

#endif

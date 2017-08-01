/****************************************************************************
 *
 * Filename:    pico_status.h
 * Copyright:   Pico Technology Limited 2002 - 2013
 * Author:      MAS
 * Description:
 *
 * This header defines the status codes returned by a  
 *	Pico device, a PC Oscilloscope or data logger.
 *
 ****************************************************************************/
#ifndef __PICOSTATUS_H__
#define __PICOSTATUS_H__

#include <stdint.h>

#define	PICO_DRIVER_VERSION                         0x00000000UL
#define	PICO_USB_VERSION                            0x00000001UL
#define	PICO_HARDWARE_VERSION                       0x00000002UL
#define	PICO_VARIANT_INFO                           0x00000003UL
#define	PICO_BATCH_AND_SERIAL                       0x00000004UL
#define	PICO_CAL_DATE                               0x00000005UL
#define	PICO_KERNEL_VERSION                         0x00000006UL

#define PICO_DIGITAL_HARDWARE_VERSION               0x00000007UL
#define PICO_ANALOGUE_HARDWARE_VERSION              0x00000008UL

#define PICO_FIRMWARE_VERSION_1                     0x00000009UL
#define PICO_FIRMWARE_VERSION_2                     0x0000000AUL

#define PICO_MAC_ADDRESS                            0x0000000BUL

typedef uint32_t PICO_INFO;

#define PICO_OK                                     0x00000000UL
#define	PICO_MAX_UNITS_OPENED                       0x00000001UL
#define	PICO_MEMORY_FAIL                            0x00000002UL
#define	PICO_NOT_FOUND                              0x00000003UL
#define	PICO_FW_FAIL                                0x00000004UL
#define PICO_OPEN_OPERATION_IN_PROGRESS             0x00000005UL
#define PICO_OPERATION_FAILED                       0x00000006UL
#define	PICO_NOT_RESPONDING                         0x00000007UL
#define PICO_CONFIG_FAIL                            0x00000008UL
#define PICO_KERNEL_DRIVER_TOO_OLD                  0x00000009UL
#define PICO_EEPROM_CORRUPT                         0x0000000AUL
#define PICO_OS_NOT_SUPPORTED                       0x0000000BUL
#define PICO_INVALID_HANDLE                         0x0000000CUL
#define PICO_INVALID_PARAMETER                      0x0000000DUL
#define PICO_INVALID_TIMEBASE                       0x0000000EUL
#define PICO_INVALID_VOLTAGE_RANGE                  0x0000000FUL
#define PICO_INVALID_CHANNEL                        0x00000010UL
#define PICO_INVALID_TRIGGER_CHANNEL                0x00000011UL
#define PICO_INVALID_CONDITION_CHANNEL              0x00000012UL
#define PICO_NO_SIGNAL_GENERATOR                    0x00000013UL
#define PICO_STREAMING_FAILED                       0x00000014UL
#define PICO_BLOCK_MODE_FAILED                      0x00000015UL
#define PICO_NULL_PARAMETER                         0x00000016UL
#define PICO_ETS_MODE_SET                           0x00000017UL
#define PICO_DATA_NOT_AVAILABLE                     0x00000018UL
#define PICO_STRING_BUFFER_TO_SMALL                 0x00000019UL
#define PICO_ETS_NOT_SUPPORTED                      0x0000001AUL
#define PICO_AUTO_TRIGGER_TIME_TO_SHORT             0x0000001BUL
#define PICO_BUFFER_STALL                           0x0000001CUL
#define PICO_TOO_MANY_SAMPLES                       0x0000001DUL
#define PICO_TOO_MANY_SEGMENTS                      0x0000001EUL
#define PICO_PULSE_WIDTH_QUALIFIER                  0x0000001FUL
#define PICO_DELAY                                  0x00000020UL
#define	PICO_SOURCE_DETAILS                         0x00000021UL
#define PICO_CONDITIONS                             0x00000022UL
#define	PICO_USER_CALLBACK                          0x00000023UL
#define PICO_DEVICE_SAMPLING                        0x00000024UL
#define PICO_NO_SAMPLES_AVAILABLE                   0x00000025UL
#define	PICO_SEGMENT_OUT_OF_RANGE                   0x00000026UL
#define PICO_BUSY                                   0x00000027UL
#define PICO_STARTINDEX_INVALID                     0x00000028UL
#define PICO_INVALID_INFO                           0x00000029UL
#define PICO_INFO_UNAVAILABLE                       0x0000002AUL
#define PICO_INVALID_SAMPLE_INTERVAL                0x0000002BUL
#define PICO_TRIGGER_ERROR                          0x0000002CUL
#define	PICO_MEMORY                                 0x0000002DUL
#define PICO_SIG_GEN_PARAM                          0x0000002EUL
#define PICO_SHOTS_SWEEPS_WARNING                   0x0000002FUL
#define PICO_SIGGEN_TRIGGER_SOURCE                  0x00000030UL
#define PICO_AUX_OUTPUT_CONFLICT                    0x00000031UL
#define PICO_AUX_OUTPUT_ETS_CONFLICT                0x00000032UL
#define PICO_WARNING_EXT_THRESHOLD_CONFLICT         0x00000033UL
#define PICO_WARNING_AUX_OUTPUT_CONFLICT            0x00000034UL
#define PICO_SIGGEN_OUTPUT_OVER_VOLTAGE             0x00000035UL
#define PICO_DELAY_NULL                             0x00000036UL
#define PICO_INVALID_BUFFER                         0x00000037UL
#define PICO_SIGGEN_OFFSET_VOLTAGE                  0x00000038UL
#define PICO_SIGGEN_PK_TO_PK                        0x00000039UL
#define PICO_CANCELLED                              0x0000003AUL
#define	PICO_SEGMENT_NOT_USED                       0x0000003BUL
#define PICO_INVALID_CALL                           0x0000003CUL
#define PICO_GET_VALUES_INTERRUPTED                 0x0000003DUL
#define PICO_NOT_USED                               0x0000003FUL
#define PICO_INVALID_SAMPLERATIO                    0x00000040UL
// Operation could not be carried out because device was in an invalid state.
#define PICO_INVALID_STATE                          0x00000041UL
// Operation could not be carried out as rapid capture no of waveforms are greater than the 
// no of memory segments.
#define PICO_NOT_ENOUGH_SEGMENTS                    0x00000042UL
// A driver function has already been called and not yet finished
// only one call to the driver can be made at any one time
#define PICO_DRIVER_FUNCTION                        0x00000043UL
#define PICO_RESERVED                               0x00000044UL
#define PICO_INVALID_COUPLING                       0x00000045UL
#define PICO_BUFFERS_NOT_SET                        0x00000046UL
#define PICO_RATIO_MODE_NOT_SUPPORTED               0x00000047UL
#define PICO_RAPID_NOT_SUPPORT_AGGREGATION          0x00000048UL
#define PICO_INVALID_TRIGGER_PROPERTY               0x00000049UL
#define PICO_INTERFACE_NOT_CONNECTED                0x0000004AUL
#define PICO_RESISTANCE_AND_PROBE_NOT_ALLOWED       0x0000004BUL
#define PICO_POWER_FAILED                           0x0000004CUL
#define PICO_SIGGEN_WAVEFORM_SETUP_FAILED           0x0000004DUL
#define PICO_FPGA_FAIL                              0x0000004EUL
#define PICO_POWER_MANAGER                          0x0000004FUL
#define PICO_INVALID_ANALOGUE_OFFSET                0x00000050UL
// unable to configure the ps6000
#define PICO_PLL_LOCK_FAILED                        0x00000051UL
// the ps6000 Analog board is not detectly connected
//to the digital board
#define PICO_ANALOG_BOARD                           0x00000052UL
// unable to configure the Signal Generator
#define PICO_CONFIG_FAIL_AWG                        0x00000053UL
#define PICO_INITIALISE_FPGA                        0x00000054UL
#define PICO_EXTERNAL_FREQUENCY_INVALID             0x00000056UL
#define PICO_CLOCK_CHANGE_ERROR                     0x00000057UL
#define	PICO_TRIGGER_AND_EXTERNAL_CLOCK_CLASH       0x00000058UL
#define PICO_PWQ_AND_EXTERNAL_CLOCK_CLASH           0x00000059UL
#define PICO_UNABLE_TO_OPEN_SCALING_FILE            0x0000005AUL

#define PICO_MEMORY_CLOCK_FREQUENCY                 0x0000005BUL
#define PICO_I2C_NOT_RESPONDING                     0x0000005CUL

#define PICO_NO_CAPTURES_AVAILABLE                  0x0000005DUL
#define PICO_NOT_USED_IN_THIS_CAPTURE_MODE          0x0000005EUL

#define PICO_GET_DATA_ACTIVE                        0x00000103UL

// used by the PT104 (USB) when connected via the Network Socket
#define PICO_IP_NETWORKED                           0x00000104UL
#define PICO_INVALID_IP_ADDRESS                     0x00000105UL
#define PICO_IPSOCKET_FAILED                        0x00000106UL
#define PICO_IPSOCKET_TIMEDOUT                      0x00000107UL
#define PICO_SETTINGS_FAILED                        0x00000108UL
#define PICO_NETWORK_FAILED                         0x00000109UL
#define PICO_WS2_32_DLL_NOT_LOADED                  0x0000010AUL
#define PICO_INVALID_IP_PORT                        0x0000010BUL

#define PICO_COUPLING_NOT_SUPPORTED                 0x0000010CUL
#define PICO_BANDWIDTH_NOT_SUPPORTED                0x0000010DUL
#define PICO_INVALID_BANDWIDTH                      0x0000010EUL

#define PICO_AWG_NOT_SUPPORTED                      0x0000010FUL
#define PICO_ETS_NOT_RUNNING                        0x00000110UL
#define	PICO_SIG_GEN_WHITENOISE_NOT_SUPPORTED       0x00000111UL
#define	PICO_SIG_GEN_WAVETYPE_NOT_SUPPORTED         0x00000112UL

#define PICO_INVALID_DIGITAL_PORT                   0x00000113UL
#define PICO_INVALID_DIGITAL_CHANNEL                0x00000114UL
#define PICO_INVALID_DIGITAL_TRIGGER_DIRECTION      0x00000115UL

#define	PICO_SIG_GEN_PRBS_NOT_SUPPORTED             0x00000116UL

#define PICO_ETS_NOT_AVAILABLE_WITH_LOGIC_CHANNELS  0x00000117UL

#define PICO_WARNING_REPEAT_VALUE                   0x00000118UL

#define PICO_POWER_SUPPLY_CONNECTED                 0x00000119UL
#define PICO_POWER_SUPPLY_NOT_CONNECTED             0x0000011AUL
#define PICO_POWER_SUPPLY_REQUEST_INVALID           0x0000011BUL
#define PICO_POWER_SUPPLY_UNDERVOLTAGE              0x0000011CUL

#define PICO_CAPTURING_DATA                         0x0000011DUL

#define PICO_USB3_0_DEVICE_NON_USB3_0_PORT          0x0000011EUL

#define PICO_NOT_SUPPORTED_BY_THIS_DEVICE           0x0000011FUL
#define PICO_INVALID_DEVICE_RESOLUTION              0x00000120UL
#define PICO_INVALID_NUMBER_CHANNELS_FOR_RESOLUTION 0x00000121UL

#define PICO_CHANNEL_DISABLED_DUE_TO_USB_POWERED    0x00000122UL

#define PICO_SIGGEN_DC_VOLTAGE_NOT_CONFIGURABLE     0x00000123UL

#define	PICO_NO_TRIGGER_ENABLED_FOR_TRIGGER_IN_PRE_TRIG  0x00000124UL
#define PICO_TRIGGER_WITHIN_PRE_TRIG_NOT_ARMED           0x00000125UL
#define PICO_TRIGGER_WITHIN_PRE_NOT_ALLOWED_WITH_DELAY   0x00000126UL
#define PICO_TRIGGER_INDEX_UNAVAILABLE                   0x00000127UL

#define PICO_AWG_CLOCK_FREQUENCY									0x00000128UL
// there are more than 4 analogue channels with a trigger condition set
#define PICO_TOO_MANY_CHANNELS_IN_USE							0x00000129UL

#define PICO_NULL_CONDITIONS											0x000012AUL	
#define PICO_DUPLICATE_CONDITION_SOURCE						0x0000012BUL	
#define PICO_INVALID_CONDITION_INFO								0x0000012CUL	

#define PICO_SETTINGS_READ_FAILED									0x0000012DUL
#define PICO_SETTINGS_WRITE_FAILED								0x0000012EUL

#define PICO_ARGUMENT_OUT_OF_RANGE								0x0000012FUL

#define PICO_HARDWARE_VERSION_NOT_SUPPORTED				0x00000130UL
#define PICO_DIGITAL_HARDWARE_VERSION_NOT_SUPPORTED				0x00000131UL
#define PICO_ANALOGUE_HARDWARE_VERSION_NOT_SUPPORTED				0x00000132UL

#define PICO_DEVICE_TIME_STAMP_RESET							0x01000000UL

#define PICO_WATCHDOGTIMER                        0x10000000UL

typedef uint32_t PICO_STATUS;


#endif

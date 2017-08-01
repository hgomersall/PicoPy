# -*- coding: utf-8 -*-

from pico_status cimport *

cpdef check_status(unsigned long status_code):

    if status_code != PICO_OK:
        raise PicoError(status_code)

class PicoError(Exception):
    def __init__(self, status_code):
        self.status_code = status_code

        try:
            self.status_code_str = status_code_lookup[status_code][0]
            self.status_str = status_code_lookup[status_code][1]
        except KeyError:
            self.status_code_str = 'ERROR ' + str(status_code)
            self.status_str = 'Unknown error (lookup the 5k docs)'

    def __str__(self):
        return '%s: %s' % (self.status_code_str, self.status_str)


status_code_lookup = {
        PICO_OK: (
            'PICO_OK',
            'The PicoScope 5000A is functioning correctly'),
        PICO_MAX_UNITS_OPENED: (
            'PICO_MAX_UNITS_OPENED',
            'An attempt has been made to open more than PS5000A_MAX_UNITS.'),
        PICO_MEMORY_FAIL: (
            'PICO_MEMORY_FAIL',
            'Not enough memory could be allocated on the host machine'),
        PICO_NOT_FOUND: (
            'PICO_NOT_FOUND',
            'No PicoScope 5000A could be found'),
        PICO_FW_FAIL: (
            'PICO_FW_FAIL',
            'Unable to download firmware'),
        PICO_OPEN_OPERATION_IN_PROGRESS: (
            'PICO_OPEN_OPERATION_IN_PROGRESS',
            ''),
        PICO_OPERATION_FAILED: (
            'PICO_OPERATION_FAILED',
            ''),
        PICO_NOT_RESPONDING: (
            'PICO_NOT_RESPONDING',
            'The PicoScope 5000A is not responding to commands from the '
            'PC'),
        PICO_CONFIG_FAIL: (
            'PICO_CONFIG_FAIL',
            'The configuration information in the PicoScope 5000A has '
            'become corrupt or is missing'),
        PICO_KERNEL_DRIVER_TOO_OLD: (
            'PICO_KERNEL_DRIVER_TOO_OLD',
            'The picopp.sys file is too old to be used with the device '
            'driver'),
        PICO_EEPROM_CORRUPT: (
            'PICO_EEPROM_CORRUPT',
            'The EEPROM has become corrupt, so the device will use a '
            'default setting'),
        PICO_OS_NOT_SUPPORTED: (
            'PICO_OS_NOT_SUPPORTED',
            'The operating system on the PC is not supported by this '
            'driver'),
        PICO_INVALID_HANDLE: (
            'PICO_INVALID_HANDLE',
            'There is no device with the handle value passed'),
        PICO_INVALID_PARAMETER: (
            'PICO_INVALID_PARAMETER',
            'A parameter value is not valid'),
        PICO_INVALID_TIMEBASE: (
            'PICO_INVALID_TIMEBASE',
            'The timebase is not supported or is invalid'),
        PICO_INVALID_VOLTAGE_RANGE: (
            'PICO_INVALID_VOLTAGE_RANGE',
            'The voltage range is not supported or is invalid'),
        PICO_INVALID_CHANNEL: (
            'PICO_INVALID_CHANNEL',
            'The channel number is not valid on this device or no channels '
            'have been set'),
        PICO_INVALID_TRIGGER_CHANNEL: (
            'PICO_INVALID_TRIGGER_CHANNEL',
            'The channel set for a trigger is not available on this '
            'device'),
        PICO_INVALID_CONDITION_CHANNEL: (
            'PICO_INVALID_CONDITION_CHANNEL',
            'The channel set for a condition is not available on this '
            'device'),
        PICO_NO_SIGNAL_GENERATOR: (
            'PICO_NO_SIGNAL_GENERATOR',
            'The device does not have a signal generator'),
        PICO_STREAMING_FAILED: (
            'PICO_STREAMING_FAILED',
            'Streaming has failed to start or has stopped without user '
            'request'),
        PICO_BLOCK_MODE_FAILED: (
            'PICO_BLOCK_MODE_FAILED',
            'Block failed to start - a parameter may have been set '
            'wrongly'),
        PICO_NULL_PARAMETER: (
            'PICO_NULL_PARAMETER',
            'A parameter that was required is NULL'),
        PICO_DATA_NOT_AVAILABLE: (
            'PICO_DATA_NOT_AVAILABLE',
            'No data is available from a run block call'),
        PICO_STRING_BUFFER_TOO_SMALL: (
            'PICO_STRING_BUFFER_TOO_SMALL',
            'The buffer passed for the information was too small'),
        PICO_ETS_NOT_SUPPORTED: (
            'PICO_ETS_NOT_SUPPORTED',
            'ETS is not supported on this device'),
        PICO_AUTO_TRIGGER_TIME_TOO_SHORT: (
            'PICO_AUTO_TRIGGER_TIME_TOO_SHORT',
            'The auto trigger time is less than the time it will take to '
            'collect the pre-trigger data'),
        PICO_BUFFER_STALL: (
            'PICO_BUFFER_STALL',
            'The collection of data has stalled as unread data would be '
            'overwritten'),
        PICO_TOO_MANY_SAMPLES: (
            'PICO_TOO_MANY_SAMPLES',
            'Number of samples requested is more than available in the '
            'current memory segment'),
        PICO_TOO_MANY_SEGMENTS: (
            'PICO_TOO_MANY_SEGMENTS',
            'Not possible to create number of segments requested'),
        PICO_PULSE_WIDTH_QUALIFIER: (
            'PICO_PULSE_WIDTH_QUALIFIER',
            'A null pointer has been passed in the trigger function or one '
            'of the parameters is out of range'),
        PICO_DELAY: (
            'PICO_DELAY',
            'One or more of the hold-off parameters are out of range'),
        PICO_SOURCE_DETAILS: (
            'PICO_SOURCE_DETAILS',
            'One or more of the source details are incorrect'),
        PICO_CONDITIONS: (
            'PICO_CONDITIONS',
            'One or more of the conditions are incorrect'),
        PICO_USER_CALLBACK: (
            'PICO_USER_CALLBACK',
            'The driver\'s thread is currently in the ps5000a...Ready '
            'callback function and therefore the action cannot be carried '
            'out'),
        PICO_DEVICE_SAMPLING: (
            'PICO_DEVICE_SAMPLING',
            'An attempt is being made to get stored data while streaming.  '
            'Either stop streaming by calling ps5000aStop, or use '
            'ps5000aGetStreamingLatestValues'),
        PICO_NO_SAMPLES_AVAILABLE: (
            'PICO_NO_SAMPLES_AVAILABLE',
            'No samples available because a run has not been completed'),
        PICO_SEGMENT_OUT_OF_RANGE: (
            'PICO_SEGMENT_OUT_OF_RANGE',
            'The memory index is out of range'),
        PICO_BUSY: (
            'PICO_BUSY',
            'Data cannot be returned yet'),
        PICO_STARTINDEX_INVALID: (
            'PICO_STARTINDEX_INVALID',
            'The start time to get stored data is out of range'),
        PICO_INVALID_INFO: (
            'PICO_INVALID_INFO',
            'The information number requested is not a valid number'),
        PICO_INFO_UNAVAILABLE: (
            'PICO_INFO_UNAVAILABLE',
            'The handle is invalid so no information is available about '
            'the device.  Only PICO_DRIVER_VERSION is available.'),
        PICO_INVALID_SAMPLE_INTERVAL: (
            'PICO_INVALID_SAMPLE_INTERVAL',
            'The sample interval selected for streaming is out of '
            'range'),
        PICO_TRIGGER_ERROR: (
            'PICO_TRIGGER_ERROR',
            ''),
        PICO_MEMORY: (
            'PICO_MEMORY',
            'Driver cannot allocate memory'),
        PICO_SIGGEN_OUTPUT_OVER_VOLTAGE: (
            'PICO_SIGGEN_OUTPUT_OVER_VOLTAGE',
            'The combined peak to peak voltage and the analog offset '
            'voltage exceeds the allowable voltage the signal generator '
            'can produce'),
        PICO_DELAY_NULL: (
            'PICO_DELAY_NULL',
            'NULL pointer passed as delay parameter'),
        PICO_INVALID_BUFFER: (
            'PICO_INVALID_BUFFER',
            'The buffers for overview data have not been set while '
            'streaming'),
        PICO_SIGGEN_OFFSET_VOLTAGE: (
            'PICO_SIGGEN_OFFSET_VOLTAGE',
            'The analog offset voltage is out of range'),
        PICO_SIGGEN_PK_TO_PK: (
            'PICO_SIGGEN_PK_TO_PK',
            'The analog peak to peak voltage is out of range'),
        PICO_CANCELLED: (
            'PICO_CANCELLED',
            'A block collection has been cancelled'),
        PICO_SEGMENT_NOT_USED: (
            'PICO_SEGMENT_NOT_USED',
            'The segment index is not currently being used'),
        PICO_INVALID_CALL: (
            'PICO_INVALID_CALL',
            'The wrong GetValues function has been called for the '
            'collection mode in use'),
        PICO_NOT_USED: (
            'PICO_NOT_USED',
            'The function is not available'),
        PICO_INVALID_SAMPLERATIO: (
            'PICO_INVALID_SAMPLERATIO',
            'The aggregation ratio requested is out of range'),
        PICO_INVALID_STATE: (
            'PICO_INVALID_STATE',
            'Device is in an invalid state'),
        PICO_NOT_ENOUGH_SEGMENTS: (
            'PICO_NOT_ENOUGH_SEGMENTS',
            'The number of segments allocated is fewer than the number of '
            'captures requested'),
        PICO_DRIVER_FUNCTION: (
            'PICO_DRIVER_FUNCTION',
            'You called a driver function while another driver function '
            'was still being processed'),
        PICO_RESERVED: (
            'PICO_RESERVED',
            ''),
        PICO_INVALID_COUPLING: (
            'PICO_INVALID_COUPLING',
            'An invalid coupling type was specified in ps5000aSetChannel'),
        PICO_BUFFERS_NOT_SET: (
            'PICO_BUFFERS_NOT_SET',
            'An attempt was made to get data before a data buffer was '
            'defined'),
        PICO_RATIO_MODE_NOT_SUPPORTED: (
            'PICO_RATIO_MODE_NOT_SUPPORTED',
            'The selected downsampling mode (used for data reduction) is '
            'not allowed'),
        PICO_INVALID_TRIGGER_PROPERTY: (
            'PICO_INVALID_TRIGGER_PROPERTY',
            'An invalid parameter was passed to ps5000aSetTriggerChannelProperties'),
        PICO_INTERFACE_NOT_CONNECTED: (
            'PICO_INTERFACE_NOT_CONNECTED',
            'The driver was unable to contact the oscilloscope'),
        PICO_SIGGEN_WAVEFORM_SETUP_FAILED: (
            'PICO_SIGGEN_WAVEFORM_SETUP_FAILED',
            'A problem occurred in ps5000aSetSigGenBuiltIn or '
            'ps5000aSetSigGenArbitrary'),
        PICO_FPGA_FAIL: (
            'PICO_FPGA_FAIL',
            ''),
        PICO_POWER_MANAGER: (
            'PICO_POWER_MANAGER',
            ''),
        PICO_INVALID_ANALOGUE_OFFSET: (
            'PICO_INVALID_ANALOGUE_OFFSET',
            'An impossible analogue offset value was specified in '
            'ps5000aSetChannel'),
        PICO_PLL_LOCK_FAILED: (
            'PICO_PLL_LOCK_FAILED',
            'Unable to configure the PicoScope 5000A'),
        PICO_ANALOG_BOARD: (
            'PICO_ANALOG_BOARD',
            'The oscilloscope\'s analog board is not detected, or is not '
            'connected to the digital board'),
        PICO_CONFIG_FAIL_AWG: (
            'PICO_CONFIG_FAIL_AWG',
            'Unable to configure the signal generator'),
        PICO_INITIALISE_FPGA: (
            'PICO_INITIALISE_FPGA',
            'The FPGA cannot be initialized, so unit cannot be opened'),
        PICO_EXTERNAL_FREQUENCY_INVALID: (
            'PICO_EXTERNAL_FREQUENCY_INVALID',
            'The frequency for the external clock is not within ±5% of the '
            'stated value'),
        PICO_CLOCK_CHANGE_ERROR: (
            'PICO_CLOCK_CHANGE_ERROR',
            'The FPGA could not lock the clock signal'),
        PICO_TRIGGER_AND_EXTERNAL_CLOCK_CLASH: (
            'PICO_TRIGGER_AND_EXTERNAL_CLOCK_CLASH',
            'You are trying to configure the AUX input as both a trigger '
            'and a reference clock'),
        PICO_PWQ_AND_EXTERNAL_CLOCK_CLASH: (
            'PICO_PWQ_AND_EXTERNAL_CLOCK_CLASH',
            'You are trying to congfigure the AUX input as both a pulse '
            'width qualifier and a reference clock'),
        PICO_UNABLE_TO_OPEN_SCALING_FILE: (
            'PICO_UNABLE_TO_OPEN_SCALING_FILE',
            'The scaling file set can not be opened.'),
        PICO_MEMORY_CLOCK_FREQUENCY: (
            'PICO_MEMORY_CLOCK_FREQUENCY',
            'The frequency of the memory is reporting incorrectly.'),
        PICO_I2C_NOT_RESPONDING: (
            'PICO_I2C_NOT_RESPONDING',
            'The I2C that is being actioned is not responding to '
            'requests.'),
        PICO_NO_CAPTURES_AVAILABLE: (
            'PICO_NO_CAPTURES_AVAILABLE',
            'There are no captures available and therefore no data can be '
            'returned.'),
        PICO_NOT_USED_IN_THIS_CAPTURE_MODE: (
            'PICO_NOT_USED_IN_THIS_CAPTURE_MODE',
            'The capture mode the device is currently running in does not '
            'support the current request.'),
        PICO_GET_DATA_ACTIVE: (
            'PICO_GET_DATA_ACTIVE',
            'Reserved'),
        PICO_IP_NETWORKED: (
            'PICO_IP_NETWORKED',
            'The device is currently connected via the IP Network socket '
            'and thus the call made is not supported.'),
        PICO_INVALID_IP_ADDRESS: (
            'PICO_INVALID_IP_ADDRESS',
            'An IP address that is not correct has been passed to the '
            'driver.'),
        PICO_IPSOCKET_FAILED: (
            'PICO_IPSOCKET_FAILED',
            'The IP socket has failed.'),
        PICO_IPSOCKET_TIMEDOUT: (
            'PICO_IPSOCKET_TIMEDOUT',
            'The IP socket has timed out.'),
        PICO_SETTINGS_FAILED: (
            'PICO_SETTINGS_FAILED',
            'The settings requested have failed to be set.'),
        PICO_NETWORK_FAILED: (
            'PICO_NETWORK_FAILED',
            'The network connection has failed.'),
        PICO_WS2_32_DLL_NOT_LOADED: (
            'PICO_WS2_32_DLL_NOT_LOADED',
            'Unable to load the WS2 dll.'),
        PICO_INVALID_IP_PORT: (
            'PICO_INVALID_IP_PORT',
            'The IP port is invalid'),
        PICO_COUPLING_NOT_SUPPORTED: (
            'PICO_COUPLING_NOT_SUPPORTED',
            'The type of coupling requested is not supported on the opened '
            'device.'),
        PICO_BANDWIDTH_NOT_SUPPORTED: (
            'PICO_BANDWIDTH_NOT_SUPPORTED',
            'Bandwidth limit is not supported on the opened device.'),
        PICO_INVALID_BANDWIDTH: (
            'PICO_INVALID_BANDWIDTH',
            'The value requested for the bandwidth limit is out of '
            'range.'),
        PICO_AWG_NOT_SUPPORTED: (
            'PICO_AWG_NOT_SUPPORTED',
            'The arbitrary waveform generator is not supported by the '
            'opened device.'),
        PICO_ETS_NOT_RUNNING: (
            'PICO_ETS_NOT_RUNNING',
            'Data has been requested with ETS mode set but run block has '
            'not been called, or stop has been called.'),
        PICO_SIG_GEN_WHITENOISE_NOT_SUPPORTED: (
            'PICO_SIG_GEN_WHITENOISE_NOT_SUPPORTED',
            'White noise is not supported on the opened device.'),
        PICO_SIG_GEN_WAVETYPE_NOT_SUPPORTED: (
            'PICO_SIG_GEN_WAVETYPE_NOT_SUPPORTED',
            'The wave type requested is not supported by the opened '
            'device. '),
        PICO_INVALID_DIGITAL_PORT: (
            'PICO_INVALID_DIGITAL_PORT',
            'Not applicable to this device'),
        PICO_INVALID_DIGITAL_CHANNEL: (
            'PICO_INVALID_DIGITAL_CHANNEL',
            'Not applicable to this device'),
        PICO_INVALID_DIGITAL_TRIGGER_DIRECTION: (
            'PICO_INVALID_DIGITAL_TRIGGER_DIRECTION',
            'Not applicable to this device'),
        PICO_SIG_GEN_PRBS_NOT_SUPPORTED: (
            'PICO_SIG_GEN_PRBS_NOT_SUPPORTED',
            'Siggen does not generate pseudo-random  bit stream.'),
        PICO_ETS_NOT_AVAILABLE_WITH_LOGIC_CHANNELS: (
            'PICO_ETS_NOT_AVAILABLE_WITH_LOGIC_CHANNELS',
            'Not applicable to this device'),
        PICO_WARNING_REPEAT_VALUE: (
            'PICO_WARNING_REPEAT_VALUE',
            'Not applicable to this device'),
        PICO_POWER_SUPPLY_CONNECTED: (
            'PICO_POWER_SUPPLY_CONNECTED',
            '4-Channel only - The DC power supply is connected.'),
        PICO_POWER_SUPPLY_NOT_CONNECTED: (
            'PICO_POWER_SUPPLY_NOT_CONNECTED',
            '4-Channel only - The DC power supply isn’t connected.'),
        PICO_POWER_SUPPLY_REQUEST_INVALID: (
            'PICO_POWER_SUPPLY_REQUEST_INVALID',
            'Incorrect power mode passed for current power source.'),
        PICO_POWER_SUPPLY_UNDERVOLTAGE: (
            'PICO_POWER_SUPPLY_UNDERVOLTAGE',
            'The supply voltage from the USB source is too low.'),
        }

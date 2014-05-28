# Henry Gomersall
# heng@kedevelopments.co.uk
#

cpdef check_status(unsigned long pico_status)

#cdef extern from 'libps3000a-1.0/PicoStatus.h':
#    ctypedef unsigned long PICO_INFO
#    ctypedef unsigned long PICO_STATUS

cdef extern from 'PicoStatus.h':
    ctypedef unsigned long PICO_INFO
    ctypedef unsigned long PICO_STATUS

# PICO_INFO flags
cdef enum:
    PICO_DRIVER_VERSION = 0x0
    PICO_USB_VERSION = 0x1
    PICO_HARDWARE_VERSION = 0x2
    PICO_VARIANT_INFO = 0x3
    PICO_BATCH_AND_SERIAL = 0x4
    PICO_CAL_DATE = 0x5
    PICO_KERNEL_VERSION = 0x6

    PICO_DIGITAL_HARDWARE_VERSION = 0x7
    PICO_ANALOGUE_HARDWARE_VERSION = 0x8

    PICO_FIRMWARE_VERSION_1 = 0x9
    PICO_FIRMWARE_VERSION_2 = 0xA

    PICO_MAC_ADDRESS = 0xB

# PICO_STATUS flags
cdef enum:
    PICO_OK = 0x0
    PICO_MAX_UNITS_OPENED = 0x1
    PICO_MEMORY_FAIL = 0x2
    PICO_NOT_FOUND = 0x3
    PICO_FW_FAIL = 0x4
    PICO_OPEN_OPERATION_IN_PROGRESS = 0x5
    PICO_OPERATION_FAILED = 0x6
    PICO_NOT_RESPONDING = 0x7
    PICO_CONFIG_FAIL = 0x8
    PICO_KERNEL_DRIVER_TOO_OLD = 0x9
    PICO_EEPROM_CORRUPT = 0xA
    PICO_OS_NOT_SUPPORTED = 0xB
    PICO_INVALID_HANDLE = 0xC
    PICO_INVALID_PARAMETER = 0xD
    PICO_INVALID_TIMEBASE = 0xE
    PICO_INVALID_VOLTAGE_RANGE = 0xF
    PICO_INVALID_CHANNEL = 0x10
    PICO_INVALID_TRIGGER_CHANNEL = 0x11
    PICO_INVALID_CONDITION_CHANNEL = 0x12
    PICO_NO_SIGNAL_GENERATOR = 0x13
    PICO_STREAMING_FAILED = 0x14
    PICO_BLOCK_MODE_FAILED = 0x15
    PICO_NULL_PARAMETER = 0x16
    PICO_ETS_MODE_SET = 0x17
    PICO_DATA_NOT_AVAILABLE = 0x18
    PICO_STRING_BUFFER_TOO_SMALL = 0x19
    PICO_ETS_NOT_SUPPORTED = 0x1A
    PICO_AUTO_TRIGGER_TIME_TOO_SHORT = 0x1B
    PICO_BUFFER_STALL = 0x1C
    PICO_TOO_MANY_SAMPLES = 0x1D
    PICO_TOO_MANY_SEGMENTS = 0x1E
    PICO_PULSE_WIDTH_QUALIFIER = 0x1F
    PICO_DELAY = 0x20
    PICO_SOURCE_DETAILS = 0x21
    PICO_CONDITIONS = 0x22
    PICO_USER_CALLBACK = 0x23
    PICO_DEVICE_SAMPLING = 0x24
    PICO_NO_SAMPLES_AVAILABLE = 0x25
    PICO_SEGMENT_OUT_OF_RANGE = 0x26
    PICO_BUSY = 0x27
    PICO_STARTINDEX_INVALID = 0x28
    PICO_INVALID_INFO = 0x29
    PICO_INFO_UNAVAILABLE = 0x2A
    PICO_INVALID_SAMPLE_INTERVAL = 0x2B
    PICO_TRIGGER_ERROR = 0x2C
    PICO_MEMORY = 0x2D
    PICO_SIG_GEN_PARAM = 0x2E
    PICO_SHOTS_SWEEPS_WARNING = 0x2F
    PICO_SIGGEN_TRIGGER_SOURCE = 0x30
    PICO_AUX_OUTPUT_CONFLICT = 0x31
    PICO_AUX_OUTPUT_ETS_CONFLICT = 0x32
    PICO_WARNING_EXT_THRESHOLD_CONFLICT = 0x33
    PICO_WARNING_AUX_OUTPUT_CONFLICT = 0x34
    PICO_SIGGEN_OUTPUT_OVER_VOLTAGE = 0x35
    PICO_DELAY_NULL = 0x36
    PICO_INVALID_BUFFER = 0x37
    PICO_SIGGEN_OFFSET_VOLTAGE = 0x38
    PICO_SIGGEN_PK_TO_PK = 0x39
    PICO_CANCELLED = 0x3A
    PICO_SEGMENT_NOT_USED = 0x3B
    PICO_INVALID_CALL = 0x3C
    PICO_GET_VALUES_INTERRUPTED = 0x3D
    PICO_NOT_USED = 0x3F
    PICO_INVALID_SAMPLERATIO = 0x40
    
    # Operation could not be carried out because device was in an 
    # invalid state.
    PICO_INVALID_STATE = 0x41
    
    # Operation could not be carried out as rapid capture no of 
    # waveforms are greater than the no of memory segments.
    PICO_NOT_ENOUGH_SEGMENTS = 0x42

    # A driver function has already been called and not yet finished
    # only one call to the driver can be made at any one time
    PICO_DRIVER_FUNCTION = 0x43
    PICO_RESERVED = 0x44
    PICO_INVALID_COUPLING = 0x45
    PICO_BUFFERS_NOT_SET = 0x46
    PICO_RATIO_MODE_NOT_SUPPORTED = 0x47
    PICO_RAPID_NOT_SUPPORT_AGGREGATION = 0x48
    PICO_INVALID_TRIGGER_PROPERTY = 0x49
    PICO_INTERFACE_NOT_CONNECTED = 0x4A
    PICO_RESISTANCE_AND_PROBE_NOT_ALLOWED = 0x4B
    PICO_POWER_FAILED = 0x4C
    PICO_SIGGEN_WAVEFORM_SETUP_FAILED = 0x4D
    PICO_FPGA_FAIL = 0x4E
    PICO_POWER_MANAGER = 0x4F
    PICO_INVALID_ANALOGUE_OFFSET = 0x50
    
    # unable to configure the ps6000
    PICO_PLL_LOCK_FAILED = 0x51
    
    # the ps6000 Analog board is not detectly connected to the digital board
    PICO_ANALOG_BOARD = 0x52
    
    # unable to configure the Signal Generator
    PICO_CONFIG_FAIL_AWG = 0x53
    PICO_INITIALISE_FPGA = 0x54
    PICO_EXTERNAL_FREQUENCY_INVALID = 0x56
    PICO_CLOCK_CHANGE_ERROR = 0x57
    PICO_TRIGGER_AND_EXTERNAL_CLOCK_CLASH = 0x58
    PICO_PWQ_AND_EXTERNAL_CLOCK_CLASH = 0x59
    PICO_UNABLE_TO_OPEN_SCALING_FILE = 0x5A

    PICO_MEMORY_CLOCK_FREQUENCY = 0x5B
    PICO_I2C_NOT_RESPONDING = 0x5C

    PICO_NO_CAPTURES_AVAILABLE = 0x5D
    PICO_NOT_USED_IN_THIS_CAPTURE_MODE = 0x5E

    PICO_GET_DATA_ACTIVE = 0x103
    
    # used by the PT104 (USB) when connected via the Network Socket
    PICO_IP_NETWORKED = 0x104
    PICO_INVALID_IP_ADDRESS = 0x105
    PICO_IPSOCKET_FAILED = 0x106
    PICO_IPSOCKET_TIMEDOUT = 0x107
    PICO_SETTINGS_FAILED = 0x108
    PICO_NETWORK_FAILED = 0x109
    PICO_WS2_32_DLL_NOT_LOADED = 0x10A
    PICO_INVALID_IP_PORT = 0x10B

    PICO_COUPLING_NOT_SUPPORTED = 0x10C
    PICO_BANDWIDTH_NOT_SUPPORTED = 0x10D
    PICO_INVALID_BANDWIDTH = 0x10E

    PICO_AWG_NOT_SUPPORTED = 0x10F
    PICO_ETS_NOT_RUNNING = 0x110
    PICO_SIG_GEN_WHITENOISE_NOT_SUPPORTED = 0x111
    PICO_SIG_GEN_WAVETYPE_NOT_SUPPORTED = 0x112

    PICO_INVALID_DIGITAL_PORT = 0x113
    PICO_INVALID_DIGITAL_CHANNEL = 0x114
    PICO_INVALID_DIGITAL_TRIGGER_DIRECTION = 0x115

    PICO_SIG_GEN_PRBS_NOT_SUPPORTED = 0x116

    PICO_ETS_NOT_AVAILABLE_WITH_LOGIC_CHANNELS = 0x117
    PICO_WARNING_REPEAT_VALUE = 0x118
    PICO_POWER_SUPPLY_CONNECTED = 0x119
    PICO_POWER_SUPPLY_NOT_CONNECTED = 0x11A
    PICO_POWER_SUPPLY_REQUEST_INVALID = 0x11B
    PICO_POWER_SUPPLY_UNDERVOLTAGE = 0x11C

    PICO_CAPTURING_DATA = 0x11D

    PICO_USB3_0_DEVICE_NON_USB3_0_PORT = 0x11E

    PICO_NOT_SUPPORTED_BY_THIS_DEVICE = 0x11F
    PICO_INVALID_DEVICE_RESOLUTION = 0x120
    PICO_INVALID_NUMBER_CHANNELS_FOR_RESOLUTION = 0x121

    PICO_CHANNEL_DISABLED_DUE_TO_USB_POWERED = 0x122

    PICO_SIGGEN_DC_VOLTAGE_NOT_CONFIGURABLE = 0x123

    PICO_NO_TRIGGER_ENALBED_FOR_TRIGGER_IN_PRE_TRIG = 0x124
    PICO_TRIGGER_WITHIN_PRE_TRIG_NOT_ARMED = 0x125
    PICO_TRIGGER_WITHIN_PRE_NOT_ALLOWED_WITH_DELAY = 0x126
    PICO_TRIGGER_INDEX_UNAVAILABLE = 0x127

    PICO_DEVICE_TIME_STAMP_RESET = 0x01000000

    PICO_WATCHDOGTIMER = 0x10000000


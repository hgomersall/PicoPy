# Copyright 2012 Knowledge Economy Developments Ltd
#
# Henry Gomersall
# heng@kedevelopments.co.uk
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
# 

from pico_status cimport check_status
from pico_status import PicoError
cimport pico_status

import logic
from frozendict import frozendict

import copy
import math
import time
from math import copysign

from libc.stdlib cimport malloc, free

import numpy as np
cimport numpy as np

capability_dict = frozendict({
    '3204A': frozendict({'channels': 2, 'max_sampling_rate': 5e8}),
    '3204B': frozendict({'channels': 2, 'max_sampling_rate': 5e8}),
    '3205A': frozendict({'channels': 2, 'max_sampling_rate': 5e8}),
    '3205B': frozendict({'channels': 2, 'max_sampling_rate': 5e8}),
    '3206A': frozendict({'channels': 2, 'max_sampling_rate': 5e8}),
    '3206B': frozendict({'channels': 2, 'max_sampling_rate': 5e8}),
    '3404A': frozendict({'channels': 4, 'max_sampling_rate': 1e9}),
    '3404B': frozendict({'channels': 4, 'max_sampling_rate': 1e9}),
    '3405A': frozendict({'channels': 4, 'max_sampling_rate': 1e9}),
    '3405B': frozendict({'channels': 4, 'max_sampling_rate': 1e9}),
    '3406A': frozendict({'channels': 4, 'max_sampling_rate': 1e9}),
    '3406B': frozendict({'channels': 4, 'max_sampling_rate': 1e9})})

channel_dict = frozendict({
    'A': PS3000A_CHANNEL_A,
    'B': PS3000A_CHANNEL_B,
    'C': PS3000A_CHANNEL_C,
    'D': PS3000A_CHANNEL_D,
    'ext': PS3000A_EXTERNAL,
    'aux': PS3000A_TRIGGER_AUX,
    })

channel_type_dict = frozendict({
    'AC': PS3000A_AC,
    'DC': PS3000A_DC})

voltage_range_dict = frozendict({
    '50mV': PS3000A_50MV,
    '100mV': PS3000A_100MV,
    '200mV': PS3000A_200MV,
    '500mV': PS3000A_500MV,
    '1V': PS3000A_1V,
    '2V': PS3000A_2V,
    '5V': PS3000A_5V,
    '10V': PS3000A_10V,
    '20V': PS3000A_20V})

voltage_range_values = frozendict({
    PS3000A_50MV: 50e-3,
    PS3000A_100MV: 100e-3,
    PS3000A_200MV: 500e-3,
    PS3000A_1V: 1.0,
    PS3000A_2V: 2.0,
    PS3000A_5V: 5.0,
    PS3000A_10V: 10.0,
    PS3000A_20V: 20.0})

threshold_direction_dict = frozendict({
    'ABOVE': PS3000A_ABOVE,
    'ABOVE_LOWER': PS3000A_ABOVE_LOWER,
    'BELOW': PS3000A_BELOW,
    'BELOW_LOWER': PS3000A_BELOW_LOWER,
    'RISING': PS3000A_RISING,
    'RISING_LOWER': PS3000A_RISING_LOWER,
    'FALLING': PS3000A_FALLING,
    'FALLING_LOWER': PS3000A_FALLING_LOWER,
    'RISING_OR_FALLING': PS3000A_RISING_OR_FALLING,
    'INSIDE': PS3000A_INSIDE,
    'OUTSIDE': PS3000A_OUTSIDE,
    'ENTER': PS3000A_ENTER,
    'EXIT': PS3000A_EXIT,
    'ENTER_OR_EXIT': PS3000A_ENTER_OR_EXIT,
    'POSITIVE_RUNT': PS3000A_POSITIVE_RUNT,
    'NEGATIVE_RUNT': PS3000A_NEGATIVE_RUNT,
    'NONE': PS3000A_NONE,
    None: PS3000A_NONE,})

threshold_mode_dict = frozendict({
    'LEVEL': PS3000A_LEVEL,
    'WINDOW': PS3000A_WINDOW})

PWQ_type_dict = frozendict({
    'NONE': PS3000A_PW_TYPE_NONE,
    'GREATER_THAN': PS3000A_PW_TYPE_GREATER_THAN,
    'LESS_THAN': PS3000A_PW_TYPE_LESS_THAN,
    'IN_RANGE': PS3000A_PW_TYPE_IN_RANGE,
    'OUT_OF_RANGE': PS3000A_PW_TYPE_OUT_OF_RANGE})

trigger_state_dict = frozendict({
    None: PS3000A_CONDITION_DONT_CARE,
    True: PS3000A_CONDITION_TRUE,
    False: PS3000A_CONDITION_FALSE,})

channel_enumeration = frozendict({
    'A': 0,
    'B': 1,
    'C': 2,
    'D': 3,
    'ext': 4,
    'aux': 5,
    'PWQ': 6,})

default_trigger_properties = frozendict({
    'upper_threshold': 0.0,
    'upper_hysteresis': 0.0,
    'lower_threshold': 0.0,
    'lower_hysteresis': 0.0,
    'threshold_mode': 'LEVEL',
    'trigger_direction': 'NONE',})

default_pwq_properties = frozendict({
    'PWQ_logic': '',
    'PWQ_lower': 0.0,
    'PWQ_upper': 0.0,
    'PWQ_type': 'NONE',
    'PWQ_direction': 'NONE',})


cdef open_unit(char *serial_str):
    cdef PICO_STATUS status
    cdef short handle

    with nogil:
        status = ps3000aOpenUnit(&handle, serial_str)
    check_status(status)

    serial = get_unit_info(handle, pico_status.PICO_BATCH_AND_SERIAL)

    return handle

cdef close_unit(short handle):
    cdef PICO_STATUS status
    
    with nogil:
        status = ps3000aCloseUnit(handle)

    check_status(status)


cdef get_unit_info(short handle, PICO_INFO info):

    cdef short n = 20
    cdef char* info_str = <char *>malloc(sizeof(char)*(n))
    cdef short required_n

    cdef bytes py_info_str
    
    cdef PICO_STATUS status

    with nogil:
        status = ps3000aGetUnitInfo(handle, info_str, n, &required_n, info)
    check_status(status)
    
    # Make sure we had a big enough string
    if required_n > n:
        free(info_str)
        n = required_n
        info_str = <char *>malloc(sizeof(char)*(n))
        
        with nogil:
            status = ps3000aGetUnitInfo(
                    handle, info_str, n, &required_n, info)
        check_status(status)

    try:
        py_info_str = info_str
    finally:
        free(info_str)

    return py_info_str

cdef set_channel(short handle, channel, bint enable, 
        voltage_range, channel_type, float analogue_offset):

    cdef PICO_STATUS status
    cdef short _enable = enable
    cdef PS3000A_CHANNEL _channel = channel_dict[channel]
    cdef PS3000A_COUPLING _channel_type = channel_type_dict[channel_type]
    cdef PS3000A_RANGE _voltage_range = voltage_range_dict[voltage_range]

    with nogil:
        status = ps3000aSetChannel(handle, _channel, _enable,
                _channel_type, _voltage_range, analogue_offset)

    check_status(status)

cdef get_timebase(short handle, unsigned long timebase_index, 
        long no_samples, short oversample, unsigned short segment_index):

    cdef float time_interval
    cdef long max_samples
    cdef PICO_STATUS status

    with nogil:
        status = ps3000aGetTimebase2(handle, timebase_index, no_samples, 
                &time_interval, oversample, &max_samples, segment_index)

    check_status(status)

    return (time_interval*1e-9, max_samples)

cdef unsigned long compute_timebase_index(
        float sampling_period, float sampling_rate, 
        unsigned char oversample):
    '''Round the sampling period to the nearest valid sampling period and
    return the timebase index to which the sampling period corresponds.

    If there is no sampling period is set to be below or below the maximum
    possible, return either 0 or the maximum index respectively.
    '''

    cdef unsigned long timebase_index_low 
    cdef unsigned long timebase_index

    # We need to work with a sampling period that has been
    # scaled by the oversample rate
    us_sampling_period = sampling_period/oversample

    if us_sampling_period < 1/sampling_rate:
        return 0

    elif us_sampling_period > (2**32 - 3)/(sampling_rate/8):
        return 2**32 - 1

    elif us_sampling_period < 8/sampling_rate:
        timebase_index_low = int(
                math.floor(math.log(us_sampling_period * sampling_rate, 2)))

    else:
        timebase_index_low = int(
                math.floor(us_sampling_period * sampling_rate/8 + 2))

    cdef float mean_sampling_period = 0.0
    cdef int n

    for n in range(2):
        # The following are set by the sample interval formula in the docs
        if timebase_index_low + n < 3:
            mean_sampling_period += (
                    2**(timebase_index_low + n)/(2*sampling_rate))
        else:
            mean_sampling_period += (
                    (timebase_index_low + n - 2)/(2*sampling_rate/8))

    if us_sampling_period < mean_sampling_period:
        timebase_index = timebase_index_low
    else:
        timebase_index = timebase_index_low + 1

    return timebase_index

cdef run_block(short handle, long no_of_pretrigger_samples, 
        long no_of_posttrigger_samples, unsigned long timebase_index, 
        short oversample, unsigned short segment_index):

    cdef PICO_STATUS status
    cdef bint blocking = True
    
    cdef long time_indisposed_ms

    with nogil:
        status = ps3000aRunBlock(handle, no_of_pretrigger_samples, 
                no_of_posttrigger_samples, timebase_index, oversample,
                &time_indisposed_ms, segment_index, NULL, NULL)

    check_status(status)
    cdef short finished = 0

    if blocking:
        # Sleep for the time it was expected to take (of course, this
        # doesn't factor in the trigger time).
        time.sleep(time_indisposed_ms * 1e-3)

        while True:
            with nogil:
                status = ps3000aIsReady(handle, &finished)

            check_status(status)

            if finished:
                break
            
            # Sleep for another few microseconds
            time.sleep(10e-6)

cdef setup_arrays(short handle, channels, samples):
    
    cdef PICO_STATUS status
    cdef PS3000A_CHANNEL _channel
    cdef short * _buffer
    cdef long _samples = samples
    cdef unsigned short segment_index = 0

    n_channels = len(channels)

    full_array = np.zeros((n_channels, samples), dtype='int16')
    
    data_dict = {}

    for n, channel in enumerate(channels):

        channel_array = full_array[n, :]
        _channel = channel_dict[channel]
        _buffer = <short *>np.PyArray_DATA(channel_array)

        with nogil:
            status = ps3000aSetDataBuffer(handle, _channel, _buffer, 
                    _samples, segment_index, PS3000A_RATIO_MODE_NONE)

        check_status(status)

        data_dict[channel] = channel_array

    return channel_array


cdef get_data(short handle, channels, samples):
    '''Get the data associated with the given channels, and return a
    tuple containing a dictionary of samples length numpy arrays (as
    the first element) and a dictionary of bools indicating whether
    the scope channel overflowed during the capture.

    Each channel is a view into an N x samples length block of memory,
    where N is the number of channels.

    What is returned is a tuple with first ele
    '''
    
    cdef PICO_STATUS status
    cdef PS3000A_CHANNEL _channel
    cdef short * _buffer
    cdef long _samples = samples
    cdef unsigned short segment_index = 0

    n_channels = len(channels)

    full_array = np.zeros((n_channels, samples), dtype='int16')
    
    data_dict = {}

    for n, channel in enumerate(channels):

        channel_array = full_array[n, :]
        _channel = channel_dict[channel]
        _buffer = <short *>np.PyArray_DATA(channel_array)

        with nogil:
            status = ps3000aSetDataBuffer(handle, _channel, _buffer, 
                    _samples, segment_index, PS3000A_RATIO_MODE_NONE)

        check_status(status)

        data_dict[channel] = channel_array
        
    
    cdef unsigned long start_index = 0
    cdef unsigned long downsample_factor = 1
    cdef short overflow

    cdef unsigned long n_samples = samples

    with nogil:
        status = ps3000aGetValues(handle, start_index, &n_samples, 
                downsample_factor, PS3000A_RATIO_MODE_NONE, segment_index,
                &overflow)

    check_status(status)

    if not n_samples == samples:
        raise IOError('The expected number of samples were not returned.')

    overflow_dict = {}
    for channel in channels:
        overflow_dict[channel] = bool(
                1 << channel_enumeration[channel] & overflow)

    return (data_dict, overflow_dict)

cdef stop_scope(short handle):

    with nogil:
        status = ps3000aStop(handle)

    check_status(status)

cdef setup_trigger_conditions(short handle, logic_sop, logic_variables):
    '''Setup the trigger conditions from a sum of products and a list
    of the corresponding logic variables.
    '''
    cdef short n_conditions = len(logic_sop)

    cdef PS3000A_TRIGGER_CONDITIONS *trigger_conditions

    trigger_conditions = <PS3000A_TRIGGER_CONDITIONS *>malloc(
            sizeof(PS3000A_TRIGGER_CONDITIONS) * n_conditions)

    for n, products in enumerate(logic_sop):

        trigger_state = <PS3000A_TRIGGER_STATE *>&trigger_conditions[n]

        for each_channel in channel_enumeration:

            if each_channel in logic_variables:

                channel_index = logic_variables.index(each_channel)

                trigger_state[channel_enumeration[each_channel]] = (
                        trigger_state_dict[products[channel_index]])
            else:
                trigger_state[channel_enumeration[each_channel]] = (
                        trigger_state_dict[None])

    with nogil:
        status = ps3000aSetTriggerChannelConditions(handle, 
                trigger_conditions, n_conditions)
    
    free(trigger_conditions)
    check_status(status)


cdef setup_trigger_directions(short handle, trigger):

    directions = {}
    for channel in ['A', 'B', 'C', 'D', 'ext', 'aux']:
        if channel in trigger and trigger[channel] is not None:
            directions[channel] = trigger[channel]['trigger_direction']
        else:
            directions[channel] = threshold_direction_dict[None]
    
    cdef PS3000A_THRESHOLD_DIRECTION _directions[6]

    for channel in ('A', 'B', 'C', 'D', 'ext', 'aux'):
        _directions[channel_enumeration[channel]] = directions[channel]

    with nogil:
        status = ps3000aSetTriggerChannelDirections(
                handle,
                _directions[0],
                _directions[1],
                _directions[2],
                _directions[3],
                _directions[4],
                _directions[5])

    check_status(status)

cdef setup_trigger_properties(short handle, trigger, channel_states, 
        long autotrigger_timeout_ms):

    cdef PICO_STATUS status

    # We need to work out the channels we actually have enough info
    # to use (these are also the only channels it's necessary to use)
    channels = []
    for channel in set.intersection(set(channel_states), set(trigger)):
        if trigger[channel] is not None:
            channels.append(channel)

    cdef short n_properties = len(channels)

    cdef PS3000A_TRIGGER_CHANNEL_PROPERTIES *trigger_properties
    trigger_properties = <PS3000A_TRIGGER_CHANNEL_PROPERTIES *>malloc(
            sizeof(PS3000A_TRIGGER_CHANNEL_PROPERTIES) * n_properties)

    cdef short min_val
    cdef short max_val

    with nogil:
        status = ps3000aMinimumValue(handle, &min_val)
    check_status(status)

    with nogil:
        status = ps3000aMaximumValue(handle, &max_val)
    check_status(status)

    for n, channel in enumerate(channels):
        channel_v_range = channel_states[channel][0]
        ADC_scaling = float(max_val)/channel_v_range

        upper_threshold = int(round(
            trigger[channel]['upper_threshold'] * ADC_scaling))
        upper_thld_hyst = int(round(
            trigger[channel]['upper_hysteresis'] * ADC_scaling))
        lower_threshold = int(round(
            trigger[channel]['lower_threshold'] * ADC_scaling))
        lower_thld_hyst = int(round(
            trigger[channel]['lower_hysteresis'] * ADC_scaling))

        # ideally:
        # cap_abs = lambda x: (
        #    x if abs(x) < max_val else int(copysign(max_val, x)))
        #
        # Lambdas aren't possible in cdefs, so we work around that
        x = upper_threshold
        trigger_properties[n].thresholdUpper = (
                x if abs(x) < max_val else int(copysign(max_val, x)))

        x = upper_thld_hyst
        trigger_properties[n].thresholdUpperHysteresis = (
                x if abs(x) < max_val else max_val)

        x = lower_threshold
        trigger_properties[n].thresholdLower = (
                x if abs(x) < max_val else int(copysign(max_val, x)))

        x = lower_thld_hyst
        trigger_properties[n].thresholdLowerHysteresis = (
                x if abs(x) < max_val else max_val)

        trigger_properties[n].channel = channel_dict[channel]
        trigger_properties[n].thresholdMode = (
                trigger[channel]['threshold_mode'])

    with nogil:
        status = ps3000aSetTriggerChannelProperties(handle, 
                trigger_properties, n_properties, 0, autotrigger_timeout_ms)

    free(trigger_properties)
    check_status(status)    

cdef setup_pulse_width_qualifier(short handle, trigger, 
        float sampling_period):

    cdef PICO_STATUS status

    #Firstly, get the pulse width qualifier
    pwq = trigger['PWQ']
    logic_variables, pwq_logic = pwq['PWQ_logic']
    cdef short n_conditions = len(pwq_logic)

    cdef PS3000A_PWQ_CONDITIONS *pwq_conditions

    pwq_conditions = <PS3000A_PWQ_CONDITIONS *>malloc(
            sizeof(PS3000A_PWQ_CONDITIONS) * n_conditions)

    # Copy in the pwq_conditions array from the pwq_logic structure
    for n, products in enumerate(pwq_logic):

        trigger_state = <PS3000A_TRIGGER_STATE *>&pwq_conditions[n]

        for each_channel in channel_enumeration:

            if each_channel in logic_variables:

                channel_index = logic_variables.index(each_channel)

                trigger_state[channel_enumeration[each_channel]] = (
                        trigger_state_dict[products[channel_index]])
            else:
                trigger_state[channel_enumeration[each_channel]] = (
                        trigger_state_dict[None])

    cdef PS3000A_THRESHOLD_DIRECTION PWQ_direction = pwq['PWQ_direction']
    cdef unsigned long PWQ_lower = int(
            round(pwq['PWQ_lower']/sampling_period))
    cdef unsigned long PWQ_upper = int(
            round(pwq['PWQ_upper']/sampling_period))

    cdef PS3000A_PULSE_WIDTH_TYPE PWQ_type = pwq['PWQ_type']

    with nogil:
        status = ps3000aSetPulseWidthQualifier(handle, pwq_conditions, 
                n_conditions, PWQ_direction, PWQ_lower, PWQ_upper, PWQ_type)

    free(pwq_conditions)
    check_status(status)    


cdef setup_trigger(handle, trigger, channel_states, 
        float sampling_period, long autotrigger_timeout_ms):
    
    # Firstly set up the channel conditions

    logic_variables, logic_sop = trigger['trigger_logic']

    setup_trigger_conditions(handle, logic_sop, logic_variables)

    setup_trigger_directions(handle, trigger)

    setup_trigger_properties(handle, trigger, channel_states, 
            autotrigger_timeout_ms)

    if trigger['PWQ'] is not None:
        setup_pulse_width_qualifier(handle, trigger, sampling_period)


cpdef get_units():
    '''Return a list of the serial numbers of the connected units.
    '''
    cdef PICO_STATUS status

    cdef short n = 200
    cdef char* serial_str = <char *>malloc(sizeof(char)*(n))
    cdef short count

    cdef bytes py_serial_str
    
    with nogil:
        status = ps3000aEnumerateUnits(&count, serial_str, &n)

    if status != pico_status.PICO_OK:
        raise IOError

    try:
        py_serial_str = serial_str
    finally:
        free(serial_str)

    if count == 0:
        unit_list = []
    else:
        unit_list = py_serial_str.split(',')

    return unit_list


cdef class Pico3k:

    cdef short __handle

    cdef object __channels
    cdef object __channel_states
    cdef object __trigger
    cdef object __hardware_variant
    cdef object __max_sampling_rate
    cdef object __serial_string

    cdef unsigned short __segment_index

    def __cinit__(self, serial=None, channel_configs={}):
        
        cdef char* serial_str

        if serial == None:
            serial_str = NULL
        else:
            serial_str = serial

        self.__handle = open_unit(serial_str)

    def __init__(self, serial=None, channel_configs={}):

        # Set the default enable state of the channel
        channel_default_state = {'A':True, 'B':False, 'C':False, 'D':False}

        default_trigger = ''

        self.__hardware_variant = get_unit_info(
                self.__handle, pico_status.PICO_VARIANT_INFO)

        self.__max_sampling_rate = (
                capability_dict[self.__hardware_variant]['max_sampling_rate'])

        self.__serial_string = get_unit_info(
                self.__handle, pico_status.PICO_BATCH_AND_SERIAL)

        self.__segment_index = 0

        # __channel_states stores which channels are enabled along
        # with necessary info about that channel
        self.__channel_states = {}

        channels = []

        # Iterate through all channels
        for channel in channel_default_state:
            # Get the config from the args
            try:
                channel_config = channel_configs[channel]
            except KeyError:
                channel_config = {'enable':channel_default_state[channel]}

            # Some channels are not always possible on all hardware
            try:
                self.configure_channel(channel, **channel_config)
            except PicoError as e:
                if not e.status_code == pico_status.PICO_INVALID_CHANNEL:
                    raise

            else:
                # Append valid channels to the channel list
                channels.append(channel)

        channels.append('ext')

        self.__channels = tuple(channels)

        self.__trigger = {}

        trigger_object = {'logic_function': ''}

        self.set_trigger(trigger_object)

    def __dealloc__(self):

        try:
            close_unit(self.__handle)
        except KeyError:
            pass

    def get_hardware_info(self):
        '''Return some information about the attached hardware to which
        this class refers.
        '''

        info = {'hardware_variant': self.__hardware_variant,
                'serial_string': self.__serial_string,
                'max_sampling_rate': capability_dict[
                    self.__hardware_variant]['max_sampling_rate'],
                }

        return info

    def configure_channel(self, channel, enable=True, voltage_range='5V', 
            channel_type='DC', offset=0.0):

        set_channel(self.__handle, channel, enable, voltage_range, 
                channel_type, offset)

        self.__channel_states[channel] = (
                voltage_range_values[voltage_range_dict[voltage_range]],
                enable)


    def set_trigger(self, trigger_object):
        '''Set the trigger with the trigger object, given by trigger_object.

        A trigger object is an object that possesses zero or more channel
        triggers and logic describing how the channels should be combined.
        Optionally, a pulse width qualifier (PWQ) can be included with the 
        object.

        Channel Triggers
        ----------------

        The channel triggers should be referenced with the key string that
        refers to the channel, with each channel reference returning a
        dictionary like object with the following keys:

        'upper_threshold' (volts),
        'upper_hysteresis' (volts),
        'lower_threshold' (volts),
        'lower_hysteresis' (volts),
        'threshold_mode' (one of 'LEVEL' or 'WINDOW'),
        'trigger_direction' (a direction contained in 
            threshold_direction_dict),

        For example:
        trigger_object['A']['upper_threshold'] gives the value in volts of
        the upper threshold for the trigger on channel 'A'.

        Logic Function
        --------------
        
        The logic function is accessed with the 'logic_function' key and 
        describes how the channels should be combined. This is necessary to
        describe which channels should be looked up.

        The string should describe a logical function of the possible
        trigger channels and pulse width qualifier, which can be 'A', 'B', 
        'C', 'D', 'ext', 'aux' and 'PWQ' according to the hardware.

        If a channel is included in the logic string that does not
        correspond to a valid hardware channel, then picopy.logic.ParseError 
        is raised.

        The four logical operands that are allowed, in order of precedence, 
        are:
        NOT: 'NOT', '~', '!'
        AND: 'AND', '.', '&'
        OR: 'OR', '+', '|'
        XOR: 'XOR'

        The word form of each of the above is not case dependent.
        
        Parantheses can be used to explicitly denote precedence.

        An empty string sets all the channels to "Don't care". This 
        effectively turns off triggering.

        Pulse Width Qualifier
        ---------------------

        The optional pulse width qualifier is accessed with the 'PWQ'
        key and should be an object with the following keys:

        'PWQ_logic' (a string describing the logic function of the channels.
            It is of the same form as the logic string for the main trigger
            object - see above - but without 'PWQ' being allowed as a 
            boolean variable.)
        'PWQ_lower' (seconds),
        'PWQ_upper' (seconds),
        'PWQ_type' (one of 'NONE', 'GREATER_THAN', 'LESS_THAN', 'IN_RANGE'
            or 'OUT_OF_RANGE'),
        'PWQ_direction' (a direction contained in threshold_direction_dict)

        '''

        logic_variables = self.__channels + ('PWQ',)

        # trigger_logic is a list (sum) of lists (products)
        trigger_logic = logic.get_minimal_sop_from_string(
                trigger_object['logic_function'], logic_variables)
        
        trigger = {}
        trigger['trigger_logic'] = (logic_variables, trigger_logic)

        # Work out which channels are enabled from the returned
        # logic string. This defines which channels we need to look up.
        enabled_logic_variables = set()

        for each_product in trigger_logic:

            for condition, variable in zip(each_product, logic_variables):

                if condition is not None:
                    enabled_logic_variables.add(variable)

        for channel in self.__channels:
            
            if channel in enabled_logic_variables:

                channel_trigger = {}
                    
                try:
                    _channel_trigger = trigger_object[channel]
                except KeyError as e:
                    raise KeyError('Missing channel: trigger_object is '
                            'missing expected channel %s' % (e,))

                # Turn all the properties into their canonical form, and store in
                # the trigger dict
                for each_property in default_trigger_properties:

                    try:
                        property_value = (
                                _channel_trigger[each_property])
                    except KeyError as e:
                        raise KeyError('Missing trigger property: '
                                '%s (channel %s)' % (e, channel))

                    if each_property == 'threshold_mode':
                        channel_trigger[each_property] = (
                                threshold_mode_dict[property_value])
                    
                    elif (each_property == 'trigger_direction'):
                        channel_trigger[each_property] = (
                                threshold_direction_dict[property_value])
                    
                    else:

                        float_property_value = float(property_value)
                        if ('hysteresis' in each_property and 
                                float_property_value < 0.0):
                            raise ValueError('Negative hysteresis: ',
                                    'Hysteresis values should be positive.')

                        channel_trigger[each_property] = (
                                float(property_value))

                trigger[channel] = channel_trigger

            else:
                trigger[channel] = None
                
        if 'PWQ' in enabled_logic_variables:

            pwq_trigger = {}

            try:
                _pwq_trigger = trigger_object['PWQ']
            except KeyError as e:
                raise KeyError('Missing channel: trigger_object is '
                        'missing expected channel %s' % (e,))
            
            for each_property in default_pwq_properties:
                try:
                    property_value = (
                            _pwq_trigger[each_property])
                except KeyError as e:
                    raise KeyError('Missing pwq property: '
                            '%s (PWQ)' % (e,))
                    
                if each_property == 'PWQ_type':
                    pwq_trigger[each_property] = (
                            PWQ_type_dict[property_value])
                    
                elif (each_property == 'PWQ_direction'):
                    pwq_trigger[each_property] = (
                            threshold_direction_dict[property_value])

                elif (each_property == 'PWQ_logic'):
                    # We don't want 'PWQ' to be a variable. This would break
                    # lots of things!
                    logic_variables = self.__channels
                    
                    pwq_logic = logic.get_minimal_sop_from_string(
                            property_value, logic_variables)

                    pwq_trigger[each_property] = (logic_variables, pwq_logic)
                    
                else:
                    float_property_value = float(property_value)
                    if float_property_value < 0.0:
                        raise ValueError('Negative pulse width times: '
                                'The pulse width specifiers must be a '
                                'positive number of seconds.')
                    pwq_trigger[each_property] = float_property_value
                    
            trigger['PWQ'] = pwq_trigger
        else:
            trigger['PWQ'] = None
            

        # Finally write the trigger dict back to the main triggers dict
        self.__trigger = trigger

    def get_valid_sampling_period(self, sampling_period, oversample=1):
        '''Compute the closest valid sampling period to sampling_period 
        given the hardware settings and return a tuple giving the closest
        valid sampling period as a floating point number and the maximum
        number of samples that can be captured at that sampling rate as:
        (closest_sampling_period, max_samples)

        sampling_period is the the number of seconds between each
        sample.

        oversample is the number of samples that are averaged to
        return a single sample.
        '''

        if oversample < 1 or oversample > 2**8 - 1:
            raise ValueError('Value out of range: oversample should be '
                    'between 1 and %i inclusive.', (2**8 - 1))

        cdef unsigned long timebase_index = compute_timebase_index(
                sampling_period, self.__max_sampling_rate, oversample)

        valid_period, max_samples = get_timebase(self.__handle, 
                timebase_index, 0, oversample, 0)

        # Check we are not at the limits of the range
        if not (timebase_index == 0 or timebase_index == 2**32-1):

            # If we're not, we should look to see whether we should
            # actually be returning the sampling period above or
            # below the currently calculated one.
            if sampling_period > valid_period:
                alt_timebase_index = timebase_index + 1

                valid_period_low = valid_period
                max_samples_low = max_samples
                valid_period_high, max_samples_high = get_timebase(
                        self.__handle, alt_timebase_index, 0, oversample, 0)

            else:
                alt_timebase_index = timebase_index - 1

                valid_period_low, max_samples_low = get_timebase(
                        self.__handle, alt_timebase_index, 0, oversample, 0)

                valid_period_high = valid_period
                max_samples_high = max_samples

            mean_valid_period = (valid_period_high + valid_period_low)/2

            if sampling_period < mean_valid_period:
                valid_period = valid_period_low
                max_samples = max_samples_low
            else:
                valid_period = valid_period_high
                max_samples = max_samples_high

        return (valid_period, max_samples)

    def capture_block(self, sampling_period, post_trigger_samples, 
            pre_trigger_samples=0, oversample=1, 
            autotrigger_timeout=None, return_scaled_array=True):
        '''Capture a block of data.

        The actual sampling period is adjusted to fit a nearest valid
        sampling period that can be found. To know in advance what will
        be used, call the get_valid_sampling_period method with the same
        sampling_period and oversample arguments.

        oversample is the number of samples that are averaged to produce
        a single sample. Clearly this will affect the output sample rate.

        autotrigger_timeout is the number of seconds before the trigger 
        should fire automatically. Setting this to None or 0 means the 
        trigger will never fire automatically.

        If return_scaled_array is set to False, the raw data is
        returned without scaling it to the voltage range for each
        channel.
        '''
        
        cdef unsigned long timebase_index

        if oversample < 1 or oversample > 2**8 - 1:
            raise ValueError('Value out of range: oversample should be '
                    'between 1 and %i inclusive.', (2**8 - 1))

        valid_sampling_period, max_samples = self.get_valid_sampling_period(
                sampling_period, oversample)

        n_samples = post_trigger_samples + pre_trigger_samples

        if n_samples > max_samples:
            raise PicoError(pico_status.PICO_TOO_MANY_SAMPLES)
        
        timebase_index = compute_timebase_index(valid_sampling_period, 
                self.__max_sampling_rate, oversample)

        if autotrigger_timeout is None:
            autotrigger_timeout = 0.0

        # Convert the autotrigger_timeout from seconds to milliseconds
        autotrigger_timeout_ms = int(round(autotrigger_timeout * 1e3))

        if (autotrigger_timeout_ms < 0.0 or 
                autotrigger_timeout_ms > 2**(8*sizeof(long) - 1)):
            raise ValueError('Invalid timeout:'
                    'The autotrigger timeout must be a positive number '
                    'of seconds, no greater than %.3f. (%.3f given)' % 
                    (2**(8*sizeof(long) - 1)/1e3, 
                        float(autotrigger_timeout)))

        setup_trigger(self.__handle, self.__trigger, self.__channel_states,
                sampling_period, autotrigger_timeout_ms)

        segment_index = 0

        run_block(self.__handle, pre_trigger_samples, post_trigger_samples,
                timebase_index, oversample, segment_index)

        data_channels = set()
        for channel in self.__channel_states:
            if self.__channel_states[channel][1]:
                data_channels.add(channel)

        data, overflow = get_data(self.__handle, data_channels, n_samples)

        stop_scope(self.__handle)

        if return_scaled_array:
            for channel in data:
                channel_scaling = ( 
                        self.__channel_states[channel][0]/2**15)
                scaled_channel_data = data[channel] * channel_scaling
                data[channel] = scaled_channel_data

        return (data, overflow)


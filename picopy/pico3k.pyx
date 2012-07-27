# Copyright 2012 Knowledge Economy Developments Ltd
#
# Henry Gomersall
# heng@kedevelopments.co.uk
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#    http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

from pico_status cimport check_status
from pico_status import PicoError
cimport pico_status

import logic
from frozendict import frozendict

import copy
import math
import time

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
        'D': PS3000A_CHANNEL_D})

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
        'NONE': PS3000A_NONE})

threshold_mode_dict = frozendict({
        'LEVEL': PS3000A_LEVEL,
        'WINDOW': PS3000A_WINDOW})

PWQ_type_dict = frozendict({
        'NONE': PS3000A_PW_TYPE_NONE,
        'GREATER_THAN': PS3000A_PW_TYPE_GREATER_THAN,
        'LESS_THAN': PS3000A_PW_TYPE_LESS_THAN,
        'IN_RANGE': PS3000A_PW_TYPE_IN_RANGE,
        'OUT_OF_RANGE': PS3000A_PW_TYPE_OUT_OF_RANGE})

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


channel_property_dtype = np.dtype([
    ('thresholdUpper', np.int16),
    ('thresholdUpperHysteresis', np.uint16),
    ('thresholdLower', np.int16),
    ('thresholdLowerHysteresis', np.uint16),
    ('channel', np.dtype('u%i' % (sizeof(PS3000A_CHANNEL)))),
    ('threshold_mode', np.dtype('u%i' % (sizeof(PS3000A_THRESHOLD_MODE))))])


trigger_state_dtype = np.dtype('u%i' % (sizeof(PS3000A_TRIGGER_STATE)))
trigger_conditions_dtype = np.dtype([
    ('channelA', trigger_state_dtype),
    ('channelB', trigger_state_dtype),
    ('channelC', trigger_state_dtype),
    ('channelD', trigger_state_dtype),
    ('external', trigger_state_dtype),
    ('aux', trigger_state_dtype),
    ('pulseWidthQualifier', trigger_state_dtype)])


cdef open_unit(char *serial_str):
    cdef short handle

    status = ps3000aOpenUnit(&handle, serial_str)
    check_status(status)

    serial = get_unit_info(handle, pico_status.PICO_BATCH_AND_SERIAL)

    return handle

cdef close_unit(handle):
    
    status = ps3000aCloseUnit(handle)
    check_status(status)


cdef get_unit_info(short handle, PICO_INFO info):

    cdef short n = 20
    cdef char* info_str = <char *>malloc(sizeof(char)*(n))
    cdef short required_n

    cdef bytes py_info_str
    
    cdef PICO_STATUS status

    status = ps3000aGetUnitInfo(handle, info_str, n, &required_n, info)
    check_status(status)
    
    # Make sure we had a big enough string
    if required_n > n:
        free(info_str)
        n = required_n
        info_str = <char *>malloc(sizeof(char)*(n))
        
        status = ps3000aGetUnitInfo(handle, info_str, n, &required_n, info)
        check_status(status)

    try:
        py_info_str = info_str
    finally:
        free(info_str)

    return py_info_str

cdef set_channel(short handle, channel, bint enable, voltage_range, channel_type,
        float analogue_offset):

    cdef PICO_STATUS status

    status = ps3000aSetChannel(handle, channel_dict[channel], enable,
            channel_type_dict[channel_type], voltage_range_dict[voltage_range],
            analogue_offset)

    check_status(status)

cdef get_timebase(short handle, unsigned long timebase_index, 
        long no_samples, short oversample, unsigned short segment_index):

    cdef float time_interval
    cdef long max_samples
    cdef PICO_STATUS status

    status = ps3000aGetTimebase2(handle, timebase_index, no_samples, 
            &time_interval, oversample, &max_samples, segment_index)

    check_status(status)

    return (time_interval*1e-9, max_samples)

cdef unsigned long compute_timebase_index(
        float sampling_period, float sampling_rate):
    '''Round the sampling period to the nearest valid sampling period and
    return the timebase index to which the sampling period corresponds.

    If there is no sampling period is set to be below or below the maximum
    possible, return either 0 or the maximum index respectively.
    '''

    cdef unsigned long timebase_index_low 
    cdef unsigned long timebase_index

    if sampling_period < 1/sampling_rate:
        return 0

    elif sampling_period > (2**32 - 3)/(sampling_rate/8):
        return 2**32 - 1

    elif sampling_period < 8/sampling_rate:
        timebase_index_low = int(
                math.floor(math.log(sampling_period * sampling_rate, 2)))

    else:
        timebase_index_low = int(
                math.floor(sampling_period * sampling_rate/8 + 2))

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

    if sampling_period < mean_sampling_period:
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

    status = ps3000aRunBlock(handle, no_of_pretrigger_samples, 
            no_of_posttrigger_samples, timebase_index, oversample,
            &time_indisposed_ms, segment_index, NULL, NULL)

    check_status(status)
    cdef short finished = 0

    if blocking:
        # Sleep for the time it was expected to take
        time.sleep(time_indisposed_ms * 1e-3)

        while True:
            status = ps3000aIsReady(handle, &finished)
            check_status(status)

            if finished:
                break
            
            # Sleep for another microsecond
            time.sleep(1e-6)

cdef setup_triggers(triggers, trigger_logic):
    pass

cpdef get_units():
    '''Return a list of the serial numbers of the connected units.
    '''
    cdef short n = 200
    cdef char* serial_str = <char *>malloc(sizeof(char)*(n))
    cdef short count

    cdef bytes py_serial_str
    
    cdef PICO_STATUS status

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


cdef class EdgeTrigger:
    '''Define an edge trigger object (including an advanced edge trigger).
    '''

    cdef object _channel
    cdef object _properties

    _valid_directions = ['RISING', 'FALLING', 'RISING_OR_FALLING']
    
    def __getitem__(self, key):

        if key == 'logic_function':
            return self._channel

        elif key == self._channel:
            return self._properties

        else:
            raise KeyError('Invalid channel')

    def __init__(self, channel, direction='RISING', threshold=0.0, 
            hysteresis=0.0):
        '''Initialise an edge trigger.

        channel is the channel to which the trigger should apply.

        direction is one of 'RISING', 'FALLING' or 'RISING_OR_FALLING'.
        These refer to the signal rising, falling or either.

        threshold is a floating point value giving the threshold voltage for
        the edge trigger.

        hysteresis is a positive floating point number. After the signal
        passes the threshold in the given direction, the trigger becomes
        armed. The signal must then pass the number of volts given by 
        hysteresis beyond that the threshold for the trigger to fire.
        '''

        self._channel = channel

        properties = dict(default_trigger_properties)

        if direction not in self._valid_directions:
            raise ValueError('Invalid direction: The direction passed does '
                    'not correspond to any known edge trigger.')

        properties['trigger_direction'] = direction
        properties['upper_threshold'] = float(threshold)
        properties['upper_hysteresis'] = float(hysteresis)

        self._properties = frozendict(properties)


cdef class Pico3k:

    cdef short __handle

    cdef object __channels
    cdef object __triggers
    cdef object __trigger_logic
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

        self.__triggers = {}

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

    def configure_channel(self, channel, enable=True, voltage_range='20V', 
            channel_type='DC', offset=0.0):

        set_channel(self.__handle, channel, enable, voltage_range, 
                channel_type, offset)

    def set_trigger_logic(self, logic_string):
        '''Set the trigger logic for the scope.

        logic_string is a string that describes how the triggers for
        each of the channels should be combined.

        The string should describe a logical function of the possible
        trigger channels, which can be 'A', 'B', 'C', 'D', or 'ext' according
        to the hardware.
        
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

        An empty string set all the channels to "Don't care". This 
        effectively turns off triggering.

        Examples:
        >>> pico3k_instance.set_trigger_logic('A AND NOT B')
        >>> pico3k_instance.set_trigger_logic('A XOR C')
        '''
        self.__trigger_logic = logic.get_minimal_sop_from_string(
                logic_string, self.__channels)

        
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

        # self.__trigger_logic is a list (sum) of lists (products)
        trigger_logic = logic.get_minimal_sop_from_string(
                trigger_object['logic_function'], logic_variables)

        self.__trigger_logic = (logic_variables, trigger_logic)

        # Work out which channels are enabled from the returned
        # logic string. This defines which channels we need to look up.
        enabled_logic_variables = set()

        for each_product in trigger_logic:

            for condition, variable in zip(each_product, logic_variables):

                if condition is not None:
                    enabled_logic_variables.add(variable)

        trigger = {}

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
                    logic_variables = self.__channels
                    
                    pwq_logic = logic.get_minimal_sop_from_string(
                            property_value, logic_variables)

                    pwq_trigger[each_property] = (logic_variables, pwq_logic)
                    
                else:
                    pwq_trigger[each_property] = (
                            float(property_value))
                    
            trigger['PWQ'] = channel_trigger
        else:
            trigger['PWQ'] = None
            

        # Finally write the trigger dict back to the main triggers dict
        self.__triggers[channel] = trigger

    def get_valid_sampling_period(self, sampling_period):
        '''Compute the closest valid sampling period to sampling_period 
        given the hardware settings and return a tuple giving the closest
        valid sampling period as a floating point number and the maximum
        number of samples that can be captured at that sampling rate as:
        (closest_sampling_period, max_samples)

        sampling_period is the the number of seconds between each
        sample.
        '''

        cdef unsigned long timebase_index = compute_timebase_index(
                sampling_period, self.__max_sampling_rate)

        valid_period, max_samples = get_timebase(self.__handle, 
                timebase_index, 0, 1, 0)
        
        # Check we are not at the limits of the range
        if not (timebase_index == 0 or timebase_index == 2**32-1):

            # If we're not, we should look to see whether we should
            # actually be returning the sampling period above or
            # below the currently calculated one.
            if sampling_period > valid_period:
                alt_timebase_index = timebase_index + 1

                valid_period_low = valid_period
                max_samples_low = max_samples
                valid_period_high, max_samples_high = get_timebase(self.__handle, 
                    alt_timebase_index, 0, 1, 0)

            else:
                alt_timebase_index = timebase_index - 1

                valid_period_low, max_samples_low = get_timebase(self.__handle, 
                    alt_timebase_index, 0, 1, 0)

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
            pre_trigger_samples=0):
        '''Capture a block of data.
        '''
        
        cdef unsigned long timebase_index
        
        valid_sampling_period, max_samples = self.get_valid_sampling_period(
                sampling_period)

        if post_trigger_samples + pre_trigger_samples > max_samples:
            raise PicoError(pico_status.PICO_TOO_MANY_SAMPLES)
        
        timebase_index = compute_timebase_index(sampling_period, 
                self.__max_sampling_rate)

        setup_triggers(self.__triggers, self.__trigger_logic)

        #ps3000aSetTriggerChannelConditions()
        #ps3000aSetTriggerChannelDirections()
        #ps3000aSetTriggerChannelProperties()
        #ps3000aRunBlock




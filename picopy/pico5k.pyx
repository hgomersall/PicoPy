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

from .pico_status cimport check_status
from .pico_status import PicoError
from . cimport pico_status

from . import logic
from .frozendict import frozendict

import copy
import math
import time
from math import copysign

#from libc.stdlib cimport malloc, free

import numpy as np
cimport numpy as np

from cpython.mem cimport PyMem_Malloc, PyMem_Free

capability_dict = frozendict({
    b'5443B': frozendict({
        'channels': 4, 
        'max_sampling_rate': {'DR_8BIT':['invalid', 1e9, 5e8, 2.5e8, 2.5e8],
                              'DR_12BIT':['invalid', 5e9, 2.5e8, 1.25e8, 1.25e8],
                              'DR_14BIT':['invalid', 1.25e8, 1.25e8, 1.25e8, 1.25e8],
                              'DR_15BIT':['invalid', 1.25e8, 1.25e8, 'invalid', 'invalid'],
                              'DR_16BIT':['invalid', 6.25e7, 'invalid', 'invalid', 'invalid']}
                        })
                            }) 

channel_dict = frozendict({
    'A': PS5000A_CHANNEL_A,
    'B': PS5000A_CHANNEL_B,
    'C': PS5000A_CHANNEL_C,
    'D': PS5000A_CHANNEL_D,
    'ext': PS5000A_EXTERNAL,
    'aux': PS5000A_TRIGGER_AUX,
	'src': PS5000A_MAX_TRIGGER_SOURCES
    })

channel_type_dict = frozendict({
    'AC': PS5000A_AC,
    'DC': PS5000A_DC})

voltage_range_dict = frozendict({
    '10mV': PS5000A_10MV,
    '20mV': PS5000A_20MV,
    '50mV': PS5000A_50MV,
    '100mV': PS5000A_100MV,
    '200mV': PS5000A_200MV,
    '500mV': PS5000A_500MV,
    '1V': PS5000A_1V,
    '2V': PS5000A_2V,
    '5V': PS5000A_5V,
    '10V': PS5000A_10V,
    '20V': PS5000A_20V,
	'50V': PS5000A_50V})

voltage_range_values = frozendict({
    PS5000A_10MV: 10e-3,
    PS5000A_20MV: 20e-3,
    PS5000A_50MV: 50e-3,
    PS5000A_100MV: 100e-3,
    PS5000A_200MV: 200e-3,
    PS5000A_500MV: 500e-3,
    PS5000A_1V: 1.0,
    PS5000A_2V: 2.0,
    PS5000A_5V: 5.0,
    PS5000A_10V: 10.0,
    PS5000A_20V: 20.0,
	PS5000A_50V: 50.0})
	
resolution_dict = frozendict({
	"DR_8BIT" : PS5000A_DR_8BIT,
	"DR_12BIT" : PS5000A_DR_12BIT,
	"DR_14BIT" : PS5000A_DR_14BIT,
	"DR_15BIT" : PS5000A_DR_15BIT,
	"DR_16BIT" : PS5000A_DR_16BIT})

downsampling_modes = frozendict({
    'NONE': PS5000A_RATIO_MODE_NONE,
    'AGGREGATE': PS5000A_RATIO_MODE_AGGREGATE,
    'AVERAGE': PS5000A_RATIO_MODE_AVERAGE,
    })

threshold_direction_dict = frozendict({
    'ABOVE': PS5000A_ABOVE,
    'ABOVE_LOWER': PS5000A_ABOVE_LOWER,
    'BELOW': PS5000A_BELOW,
    'BELOW_LOWER': PS5000A_BELOW_LOWER,
    'RISING': PS5000A_RISING,
    'RISING_LOWER': PS5000A_RISING_LOWER,
    'FALLING': PS5000A_FALLING,
    'FALLING_LOWER': PS5000A_FALLING_LOWER,
    'RISING_OR_FALLING': PS5000A_RISING_OR_FALLING,
    'INSIDE': PS5000A_INSIDE,
    'OUTSIDE': PS5000A_OUTSIDE,
    'ENTER': PS5000A_ENTER,
    'EXIT': PS5000A_EXIT,
    'ENTER_OR_EXIT': PS5000A_ENTER_OR_EXIT,
    'POSITIVE_RUNT': PS5000A_POSITIVE_RUNT,
    'NEGATIVE_RUNT': PS5000A_NEGATIVE_RUNT,
    'NONE': PS5000A_NONE,
    None: PS5000A_NONE,})

threshold_mode_dict = frozendict({
    'LEVEL': PS5000A_LEVEL,
    'WINDOW': PS5000A_WINDOW})

PWQ_type_dict = frozendict({
    'NONE': PS5000A_PW_TYPE_NONE,
    'GREATER_THAN': PS5000A_PW_TYPE_GREATER_THAN,
    'LESS_THAN': PS5000A_PW_TYPE_LESS_THAN,
    'IN_RANGE': PS5000A_PW_TYPE_IN_RANGE,
    'OUT_OF_RANGE': PS5000A_PW_TYPE_OUT_OF_RANGE})

trigger_state_dict = frozendict({
    None: PS5000A_CONDITION_DONT_CARE,
    True: PS5000A_CONDITION_TRUE,
    False: PS5000A_CONDITION_FALSE,})

channel_enumeration = frozendict({
    'A': 0,
    'B': 1,
    'C': 2,
    'D': 3,
    'ext': 4,
    'aux': 5,
    'src': 6,
    'PWQ': 7,})

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

time_units = frozendict({
    PS5000A_FS: 1e-15,
    PS5000A_PS: 1e-12,
    PS5000A_NS: 1e-9,
    PS5000A_US: 1e-6,
    PS5000A_MS: 1e-3,
    PS5000A_S: 1.0})

cdef open_unit(char *serial_str, resolution):
    cdef PICO_STATUS status
    cdef short handle
    cdef PS5000A_DEVICE_RESOLUTION _resolution = resolution_dict[resolution]
	
    with nogil:
        status = ps5000aOpenUnit(&handle, serial_str, _resolution)
    check_status(status)

    serial = get_unit_info(handle, pico_status.PICO_BATCH_AND_SERIAL)

    return handle

cdef close_unit(short handle):
    cdef PICO_STATUS status
    
    with nogil:
        status = ps5000aCloseUnit(handle)

    check_status(status)

cdef get_unit_info(short handle, PICO_INFO info):

    cdef short n = 20
    cdef char* info_str = <char *>PyMem_Malloc(sizeof(char)*(n))
    cdef short required_n

    cdef bytes py_info_str
    
    cdef PICO_STATUS status

    with nogil:
        status = ps5000aGetUnitInfo(handle, info_str, n, &required_n, info)
    check_status(status)
    
    # Make sure we had a big enough string
    if required_n > n:
        PyMem_Free(info_str)
        n = required_n
        info_str = <char *>PyMem_Malloc(sizeof(char)*(n))
        
        with nogil:
            status = ps5000aGetUnitInfo(
                    handle, info_str, n, &required_n, info)
        check_status(status)

    try:
        py_info_str = info_str
    finally:
        PyMem_Free(info_str)

    return py_info_str

cdef get_sample_limits(short handle):

    cdef short min_val
    cdef short max_val
    
    with nogil:
       status = ps5000aMinimumValue(handle, &min_val)
    check_status(status)
    
    with nogil:
       status = ps5000aMaximumValue(handle, &max_val)
    check_status(status)
    
    return (min_val, max_val)

cdef set_channel(short handle, channel, bint enable, 
        voltage_range, channel_type, float analogue_offset):

    cdef PICO_STATUS status
    cdef short _enable = enable
    cdef PS5000A_CHANNEL _channel = channel_dict[channel]
    cdef PS5000A_COUPLING _channel_type = channel_type_dict[channel_type]
    cdef PS5000A_RANGE _voltage_range = voltage_range_dict[voltage_range]

    with nogil:
        status = ps5000aSetChannel(handle, _channel, _enable,
                _channel_type, _voltage_range, analogue_offset)

    check_status(status)

cdef get_timebase(short handle, unsigned long timebase_index, 
        long no_samples, unsigned short segment_index):

    cdef float time_interval
    cdef int max_samples
    cdef PICO_STATUS status

    with nogil:
        status = ps5000aGetTimebase2(handle, timebase_index, no_samples, 
                &time_interval, &max_samples, segment_index)

    check_status(status)

    return (time_interval*1e-9, max_samples)

cdef get_minimum_timebase_index(active_channels, max_sampling_rate):
    '''Compute the smallest timebase that can be used given
    the number of active channels.
    '''
    max_rate = max_sampling_rate[active_channels]
    if max_rate == 'invalid':
        raise RuntimeError('Invalid number of channels enabled for'
                           ' selected device resolution')
    else:
        return int(round(math.log(1e9/max_rate, 2)))    

cdef unsigned long compute_timebase_index(
        float sampling_period, max_sampling_rate, 
        int active_channels, resolution):
    '''Round the sampling period to the nearest valid sampling period and
    return the timebase index to which the sampling period corresponds.
    '''

    cdef unsigned long timebase_index_low 
    cdef unsigned long timebase_index
      
    max_rate = max_sampling_rate[active_channels]
    if max_rate == 'invalid':
        raise RuntimeError('Invalid number of channels enabled for'
                           ' selected device resolution')
    else:
        min_sample_period = 1/max_rate
    
    min_timebase_index = get_minimum_timebase_index(active_channels, max_sampling_rate)

    if sampling_period < min_sample_period:
        return min_timebase_index
    elif sampling_period < 20e-9:
        return int(round(math.log(sampling_period*1e9, 2))) 
    elif resolution in ["DR_8BIT", "DR_14BIT", "DR_15BIT"]:
        if sampling_period > (2**32 - 1)/125e6:
            return 2**32-1
        else:
            return int(round(125e6*sampling_period+3))
    else: #12 or 16 bit resolution
        if sampling_period > (2**32 - 1)/62.5e6:
            return 2**32-1
        else:
            return int(round(62.5e6*sampling_period+2))

cdef run_block(short handle, long no_of_pretrigger_samples, 
        long no_of_posttrigger_samples, unsigned long timebase_index, 
        unsigned short segment_index, unsigned short number_of_captures):

    cdef PICO_STATUS status
    cdef bint blocking = True
    
    cdef int time_indisposed_ms = 0

    cdef int max_samples_per_segment
    with nogil:
        status = ps5000aMemorySegments(handle, number_of_captures, 
                &max_samples_per_segment)

    check_status(status)

    if (max_samples_per_segment < 
            no_of_posttrigger_samples + no_of_pretrigger_samples):
        raise ValueError('The number of captures requested with the given '
                'number of samples is too great to store in the picoscope '
                'memory')

    with nogil:
        status = ps5000aSetNoOfCaptures(handle, number_of_captures)

    check_status(status)

    with nogil:
        status = ps5000aRunBlock(handle, no_of_pretrigger_samples, 
                no_of_posttrigger_samples, timebase_index,
                &time_indisposed_ms, segment_index, NULL, NULL)

    check_status(status)
    cdef short finished = 0

    if blocking:
        # Sleep for the time it was expected to take (of course, this
        # doesn't factor in the trigger time).
        time.sleep(time_indisposed_ms * 1e-3)

        while True:
            with nogil:
                status = ps5000aIsReady(handle, &finished)

            check_status(status)

            if finished:
                break
            
            # Sleep for another few microseconds
            time.sleep(10e-6)

# cdef setup_arrays(short handle, channels, samples):
    
    # cdef PICO_STATUS status
    # cdef PS5000A_CHANNEL _channel
    # cdef short * _buffer
    # cdef long _samples = samples
    # #Needed for 3k case
    # #cdef unsigned short segment_index = 0

    # n_channels = len(channels)

    # full_array = np.zeros((n_channels, samples), dtype='int16')
    
    # data_dict = {}

    # for n, channel in enumerate(channels):

        # channel_array = full_array[n, :]
        # _channel = channel_dict[channel]
        # _buffer = <short *>np.PyArray_DATA(channel_array)

        # with nogil:
            # # differs from 3k:
            # # ps3000aSetDataBuffer(handle, _channel, _buffer, 
            # #        _samples, segment_index, PS3000A_RATIO_MODE_NONE)
            # status = ps4000SetDataBufferWithMode(handle, _channel, _buffer, 
                    # _samples, RATIO_MODE_NONE)

        # check_status(status)

        # data_dict[channel] = channel_array

    # return channel_array


cdef get_data(short handle, channels, samples, unsigned long downsample, 
        PS5000A_RATIO_MODE downsample_mode):
    '''Get the data associated with the given channels, and return a
    tuple containing a dictionary of samples length numpy arrays (as
    the first element) and a dictionary of bools indicating whether
    the scope channel overflowed during the capture.

    Each channel is a view into an N x samples length block of memory,
    where N is the number of channels.

    '''
    cdef PICO_STATUS status
    cdef PS5000A_CHANNEL _channel
    cdef short * _buffer
    cdef long _samples = samples
    
    cdef unsigned short segment_index = 0

    n_channels = len(channels)

    # 3k difference - DECIMATE not available in 4k
    if (downsample_mode == PS5000A_RATIO_MODE_AVERAGE):
        _samples = int(math.ceil(samples/downsample))

    full_array = np.zeros((n_channels, 1, _samples), dtype='int16')
    
    data_dict = {}

    for n, channel in enumerate(channels):

        channel_array = full_array[n, :, :]
        _channel = channel_dict[channel]
        _buffer = <short *>np.PyArray_DATA(channel_array[0, :])

        with nogil:
            status = ps5000aSetDataBuffer(handle, _channel, _buffer, 
                    _samples, segment_index, PS5000A_RATIO_MODE_NONE)

        check_status(status)

        data_dict[channel] = channel_array
        
    
    cdef unsigned long start_index = 0
    cdef short overflow

    # Setup the arrays for the trigger time (it's an array to maintain
    # shape consistency with the bulk data capture).
    cdef PS5000A_TIME_UNITS _trigger_time_units

    _np_int_trigger_times = np.empty((1,), dtype='int64')

    trigger_times = np.empty((1,), dtype='float64')

    cdef long* _int_trigger_times = <long *>np.PyArray_DATA(
            _np_int_trigger_times)

    cdef double* _float_trigger_times = <double *>np.PyArray_DATA(
            trigger_times)

    cdef unsigned int n_samples = _samples

    with nogil:
        status = ps5000aGetValues(handle, start_index, &n_samples, 
                downsample, downsample_mode, segment_index,
                &overflow)

    check_status(status)

    if not n_samples == _samples:
        raise IOError('The expected number of samples were not returned.')

    with nogil:
        status = ps5000aGetTriggerTimeOffset64(handle,
                _int_trigger_times, &_trigger_time_units, segment_index)
        
    check_status(status)

    overflow_dict = {}
    for channel in channels:
        overflow_dict[channel] = bool(
                1 << channel_enumeration[channel] & overflow)

    # Convert the trigger time from int64 picoseconds to 
    # float seconds and write back to the trigger_times array 
    # (pointed to by _float_trigger_times)
    _float_trigger_times[0] = (<float>_int_trigger_times[0] * 
                    time_units[_trigger_time_units])

    return (data_dict, overflow_dict, trigger_times)

cdef get_data_bulk(short handle, channels, samples, unsigned long downsample, 
        PS5000A_RATIO_MODE downsample_mode, unsigned short number_of_captures):
    '''Get the data associated with the given channels, and return a
    tuple containing a dictionary of samples length numpy arrays (as
    the first element), a dictionary of bools indicating whether
    the scope channel overflowed during the capture, and an array
    of times denoting the offset of the trigger from the beginning of
    the capture.

    Each channel is a view into an N x samples length block of memory,
    where N is the number of channels.

    The returned times are a floating point array of seconds 
    (which are derived from 64-bit integers of picoseconds).
    '''
    
    cdef PICO_STATUS status
    cdef PS5000A_CHANNEL _channel
    cdef short * _buffer
    cdef short * _single_capture_buffer
    cdef long _samples = samples
    cdef unsigned short segment_index = 0
    n_channels = len(channels)

    if downsample_mode != PS5000A_RATIO_MODE_NONE:
        raise ValueError('For rapid mode acquisitions, aggregation is '
                'currently unsupported.')

    full_array = np.zeros((n_channels, number_of_captures, _samples), 
            dtype='int16')
    
    data_dict = {}

    cdef int i
    for n, channel in enumerate(channels):

        channel_array = full_array[n, :, :]
        _channel = channel_dict[channel]
        _buffer = <short *>np.PyArray_DATA(channel_array)
        with nogil:
            for i in range(number_of_captures):
                _single_capture_buffer = _buffer + i*_samples
                status = ps5000aSetDataBuffer(handle, _channel, _buffer, 
                    _samples, segment_index, PS5000A_RATIO_MODE_NONE)

        check_status(status)

        data_dict[channel] = channel_array
    
    cdef unsigned long start_index = 0
    cdef short any_overflow = 0

    cdef unsigned int n_samples = _samples

    cdef bint n_samples_fail = False
    
    cdef short* _overflow = <short *>PyMem_Malloc(
            sizeof(short)*(number_of_captures))

    # Set up the arrays for getting the trigger times
    cdef PS5000A_TIME_UNITS* _trigger_time_units = (
            <PS5000A_TIME_UNITS *>PyMem_Malloc(
                sizeof(PS5000A_TIME_UNITS)*number_of_captures))

    _np_int_trigger_times = np.empty((number_of_captures,),
            dtype='int64')

    trigger_times = np.empty((number_of_captures,), dtype='float64')

    cdef long* _int_trigger_times = <long *>np.PyArray_DATA(
            _np_int_trigger_times)

    cdef double* _float_trigger_times = <double *>np.PyArray_DATA(
            trigger_times)

    cdef int this_channel

    try:
        with nogil:
            status = ps5000aGetValuesBulk(handle, &n_samples, 
                    0, number_of_captures-1, downsample, downsample_mode, _overflow)

            if not n_samples == _samples:
                n_samples_fail = True

        check_status(status)

        if n_samples_fail:
            raise IOError('The expected number of samples were not returned.')

        with nogil:
            status = ps5000aGetValuesTriggerTimeOffsetBulk64(handle,
                    _int_trigger_times, _trigger_time_units, 0, 
                    number_of_captures-1)


        check_status(status)

        overflow_dict = {}
        for channel in channels:
            this_channel = channel_enumeration[channel]

            for i in range(number_of_captures):
                any_overflow &= (1 << this_channel) & _overflow[i]

            overflow_dict[channel] = bool(any_overflow)

        # Convert the trigger times from int64 picoseconds to 
        # float seconds and write back to the trigger_times array 
        # (pointed to by _float_trigger_times)
        for i in range(number_of_captures):
            _float_trigger_times[i] = (<float>_int_trigger_times[i] * 
                    time_units[_trigger_time_units[i]])

    finally:
        PyMem_Free(_overflow)
        PyMem_Free(_trigger_time_units)

    return (data_dict, overflow_dict, trigger_times)


cdef stop_scope(short handle):

    with nogil:
        status = ps5000aStop(handle)

    check_status(status)

cdef setup_trigger_conditions(short handle, logic_sop, logic_variables):
    '''Setup the trigger conditions from a sum of products and a list
    of the corresponding logic variables.
    '''
    cdef short n_conditions = len(logic_sop)

    cdef PS5000A_TRIGGER_CONDITIONS *trigger_conditions

    trigger_conditions = <PS5000A_TRIGGER_CONDITIONS *>PyMem_Malloc(
            sizeof(PS5000A_TRIGGER_CONDITIONS) * n_conditions)

    try:
        for n, products in enumerate(logic_sop):

            trigger_state = <PS5000A_TRIGGER_STATE *>&trigger_conditions[n]

            for each_channel in channel_enumeration:

                if each_channel in logic_variables:

                    channel_index = logic_variables.index(each_channel)

                    trigger_state[channel_enumeration[each_channel]] = (
                            trigger_state_dict[products[channel_index]])
                else:
                    trigger_state[channel_enumeration[each_channel]] = (
                            trigger_state_dict[None])

        with nogil:
            status = ps5000aSetTriggerChannelConditions(handle, 
                    trigger_conditions, n_conditions)
    
    finally:
        PyMem_Free(trigger_conditions)

    check_status(status)


cdef setup_trigger_directions(short handle, trigger):

    directions = {}
    for channel in ['A', 'B', 'C', 'D', 'ext', 'aux']:
        if channel in trigger and trigger[channel] is not None:
            directions[channel] = trigger[channel]['trigger_direction']
        else:
            directions[channel] = threshold_direction_dict[None]
    
    cdef PS5000A_THRESHOLD_DIRECTION _directions[6]

    for channel in ('A', 'B', 'C', 'D', 'ext', 'aux'):
        _directions[channel_enumeration[channel]] = directions[channel]

    with nogil:
        status = ps5000aSetTriggerChannelDirections(
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

    cdef PS5000A_TRIGGER_CHANNEL_PROPERTIES *trigger_properties
    trigger_properties = <PS5000A_TRIGGER_CHANNEL_PROPERTIES *>PyMem_Malloc(
            sizeof(PS5000A_TRIGGER_CHANNEL_PROPERTIES) * n_properties)

    try:
        min_val, max_val = get_sample_limits(handle)

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
            status = ps5000aSetTriggerChannelProperties(handle, 
                    trigger_properties, n_properties, 0, autotrigger_timeout_ms)

    finally:
        PyMem_Free(trigger_properties)

    check_status(status)    

cdef setup_pulse_width_qualifier(short handle, trigger, 
        float sampling_period):

    cdef PICO_STATUS status

    #Firstly, get the pulse width qualifier
    pwq = trigger['PWQ']
    logic_variables, pwq_logic = pwq['PWQ_logic']
    cdef short n_conditions = len(pwq_logic)

    cdef PS5000A_THRESHOLD_DIRECTION PWQ_direction = pwq['PWQ_direction']
    cdef unsigned long PWQ_lower = int(
            round(pwq['PWQ_lower']/sampling_period))
    cdef unsigned long PWQ_upper = int(
            round(pwq['PWQ_upper']/sampling_period))

    cdef PS5000A_PULSE_WIDTH_TYPE PWQ_type = pwq['PWQ_type']

    cdef PS5000A_PWQ_CONDITIONS *pwq_conditions
    pwq_conditions = <PS5000A_PWQ_CONDITIONS *>PyMem_Malloc(
            sizeof(PS5000A_PWQ_CONDITIONS) * n_conditions)

    try:
        # Copy in the pwq_conditions array from the pwq_logic structure
        for n, products in enumerate(pwq_logic):

            trigger_state = <PS5000A_TRIGGER_STATE *>&pwq_conditions[n]

            for each_channel in channel_enumeration:

                if each_channel in logic_variables:

                    channel_index = logic_variables.index(each_channel)

                    trigger_state[channel_enumeration[each_channel]] = (
                            trigger_state_dict[products[channel_index]])
                else:
                    trigger_state[channel_enumeration[each_channel]] = (
                            trigger_state_dict[None])

        with nogil:
            status = ps5000aSetPulseWidthQualifier(handle, pwq_conditions, 
                    n_conditions, PWQ_direction, PWQ_lower, PWQ_upper, PWQ_type)

    finally:
        PyMem_Free(pwq_conditions)

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
    cdef char* serial_str = <char *>PyMem_Malloc(sizeof(char)*(n))
    cdef short count

    cdef bytes py_serial_str
    
    with nogil:
        status = ps5000aEnumerateUnits(&count, serial_str, &n)

    if status != pico_status.PICO_OK:
        raise IOError

    try:
        py_serial_str = serial_str
    finally:
        PyMem_Free(serial_str)

    if count == 0:
        unit_list = []
    else:
        unit_list = py_serial_str.split(',')

    return unit_list

cdef class Pico5k:

    cdef short _handle

    cdef object __channels
    cdef object __channel_states
    cdef object __trigger
    cdef object __hardware_variant
    cdef object __max_sampling_rate
    cdef object __serial_string
    cdef object __resolution

    cdef unsigned short __segment_index

    def __cinit__(self, serial=None, channel_configs={}, resolution = "DR_8BIT"):
        
        cdef char* serial_str

        if serial == None:
            serial_str = NULL
        else:
            serial_str = serial

        self._handle = open_unit(serial_str, resolution)

    def __init__(self, serial=None, channel_configs={}, resolution = "DR_8BIT"):

        # Set the default enable state of the channel
        channel_default_state = {'A':True, 'B':False, 'C':False, 'D':False}

        default_trigger = ''
        
        self.__resolution = resolution
        
        self.__hardware_variant = get_unit_info(
                self._handle, pico_status.PICO_VARIANT_INFO)

        self.__max_sampling_rate = (
                capability_dict[self.__hardware_variant]['max_sampling_rate'][resolution])

        self.__serial_string = get_unit_info(
                self._handle, pico_status.PICO_BATCH_AND_SERIAL)

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
            close_unit(self._handle)
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

        set_channel(self._handle, channel, enable, voltage_range, 
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

    def get_valid_sampling_period(self, sampling_period):
        '''Compute the closest valid sampling period to sampling_period 
        given the hardware settings and return a tuple giving the closest
        valid sampling period as a floating point number and the maximum
        number of samples that can be captured at that sampling rate as:
        (closest_sampling_period, max_samples)

        sampling_period is the the number of seconds between each
        sample.
        '''

        # The number of active channels dictates the maximum sampling
        # rate.
        active_channels = 0
        for channel in self.__channel_states:
            if self.__channel_states[channel][1]:
                active_channels += 1

        cdef unsigned long timebase_index = compute_timebase_index(
                sampling_period, self.__max_sampling_rate, active_channels, self.__resolution)

        valid_period, max_samples = get_timebase(self._handle, 
                timebase_index, 0, 0)

        # We should look to see whether we should
        # actually be returning the sampling period above or
        # below the currently calculated one.
        min_timebase_index = get_minimum_timebase_index(active_channels, self.__max_sampling_rate)
        max_timebase_index = 2**32-1

        if (sampling_period > valid_period and 
                timebase_index < max_timebase_index):
            alt_timebase_index = timebase_index + 1

            valid_period_low = valid_period
            max_samples_low = max_samples
            valid_period_high, max_samples_high = get_timebase(
                    self._handle, alt_timebase_index, 0, 0)

        elif timebase_index > min_timebase_index:
            alt_timebase_index = timebase_index - 1

            valid_period_low, max_samples_low = get_timebase(
                    self._handle, alt_timebase_index, 0, 0)

            valid_period_high = valid_period
            max_samples_high = max_samples

        else:
            valid_period_low = valid_period
            valid_period_high = valid_period
            max_samples_low = max_samples
            max_samples_high = max_samples

        mean_valid_period = (valid_period_high + valid_period_low)/2

        if sampling_period < mean_valid_period:
            valid_period = valid_period_low
            max_samples = max_samples_low
        else:
            valid_period = valid_period_high
            max_samples = max_samples_high

        return (valid_period, max_samples)

    def get_scalings(self):
        
        min_val, max_val = get_sample_limits(self._handle)
        scalings = {}
        
        for channel in self.__channel_states:
            if self.__channel_states[channel][1]:
                scalings[channel] = ( 
                        self.__channel_states[channel][0]/max_val)

        return scalings

    def capture_block(self, sampling_period, post_trigger, 
            pre_trigger=0.0, units = "seconds", autotrigger_timeout=None, 
            number_of_frames=1, downsample=1, downsample_mode='NONE', 
            return_scaled_array=True):
        '''Capture a block of data.

        The actual sampling period is adjusted to fit a nearest valid
        sampling period that can be found. To know in advance what will
        be used, call the get_valid_sampling_period method with the same
        sampling_period argument.

        autotrigger_timeout is the number of seconds before the trigger 
        should fire automatically. Setting this to None or 0 means the 
        trigger will never fire automatically.

        downsample_mode dictates the mode that the pico scope uses
        to downsample the captured data and return it to the host machine.
        For every block of length ``downsample'', 'NONE' returns
        all samples with no downsample, 'AVERAGE' returns the average of 
        those samples, and 'DECIMATE' returns the first.

        If return_scaled_array is set to False, the raw data is
        returned without scaling it to the voltage range for each
        channel.
        '''
        
        cdef unsigned long timebase_index

        valid_sampling_period, max_samples = self.get_valid_sampling_period(
                sampling_period)
        if units == "seconds":
            post_trigger_samples = int(
                    round(post_trigger/valid_sampling_period))
            pre_trigger_samples = int(
                    round(pre_trigger/valid_sampling_period))
        elif units == "samples": 
            post_trigger_samples = post_trigger
            pre_trigger_samples = pre_trigger
        else:
            raise ValueError("Units must be in seconds or samples")
        
        n_samples = post_trigger_samples + pre_trigger_samples
        if n_samples > max_samples:
            raise PicoError(pico_status.PICO_TOO_MANY_SAMPLES)

        data_channels = set()
        for channel in self.__channel_states:
            if self.__channel_states[channel][1]:
                data_channels.add(channel)

        active_channels = len(data_channels)

        if active_channels == 0:
            raise RuntimeError('No active channels: No channels have been '
                    'enabled.')
        
        timebase_index = compute_timebase_index(valid_sampling_period, 
                self.__max_sampling_rate, active_channels, self.__resolution)

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

        setup_trigger(self._handle, self.__trigger, self.__channel_states,
                sampling_period, autotrigger_timeout_ms)

        segment_index = 0

        run_block(self._handle, pre_trigger_samples, post_trigger_samples,
                timebase_index, segment_index, number_of_frames)

        cdef unsigned long _downsample = downsample
        cdef PS5000A_RATIO_MODE _downsample_mode = (
                downsampling_modes[downsample_mode])

        if number_of_frames == 1:
            data, overflow, trigger_times = get_data(self._handle, 
                    data_channels, n_samples, _downsample, _downsample_mode)
        else:
            data, overflow, trigger_times = get_data_bulk(self._handle, 
                    data_channels, n_samples, _downsample, _downsample_mode, 
                    number_of_frames)

        stop_scope(self._handle)

        scalings = self.get_scalings()

        if return_scaled_array:
            for channel in data:
                scaled_channel_data = data[channel] * scalings[channel]
                data[channel] = scaled_channel_data

        return (data, overflow)


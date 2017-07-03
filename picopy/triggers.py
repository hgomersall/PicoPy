#!/usr/bin/env python

try:
    from pico3k import default_trigger_properties, default_pwq_properties
except ImportError:
    from pico4k import default_trigger_properties, default_pwq_properties


class EdgeTrigger(object):
    '''Define an edge trigger object (including an advanced edge trigger).
    '''

    _valid_directions = ['RISING', 'FALLING', 'RISING_OR_FALLING']

    def __getitem__(self, key):

        if key == 'logic_function':
            return self._channel

        elif key == self._channel:
            return self._properties

        else:
            raise KeyError('Invalid channel')

    def __init__(self, channel, threshold=0.0, direction='RISING',
            hysteresis=0.0):
        '''Initialise an edge trigger.

        channel is the channel to which the trigger should apply.

        threshold is a floating point value giving the threshold voltage for
        the edge trigger.

        direction is one of 'RISING', 'FALLING' or 'RISING_OR_FALLING'.
        These refer to the signal rising, falling or either.

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

        self._properties = properties


class PulseWidthTrigger(object):

    # Each direction mapping is a tuple giving the directions
    # for (pulse trigger, edge trigger)
    direction_mapping = {
            'POSITIVE_PULSE': ('RISING_LOWER', 'FALLING'),
            'NEGATIVE_PULSE': ('FALLING', 'RISING')}

    _valid_conditions = [
            'GREATER_THAN', 'LESS_THAN', 'IN_RANGE', 'OUT_OF_RANGE']

    def __getitem__(self, key):

        if key == 'PWQ':
            return self._properties

        elif key == 'logic_function':
            return self._channel + ' AND PWQ'

        else:
            return self._edge_trigger[key]

    def __init__(self, channel, threshold, time=0.0, hysteresis=0.0,
            pulse_direction='POSITIVE_PULSE', condition='GREATER_THAN',
            time2=None):
        '''Set up a pulse width trigger.
        '''

        self._edge_trigger = EdgeTrigger(channel, threshold,
                self.direction_mapping[pulse_direction][1], hysteresis)

        self._channel = channel

        properties = dict(default_pwq_properties)

        if condition not in self._valid_conditions:
            raise ValueError('Invalid condition: The condition passed does '
                    'not correspond to any known pulse width trigger.')

        self._edge_trigger._properties['lower_threshold'] = float(threshold)
        self._edge_trigger._properties['lower_hysteresis'] = float(hysteresis)

        properties['PWQ_logic'] = channel
        properties['PWQ_type'] = condition
        properties['PWQ_lower'] = float(time)
        properties['PWQ_direction'] = (
                self.direction_mapping[pulse_direction][0])

        if condition in ('IN_RANGE', 'OUT_OF_RANGE'):
            if threshold is None:
                raise ValueError('No second time given: For IN_RANGE or '
                        'OUT_OF_RANGE, the time2 argument needs to be set.')

            properties['PWQ_upper'] = float(threshold)

        self._properties = properties

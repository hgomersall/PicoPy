#!/usr/bin/env python
#
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

import unittest

import picopy
import picopy.pico_status as status

import copy
import math
import time

pico = picopy.Pico3k()

class Pico3kTest(unittest.TestCase):

    def test_valid_setup(self):

        self.assertTrue(pico.get_hardware_info()['hardware_variant'] in 
            picopy.pico3k.capability_dict)

    def test_reinitialise_fail(self):
        with self.assertRaisesRegexp(status.PicoError, 'PICO_NOT_FOUND'):
            picopy.Pico3k(pico.get_hardware_info()['serial_string'])

    def test_delete_and_reinit(self):
        # sleep for a second to let things settle down
        time.sleep(1)
        global pico
        pico = None
        pico = picopy.Pico3k()

    def test_edge_trigger(self):

        trigger = picopy.EdgeTrigger(channel='A')
        self.assertEqual(trigger['A']['trigger_direction'], 'RISING')
        self.assertEqual(trigger['A']['upper_threshold'], 0.0)
        self.assertEqual(trigger['A']['upper_hysteresis'], 0.0)
        self.assertEqual(trigger['A']['lower_threshold'], 0.0)
        self.assertEqual(trigger['A']['lower_hysteresis'], 0.0)
        self.assertEqual(trigger['A']['threshold_mode'], 'LEVEL')

    def test_edge_trigger_invalid_args(self):

        with self.assertRaisesRegexp(ValueError, 'Invalid direction'):
            trigger = picopy.EdgeTrigger(channel='A', direction='FooBar')

        with self.assertRaises(ValueError):
            trigger = picopy.EdgeTrigger(channel='A', threshold='foo')

        with self.assertRaises(ValueError):
            trigger = picopy.EdgeTrigger(channel='A', hysteresis='foo')


    def test_set_trigger_invalid_channel(self):

        trigger_object = {
                'A': dict(picopy.pico3k.default_trigger_properties),
                'logic_function': 'B',}
        
        with self.assertRaisesRegexp(KeyError, 'Missing channel'):
            pico.set_trigger(trigger_object)

    def test_set_trigger_missing_pwq(self):

        trigger_object = {
                'A': dict(picopy.pico3k.default_trigger_properties),
                'logic_function': 'A and PWQ',}
        
        with self.assertRaisesRegexp(KeyError, 'Missing channel'):
            pico.set_trigger(trigger_object)

    def test_set_trigger_missing_property(self):

        for each_key in picopy.pico3k.default_trigger_properties:
            trigger = dict(picopy.pico3k.default_trigger_properties)

            del trigger[each_key]
            trigger_object = {'A': trigger, 'logic_function': 'A'}
            
            with self.assertRaisesRegexp(KeyError, 'Missing trigger property'):
                pico.set_trigger(trigger_object)

    def test_set_trigger_missing_PWQ_property(self):
        
        trigger = dict(picopy.pico3k.default_trigger_properties)

        for each_key in picopy.pico3k.default_pwq_properties:
            pwq = dict(picopy.pico3k.default_pwq_properties)

            del pwq[each_key]
            
            trigger_object = {'A': trigger, 'PWQ': pwq, 
                    'logic_function': 'A and PWQ'}
            
            with self.assertRaisesRegexp(KeyError, 'Missing pwq property'):
                pico.set_trigger(trigger_object)

    def test_set_trigger_invalid_value(self):

        for each_key in picopy.pico3k.default_trigger_properties:
            trigger = dict(picopy.pico3k.default_trigger_properties)
            
            trigger[each_key] = 'foobarbaz'

            trigger_object = {'A': trigger, 'logic_function': 'A'}

            if each_key in ('threshold_mode', 'trigger_direction'):

                with self.assertRaises(KeyError):
                    pico.set_trigger(trigger_object)

            else:
                
                with self.assertRaises(ValueError):
                    pico.set_trigger(trigger_object)

    def test_set_trigger_invalid_negative_hysteresis(self):

        for each_key in ['upper_hysteresis', 'lower_hysteresis']:
            trigger = dict(picopy.pico3k.default_trigger_properties)
            
            trigger[each_key] = -5.0

            trigger_object = {'A': trigger, 'logic_function': 'A'}

            with self.assertRaisesRegexp(ValueError, 'Negative hysteresis'):
                pico.set_trigger(trigger_object)

    def test_set_pwq_invalid_value(self):
        
        trigger = dict(picopy.pico3k.default_trigger_properties)
        for each_key in picopy.pico3k.default_pwq_properties:
            pwq = dict(picopy.pico3k.default_pwq_properties)
            
            pwq[each_key] = 'foobarbaz'

            trigger_object = {
                    'A': trigger, 'logic_function': 'A or PWQ',
                    'PWQ': pwq}

            if each_key in ('PWQ_type', 'PWQ_direction'):

                with self.assertRaises(KeyError):
                    pico.set_trigger(trigger_object)

            elif each_key == 'PWQ_logic':
                with self.assertRaises(picopy.logic.ParseError):
                    pico.set_trigger(trigger_object)
            else:
                
                with self.assertRaises(ValueError):
                    pico.set_trigger(trigger_object)

    def test_set_pwq_invalid_value(self):
        
        trigger = dict(picopy.pico3k.default_trigger_properties)
        for each_key in ('PWQ_upper', 'PWQ_lower'):
            pwq = dict(picopy.pico3k.default_pwq_properties)
            
            pwq[each_key] = -10

            trigger_object = {
                    'A': trigger, 'logic_function': 'A or PWQ',
                    'PWQ': pwq}

            with self.assertRaisesRegexp(ValueError, 
                    'Negative pulse width times'):
                pico.set_trigger(trigger_object)

    def test_set_trigger_float_coercian(self):

        for each_key in picopy.pico3k.default_trigger_properties:
            trigger = dict(picopy.pico3k.default_trigger_properties)

            if each_key not in ('threshold_mode', 'trigger_direction'):

                trigger[each_key] = '0.0'

                trigger_object = {'A': trigger, 'logic_function': 'A'}
                pico.set_trigger(trigger_object)

    def test_pwq_float_coercian(self):
        
        trigger = dict(picopy.pico3k.default_trigger_properties)
        for each_key in picopy.pico3k.default_pwq_properties:
            pwq = dict(picopy.pico3k.default_pwq_properties)

            if each_key not in ('PWQ_logic', 'PWQ_direction', 'PWQ_type'):

                pwq[each_key] = '0.0'

                trigger_object = {
                        'A': trigger, 'logic_function': 'A or PWQ',
                        'PWQ': pwq}

                pico.set_trigger(trigger_object)

    def test_set_trigger(self):

        trigger_object = picopy.EdgeTrigger(channel='A')
        pico.set_trigger(trigger_object)

    def test_valid_sampling_period(self):

        max_sampling_rate = pico.get_hardware_info()['max_sampling_rate']
        min_sampling_period = 1/max_sampling_rate
        max_sampling_period = (2**32-3)/(max_sampling_rate/8)

        def sampling_period_from_index(index):
            if index < 3:
                return (2**index)/max_sampling_rate
            else:
                return (index - 3)/(max_sampling_rate/8)

        def compute_nearest_sp(sampling_period, active_channels=1):

            if sampling_period > max_sampling_period:
                return max_sampling_period

            elif sampling_period < min_sampling_period:
                return min_sampling_period

            elif sampling_period < 8/max_sampling_rate:
                index = math.log(sampling_period * max_sampling_rate, 2)

            else:
                index = (max_sampling_rate/8)*sampling_period + 2

            min_index = int(math.ceil(math.log(active_channels, 2))) 
            if index < min_index:
                low_index = min_index
                high_index = min_index
            else:
                low_index = int(math.floor(index))
                high_index = int(math.ceil(index))

            low_sampling_period = sampling_period_from_index(low_index)
            high_sampling_period = sampling_period_from_index(high_index)

            mid_sampling_period = (
                    low_sampling_period + high_sampling_period)/2

            if sampling_period < mid_sampling_period:
                return low_sampling_period
            else:
                return high_sampling_period

        test_set = [-100.0, 0, 0.1e-12, 2e-9, 3e-9, 7e-9, 20e-9, 5e-5, 20, 
                1000]

        # We run the test for one and both channels enabled
        for channel in ('A', 'B'):

            pico.configure_channel(channel)

            for each_sp in test_set:

                valid_period, max_samples = pico.get_valid_sampling_period(
                        each_sp)

                test_valid_period = compute_nearest_sp(each_sp)

                self.assertAlmostEqual(valid_period, test_valid_period, 
                        places=3)

    def test_get_valid_sampling_period_invalid_args(self):

        with self.assertRaises(TypeError):
            pico.get_valid_sampling_period('sdfsdfsdf')


    def test_block_capture_with_too_many_samples(self):

        with self.assertRaisesRegexp(status.PicoError, 
                'PICO_TOO_MANY_SAMPLES'):

            pico.capture_block(4e-9, 10e10)

    def test_block_capture_with_invalid_timeout(self):

        with self.assertRaisesRegexp(ValueError, 
                'Invalid timeout'):

            pico.capture_block(4e-9, 10e-8, autotrigger_timeout=-10)
            pico.capture_block(4e-9, 10e-8, autotrigger_timeout=2**32)

    #def test_block_capture_with_timeout(self):
    #
    #    pico.capture_block(4e-9, 1024)


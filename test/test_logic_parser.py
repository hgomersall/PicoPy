#!/usr/bin/env python

import unittest

from picopy import logic
from picopy import qm

class LogicParserTest(unittest.TestCase):

    def common_parser(self, strings, variables, truth_tables):

        for n, string in enumerate(strings):

            if len(truth_tables) > 1:
                truth_table = truth_tables[n]
            else:
                truth_table = truth_tables[0]

            func = logic.parse_boolean_function_string(string, variables)

            for each_row in truth_table:
                inputs = dict(zip(variables, each_row[:-1]))
                self.assertEqual(func(inputs), each_row[-1])

    def test_parser_or(self):
        '''Test parsing an OR function'''
        strings = ['A OR B', 'A oR B', 'A | B', 'A + B']
        variables = ['A', 'B']
        truth_tables = [[
                [False, False, False],
                [False, True, True],
                [True, False, True],
                [True, True, True]]]


        self.common_parser(strings, variables, truth_tables)

    def test_parser_and(self):
        '''Test parsing an AND function'''
        strings = ['A AND B', 'A anD B', 'A & B', 'A.B']
        variables = ['A', 'B']
        truth_tables = [[
                [False, False, False],
                [False, True, False],
                [True, False, False],
                [True, True, True]]]


        self.common_parser(strings, variables, truth_tables)

    def test_parser_not(self):
        '''Test parsing a NOT function'''
        strings = ['NOT A', 'nOt A', '!A', '~A']
        variables = ['A', 'B']
        truth_tables = [[
                [False, False, True],
                [False, True, True],
                [True, False, False],
                [True, True, False]]]


        self.common_parser(strings, variables, truth_tables)

    def test_parser_xor(self):
        '''Test parsing an XOR function'''
        strings = ['A XOR B', 'A xoR B']
        variables = ['A', 'B']
        truth_tables = [[
                [False, False, False],
                [False, True, True],
                [True, False, True],
                [True, True, False]]]

        self.common_parser(strings, variables, truth_tables)

    def test_parser_precedence(self):
        '''Test predence is correct'''
        strings = ['A AND B OR C', 'A XOR B OR C', 'NOT A OR B AND NOT C']
        variables = ['A', 'B', 'C']
        truth_tables = [[
                [False, False, False, False],
                [False, False, True, True],
                [False, True, False, False],
                [False, True, True, True],
                [True, False, False, False],
                [True, False, True, True],
                [True, True, False, True],
                [True, True, True, True]],
                [
                [False, False, False, False],
                [False, False, True, True],
                [False, True, False, True],
                [False, True, True, True],
                [True, False, False, True],
                [True, False, True, False],
                [True, True, False, False],
                [True, True, True, False]],
                [
                [False, False, False, True],
                [False, False, True, True],
                [False, True, False, True],
                [False, True, True, True],
                [True, False, False, False],
                [True, False, True, False],
                [True, True, False, True],
                [True, True, True, False]]]


        self.common_parser(strings, variables, truth_tables)

    def test_brackets(self):
        '''Test predence is correct with brackets'''
        strings = ['A AND (B OR C)', '(A XOR B) OR C', 
                'NOT (A OR B) AND NOT C']
        variables = ['A', 'B', 'C']
        truth_tables = [[
                [False, False, False, False],
                [False, False, True, False],
                [False, True, False, False],
                [False, True, True, False],
                [True, False, False, False],
                [True, False, True, True],
                [True, True, False, True],
                [True, True, True, True]],
                [
                [False, False, False, False],
                [False, False, True, True],
                [False, True, False, True],
                [False, True, True, True],
                [True, False, False, True],
                [True, False, True, True],
                [True, True, False, False],
                [True, True, True, True]],
                [
                [False, False, False, True],
                [False, False, True, False],
                [False, True, False, False],
                [False, True, True, False],
                [True, False, False, False],
                [True, False, True, False],
                [True, True, False, False],
                [True, True, True, False]]]


        self.common_parser(strings, variables, truth_tables)

    def test_garbage_string(self):
        '''Test nonsensical strings raise an exception'''

        variables = ['A', 'B']
        strings = ['gdfvd', 'C OR A', 'NOT A AND dsfdsfdsf',
                'A OR', 'NOT']

        for string in strings:
            self.assertRaises(logic.ParseError, 
                    logic.parse_boolean_function_string, *(string, variables))

    def test_get_minterms_from_string(self):
        '''Test getting the minterms from a string'''

        strings = ['A AND (B OR C)', '(A XOR B) OR C', 
                'NOT (A OR B) AND NOT C', '']

        minterms_list = [[5, 6, 7], [1, 2, 3, 4, 5, 7], [0], []]

        variables = ['C', 'B', 'A']

        for string, minterms in zip(strings, minterms_list):

            self.assertEqual(logic.get_minterms_from_string(
                string, variables), minterms)

    def test_get_canonical_minimal_sop_from_string(self):

        strings = ['A AND (B OR C)', '(A XOR B) OR C', 
                'NOT (A OR B) AND NOT C']

        minterms_list = [[5, 6, 7], [1, 2, 3, 4, 5, 7], [0]]

        variables = ['C', 'B', 'A']

        for string, minterms in zip(strings, minterms_list):

            sop = logic.get_canonical_minimal_sop_from_string(
                    string, variables)

            _qm = qm.QM(variables)

            self.assertEqual(
                    logic.get_minterms_from_string(_qm.get_function(sop), 
                        variables), 
                    minterms)

    def test_get_minimal_sop_from_string(self):

        strings = ['A AND (B OR C)', '(A XOR B) OR C', 
                'NOT (A OR B)', 'A', '']

        sop_list = [
                [[True, True, None], [True, None, True]],
                [[None, None, True], [False, True, None], 
                    [True, False, None]],
                [[False, False, None]],
                [[True, None, None]],
                [[None, None, None]]]

        variables = ['A', 'B', 'C']




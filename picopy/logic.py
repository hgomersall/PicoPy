#!/usr/bin/env python
#
# Copyright 2012 Knowledge Economy Developments Ltd
#
# Henry Gomersall
# heng@kedevelopments.co.uk
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met: 
# 
# 1. Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer. 
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution. 
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#

import pyparsing
from . import qm
import sys

ParseError = pyparsing.ParseException

class BoolOperand(object):
    def __init__(self,t):
        self.args = t[0][0::2]

    def __unicode__(self):
        sep = u' %s ' % self.symbol
        return u'(' + sep.join([unicode(arg) for arg in self.args]) + u')'

    def __str__(self):
        return unicode(self).encode(
                sys.stdout.encoding or DEFAULT_ENCODING, 'replace')


class BoolAnd(BoolOperand):
    symbol = u'.'

    def __call__(self, bool_dict):

        return_bool = True
        
        for each_arg in self.args:

            if each_arg not in bool_dict:
                # We assume this must be an BoolOperand
                arg_bool = each_arg(bool_dict)
            else:
                arg_bool = bool(bool_dict[each_arg])

            if not arg_bool:
                # The AND of the args must be False
                return_bool = False
                break

        return return_bool


class BoolOr(BoolOperand):
    symbol = u'+'

    def __call__(self, bool_dict):

        return_bool = False
        
        for each_arg in self.args:

            if each_arg not in bool_dict:
                # We assume this must be an BoolOperand
                arg_bool = each_arg(bool_dict)
            else:
                arg_bool = bool(bool_dict[each_arg])

            if arg_bool:
                # The OR of the args must be True
                return_bool = True
                break

        return return_bool


class BoolXOr(BoolOperand):
    symbol = u'\u2295'

    def __call__(self, bool_dict):

        return_bool = False
        
        for each_arg in self.args:

            if each_arg not in bool_dict:
                # We assume this must be an BoolOperand
                arg_bool = each_arg(bool_dict)
            else:
                arg_bool = bool(bool_dict[each_arg])

            if arg_bool and not return_bool:
                # The exclusive case
                return_bool = True
            elif arg_bool and return_bool:
                # More than one input is True
                return_bool = False
                break

        return return_bool
    

class BoolNot(BoolOperand):
    def __init__(self,t):
        self.arg = t[0][1]

    def __call__(self, bool_dict):

        if self.arg not in bool_dict:
            # We assume this must be an BoolOperand
            arg_bool = self.arg(bool_dict)
        else:
            arg_bool = bool(bool_dict[self.arg])

        return not arg_bool

    def __unicode__(self):
        return u'~' + str(self.arg)        


def parse_boolean_function_string(boolean_string, boolean_variables):
    '''Parses the string using the passed iterable of boolean variables 
    and constructs a callable that implements the boolean function that 
    the string describes.

    The four logical operands that are allowed, in order of precedence, 
    are:
    NOT: 'NOT', '~', '!'
    AND: 'AND', '.', '&'
    OR: 'OR', '+', '|'
    XOR: 'XOR'

    The word form of each of the above is not case dependent.

    Parantheses can be used to explicitly denote precedence.

    The callable takes a dictionary of variables to their logical values
    and returns the result of applying the boolean function to those
    variables.

    >>> func = parse_boolean_function_string('A XOR B', ['A', 'B'])
    >>> func({'A':True, 'B':False})
    True
    >>> func({'A':True, 'B':True})
    False

    >>> func = parse_boolean_function_string('not (A and B)', ['A', 'B'])
    >>> func({'A':False, 'B':False})
    True
    >>> func({'A':True, 'B':True})
    False
    >>> func({'A':False, 'B':True})
    True

    >>> func = parse_boolean_function_string('A.B+~B', ['A', 'B'])
    >>> print(func)
    ((A . B) + ~B)
    >>> func({'A':True, 'B':False})
    True
    >>> func({'A':False, 'B':False})
    True
    >>> func({'A':False, 'B':True})
    False
    '''

    not_symbol = pyparsing.Or(
            [pyparsing.CaselessLiteral(sym) for sym in ('NOT', '~', '!')])
    and_symbol = pyparsing.Or(
            [pyparsing.CaselessLiteral(sym) for sym in ('AND', '.', '&')])
    or_symbol = pyparsing.Or(
            [pyparsing.CaselessLiteral(sym) for sym in ('OR', '+', '|')])
    xor_symbol = pyparsing.Or(
            [pyparsing.CaselessLiteral(sym) for sym in ('XOR',)])

    precedence_list = [
            (not_symbol, 1, pyparsing.opAssoc.RIGHT, BoolNot),
            (and_symbol, 2, pyparsing.opAssoc.LEFT, BoolAnd),
            (or_symbol, 2, pyparsing.opAssoc.LEFT, BoolOr),
            (xor_symbol, 2, pyparsing.opAssoc.LEFT, BoolXOr),]

    bool_tokens = pyparsing.Or(
            [pyparsing.Keyword(var) for var in boolean_variables])

    bool_parser = pyparsing.operatorPrecedence(
            bool_tokens, precedence_list)

    func = bool_parser.parseString(boolean_string, parseAll=True)[0]

    if type(func) is str:
        var_str = func
        func = lambda bool_var_dict: bool_var_dict[var_str]

    return func

def get_minterms_from_string(boolean_string, boolean_variables):

    if boolean_string == '':
        return []

    bool_func = parse_boolean_function_string(boolean_string, 
            boolean_variables)

    bool_var_dict = dict.fromkeys(boolean_variables, False)

    def get_minterms(min_term_list, depth=0, offset=0):
        depth_contribution = 2**depth

        for val in [False, True]:

            if val:
                offset += depth_contribution

            bool_var_dict[boolean_variables[depth]] = val
            if depth+1 == len(boolean_variables):

                if bool_func(bool_var_dict):
                    min_term_list.append(offset)

            else:
                get_minterms(min_term_list, depth+1, offset)

    min_term_list = []
    get_minterms(min_term_list)

    min_term_list.sort()

    return min_term_list

def get_canonical_minimal_sop_from_string(
        boolean_string, boolean_variables):
    '''Returns the full minimal canonical form for all the variables
    passed, given the string, or simply '0' if the string always evaluates
    to False.
    
    >>> get_canonical_minimal_sop_from_string('A AND (B OR C)', ['A', 'B', 'C'])
    [(3, 4), (5, 2)]
    '''

    min_terms = get_minterms_from_string(boolean_string, boolean_variables)

    _qm = qm.QM(boolean_variables)

    minimal_sop = _qm.solve(min_terms, [])

    return minimal_sop[1]

def get_minimal_sop_from_string(boolean_string, boolean_variables):
    '''Get the minimal sum of products as a list of lists which 
    correspond to products and sums respectively.

    Each entry in the inner list corresponds to a boolean variable
    given in the boolean_variables argument, and in the same order.
    
    The value of each entry in the inner list is either True, False
    or None, according to whether that variable should be True, 
    False or "Don't care" in generating a True output.

    An empty string will return all "Don't care".

    >>> get_minimal_sop_from_string('A AND B', ['A', 'B', 'C'])
    [[True, True, None]]
    >>> get_minimal_sop_from_string('A OR C', ['A', 'B', 'C'])
    [[True, None, None], [None, None, True]]
    >>> get_minimal_sop_from_string('', ['A', 'B', 'C'])
    [[None, None, None]]
    '''

    canonical_sop = get_canonical_minimal_sop_from_string(
            boolean_string, boolean_variables)

    minimal_sop = []

    if canonical_sop == '0':
        canonical_sop = [(0, -1)]

    for each_term in canonical_sop:
        and_terms = []
        
        for j in range(len(boolean_variables)):
            if each_term[0] & 1<<j:
                and_terms.append(True)
            
            elif not each_term[1] & 1<<j:
                and_terms.append(False)
            
            else:
                and_terms.append(None)

        minimal_sop.append(and_terms)

    return minimal_sop

if __name__ == "__main__":
    import doctest
    doctest.testmod()


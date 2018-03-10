#!/bin/env python2

import argparse
parser = argparse.ArgumentParser(description='Tracks time')
parser.add_argument('-c', '--csv', default='time.csv', type=argparse.FileType('a+'), help='datafile')
pgroup = parser.add_mutually_exclusive_group(required=True)
pgroup.add_argument('-w', '--work', action=', const='work', help='track work towards a goal')
pgroup.add_argument('-r', '--report', help='report on time usage')
pgroup.add_argument('-s', '--suggest', help='recommend goal to work toward')
args = parser.parse_args()




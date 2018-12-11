#!/usr/bin/python

def outtime(mins):
	hrs = mins / 60
	mins = mins % 60
	print str(hrs) + "h " + str(mins) + "m"

for a in xrange(6):
	outtime(19*60+0 + (a-4) * 136)

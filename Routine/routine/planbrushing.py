#!/usr/bin/python

def outtime(mins):
	hrs = mins / 60
	mins = mins % 60
	print str(hrs) + "h " + str(mins) + "m"

for a in xrange(6):
	outtime(7*60+10 + (a) * 138)

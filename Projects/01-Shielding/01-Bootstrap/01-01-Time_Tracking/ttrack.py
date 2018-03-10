#!/bin/env python2

import argparse, time, sys, tty

parser = argparse.ArgumentParser(description='Tracks time')
parser.add_argument('-c', '--csv', default='time.csv', type=argparse.FileType('a+'), help='datafile')
pgroup = parser.add_mutually_exclusive_group(required=True)
pgroup.add_argument('-w', '--work', metavar=('GOAL', 'TASK'), nargs='+', help='track work towards a goal')
pgroup.add_argument('-r', '--report', action='store_true', help='report on time usage')
pgroup.add_argument('-s', '--suggest', action='store_true', help='recommend goal to work toward')

TIME_COL = 'time'
EVENT_COL = 'event'
GOAL_COL = 'goal'
TASK_COL = 'task'
EVENT_START = 'start'
EVENT_HEARTBEAT = 'heartbeat'
EVENT_STOP = 'stop'

class Format1:
    FORMAT1 = [TIME_COL, EVENT_COL, GOAL_COL, TASK_COL]
    def __init__(self, file):
        self.file = file
    def read_all(self):
        self.file.seek(0)
        ret = []
        for line in self.file.readlines():
            row = line.split(',')
            fullrow = dict()
            for i in range(row.len()):
                fullrow[Format1.FORMAT1[i]] = row[i]
            ret.append(fullrow)
        return ret
    def output(self, cols):
        # TODO: seek to end
        self.file.seek(0, 2)
        self.file.write(','.join([cols[x] for x in Format1.FORMAT1]))
        self.file.write('\n')
        self.file.flush()

args = parser.parse_args()
fmt = Format1(args.csv)
print(fmt.read_all())

if args.work:
    fd = sys.stdin.fileno()
    old = tty.tcgetattr(fd)
    tty.setcbreak(fd)
    getchar = lambda: sys.stdin.read(1)
    try:
        goal = args.work.pop(0)
        goal = goal.upper()
        tasks = ' '.join(args.work)
        ts = time.time()
        print('Beginning work on %s towards %s at %s' % (tasks, goal, time.ctime(ts)))
        fmt.output({TIME_COL: ts, EVENT_COL: EVENT_START, GOAL_COL: goal, TASK_COL: tasks})
        print('Press spacebar to indicate you are still working.')
        print('Press enter to indicate you have stopped.')
        #key = 
        while True:
            key = getchar()
            if key == '\n':
                break
            if key != ' ':
                print('!! Unrecognized keypress.  Press enter to stop, space to continue.')
            ts = time.time()
            print('Still working on %s towards %s at %s' % (tasks, goal, time.ctime(ts)))
            fmt.output({TIME_COL: ts, EVENT_COL: EVENT_HEARTBEAT, GOAL_COL: goal, TASK_COL: tasks})
        print('Stopped working on %s towards %s at %s' % (tasks, goal, time.ctime(ts)))
        fmt.output({TIME_COL: ts, EVENT_COL: EVENT_STOP, GOAL_COL: goal, TASK_COL: tasks})
    finally:
        tty.tcsetattr(fd, tty.TCSAFLUSH, old)

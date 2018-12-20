/* .C file for routine stuff
 *
 * NOW Thu Morn: SCRIPT GOAL judge history.  reorder routine. THEN run routine!  YES c++ root
 *
 */

// NOTE FOR STRATEGY: reorder after brushing event such that goals are met.  reorder prior to & during brushing event such that behavior is learned.

// focus. work this script. memory loss.
// keep focus. handle environ. because keep work.
// yes yes =) work script c++, root, shell script! YES YES
//
// refill nic LATER due to this task importance.
// maybe when spit? remember: schedule, refill nicotine to keep nic strength high

// arguments? => methods on Routine, or global shortcuts
// -> script has main function calls script macro function
// type commands! function calls!
// make global object? maybe!
// at end, for crash. (something is wrong with making global object, so put it at the end in case causes problem.  solve later, much later)

// consolide notes

// RESIST distraction when swishing

// CSV: all in routinedata.csv, one big file
// Code, Routine, Start Time, Stop Time, Description
// separator = ", " and it tails the line
//
// process csv using c++? or system(3)?
//  c++ -> need to look up how to split on token
//  could use string loop
//  ok
//  c++ ->  need to look up how to read line
//  use root to infer
//  routinedata.csv
//  
//
// system(3)
// int system(const char *command)
// really uses execl("/bin/sh", "sh", "-c", command, (char *) 0)
// buts wraps using a synchronous fork()
// RETURNS: exist status, also nonzero for error

#include <string>
#include <ifstream>

class RoutineHistoryEntry
{
public:
  RoutineHistoryEntry(std::string code, std::string routine, time_t startTime, time_t stopTime, std::string description)
  : code(code),
    routine(routine),
    startTime(startTime),
    stopTime(stopTime),
    description(description)
  {}

  static fromCSVLine(char * csvLine, size_t len)
  {
    char * chunkStart = csvLine;
    char * chunkEnd = csvLine;
    // not using strtok because it is confusing to see later

    // code
    while (*chunkEnd != ',') { ++ chunkEnd; }
    *chunkEnd = 0;
    const char * code = chunkStart;

    chunkStart = ++chunkEnd;

    // routine
    while (*chunkEnd != ',') { ++ chunkEnd; }
    const char * routine = chunkStart;

    chunkStart = ++chunkEnd;

    // startTime
    struct tm _tm;
    chunkEnd = strptime(chunkStart, "%FT%T%z", &_tm);
    time_t startTime = mktime(&_tm);
    
    if (*chunkEnd != ',') throw std::runtime_error("unexpected data after startTime");
    while (*++chunkEnd == ' ');
    chunkStart = chunkEnd;

    chunkEnd = strptime(chunkStart, "%FT%T%z", &_tm);
    time_t stopTime = mktime(&_tm);

    if (*chunkEnd != ',') throw std::runtime_error("unexpected data after stopTime");
    while (*++chunkEnd == ' ');
    chunkStart = chunkEnd;

    while (*chunkEnd != ',') { ++ chunkEnd; }
    const char * description = chunkStart;

    return {code, routine, startTime, stopTime, description};
  }

  template <typename Processor>
  static void processCSV(Processor processor, std::string filename = "routinedata.csv")
  {
    std::ifstream file(filename);
    char linebuf[1024];
    // read header line and discard
    file.getline(linebuf, sizeof(linebuf));
    // read entries
    while (true)
    {
      file.getline(linebuf, sizeof(linebuf));
      if (file.eof()) break;
      processor(RoutineHistoryEntry.fromCSVLine(linebuf, sizeof(linebuf)));
    }
  }

  std::string code;
  std::string routine;
  // time_t is UTC
  time_t startTime;
  time_t stopTime;
  std::string description;
};

// what to do here ???? back to goal.
// goal. focus. strong.
// info in routin class and up top. merge
// notes not moved!!!
// notes: 3 places
RoutineCSVHistoryProcessor
{
public:
void 
};

class Routine
{
public:
  // process history using csv files.
  // produce ordering of brushing.routine using metrics
  //  NEW METRIC: success of having task.  if task is success, put other one for learning.
  //  separate out how to order and judge
  //  do in SMALL SIMPLE classes! need result!

  Routine()
  {
    {
    }
  }

};

Routine gR;

void routine2()
{
  // macro function
}

#if 0
int main(int argc, const char **argv)
{
  // haha this will never work soon
  return 0
}
#endif

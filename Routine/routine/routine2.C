/* .C file for routine stuff
 *
 * NOW Thu Morn: SCRIPT GOAL judge history.  reorder routine. THEN run routine!  YES c++ root
 *
 */

// SMALL CLASSES: JUST 1 FUNC, with members
//    BECAUSE get stuck big classes
//    and BECAUSE need generality for reuse

// Global Democracy tool concept could be used for handling Karl's life.
//  The idea is that proposals exist, and they are backed by REASONS.  Each REASON has another REASON that supports why it is valid.
//      People can discuss points in this way to discern what proposals to choose.

// PROPOSAL: pause work on this task to instead experiment with democracy tool concept
//    REASON: ?
//    REASON: it reveals when ideas are good or not.
//        REASON SUPPORTS: karl values good ideas, and when a proposal did not fill in any reason, it revealed that it could be a poor choice, despite being loud
//              REASON THIS SUPPORTS: good ideas have good reasons. proposals with no reasons are more likely bad ideas.
// note: spent all time typing reasons, did not do much work other than cleaning comments


// Next:
// 1. Finish this script to reorder toothbrush tasks
//      BECAUSE need to use nicotine-learning time most effectively
//              BEACUSE given current situation, mind suggests.  could inspect BECAUSE more, see next item
//              BECAUSE was next step planned for judging nicotine tasks & approach VERY supportive of other nicotine judgement tasks
//                      support BECAUSE:
//                          is in ROOT which provides for charts, data storage, and scientific library
//                                -> note: ROOT does not provide data decentralization. unfortunate.  solution could be ipfs and separate branch files, would take some effort
//                          uses components that can be replugged and swapped
//                          uses a language that is more flexible & powerful than old language
//                          is compatible with old language, which has existing work
//                          can read data produced by old work
//  -> use system(3) to callout to shell for migration to c++
//        BECAUSE migration to c++ without lots of work
//  -> use strategies that can be changed:
//        BECAUSE reuse & may not be the most-needed algorithmic addition
//  -> assess whether or not routine has become normal
//      how good am I at this task compared to others?
//          BEACUSE not sure.  mind suggests.
//  -> reorder routines to manage development
//      BECAUSE current list does not reflect current needs, and order is half the battle
// 2. Refine toothbrushing routine lists
// 3. Fix rating usage in routine script

// Root Macro.  Commands will be run by typing either object methods or global shortcuts.
// global object at end to handle crashing

// Can use root cli to check commands without switching windows.

// consolide notes

// system(3)
// int system(const char *command)
// RETURNS: exist status, also nonzero for error

#include <fstream>
#include <iostream>
#include <map>
#include <string>
#include <vector>

template <typename ...chars>
std::string delimAdvance(char const * & pos, chars const & ...delims)
{
  char dlms[] = {0,(char)delims...};
  char const * start = pos;
  bool contDefault = true;
  for (auto check : dlms)
  {
    if (check < 0) contDefault = false;
  }
  bool cont;
  do
  {
    cont = contDefault;
    for (auto check : dlms)
    {
      if (check >= 0)
      {
        if (*pos == check) goto done;
      }
      else // check < 0, break if not present
      {
        if (*pos == check) cont = true;
      }
    }
    ++ pos;
  } while (cont);

done:
  return {start,pos};
}

class RoutineHistoryEntry
{
public:
  RoutineHistoryEntry() {}
  RoutineHistoryEntry(std::string code, std::string routine, time_t startTime, time_t stopTime, std::string description)
  : code(code),
    routine(routine),
    startTime(startTime),
    stopTime(stopTime),
    description(description)
  {}

  static RoutineHistoryEntry fromCSVLine(std::string line)
  {
    const char * csvLine = line.c_str();
    const char * chunkStart = csvLine;
    const char * chunkEnd = csvLine;
    // not using strtok because it is confusing to see later

    // code
    while (*chunkEnd != ',') { ++ chunkEnd; }
    std::string code{chunkStart, chunkEnd};

    chunkStart = ++chunkEnd;

    // routine
    while (*chunkEnd != ',') { ++ chunkEnd; }
    std::string routine{chunkStart, chunkEnd};

    chunkStart = ++chunkEnd;

    // startTime
    struct tm _tm;
    chunkEnd = strptime(chunkStart, "%FT%T%z", &_tm);
    time_t startTime = mktime(&_tm);
    
    if (*chunkEnd != ',') throw std::runtime_error("unexpected data after startTime");
    while (*++chunkEnd == ' ');
    chunkStart = chunkEnd;

    // stopTime
    chunkEnd = strptime(chunkStart, "%FT%T%z", &_tm);
    time_t stopTime = mktime(&_tm);

    if (*chunkEnd != ',') throw std::runtime_error("unexpected data after stopTime");
    while (*++chunkEnd == ' ');
    chunkStart = chunkEnd;

    // description
    while (*chunkEnd != ',') { ++ chunkEnd; }
    std::string description{chunkStart, chunkEnd};

    // obj
    return {code, routine, startTime, stopTime, description};
  }

  std::string code;
  std::string routine;
  // time_t is UTC
  time_t startTime;
  time_t stopTime;
  std::string description;
};

// blargh i didn't generalize it enough
// the iterator returned by begin()/end() is not consistent
// to change, do a thing ...
//  -> want consistent begin()/end()
//  -> iterator interface not the best for derived class
//  -> would like virtual-func-based inheritance
//  -> need provide virtual func for base class provide iteration
//  base class just needs next func really
//  

class RoutineHistorySource
{
public:
  virtual void rewind() = 0;
  virtual RoutineHistoryEntry next() = 0;

  RoutineHistorySource & begin()
  {
    ended = false;
    rewind();
    val = next();
    return *this;
  }

  RoutineHistorySource & end()
  {
    // TODO: make iterator subclass
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
#pragma clang diagnostic ignored "-Wnull-dereference"
    return *static_cast<RoutineHistorySource *>(0);
#pragma clang diagnostic pop
  }

  bool operator==(RoutineHistorySource &other)
  {
    return (&other == &end() && ended) || (&other == this);
  }

  void operator++()
  {
    try
    {
      val = next();
    }
    catch (std::range_error const & e)
    {
      ended = true;
    }
  }

  RoutineHistoryEntry const & operator*() const
  {
    return val;
  }

  virtual ~RoutineHistorySource() = default;
private:
  bool ended;
  RoutineHistoryEntry val;
};

class RoutineHistoryCSVSource : public RoutineHistorySource
{
public:
  RoutineHistoryCSVSource(std::string fname = "routinedata.csv")
  : file(fname)
  {
    rewind();
  }

  virtual void rewind()
  {
    char linebuf[1024];
    file.seekg(0);
    // read header line and discard
    file.getline(linebuf, sizeof(linebuf));
  }

  virtual RoutineHistoryEntry next()
  {
    char linebuf[1024];
    file.getline(linebuf, sizeof(linebuf));
    std::cerr << linebuf << std::endl;
    if (file.eof()) throw std::range_error("EOF");
    return RoutineHistoryEntry::fromCSVLine({linebuf});
  }

private:
  std::ifstream file;
};

class RoutineEntry
{
public:
  enum GoalType {
    COUNT_PERCENT,
    COUNT_PERTIME,
    TIME_PERTIME,
  };

  RoutineEntry(std::string code, std::string description, double value = 0.0, std::string reason = "", double goal = 100.0, GoalType goalType = COUNT_PERCENT)
  : code(code),
    description(description),
    value(value),
    reason(reason),
    goal(goal),
    goalType(goalType)
  {}

  static RoutineEntry fromCSVStream(std::istream & csv)
  {
    // code
    std::string code;
    csv >> code;

    if (csv.eof())
    {
      throw std::range_error("EOF");
    }

    // description
    char line[1024];
    csv.getline(line, sizeof(line));
    char const * chunk = line;
    delimAdvance(chunk, -' ', -'\t');
    std::string description = delimAdvance(chunk, '{');
  
    double value = 0;
    std::string reason;
    double goal = 100;
    GoalType goalType = COUNT_PERCENT;
    std::multimap<std::string,std::string> keyvals;
    if (*chunk == '{')
    {
      ++ chunk;
      while (*chunk != '}' && *chunk)
      {
        std::string key = delimAdvance(chunk, ':', '}');
        delimAdvance(++chunk, -' ');
        std::string value = delimAdvance(chunk, ';', '}');
        delimAdvance(++chunk,  -' ');

        keyvals.insert({key, value});
      }
      auto goalit = keyvals.find("GOAL");
      if (goalit != keyvals.end())
      {
        // goal
        // continue
        // continue
        // current: iterator
        // iterator
        // iterator re: goal
        // goal iterator -> string
        std::string goalStr = goalit->second;
        // string -> goal type & amount
        // 3 kinds:
        // %, #/time, time/time
        // time fmt = [number]timechar
        // timechar: smhdwy
        // check for pct, slash, or error
        if (goalStr.back() == '%')
        {
          // percent
          goal = std::stod(goalStr) / 100.0;
          goalType = COUNT_PERCENT;
        }
        else
        {
          char const * chunk = goalStr.c_str();
          std::string numerator = delimAdvance(chunk, '/');
          std::string denominator = ++chunk;
          if (denominator.size() == 0)
          {
            throw std::runtime_error("no denominator in routine entry");
          }
          static std::map<char,double> timechars{
            {'s',1},
            {'m',60},
            {'h',60*60},
            {'d',60*60*24},
            {'w',60*60*24*7},
            {'y',60*60*24*365.25}
          };
          if (!timechars.count(denominator.back()))
          {
            throw std::runtime_error("denominator has no time unit");
          }
          double denom_secs = timechars[denominator.back()] * (denominator.size() > 1 ? std::stod(denominator) : 1);
          if (timechars.count(numerator.back()))
          {
            goalType = TIME_PERTIME;
            double numer_secs = timechars[numerator.back()] * (numerator.size() > 1 ? std::stod(numerator) : 1);
            goal = numer_secs / denom_secs;
          }
          else
          {
            goalType = COUNT_PERTIME;
            goal = std::stod(numerator) / denom_secs;
          }
        }
        keyvals.erase(goalit);
      }
      auto it = keyvals.find("VALUE");
      if (it != keyvals.end())
      {
        std::size_t ct;
        value = std::stod(it->second, &ct);
        if (ct != it->second.size()) throw std::runtime_error("trailing stuff after value " + it->second);
        keyvals.erase(it);
      }
      it = keyvals.find("REASON");
      if (it != keyvals.end())
      {
        reason = it->second;
        keyvals.erase(it);
      }
      if (keyvals.size())
      {
        throw std::runtime_error("unexpected key/value: " + keyvals.begin()->first + ": " + keyvals.begin()->second);
      }
    }
    
    // obj
    return {code, description, value, reason, goal, goalType};
  }

  template <typename Processor>
  static void processCSV(Processor processor, std::string filename)
  {
    std::ifstream file(filename);

    try
    {
      while (true)
      {
        processor(fromCSVStream(file));
      }
    }
    catch (std::range_error e)
    { }
  }

  std::string code;
  std::string description;

  double value;
  std::string reason;
  double goal;
  GoalType goalType;
};

class RoutineList
{
public:
  // ordered list of routines
  // each has a code and a description
  RoutineList() {}

  static RoutineList fromCSV(std::string filename)
  {
    RoutineList ret;

    RoutineEntry::processCSV([&ret](RoutineEntry const & entry){ ret.entries.push_back(entry); }, filename);

    return ret;
  }

  std::vector<RoutineEntry> entries;
};

RoutineHistoryCSVSource defaultRoutineHistory{};

class Routine
{
public:
  // process history using csv files.
  // produce ordering of brushing.routine using metrics
  //  NEW METRIC: success of having task.  if task is success, put other one for learning.
  //  separate out how to order and judge
  //  do in SMALL SIMPLE classes! need result!
  //
  // 1. infer how well the task has been acquired as a new metric
  // 2. combine importance with how well acquired to produc next task
  //      perhaps mutate importance to a minimum degree of acquiring the task
  // "development" and "target development"
  // how about a target of times done per time unit
  //
  // 1: mark tasks with goal frequency / time unit
  // 2: rate performance to reach goal task development
  // 3: judge importance based on goal and performance, modular
  // 4: order tasks based on importance and modular strategy
  // 5: modify reward to occur immediately after primary task
  // 6: make dispenser solid before switching off of toothbrushing as route of administration

  Routine(RoutineList list, RoutineHistorySource & history = defaultRoutineHistory)
  : list(list), history(history)
  { }

  Routine(std::string routinefile, RoutineHistorySource & history = defaultRoutineHistory)
  : list(RoutineList::fromCSV(routinefile)), history(history)
  { }

  RoutineList list;
  RoutineHistorySource & history;
};

Routine brushing("brushing.routine");

void routine2()
{
  // macro function
}

int main(int argc, const char **argv)
{
  routine2();
  return 0;
}

class TrackUI
{
public:
};

class TrackLog
{
public:
};

class TrackState
{
public:
	std::string name();
};

class TrackCore
{
public:
	TrackCore(TrackUI & ui, TrackLog & log)
	: curState(nullptr)
	{ }

	void run()
	{
		if (curState == 0)
		{
			throw std::logic_error("No state set.");
		}
		// probably wait for input on the ui
		// and offer status output

		// I guess each state will manage something or other.
		// Downtime can have a status that's displayed, and a category it records events of

		// Then working task, similar, but can have substates depending on task worked.
	}

	TrackState * curState;
};

int main()
{
	return 0;
}

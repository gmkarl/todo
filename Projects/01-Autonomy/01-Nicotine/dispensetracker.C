// load TFile with data
// accept events from user:
// 1. dispenser filled by amount
// 2. dispenser filled to amount
// 3. dispense performed
//		-> output expected mg nicotine

#include <TFile.h>

struct SoluteEvent
{
	float totalVolume;
	float totalSolute;
	char * event;

	ClassDef(SoluteEvent, 1)
};
ClassImp(SoluteEvent)

class DispenseTracker
{
public:
	DispenseTracker(std::string fname)
	: file(TFile::open(fname, "UPDATE"))
	{
		if (!file->IsOpen())
		{
			throw std::runtime_error("Failed to open " + fname);
		}
		lastEvent = read();
	}

	double volume_ml()
	{
		return lastEvent.totalVolume;
	}

	double solute_mg()
	{
		return lastEvent.totalSolute;
	}

	void setTotal(double ml, double mg)
	{
		write(ml, mg, "setTotal");
	}

	void addVolume(double ml, double mg)
	{
		write(ml + volume_ml(), mg + solute_mg(), "addVolume");
	}

	double dispense()
	{
		
	}



	~DispenseTracker()
	{
		file->Write();
		delete file;
	}

private:
	SoluteEvent read()
	{
		SoluteEvent ret;
		file->GetObject("solute", &ret);
		return ret;
	}

	void write(double ml, double mg, std::string event)
	{
		SoluteEvent ev{ml, mg, event.c_str()};
		file->WriteObject(&ev, "solute");
		lastEvent = read();
	}

	TXMLFile * file;
	SoluteEvent lastEvent;
};

void predictdispense()
{
}

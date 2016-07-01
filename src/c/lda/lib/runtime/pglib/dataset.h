#ifndef DATASET_H
#define DATASET_H

extern "C" {
#include "reconos.h"
#include "reconos_app.h"
#include "mbox.h"
}

#include <vector>

using namespace std;

class Dataset {

private:

	int16_t 		m_class;
	vector<double> 	m_data; // double needed for ALGlib

public:
	// Constructor
	Dataset(vector<double> data, int16_t assingedClass);
	//Destructor
	~Dataset();

	// Getter
	const	vector<double>	getData()	const { return m_data; }
			uint16_t		getSize()	const { return m_data.size(); }
	const	int16_t			getClass()	const { return m_class; }

	// Setter
	void setData(vector<double> data, int16_t assingedClass) 	{ m_data = data; m_class = assingedClass; }
	void setData(vector<double> data)							{ m_data = data; }
	void setClass(int16_t assingedClass)						{ m_class = assingedClass; }
};

#endif /* DATASET_H */
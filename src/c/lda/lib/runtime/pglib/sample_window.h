#ifndef SAMPLE_WINDOW_H
#define SAMPLE_WINDOW_H

extern "C" {
#include "reconos.h"
#include "reconos_app.h"
#include "mbox.h"
}

#include <string.h>
#include <stdio.h>
#include <stdlib.h>

using namespace std;

class SampleWindow {

private:

	int16_t* 	m_data;
	uint32_t 	m_start;		// Next free position
	uint16_t 	m_nbrChannels;
	uint16_t 	m_windowSize;
	uint8_t		m_windowFilled;

public:
	// Constructor
	SampleWindow(uint16_t nbrChannels, uint16_t windowSize);
	SampleWindow(int16_t* pData, uint16_t nbrChannels, uint16_t windowSize);
	//Destructor
	~SampleWindow();

	// Getter
	const 	SampleWindow* getObject()							const	{ return this; }

			int16_t*	data()									const	{ return m_data; }
	const 	int16_t* 	getDataFromRow(uint16_t row)			const 	{ return &(m_data[row*m_nbrChannels]); }
			int16_t		getDataAt(uint16_t row, uint16_t col)	const 	{ return m_data[row*m_nbrChannels + col]; }
			uint32_t	getStart()								const 	{ return m_start; }
			int16_t*	getStartAddr()							const 	{ return &(m_data[m_start*m_nbrChannels]); }
			uint16_t	getWindowSize()							const 	{ return m_windowSize; }
			uint16_t	getNbrChannels()						const 	{ return m_nbrChannels; }
			uint8_t		windowFilled()							const  	{ return m_windowFilled; }

			void 		replaceOldestRowBy(const int16_t* data);
};

#endif /* SAMPLE_WINDOW_H */
extern "C" {
#include "reconos.h"
#include "reconos_app.h"
#include "mbox.h"
}

#include "sample_window.h"

#include <iostream>

using namespace std;

/**********************************************************************************************************************/
// Constructor
/**********************************************************************************************************************/
SampleWindow::SampleWindow(uint16_t nbrChannels, uint16_t windowSize) :
	m_start(0),
	m_nbrChannels(nbrChannels),
	m_windowSize(windowSize)
{
	m_data = new int16_t[windowSize*nbrChannels];
}

/**********************************************************************************************************************/
// Constructor
/**********************************************************************************************************************/
SampleWindow::SampleWindow(int16_t* pData, uint16_t nbrChannels, uint16_t windowSize) :
	m_data(pData),
	m_start(0),
	m_nbrChannels(nbrChannels),
	m_windowSize(windowSize),
	m_windowFilled(0)
{

}

/**********************************************************************************************************************/
// Destructor
/**********************************************************************************************************************/
SampleWindow::~SampleWindow()
{
	
}

/**********************************************************************************************************************/
// Replace oldest row
/**********************************************************************************************************************/
void SampleWindow::replaceOldestRowBy(const int16_t* data)
{
	memcpy((void*)&(m_data[m_start*m_nbrChannels]), (void*)data, sizeof(int16_t)*m_nbrChannels);

	// Update offset to oldest value / next free position
	m_start++;

	// Check if next position reached the wrap-around-point
	if( m_start >= m_windowSize ) {
		// Flag to check wether the entire window is completely filled 
		m_windowFilled = 1;
		m_start = 0;
	}
}
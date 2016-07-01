extern "C" {
#include "reconos.h"
#include "reconos_app.h"
#include "mbox.h"
}

#include "feature_extraction.h"

#include <unistd.h>
#include <string.h>

using namespace std;

/**********************************************************************************************************************/
// Constructor
/**********************************************************************************************************************/
FeatureExtraction::FeatureExtraction(uint16_t nbrChannels = 0, uint16_t windowSize = 100, int16_t threshold = 0) :
	m_nbrChannels(nbrChannels),
	m_windowSize(windowSize),
	m_threshold(threshold)
{

}

/**********************************************************************************************************************/
// Destructor
/**********************************************************************************************************************/
FeatureExtraction::~FeatureExtraction()
{

}

/**********************************************************************************************************************/
// Mean absolute value
/**********************************************************************************************************************/
double FeatureExtraction::getMeanAbsoluteValue(int16_t* window, int16_t channel, int16_t offset)
{
	uint16_t i = 0;
	uint32_t sum = 0;

	for(i = 0; i < this->m_windowSize; i++) {
		sum += abs(window[i*m_nbrChannels + channel]);
	}
	
	return (double)(sum)/(double)(this->m_windowSize);
}

/**********************************************************************************************************************/
// Sign slope changes
/**********************************************************************************************************************/
int16_t FeatureExtraction::getSlopeSignChanges(int16_t* window, int16_t channel, int16_t offset)
{
	int16_t ssc = 0;
	int16_t i = offset;
	int16_t j;
	int16_t k;
	int16_t c;

	/* 
	 * This loop has to be run through <windowSize> - 2 times because we need 3 values to detect a slope-sign change.
	 * Iterator i is initializes with the offset of the first (oldest) array index. j will be i+1 and k will be j+1.
	 * If i reaches the end of the array we have to make sure j and k are moved to the beginning.
	 */
	for(c = 2; c < this->m_windowSize; c++) {
		if(i == this->m_windowSize - 1) {
			j = 0;
			k = 1;
		} else if(i == this->m_windowSize - 2) {
			j = i+1;
			k = 0;
		} else {
			j = i+1;
			k = i+2;
		}

		// Check for slope-sign change
		if((window[j*m_nbrChannels + channel] - window[k*m_nbrChannels + channel]) * (window[j*m_nbrChannels + channel] - window[i*m_nbrChannels + channel]) > 0) {
			ssc++;
		}

		i++;
		if(i >= this->m_windowSize) {
			i = 0;
		}
	}

	return ssc;
}

/**********************************************************************************************************************/
// Waveform length
/**********************************************************************************************************************/
int16_t FeatureExtraction::getWaveformLength(int16_t* window, int16_t channel, int16_t offset)
{
	int16_t i = offset;
	int16_t wl = 0;
	int16_t j;
	int16_t c;

	/*
	 * In this implementation we only measure the waveform length in Y-direction, neglecting the portion in X-direction.
	 */
	for(c = 1; c < this->m_windowSize; c++ ) {
		if(i == this->m_windowSize - 1) {
			j = 0;
		} else {
			j = i+1;
		}

		wl += abs(window[j*m_nbrChannels + channel] - window[i*m_nbrChannels + channel]);

		i++;
		if(i >= this->m_windowSize) {
			i = 0;
		}
	}

	return wl;
}

/**********************************************************************************************************************/
// Zero-crossings
/**********************************************************************************************************************/
int16_t FeatureExtraction::getZeroCrossings(int16_t* window, int16_t channel, int16_t offset, int16_t threshold) {
	int16_t i = offset;
	int16_t zc = 0;
	int16_t val;
	int16_t c;

	/*
	 * The state variable is needed for intervals with successive zeros. It stores the sign of the last nonzero value.
	 */
	int16_t state = window[offset*m_nbrChannels + channel];
	for(c = 1; c < this->m_windowSize; c++) {
		if(i >= this->m_windowSize) {
			i = 0;
		}
		// Check if the value's magnitude is greater than the threshold or set it to 0 otherwise
		val = abs(window[i*m_nbrChannels + channel]) < threshold ? 0 : window[i*m_nbrChannels + channel];

		// Only needed once. If state gets initialized with 0, set it to the first occuring nonzero value.
		if(state == 0) {
			state = val;
		} else if(val*state < 0) { 
			zc++;
			state = val/abs(val);
		}
		i++;
	}
	return zc;
}


/**********************************************************************************************************************/
// Mean absolute value on entire Sample-Window
/**********************************************************************************************************************/
void FeatureExtraction::getMeanAbsoluteValue(int16_t* window, double* windowOut)
{
	uint16_t cntChannel = 0;
	uint16_t cntSample = 0;

	memset(windowOut, 0, sizeof(windowOut[0])*m_nbrChannels);

	for(cntSample = 0; cntSample < m_windowSize; cntSample++) {
		uint16_t row = m_nbrChannels*cntSample;
		for(cntChannel = 0; cntChannel < m_nbrChannels; cntChannel++) {
			windowOut[cntChannel] += abs(window[row + cntChannel]);
		}
	}

	for(cntChannel = 0; cntChannel < m_nbrChannels; cntChannel++) {
		windowOut[cntChannel] /= m_windowSize;
	}
}

/**********************************************************************************************************************/
// Sign slope changes on entire Sample-Window
/**********************************************************************************************************************/
void FeatureExtraction::getSlopeSignChanges(int16_t* window, int16_t offset, double* windowOut)
{
	int16_t ssc = 0;
	int16_t i = offset;
	int16_t j;
	int16_t k;
	int16_t c;

	int16_t cntChannel = 0;

	int16_t* pRow;
	int16_t* pRow_1;
	int16_t* pRow_2;

	memset(windowOut, 0, sizeof(windowOut[0])*m_nbrChannels);

	/* 
	 * This loop has to be run through <windowSize> - 2 times because we need 3 values to detect a slope-sign change.
	 * Iterator i is initializes with the offset of the first (oldest) array index. j will be i+1 and k will be j+1.
	 * If i reaches the end of the array we have to make sure j and k are moved to the beginning.
	 */
	for(c = 2; c < this->m_windowSize; c++) {
		if(i == this->m_windowSize - 1) {
			j = 0;
			k = 1;
		} else if(i == this->m_windowSize - 2) {
			j = i+1;
			k = 0;
		} else {
			j = i+1;
			k = i+2;
		}

		pRow = &(window[i*m_nbrChannels]);
		pRow_1 = &(window[j*m_nbrChannels]);
		pRow_2 = &(window[k*m_nbrChannels]);

		for(cntChannel = 0; cntChannel < m_nbrChannels; cntChannel++) {
			// Check for slope-sign change
			if((pRow_1[cntChannel] - pRow_2[cntChannel]) * (pRow_1[cntChannel] - pRow[cntChannel]) > 0) {
				windowOut[cntChannel]++;
			}
		}

		i++;
		if(i >= m_windowSize) {
			i = 0;
		}
	}

}

/**********************************************************************************************************************/
// Waveform length on entire Sample-Window
/**********************************************************************************************************************/
void FeatureExtraction::getWaveformLength(int16_t* window, int16_t offset, double* windowOut)
{
	int16_t row = offset;
	int16_t wl = 0;
	int16_t row_1 = 0;
	int16_t cntChannel = 0;
	int16_t cntSample = 0;

	int16_t* pRow;
	int16_t* pRow_1;

	memset(windowOut, 0, sizeof(windowOut[0])*m_nbrChannels);

	/*
	 * In this implementation we only measure the waveform length in Y-direction, neglecting the portion in X-direction.
	 */
	for(cntSample = 1; cntSample < m_windowSize; cntSample++ ) {
		if(row == this->m_windowSize - 1) {
			row_1 = 0;
		} else {
			row_1 = row+1;
		}
		pRow = &(window[row*m_nbrChannels]);
		pRow_1 = &(window[row_1*m_nbrChannels]);

		for(cntChannel=0; cntChannel < m_nbrChannels; cntChannel++) {
			windowOut[cntChannel] += (double)abs(pRow_1[cntChannel] - pRow[cntChannel]);
		}

		row++;
		if(row >= m_windowSize) {
			row = 0;
		}
	}
}

/**********************************************************************************************************************/
// Zero-crossings on entire Sample-Window
/**********************************************************************************************************************/
void FeatureExtraction::getZeroCrossings(int16_t* window, int16_t offset, int16_t threshold, double* windowOut)
{
	int16_t row = offset;
	int16_t val;
	int16_t c;
	int16_t cntChannel = 0;

	int16_t* pRow;

	memset(windowOut, 0, sizeof(windowOut[0])*m_nbrChannels);

	/*
	 * The state variable is needed for intervals with successive zeros. It stores the sign of the last nonzero value.
	 */
	int16_t* state = new int16_t[m_nbrChannels];

	pRow = &(window[offset*m_nbrChannels]);
	for(cntChannel = 0; cntChannel < m_nbrChannels; cntChannel++) {
		state[cntChannel] = pRow[cntChannel];
	}
	
	for(c = 1; c < this->m_windowSize; c++) {
		if(row >= this->m_windowSize) {
			row = 0;
		}

		pRow = &(window[row*m_nbrChannels]);

		for(cntChannel = 0; cntChannel < m_nbrChannels; cntChannel++) {
			// Check if the value's magnitude is greater than the threshold or set it to 0 otherwise
			val = abs(pRow[cntChannel]) < threshold ? 0 : pRow[cntChannel];

			// Only needed once. If state gets initialized with 0, set it to the first occuring nonzero value.
			if(state[cntChannel] == 0) {
				state[cntChannel] = val;
			} else if(val*state[cntChannel] < 0) { 
				windowOut[cntChannel]++;
				state[cntChannel] = val/abs(val);
			}
		}

		row++;
	}

	delete[] state; 
}

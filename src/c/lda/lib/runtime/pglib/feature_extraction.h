#ifndef FEATURE_EXTRACTION_H
#define FEATURE_EXTRACTION_H

extern "C" {
#include "reconos.h"
#include "reconos_app.h"
#include "mbox.h"
}

#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <queue>
#include <vector>

using namespace std;

class FeatureExtraction {

private:
	uint16_t 	m_nbrChannels;
	uint16_t 	m_windowSize;
	int16_t 	m_threshold;

public:
	// Constructor
	FeatureExtraction(uint16_t nbrChannels, uint16_t windowSize, int16_t threshold);
	//Destructor
	~FeatureExtraction();

	// Getter
	uint16_t 	getWindowSize() 		const { return m_windowSize; }
	int16_t 	getThreshold()			const { return m_threshold; }

	// Setter
	void 	setWindowSize(uint16_t ws) 		{ m_windowSize = ws; }
	void 	setThreshold(int16_t th)		{ m_threshold = th; }

	// Feature calculation
	double 	getMeanAbsoluteValue(int16_t* window, int16_t channel, int16_t offset); 					// Mean-Absolute-Value
	int16_t getSlopeSignChanges(int16_t* window, int16_t channel, int16_t offset);						// Slope-Sign-Changes
	int16_t getWaveformLength(int16_t* window, int16_t channel, int16_t offset);						// Waveform-Length
	int16_t getZeroCrossings(int16_t* window, int16_t channel, int16_t offset, int16_t threshold);		// Zero-Crossings

	void 	getMeanAbsoluteValue(int16_t* window, double* windowOut); 									// Mean-Absolute-Value on entire Sample-Window
	void 	getSlopeSignChanges(int16_t* window, int16_t offset, double* windowOut);					// Slope-Sign-Changes on entire Sample-Window
	void 	getWaveformLength(int16_t* window, int16_t offset, double* windowOut);						// Waveform-Length on entire Sample-Window
	void 	getZeroCrossings(int16_t* window, int16_t offset, int16_t threshold, double* windowOut);	// Zero-Crossings on entire Sample-Window
};

#endif /* FEATURE_EXTRACTION_H */
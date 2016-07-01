#include <ap_int.h>
#include <hls_stream.h>

ap_int<16> abs2(ap_int<16> value) {
#pragma HLS INLINE
	if( value < 0 ) {
		return -value;
	}
	else {
		return value;
	}
}


/*****************************************************************************/
// Zero-Crossings
/*****************************************************************************/
void fe_zc(hls::stream< ap_uint<32> > sampleFifo, hls::stream< ap_uint<32> > featureFifo, ap_uint<8> windowSize, ap_uint<32> threshold) {
#pragma HLS INTERFACE ap_ctrl_none port=return
#pragma HLS INTERFACE ap_fifo port=featureFifo
#pragma HLS INTERFACE ap_fifo port=sampleFifo

	ap_uint<32> data;

	ap_int<16> sampleChannel1 = 0;
	ap_int<16> sampleChannel2 = 0;

	ap_uint<32> zcChannel1 = 0;
	ap_uint<32> zcChannel2 = 0;

	ap_int<2> stateChannel1 = 0;
	ap_int<2> stateChannel2 = 0;

	ap_uint<8> cntSamples = 0;

	// Wait for Samples to arrive in FIFO
	while( windowSize == 0 ) {

	}

	while(1) {
		zcChannel1 = 0;
		zcChannel2 = 0;

		stateChannel1 = 0;
		stateChannel2 = 0;

		// Count zero-crossing for channel 1 & 2
		for(cntSamples=0; cntSamples < windowSize; cntSamples++) {
			// Read data from Sample-FIFO
			// 2 16 bit Samples at one position in 32 bit FIFO => Process 2 channels in parallel
			data = sampleFifo.read();

			sampleChannel1 = data(15, 0);
			if( abs2(sampleChannel1) < threshold ) {
				sampleChannel1 = 0;
			}


			sampleChannel2 = data(31, 16);
			if( abs2(sampleChannel2) < threshold ) {
				sampleChannel2 = 0;
			}

			// Check whether a zero-crossing occurred or not
			// Channel 1
			if( stateChannel1 == 0 ) {
				if( sampleChannel1 < 0 ) {
					stateChannel1 = -1;
				}
				else if( sampleChannel1 == 0 ) {
					stateChannel1 = 0;
				}
				else {
					stateChannel1 = 1;
				}
			}
			else if( stateChannel1 < 0 ) {
				if( sampleChannel1 > 0 ) {
					zcChannel1++;
					if( sampleChannel1 < 0 ) {
						stateChannel1 = -1;
					}
					else if( sampleChannel1 == 0 ) {
						stateChannel1 = 0;
					}
					else {
						stateChannel1 = 1;
					}
				}
			}
			else if( stateChannel1 > 0 ) {
				if( sampleChannel1 < 0 ) {
					zcChannel1++;
					if( sampleChannel1 < 0 ) {
						stateChannel1 = -1;
					}
					else if( sampleChannel1 == 0 ) {
						stateChannel1 = 0;
					}
					else {
						stateChannel1 = 1;
					}
				}
			}

			// Channel 2
			if( stateChannel2 == 0 ) {
				if( sampleChannel2 < 0 ) {
					stateChannel2 = -1;
				}
				else if( sampleChannel2 == 0 ) {
					stateChannel2 = 0;
				}
				else {
					stateChannel2 = 1;
				}
			}
			else if( stateChannel2 < 0 ) {
				if( sampleChannel2 > 0 ) {
					zcChannel2++;
					if( sampleChannel2 < 0 ) {
						stateChannel2 = -1;
					}
					else if( sampleChannel2 == 0 ) {
						stateChannel2 = 0;
					}
					else {
						stateChannel2 = 1;
					}
				}
			}
			else if( stateChannel2 > 0 ) {
				if( sampleChannel2 < 0 ) {
					zcChannel2++;
					if( sampleChannel2 < 0 ) {
						stateChannel2 = -1;
					}
					else if( sampleChannel2 == 0 ) {
						stateChannel2 = 0;
					}
					else {
						stateChannel2 = 1;
					}
				}
			}
		}
		// Write back features to Feature-FIFO
		featureFifo.write(zcChannel1);
		featureFifo.write(zcChannel2);
	}
}

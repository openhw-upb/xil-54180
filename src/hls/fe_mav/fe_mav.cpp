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
// Mean-Absolute-Values
/*****************************************************************************/
void fe_mav(hls::stream< ap_uint<32> > sampleFifo, hls::stream< ap_uint<32> > featureFifo, ap_uint<8> windowSize) {
#pragma HLS INTERFACE ap_ctrl_none port=return
#pragma HLS INTERFACE ap_fifo port=featureFifo
#pragma HLS INTERFACE ap_fifo port=sampleFifo

	ap_uint<32> data;

	ap_uint<32> mavChannel1 = 0;
	ap_uint<32> mavChannel2 = 0;

	ap_uint<8> cntSamples = 0;

	// Wait for Samples to arrive in FIFO
	while( windowSize == 0 ) {

	}

	while(1) {
		mavChannel1 = 0;
		mavChannel2 = 0;

		for(cntSamples=0; cntSamples < windowSize; cntSamples++) {
			// Read data from Sample-FIFO
			// 2 16 bit Samples at one position in 32 bit FIFO => Process 2 channels in parallel
			data = sampleFifo.read();

			mavChannel1 += abs2(data(15, 0));

			mavChannel2 += abs2(data(31, 16));
		}

		// Write back features to Feature-FIFO
		featureFifo.write(mavChannel1);
		featureFifo.write(mavChannel2);
	}
}

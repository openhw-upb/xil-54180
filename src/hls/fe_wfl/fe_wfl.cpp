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
// Wave-Form-Length
/*****************************************************************************/
void fe_wfl(hls::stream< ap_uint<32> > sampleFifo, hls::stream< ap_uint<32> > featureFifo, ap_uint<8> windowSize) {
#pragma HLS INTERFACE ap_ctrl_none port=return
#pragma HLS INTERFACE ap_fifo port=featureFifo
#pragma HLS INTERFACE ap_fifo port=sampleFifo

    ap_uint<32> data;

    ap_int<32> wflChannel1 = 0;
    ap_int<32> wflChannel2 = 0;

    ap_int<16> sampleChannel1 = 0;
    ap_int<16> sampleChannel2 = 0;

    ap_int<16> prevSampleChannel1 = 0;
    ap_int<16> prevSampleChannel2 = 0;   

    ap_uint<8> cntSamples = 0;
    
    // Wait for Samples to arrive in FIFO
    while( windowSize == 0 ) {

    }

    while(1) {
        wflChannel1 = 0;
        wflChannel2 = 0;

        // Count zero-crossing for channel 1 & 2
        for(cntSamples = 0; cntSamples < windowSize; cntSamples++) {
            // Read data from Sample-FIFO
            // 2 16 bit Samples at one position in 32 bit FIFO => Process 2 channels in parallel
            data = sampleFifo.read();

            sampleChannel1 = data(15, 0);
            sampleChannel2 = data(31, 16);

            if (cntSamples > 0) {
                wflChannel1 += abs2(sampleChannel1 - prevSampleChannel1);
                wflChannel2 += abs2(sampleChannel2 - prevSampleChannel2);
            }

            prevSampleChannel1 = sampleChannel1;
            prevSampleChannel2 = sampleChannel2;
        }

        // Write back features to Feature-FIFO
        featureFifo.write(wflChannel1);
        featureFifo.write(wflChannel2);
    }
}

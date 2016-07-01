

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
// Slope-Sign-Changes
/*****************************************************************************/
void fe_ssc(hls::stream< ap_uint<32> > sampleFifo, hls::stream< ap_uint<32> > featureFifo, ap_uint<8> windowSize) {
#pragma HLS INTERFACE ap_ctrl_none port=return
#pragma HLS INTERFACE ap_fifo port=featureFifo
#pragma HLS INTERFACE ap_fifo port=sampleFifo

    ap_uint<32> data;

    ap_int<16> sampleChannel1[3] = {0,0,0};
    ap_int<16> sampleChannel2[3] = {0,0,0};

    ap_uint<32> sscChannel1 = 0;
    ap_uint<32> sscChannel2 = 0;

    ap_uint<8> cntSamples = 0;

    // Wait for Samples to arrive in FIFO
    while( windowSize == 0 ) {

    }

    while(1) {
        sscChannel1 = 0;
        sscChannel2 = 0;

        data = sampleFifo.read();
        sampleChannel1[0]= data(15, 0);
        sampleChannel2[0] = data(31, 16);

        data = sampleFifo.read();
        sampleChannel1[1] = data(15, 0);
        sampleChannel2[1] = data(31, 16);


        // Count wfl for channel 1 & 2
        for(cntSamples=2; cntSamples < windowSize; cntSamples++) {
            // Read data from Sample-FIFO
            // 2 16 bit Samples at one position in 32 bit FIFO => Process 2 channels in parallel
            data = sampleFifo.read();
            sampleChannel1[2] = data(15, 0);
            sampleChannel2[2] = data(31, 16);

            // Process ssc
            // Channel 1
            if( (sampleChannel1[1] - sampleChannel1[2]) * (sampleChannel1[1] - sampleChannel1[0]) > 0 ) {
                sscChannel1++;
            }

            // Channel 2
            if( (sampleChannel2[1] - sampleChannel2[2]) * (sampleChannel2[1] - sampleChannel2[0]) > 0 ) {
                sscChannel2++;
            }

            // Store old value
            sampleChannel1[0] = sampleChannel1[1];
            sampleChannel2[0] = sampleChannel2[1];

            sampleChannel1[1] = sampleChannel1[2];
            sampleChannel2[1] = sampleChannel2[2];
        }

        // Write back features to Feature-FIFO
        featureFifo.write(sscChannel1);
        featureFifo.write(sscChannel2);
    }
}
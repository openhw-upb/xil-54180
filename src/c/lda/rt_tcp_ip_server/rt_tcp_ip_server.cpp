extern "C" {
#include "reconos.h"
#include "reconos_app.h"
#include "mbox.h"
}

#include "../lib/runtime/pglib/sample_window.h"
#include "../lib/runtime/pglib/sample_identifier.h"
#include "../lib/runtime/pglib/extractor_selector.h"

#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <time.h>


extern struct mbox *mbox_init_server;

extern struct mbox *mbox_sample_window_sw;
extern struct mbox *mbox_sample_window_hw;

extern struct mbox *mbox_mav_mav;

extern struct mbox *mbox_ack_classification;

using namespace std;

int32_t initTCPIPServer(uint32_t portno) {
	int sockfd;
	struct sockaddr_in serv_addr;

	sockfd = socket(AF_INET, SOCK_STREAM, 0);

	if (sockfd < 0) {
		printf("*********/////// Error: Open socket!\n");
		return -1;
	}

	bzero((char *) &serv_addr, sizeof(serv_addr));
	serv_addr.sin_family = AF_INET;
	serv_addr.sin_addr.s_addr = INADDR_ANY;
	serv_addr.sin_port = htons(portno);

	if (bind(sockfd, (struct sockaddr *) &serv_addr, sizeof(serv_addr)) < 0) {
		printf("*********/////// Error: Binding port!\n");
		return -1;
	}

	listen(sockfd,5);

	return sockfd;
}

int16_t readSamples(int sockfd, void* buffer, size_t nbyte, int32_t& receivedBytes) {
	int16_t ret = 0;

	//receivedBytes = read(newsockfd, dataBuffer, msgElem*sizeof(int16_t));

	return ret;
}

extern "C" void *rt_tcp_ip_server(void *data) {
	int16_t mov = 0;
	int16_t mav = 0;
	uint32_t cntWindowShift = 0;
	int16_t id_class;

	uint32_t cntPkg = 0;

	// Init.-Data
	uint32_t portno;
	uint32_t nbrChannels;
	uint32_t windowSize;
	uint32_t windowShift;
	int16_t* pSampleWindowData;
	uint32_t nbrClasses;

	// Extractor-Selector
	uint32_t extractorSelectorHW;
	uint32_t extractorSelectorSW;

	// Get the important parameters for the connection via mbox, e.g. server_port
	portno = (uint32_t)mbox_get(mbox_init_server);
	windowSize = (uint32_t)mbox_get(mbox_init_server);
	windowShift = (uint32_t)mbox_get(mbox_init_server);
	nbrChannels = (uint32_t)mbox_get(mbox_init_server);
	nbrClasses = (uint32_t)mbox_get(mbox_init_server);
	pSampleWindowData = (int16_t*)mbox_get(mbox_init_server);
	extractorSelectorSW = (uint32_t)mbox_get(mbox_init_server);
	extractorSelectorHW = (uint32_t)mbox_get(mbox_init_server);

	uint32_t msgElem = nbrChannels+1;// +1 for ID

	SampleWindow* pSampleWindow = new SampleWindow(pSampleWindowData, nbrChannels, windowSize);

	struct sockaddr_in cli_addr;

	// Socket descriptors
	int sockfd;
	int newsockfd;

	int16_t* dataBuffer = new int16_t[ msgElem ];
	int32_t receivedBytes = 0;

	// Setup the server
	sockfd = initTCPIPServer(portno);

	int32_t countWindows = 0;
	// int16_t oldClass = 0;

	// if sockfd < 0 then error else listen to the port
	if( sockfd >= 0 ) {
		socklen_t clilen = sizeof(cli_addr);

		// Receive data until an Exit-Signal comes in
		while( mov >= 0 ) {
			// First check whether a connection is established (indicator: read() returns 0)
			if( receivedBytes <= 0 ) {
				newsockfd = accept(sockfd, (struct sockaddr *) &cli_addr, &clilen);
				printf("Accepted a connection with fd %d\n", newsockfd);
			}

			// If connection is established then read data
			if( newsockfd >= 0  ) {
				// Get data from client
				//int16_t re = readData(newsockfd, dataBuffer, msgElem*sizeof(int16_t), receivedBytes);
				receivedBytes = read(newsockfd, dataBuffer, msgElem*sizeof(int16_t));

				// If data is received process them
				if( receivedBytes > 0 ) {
					cntPkg++;

					// cout << "ID: " << (dataBuffer[0] & 0x00ff) << " class: " << ((dataBuffer[0] & 0xff00) >> 8) << endl;
					id_class = dataBuffer[0];

					pSampleWindow->replaceOldestRowBy( &(dataBuffer[1]) );

					// Give Sample-Window to Feature-Extraction if Window-Shift is reached
					cntWindowShift++;
					if( ((cntWindowShift >= windowShift) && (pSampleWindow->windowFilled() == 1)) || (id_class & 0x00ff) == 2) {
						countWindows++;
						// cout << "Windows collected: " << countWindows << " of class " << ((dataBuffer[0] & 0xff00) >> 8) << endl;
						// cout << "ID: " << (id_class & 0x00ff) << " class: " << ((id_class & 0xff00) >> 8) << endl;
				
						// Pass data to FEM-SW if neccessary
						if(extractorSelectorSW > 0) {
							// Send ID and class (if available)
							mbox_put(mbox_sample_window_sw, (uint32_t)id_class);

							// Give the pointer of the data to the processing thread
							mbox_put(mbox_sample_window_sw, (uint32_t)(pSampleWindow->getObject()));
						}

						// Pass data to FEM-HW if neccessary
						if(extractorSelectorHW > 0) {
							uint32_t id_class_offset = (pSampleWindow->getStart()<<16) | (dataBuffer[0]<<0);
							// Send ID, class and offset to FEM-HW
							mbox_put(mbox_sample_window_hw, id_class_offset);
						}

						cntWindowShift = 0;

						// Wait for MAV-MAV from Feature-Projection-Thread
						mav = (int16_t)mbox_get(mbox_mav_mav);
						// Wait for the classifier to be ready
						mov = (int16_t)mbox_get(mbox_ack_classification);					
					}
				}

				// Send ack to client
				int16_t ack[2];
				ack[0] = mov;	// Movement
				ack[1] = mav;	// MAV-MAV for proportional control
				write(newsockfd, ack, sizeof(int16_t)*2);
			}
		}
	}

	close(newsockfd);
	close(sockfd);
	cout << "Closed connection" << endl;

	delete[] dataBuffer;
	pthread_exit(0);
}

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <string>
#include <iostream>
#include <fstream>
#include <sstream>
#include <netinet/tcp.h>

using namespace std;

#define ID_TRAIN              0
#define ID_CLASSIFY           1
#define ID_TRAIN_AND_FINISH   2

void error(const char *msg)
{
    perror(msg);
    exit(0);
}

int main(int argc, char *argv[])
{
  int i = 0;

  // Variables for network-communication
  int sockfd, portno, nbrRows, nbrCols, ret;
  uint32_t msgElem = 0;
  uint32_t nbrSamplesPerClass;
  int16_t* data;
  int16_t assigendClass;
  int16_t id;
  char mode;
  struct sockaddr_in serv_addr;
  struct hostent *server;

  // Variables for csv-file operations
  string file;
  string line;
  string value;
  ifstream dataFile;


  // Check input-parameter
  if (argc < 7) {
     fprintf(stderr,"usage %s <server-ip> <port-no> <nbr columns> <filename in dir. HD> <T: train or C: classify> <new class after x samples>\n", argv[0]);
     exit(0);
  }
  else {
  	server = gethostbyname(argv[1]);
    portno = atoi(argv[2]);
    nbrCols = atoi(argv[3]);
    file = string(argv[4]);
    mode = argv[5][0];
    nbrSamplesPerClass = atoi(argv[6]);

    dataFile.open(file.c_str());

    msgElem = nbrCols+1;

    // Assign memory location to data
    data = new int16_t[ msgElem ]; // +1 ID
  }

  // Establish connection
  sockfd = socket(AF_INET, SOCK_STREAM, 0);

  if (sockfd < 0) {
    cout << "ERROR opening socket" << endl;
  }

  if (server == NULL) {
      cout << "ERROR, no such host" << endl;
      exit(0);
  }

  bzero((char *) &serv_addr, sizeof(serv_addr));
  serv_addr.sin_family = AF_INET;
  bcopy((char *)server->h_addr, (char *)&serv_addr.sin_addr.s_addr, server->h_length);
  serv_addr.sin_port = htons(portno);

  if (connect(sockfd,(struct sockaddr *) &serv_addr,sizeof(serv_addr)) < 0) {
    cout << "ERROR connecting" << endl;
  }
  else {
    cout << "Connected to server!\n" << endl;
  }

  // Check if csv-file is openend
  if( dataFile != NULL ) {
    uint32_t nbrSentPackages = 0;

    // Set ID
    if( (mode == 'T') || (mode == 't') ) {
    	id = ID_TRAIN;
    }
    else if( (mode == 'C') || (mode == 'c') ) {
    	id = ID_CLASSIFY;
    }
    data[0] = id;

    // Repeat until all data is sent
    while( !dataFile.eof() ) {
      // Read one line until '\r'
      getline(dataFile, line, '\n');

      // Check whether last datapackage is send and change ID if needed
      if( (id == ID_TRAIN) && (dataFile.eof()) ) {
        cout << "Package-No.: " << nbrSentPackages+1 << "\tSet ID to TRAIN_AND_FINISH" << endl;
      	data[0] = ID_TRAIN_AND_FINISH;
      }

      // Wrie the line into a stringstream and process each line individually
      stringstream lineStream;
      lineStream << line;

      // Read in one sample from each channel
      for(i=0; i < nbrCols; i++) {
        getline(lineStream, value, ',');
        data[i+1] = atoi(value.c_str());
      }

      // Set class of training data
      if( (mode == 'T') || (mode == 't') ) {
        // Reset class
        data[0] &= 0x00ff;
        //cout << "Data[0]: " << data[0] << endl;
        // Set class
    	  data[0] |= ( ((int16_t)(nbrSentPackages/nbrSamplesPerClass)+1) << 8);
        //cout << "Data[0]: " << data[0] << endl;
	    }

	    // Send the data to server over TCP/IP
      ret = send(sockfd, (void*)data, msgElem*sizeof(int16_t), 0);

      if (ret < 0) {
        cout << "ERROR writing to socket" << endl;
      }
      else {
      	nbrSentPackages++;
        if( nbrSentPackages%5000 == 0 ) {
          int16_t lower = data[0] & 0x00ff;
          int16_t upper =  (data[0] & 0xff00) >> 8;
          cout << "Package-No.: " << nbrSentPackages << " sent.\t" << "\tdata[0]-Lower-Byte:\t" << lower << "\tdata[0]-Upper-Byte:\t" << upper << endl;
        }
      }

      // Wait for acknowledgement
      int16_t ack[2];
      ack[0] = -1;
      while( ack[0] < 0 ) {
        read(sockfd, ack, sizeof(int16_t)*2);
      }
      if( ack[0] > 0 ) {
        cout << "Classified: " << ack[0] << "\tMAV: " << ack[1] << endl;
      }
    }
  }
  else {
    printf("Error: Open file!\n");
  }

  cout << "Close connection: " << sockfd << endl;
  close(sockfd);

  dataFile.close();

  delete[] data;

  return 0;
}

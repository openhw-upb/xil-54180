#include "logtime.h"

using namespace std;

void logTime(char* str, long t, FILE* timeLogFile) {
	//FILE* timeLogFile;
	//timeLogFile = fopen("time.log", "a+");
		
	//if( timeLogFile != NULL ) {
	  	fprintf(timeLogFile, "%s:%ld\n", str, t);
	/*}
	else {
		cout << "Did not open file!" << endl;
	}
	fclose(timeLogFile);*/
}
#ifndef _DLL_H_
#define _DLL_H_

#define DLLIMPORT __declspec (dllexport)


int DLLIMPORT DoJob(char *InputFile,char *Output); 

#endif /* _DLL_H_ */

#ifndef _DLL_H_
#define _DLL_H_

#define DLLIMPORT __declspec (dllexport)


int DLLIMPORT  DoJob(char *InputFile,int certainty,char *Output); 
int DLLIMPORT  DoJob_ext(char *InputFile,int certainty,char *Output,char *charset); 


#endif /* _DLL_H_ */

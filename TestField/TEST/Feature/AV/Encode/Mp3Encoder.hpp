//
//        Mp3Encoder.hpp
 //       2022/1/14
//        
//        
//        Author: Ron
//        MainPage: https://github.com/Ron-Samkulami/
//        

#ifndef Mp3Encoder_hpp
#define Mp3Encoder_hpp

#include <stdio.h>
#include "fat-lame/include/lame/lame.h"

class Mp3Encoder {
private:
    FILE* pcmFile;
    FILE* mp3File;
    lame_t lameClient;
public:
    Mp3Encoder();
    ~Mp3Encoder();
    int Init(const char *pcmFilePath, const char *mp3FilePath, int sampleRate, int channels, int bitRate);
    void Encode();
    void Destory();
};

#endif /* Mp3Encoder_hpp */

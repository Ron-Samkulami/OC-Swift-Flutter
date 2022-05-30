//
//        Mp3Encoder.cpp
 //       2022/1/14
//        
//        
//        Author: Ron
//        MainPage: https://github.com/Ron-Samkulami/
//        

#include "Mp3Encoder.hpp"

Mp3Encoder:: Mp3Encoder() {
    
}

Mp3Encoder:: ~Mp3Encoder() {
    
}

/// 初始化解码器
/// @param pcmFilePath pcm文件路径
/// @param mp3FilePath MP3文件路径
/// @param sampleRate 采样率
/// @param channels 信道数
/// @param bitRate 比特率
int Mp3Encoder::Init(const char *pcmFilePath, const char *mp3FilePath, int sampleRate, int channels, int bitRate) {
    int ret = -1;
    pcmFile = fopen(pcmFilePath, "rb");
    if (pcmFile) {
        mp3File = fopen(mp3FilePath, "wb");
        if (mp3File) {
            lameClient = lame_init();
            lame_set_in_samplerate(lameClient, sampleRate);
            lame_set_out_samplerate(lameClient, sampleRate);
            lame_set_num_channels(lameClient, channels);
            lame_set_brate(lameClient, bitRate / 1000);
            lame_init_params(lameClient);
            ret = 0;
        }
    }
    return ret;
}


/**
 编码方法
 每次读取一段bufferSize大小的PCM数据buffer，拆分左右声道，再送入LAME编码器编码后写入MP3文件
 */
void Mp3Encoder::Encode() {
    printf("Start Encode");
    
    int bufferSize = 1024 * 256;
    short* buffer = new short[bufferSize / 2];
    short* leftBuffer = new short[bufferSize / 4];
    short* rightBuffer = new short[bufferSize / 4];
    unsigned char* mp3_buffer = new unsigned char[bufferSize];
    size_t readBufferSize = 0;
    
    while ((readBufferSize = fread(buffer, 2, bufferSize / 2, pcmFile)) > 0) {
        for (int i = 0; i < readBufferSize; i++) {
            if (i % 2 == 0) {
                leftBuffer[i / 2] = buffer[i];
            } else {
                rightBuffer[i / 2] = buffer[i];
            }
        }
        size_t wroteSize = lame_encode_buffer(lameClient, (short int*)leftBuffer, (short int*)rightBuffer, (int)(readBufferSize / 2), mp3_buffer, bufferSize);
        fwrite(mp3_buffer, 1, wroteSize, mp3File);
    }
    
    delete [] buffer;
    delete [] leftBuffer;
    delete [] rightBuffer;
    delete [] mp3_buffer;
}


void Mp3Encoder::Destory() {
    if (pcmFile) {
        fclose(pcmFile);
    }
    if (mp3File) {
        fclose(mp3File);
        lame_close(lameClient);
    }
}

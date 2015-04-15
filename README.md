Codec-AS3
=========

`NetStream.appendBytes()`只支持FLV封裝的格式，在需要播放其他封裝的視頻的話，就必須將其他封裝格式轉成FLV的封裝。編碼用(H.264 & AAC)

##Libraries
*  `as3crypto` [As3Crypto](https://code.google.com/p/as3crypto/) is a cryptography library written in Actionscript 3 that provides several common algorithms. 

##Format

*  [MP4](http://xhelmboyx.tripod.com/formats/mp4-layout.txt)
*  [FLV](http://www.adobe.com/content/dam/Adobe/en/devnet/flv/pdfs/video_file_format_spec_v10.pdf)
*  [MKV](http://www.matroska.org/files/matroska.pdf)

##Usage

```as3
var mp4:Mp4Codec = new Mp4Codec();
mp4.decode(mp4bytes);
var bytes:ByteArray = new FlvCodec().encode(mp4);
ns.appendBytes(bytes);
```

##Roadmap

*  視頻壓縮
*  支持多種封裝
*  rtmp視頻流解析
*  ts流解析
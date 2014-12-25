CODEC-AS3
=========
(h264, aac)
如果要用`NetStream.appendBytes()`来播放视频的话，目前只支持flv格式的数据。要播放其他视频的时候就必须转封装。玩这个当初只是为了能够播放本地视频文件(通过socket分块传送)给另一端收看，而不用上传视频到服务器转码。目前还想试的是本地的压缩视频，本地视频有可能很大，那发送起来数据量太大了，如果可以控制质量那就再好不过了。

***mp4还只是简单的处理了下，还没遇到各种box的情况，只能以后遇到后再完善了。***

*  [MP4](http://xhelmboyx.tripod.com/formats/mp4-layout.txt)
*  [FLV](http://www.adobe.com/content/dam/Adobe/en/devnet/flv/pdfs/video_file_format_spec_v10.pdf)


###USEAGE
```as3
var mp4:Mp4Codec = new Mp4Codec();
mp4.decode(mp4bytes);
var flvbytes:ByteArray = new FlvCodec().encode(mp4);
netstream.appendBytes(flvbytes);
```
Codec-AS3
=========

`NetStream.appendBytes()`只支持FLV封裝的格式，在需要播放其他封裝的視頻的話，就必須將其他封裝格式轉成FLV的封裝。

>起初我只是想解析webm，可到现在还是没解析完成，而mp4的资料比较多所以mp4的已经ok~ 其他格式估计暂时也不会研究~ 毕竟工作不是研究视频的= = 


## 格式

- [MP4](http://xhelmboyx.tripod.com/formats/mp4-layout.txt)
- [FLV](http://www.adobe.com/content/dam/Adobe/en/devnet/flv/pdfs/video_file_format_spec_v10.pdf)
- [MKV](http://www.matroska.org/files/matroska.pdf)

## 使用

``` as3
var mp4:Mp4Codec = new Mp4Codec();
mp4.decode(mp4bytes);
var bytes:ByteArray = new FlvCodec().encode(mp4);
ns.appendBytes(bytes);
```

## 更新路线

*  压缩
*  mkv解析
*  hls流
*  scoket

## 许可证

MIT
Codec-AS3
=========

`NetStream.appendBytes()`只支持FLV封裝的格式，在需要播放其他封裝的視頻的話，就必須將其他封裝格式轉成FLV的封裝。

## 
>起初我只是想解析webm，可到现在还是没解析完成，而mp4的资料比较多所以mp4的已经ok~ 其他格式估计暂时也不会研究~ 毕竟工作不是研究视频的= =
>a和b，其中a想播放一个视频给b看，可能需要上传那个视频，然后建立流再给b看，然后我的想法是~ 能不能直接通过a加载视频，然后切割后通过socket传输到b，在b接收到足够的数据后进行解析，然后播放咧~~ 嘛~   实际上也是通过websocket测试成功，可目前也只有mp4....

## 类库
- [As3Crypto](https://code.google.com/p/as3crypto/) 

## 视频格式

- [MP4](http://xhelmboyx.tripod.com/formats/mp4-layout.txt)
- [FLV](http://www.adobe.com/content/dam/Adobe/en/devnet/flv/pdfs/video_file_format_spec_v10.pdf)
- [MKV](http://www.matroska.org/files/matroska.pdf)

## 使用方法

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
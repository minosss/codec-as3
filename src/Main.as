package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.NetStreamAppendBytesAction;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;
	
	import cc.minos.codec.flv.FlvCodec;
	import cc.minos.codec.mp4.Mp4Codec;
	
	public class Main extends Sprite
	{

		private var mp4:Mp4Codec;

		private var netStream:URLStream;

		private var v:Video;

		private var _ns:NetStream;

		private var _bytes:ByteArray;
		
		/**
		 * 默认播放   如果要生成flv文件件设置为false 
		 */		
		private static const PLAY:Boolean = true;
		public function Main()
		{
			netStream = new URLStream();
			netStream.addEventListener(ProgressEvent.PROGRESS,onProgress);
			netStream.load(new URLRequest("http://static.hdslb.com/8249030-1.mp4"));
			mp4 = new Mp4Codec();
			
			v = new Video();
			addChild(v);
			
			var nc:NetConnection = new NetConnection();
			nc.connect(null);
			_ns = new NetStream(nc);
			_ns.addEventListener(NetStatusEvent.NET_STATUS, statusHandler);
			_ns.client = this;
			_ns.play(null);
			v.attachNetStream(_ns);
			
			_bytes = new ByteArray();
		}
		
		protected function onProgressFlv(event:ProgressEvent):void
		{
			var byts:ByteArray = new ByteArray();
			netStream.readBytes(byts);
			_ns.appendBytes(byts);
		}
		
		public function onMetaData(data:Object):void
		{
			trace(data)
			for (var key:String in data)
			{
				trace(key + ":" + data[key] + "\n");
			}
		}
		
		protected function statusHandler(event:NetStatusEvent):void
		{
			// TODO Auto-generated method stub
			trace(this,event.info.code)
		}
		
		
		private var flvCode:FlvCodec = new FlvCodec();
		private var _postion:int = 0;
		
		private var testBytes:ByteArray = new ByteArray;
		protected function onProgress(event:ProgressEvent):void
		{
			if(mp4.streamDecode(netStream))
			{
//				netStream.removeEventListener(ProgressEvent.PROGRESS,onProgress);
				var bytes:ByteArray = flvCode.streamEncode(mp4);
				if(bytes)
				{
					if(PLAY)
					{
						_ns.appendBytes(bytes);
						bytes.clear();
					}
				}
			}
			
			if(event.bytesLoaded == event.bytesTotal)
			{
				bytes.position = 0;
				var saveF:File = File.desktopDirectory.resolvePath("test2.flv");
				var f:FileStream = new FileStream();
				f.open(saveF,FileMode.WRITE);
				f.writeBytes(bytes);
				f.close();
				
			}
			
		}
	}
}
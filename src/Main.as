package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.events.ProgressEvent;
	import flash.events.StatusEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.media.Video;
	import flash.net.FileReference;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.NetStreamAppendBytesAction;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.system.ApplicationDomain;
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
		public function Main()
		{
			netStream = new URLStream();
			netStream.addEventListener(ProgressEvent.PROGRESS,onProgress);
//			netStream.addEventListener(Event.COMPLETE,onComplete);
			netStream.load(new URLRequest("http://static.hdslb.com/8249030-1.mp4"));
			
			
//			netStream.addEventListener(ProgressEvent.PROGRESS,onProgressFlv);
//			netStream.addEventListener(Event.COMPLETE,onCompleteFlv);
//			netStream.load(new URLRequest("http://static.hdslb.com/testRight.flv"));
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
			
			stage.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			_ns.seek(0);
			_ns.appendBytesAction(NetStreamAppendBytesAction.RESET_SEEK);
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
			var byts:ByteArray = new ByteArray();
			netStream.readBytes(byts);
			if(byts.length>0)
			{
//				trace(byts.length)
			}
			var posiont:int = _bytes.position;
			_bytes.position = _bytes.length;
			_bytes.writeBytes(byts);
			_bytes.position = posiont;
			if(mp4.streamDecode(_bytes))
			{
//				netStream.removeEventListener(ProgressEvent.PROGRESS,onProgress);
				var bytes:ByteArray = flvCode.streamEncode(mp4);
				if(bytes)
				{
//					if(bytes.length >= 17216)
//					{
//						trace("aaa")
//					}
//					trace(bytes.length);
//					var data:ByteArray = new ByteArray();
//					data.writeBytes(bytes, _postion);
//					trace(data.length);
//					_postion = data.length;
					
//					testBytes.writeBytes(bytes);
					
//					if(bytes.length < 5*1024*1024)
//					{
//						_ns.appendBytes(bytes);
//						bytes.clear();
//					}
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
				
//				_ns.appendBytes(bytes);
				trace("加载完成，", _bytes.length,_bytes.position,_bytes.bytesAvailable)
			}
			
//			var bytes:ByteArray = new FlvCodec().streamEncode(mp4);
//			trace(_bytes.length,_bytes.position,_bytes.bytesAvailable);
		}
		
		protected function onComplete(event:Event):void
		{
			var byte:ByteArray = new ByteArray();
			netStream.readBytes(byte);
//			byte.length = 10*1024*1024;
			mp4.decode(byte);
			
			var bytes:ByteArray = new FlvCodec().encode(mp4);
//			trace(bytes.length,bytes.position,bytes.bytesAvailable)
//			_ns.appendBytes(bytes);
			
			
			var saveF:File = File.desktopDirectory.resolvePath("test.flv");
			var f:FileStream = new FileStream();
			f.open(saveF,FileMode.WRITE);
			f.writeBytes(bytes);
			f.close();
		}
	}
}
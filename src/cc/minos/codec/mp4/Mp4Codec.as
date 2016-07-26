/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/24 15:36
 */
package cc.minos.codec.mp4 {

	import flash.utils.ByteArray;
	
	import cc.minos.codec.Codec;
	import cc.minos.codec.flv.FlvCodec;
	import cc.minos.codec.flv.Frame;
	import cc.minos.codec.mp4.boxs.MoovBox;
	import cc.minos.codec.mp4.boxs.TrakBox;

	/**
	 * mp4解析
	 * moov記錄了整個視頻的數據
	 * stbl記錄幀的數據（位移大小等，獲取的時候需要分析chunk(1個chunk可以有幾個sample))
	 * stsd記錄編碼的數據，視頻或音頻的解析需要在這裏取數據
	 */
	public class Mp4Codec extends Codec {

		//數據信息
		protected var moovBox:MoovBox;
		//視頻幀列表
		protected var _videoSamples:Vector.<Sample>;
		//音頻幀列表
		protected var _audioSamples:Vector.<Sample>;

		private var $offset:uint;

		private var $size:uint;

		private var $type:uint;
		private var _waiting:Boolean = false;
		private var _hadHeadMeata:Boolean;

		public function Mp4Codec()
		{
			_name = "mp4,f4v";
			_extensions = "mp4,f4v";
			_mimeType = "video/mp4";
		}
		
		
		/**
		 * 排序
		 * @param a
		 * @param b
		 * @param array
		 * @return
		 */
		private function sortByTime(a:Object, b:Object, array:Array = null):int
		{
			//改用渲染順序來排序
			if (a.timestamp < b.timestamp )
			{
				return -1;
			}
			else if(a.timestamp > b.timestamp){
				return 1;
			}
			if (a.dataType == 0x09)
			{
				return -1;
			}
			else if (b.dataType == 0x09)
			{
				return 1;
			}
			return 0;
		}
		
		/**
		 * 排序
		 * @param a
		 * @param b
		 * @param array
		 * @return
		 */
		private function sortOffset(a:Object, b:Object, array:Array = null):int
		{
			//改用渲染順序來排序
			if (a.offset < b.offset )
			{
				return -1;
			}
			else if(a.offset > b.offset){
				return 1;
			}
			if (a.dataType == 0x09)
			{
				return -1;
			}
			else if (b.dataType == 0x09)
			{
				return 1;
			}
			return 0;
		}
		
		

		/**
		 * 排序
		 * @param a
		 * @param b
		 * @param array
		 * @return
		 */
		private function sortByIndex(a:Object, b:Object, array:Array = null):int
		{
			//改用渲染順序來排序
			if (a.index < b.index )
			{
				return -1;
			}
			else if(a.index > b.index){
				return 1;
			}
			if (a.dataType == 0x09)
			{
				return -1;
			}
			else if (b.dataType == 0x09)
			{
				return 1;
			}
			return 0;
		}
		
		
		public function streamDecode(input:ByteArray):Codec
		{
			if(_hadHeadMeata)
			{
				this._rawData = input;
				return this;
			}
			if(!_waiting)
			{
				if (!probe(input))
					throw new Error('Not a valid MP4 file!');
				this._rawData = input;
				_rawData.position = 0;
				//find moov box
				//直接搜moov解析
			}
			
			this._rawData = input;
			
			
			var size:int;
			var type:int;
			if(_rawData.bytesAvailable < 8)
			{
				return null;
			}
			while (_rawData.bytesAvailable > 8)
			{
				$offset = _rawData.position;
				for(var i:int = 0; i < 4; i++)
				{
					size = (size << 8) + _rawData[$offset + i];
				}
				for(i = 4; i < 8; i++)
				{
					type = (type << 8) + _rawData[$offset + i];
				}
				
				if ($type == Mp4.BOX_TYPE_MOOV || type == Mp4.BOX_TYPE_MOOV)
				{
					if(!_waiting)
					{
						$size = _rawData.readUnsignedInt();
						$type = _rawData.readUnsignedInt();
					}
					if(_rawData.bytesAvailable >= $size - $offset)
					{
						var d:ByteArray = new ByteArray();
						d.writeBytes(_rawData, $offset, $size);
						moovBox = new MoovBox();
						moovBox.size = $size;
						moovBox.position = $offset;
						moovBox.parse(d);
						_rawData.position = $offset;
						break;
					}
					else
					{
						_waiting = true;
						return null;
					}
				}
				else
				{
					if(!_waiting)
					{
						$size = _rawData.readUnsignedInt();
						$type = _rawData.readUnsignedInt();
						_rawData.position = ($offset + $size);
					}
				}
			}
			//
			_duration = moovBox.mvhdBox.duration;
			
			
			//獲取解析的數據
			for (i = 0; i < moovBox.traks.length; i++)
			{
				var trak:TrakBox = moovBox.traks[i] as TrakBox;
				if (trak.trakType == Mp4.TRAK_TYPE_VIDE)
				{
					_hasVideo = true;
					_videoWidth = trak.stsdBox.videoWidth;
					_videoHeight = trak.stsdBox.videoHeight;
					_frameRate = trak.framerate;
					_videoSamples = trak.samples;
					//-- video sps & pps
					_videoConfig = trak.stsdBox.configurationData;
					_keyframes = trak.keyframes;
					_keyframes = [{time:0.0, position:0.0}];//{time:0.0, position:0.0}
				}
				else if (trak.trakType == Mp4.TRAK_TYPE_SOUN)
				{
					_hasAudio = true;
					_audioChannels = trak.stsdBox.audioChannels;
					_audioRate = trak.stsdBox.audioRate;
					_audioSize = trak.stsdBox.audioSize;
					_audioSamples = trak.samples;
					//-- audio spec
					_audioConfig = trak.stsdBox.configurationData;
				}
			}
			//根據時間戳排列幀
			_frames = new Vector.<Frame>();
			if (_videoSamples != null)
			{
				for each(var v:Frame in _videoSamples)
				{
					_frames.push(v);
					if(v.frameType == FlvCodec.VIDEO_FRAME_KEY)
					{
						_keyframes.push({'time': parseFloat((v.timestamp / 1000).toFixed(2)), 'position': 0});		//取得关键帧的时间，下面会重新计算位置
					}
				}
			}
			if (_audioSamples != null)
			{
				for each(var a:Frame in _audioSamples)
				{
					_frames.push(a);
				}
			}
//			_frames.sort(sortByTime);		//按时间大小排序
//			_frames.sort(sortByIndex);		//按索引排序
			_frames.sort(sortOffset);		//按偏移排序
			
			var index:int = 1;
			var ps:uint = 0;
			
			//计算关键帧的偏移量offset 封装flv的时候会把开始位置加上去才是真的position		这里可以考虑改进
			for(i = 0; i < _frames.length; i++)
			{
				if(_frames[i].dataType == FlvCodec.TAG_TYPE_AUDIO)
				{
					ps +=  _frames[i].size + 2 + 15;
				}
				else if(_frames[i].dataType == FlvCodec.TAG_TYPE_VIDEO)
				{
					ps +=  _frames[i].size + 5 + 15;
				}
				else
				{
					trace("错误");
				}
				
				if(_frames[i].frameType == FlvCodec.VIDEO_FRAME_KEY)
				{
					_keyframes[index].position = ps -_frames[i].size - 5;
					index++;
				}
			}
			_hadHeadMeata = true;
			return this;
		}

		/**
		 * 封裝（未完成）
		 * @param input
		 * @return
		 */
		override public function encode(input:Codec):ByteArray
		{
			return null;
		}

		/**
		 * 判斷
		 * @param input
		 * @return
		 */
		public static function probe(input:ByteArray):Boolean
		{
			if (input[4] == 0x66 && input[5] == 0x74 && input[6] == 0x79 && input[7] == 0x70)
				return true;
			return false;
		}
	}
}

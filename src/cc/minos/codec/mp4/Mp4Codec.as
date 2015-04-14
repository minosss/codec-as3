/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/24 15:36
 */
package cc.minos.codec.mp4 {

	import cc.minos.codec.Codec;
	import cc.minos.codec.flv.Frame;
	import cc.minos.codec.mp4.boxs.*;
	import flash.utils.ByteArray;

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
		private function sortByTimestamp(a:Object, b:Object, array:Array = null):int
		{
			if (a.timestamp < b.timestamp)
			{
				return -1;
			}
			else if (a.timestamp > b.timestamp)
			{
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
		 * 解析
		 * @param input
		 * @return
		 */
		override public function decode(input:ByteArray):Codec
		{
			if (!probe(input))
				throw new Error('Not a valid MP4 file!');

			this._rawData = input;
			//find moov box
			//直接搜moov解析
			var offset:uint;
			var size:uint;
			var type:uint;
			_rawData.position = 0;
			while (_rawData.bytesAvailable > 8)
			{
				offset = _rawData.position;
				size = _rawData.readUnsignedInt();
				type = _rawData.readUnsignedInt();
				if (type == Mp4.BOX_TYPE_MOOV)
				{
					var d:ByteArray = new ByteArray();
					d.writeBytes(_rawData, offset, size);
					moovBox = new MoovBox();
					moovBox.size = size;
					moovBox.position = offset;
					moovBox.parse(d);
					break;
				}
				_rawData.position = (offset + size);
			}
			//
			_duration = moovBox.mvhdBox.duration;
			//獲取解析的數據
			for (var i:int = 0; i < moovBox.traks.length; i++)
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
				}
			}
			if (_audioSamples != null)
			{
				for each(var a:Frame in _audioSamples)
				{
					_frames.push(a);
				}
			}
//			_frames.sort(sortByTimestamp);

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

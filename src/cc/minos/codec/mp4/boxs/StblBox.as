/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/9 11:20
 */
package cc.minos.codec.mp4.boxs {

	import cc.minos.codec.mp4.Sample;
	import cc.minos.codec.flv.FlvCodec;
	import cc.minos.codec.mp4.Mp4;

	CONFIG::LOGGING{
		import cc.minos.codec.utils.Log;
	}
	/**
	 * sample table
	 */
	public class StblBox extends Box {

		private var _samples:Vector.<Sample>;

		private var hasKey:Boolean = false;

		private var _stsdBox:StsdBox;
		private var _sttsBox:SttsBox;
		private var _cttsBox:CttsBox;
		private var _stssBox:StssBox;

		public function StblBox()
		{
			super(Mp4.BOX_TYPE_STBL);
		}

		override protected function init():void
		{
			_stsdBox = getBox(Mp4.BOX_TYPE_STSD).shift() as StsdBox;

			//stts
			_sttsBox = getBox(Mp4.BOX_TYPE_STTS).shift() as SttsBox;
			var st:Array = _sttsBox.entries;

			//ctts
			var ct:Array;
			try
			{
				_cttsBox = getBox(Mp4.BOX_TYPE_CTTS).shift() as CttsBox;
				ct = _cttsBox.entries;
			} catch (er:Error)
			{
				CONFIG::LOGGING{
					Log.info("ctts box not found!")
				}
			}

			//stsz
			var sizes:Vector.<uint>;
			try
			{
				var stszBox:StszBox = getBox(Mp4.BOX_TYPE_STSZ).shift() as StszBox;
				sizes = stszBox.sizes;
			} catch (er:Error)
			{
				CONFIG::LOGGING{
					Log.info("sample size list not found!");
				}
				throw new Error("stz2 not parse");
				//stz2 ?
			}
			//stsc
			var entrys:Vector.<Object>;
			var stscBox:StscBox = getBox(Mp4.BOX_TYPE_STSC).shift() as StscBox;
			entrys = stscBox.entrys;

			//stco
			var chunksOffset:Vector.<uint>;
			try
			{
				var stcoBox:StcoBox = getBox(Mp4.BOX_TYPE_STCO).shift() as StcoBox;
				chunksOffset = stcoBox.chunksOffset;
			} catch (er:Error)
			{
				CONFIG::LOGGING{
					Log.info("chunk offset list not found!");
				}
				throw new Error("co64 not parse");
				//co64 ?
			}
			//stss
			var keyframes:Array
			try
			{
				_stssBox = getBox(Mp4.BOX_TYPE_STSS).shift() as StssBox;
				keyframes = _stssBox.keyframes;
				hasKey = true;
			} catch (er:Error)
			{
				CONFIG::LOGGING{
					Log.info('Not found key frames!');
				}
				hasKey = false;
			}

			//chunk -> sample
			var chunk:Vector.<Object> = new Vector.<Object>(chunksOffset.length);
			var lastNum:uint = chunksOffset.length + 1;
			for (var ci:int = entrys.length - 1; ci >= 0; --ci)
			{
				var begin:uint = entrys[ci].first_chk;
				for (var ck:uint = begin - 1; ck < lastNum - 1; ++ck)
				{
					chunk[ck] = {
						'sam_count': entrys[ci].sams_per_chk,  //chunk的sample数量
						'sdi': entrys[ci].sdi
					};
				}
				lastNum = begin;
			}
			//sample -> chunk
			_samples = new Vector.<Sample>();
			var s:Sample;
			var samIndex:uint = 0;
			for (ck = 0; ck < chunk.length; ++ck)
			{
				chunk[ck].first_sam_index = samIndex;
				var chkIndex:uint = 0;
				var offset:uint = chunksOffset[ck];
				for (var si:int = 0; si < chunk[ck].sam_count; ++si)
				{
					s = new Sample();
					s.chunkIndex = ck;
					s.sampleIndex = chkIndex;
					s.offset = offset;
					s.index = samIndex;
					s.size = sizes[samIndex];
					s.timestamp = st[samIndex];
					if (ct)
					{
						s.timestamp += ct[samIndex];
					}
					if (_stsdBox.videoWidth > 0)
					{
						s.dataType = FlvCodec.TAG_TYPE_VIDEO;
						s.frameType = (keyframes.indexOf(samIndex+1) != -1) ? FlvCodec.VIDEO_FRAME_KEY : FlvCodec.VIDEO_FRAME_INTER;
					}
					else
					{
						s.dataType = FlvCodec.TAG_TYPE_AUDIO;
					}
					_samples.push(s);
					offset += sizes[samIndex];
					samIndex++;
					chkIndex++;
				}
			}

			CONFIG::LOGGING{
				Log.info('chunk: ' + chunk.length);
				Log.info('samples: ' + samples.length);
			}
		}

		public function get samples():Vector.<Sample>
		{
			return _samples;
		}

		public function get stsdBox():StsdBox
		{
			return _stsdBox;
		}

		public function get sttsBox():SttsBox
		{
			return _sttsBox;
		}

		public function get stssBox():StssBox
		{
			return _stssBox;
		}
	}
}

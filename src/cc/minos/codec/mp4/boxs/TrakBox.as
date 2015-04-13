/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/8 17:53
 */
package cc.minos.codec.mp4.boxs {

	import cc.minos.codec.mp4.Sample;
	import cc.minos.codec.mp4.Mp4;

	/**
	 * container
	 */
	public class TrakBox extends Box {

		//mdia -> hdlr
		private var _hdlrBox:HdlrBox;
		private var _mdhdBox:MdhdBox;
		//mdia -> minf -> stbl
		private var _stblBox:StblBox;
		//tkhd box
		private var _tkhdBox:TkhdBox;

		public function TrakBox()
		{
			super(Mp4.BOX_TYPE_TRAK);
		}

		override protected function init():void
		{
			//type
			_hdlrBox = getBox(Mp4.BOX_TYPE_HDLR).shift() as HdlrBox;
			_mdhdBox = getBox(Mp4.BOX_TYPE_MDHD).shift() as MdhdBox;
			_tkhdBox = getBox(Mp4.BOX_TYPE_TKHD).shift() as TkhdBox;
			_stblBox = getBox(Mp4.BOX_TYPE_STBL).shift() as StblBox;

			for each(var sample:Sample in _stblBox.samples)
			{
				sample.timestamp = toMillisecond(sample.timestamp);
			}
		}

		public function get trakType():uint
		{
			return _hdlrBox.hdType;
		}

		public function get id():uint
		{
			return _tkhdBox.id;
		}

		public function get duration():uint
		{
			return _tkhdBox.duration;
		}

		public function get volume():uint
		{
			return _tkhdBox.volume;
		}

		public function get width():uint
		{
			return _tkhdBox.width;
		}

		public function get height():uint
		{
			return _tkhdBox.height;
		}

		public function get samples():Vector.<Sample>
		{
			return _stblBox.samples;
		}

		private function toMillisecond(ts:Number):Number
		{
			return ( ts / _mdhdBox.timeScale ) * 1000;
		}

		public function get framerate():Number
		{
			return ( _stblBox.samples.length / ( _mdhdBox.duration / _mdhdBox.timeScale ) );
		}

		public function get stsdBox():StsdBox
		{
			return _stblBox.stsdBox;
		}

		public function get keyframes():Array
		{
			if (_stblBox.stssBox != null)
				return _stblBox.stssBox.keyframes;
			return [];
		}

	}
}

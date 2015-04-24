/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/8 17:31
 */
package cc.minos.codec.mp4.boxs {

	import cc.minos.codec.mp4.Mp4;

	CONFIG::LOGGING{
		import cc.minos.codec.utils.Log;
	}

	public class MoovBox extends Box {

		private var _mvhdBox:MvhdBox;
		private var _traks:Vector.<Box>;

		public function MoovBox()
		{
			super(Mp4.BOX_TYPE_MOOV);
		}

		override protected function init():void
		{
			_mvhdBox = getBox(Mp4.BOX_TYPE_MVHD).shift() as MvhdBox;
			_traks = getBox(Mp4.BOX_TYPE_TRAK);

			CONFIG::LOGGING{
				Log.info('traks: ' + traks.length);
			}
		}

		public function get mvhdBox():MvhdBox
		{
			return _mvhdBox;
		}

		public function get traks():Vector.<Box>
		{
			return _traks;
		}
	}
}

/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/18 14:17
 */
package cc.minos.codec.mp4.boxs {

	import cc.minos.codec.mp4.Mp4;

	public class SttsBox extends Box {

		private var _count:uint;
		private var _entries:Array;

		public function SttsBox()
		{
			super(Mp4.BOX_TYPE_STTS);
		}

		override protected function init():void
		{
			data.position = 12;
			trace('stts =====');
			_count = data.readUnsignedInt();
			_entries = [];
			var sampleCount:uint = 0;
			var sampleOffset:uint = 0;
			var sampleStart:uint = 0;
			for (var i:int = 0; i < _count; i++)
			{
				sampleCount = data.readUnsignedInt();
				sampleOffset = data.readUnsignedInt();
				for (var j:uint = 0; j < sampleCount; j++)
				{
					_entries.push(sampleStart);
					sampleStart += sampleOffset;
				}
			}
		}

		public function get entries():Array
		{
			return _entries;
		}

		public function get count():uint
		{
			return _count;
		}
	}
}

/**
 * ...
 * Created by SiuzukZan<minoscc@gmail.com> on 04/13/2015 19:14
 */
package cc.minos.codec.mp4.boxs {

	import cc.minos.codec.mp4.Mp4;

	public class CttsBox extends Box {

		private var _count:uint;
		private var _entries:Array;

		public function CttsBox()
		{
			super(Mp4.BOX_TYPE_CTTS);
		}

		override protected function init():void
		{
			trace("======== ctts box =======")
			data.position = 12;
			_count = data.readUnsignedInt(); //
			_entries = [];
			var sampleCount:uint = 0;
			var sampleOffset:uint = 0;
			for (var i:int = 0; i < _count; i++)
			{
				sampleCount = data.readUnsignedInt();
				sampleOffset = data.readUnsignedInt();
				for (var j:uint = 0; j < sampleCount; j++)
				{
					_entries.push(sampleOffset);
				}
			}
			trace("ctts sample offset count: " + _entries.length);
		}

		public function get count():uint
		{
			return _count;
		}

		public function get entries():Array
		{
			return _entries;
		}
	}
}

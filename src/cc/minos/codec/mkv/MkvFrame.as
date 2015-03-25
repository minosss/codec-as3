/**
 * ...
 * Created by SiuzukZan<minoscc@gmail.com> on 01/12/2015 17:20
 */
package cc.minos.codec.mkv {

	import cc.minos.codec.flv.Frame;
	import flash.utils.ByteArray;

	public class MkvFrame extends Frame {

		private var _data:ByteArray;

		public function MkvFrame()
		{
			super("mkv");
		}

		public function get data():ByteArray
		{
			return _data;
		}

		public function set data(value:ByteArray):void
		{
			_data = value;
		}
	}
}

/**
 * ...
 * Created by SiuzukZan<minoscc@gmail.com> on 04/17/2015 16:45
 */
package cc.minos.codec {

	import flash.utils.ByteArray;

	public class Binary extends ByteArray {

		private var _bit:int;
		private var _currByte:uint;

		public function Binary(byte:ByteArray)
		{
			super();
			this.writeBytes(byte);
			this.position = 0;
			byte.clear();
			byte = null;
			_bit = -1;
		}

		public function readBit():uint
		{
			var res:uint;
			if (_bit == -1)
			{
				_currByte = this.readByte();
				_bit = 7;
			}
			res = _currByte & (1 << _bit) ? 1 : 0;
			_bit--;
			return res;
		}

		public function readBits(nbBits:uint):int
		{
			var val:int = 0;
			for (var i:uint = 0; i < nbBits; ++i)
				val = (val << 1) + readBit();
			return val;
		}

	}
}

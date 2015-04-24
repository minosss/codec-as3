/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/10 16:17
 */
package cc.minos.codec.utils {

	import flash.utils.ByteArray;

	public class Hex {


		/**
		 *
		 * @param array
		 * @param term
		 * @return
		 */
		public static function byteArrayIndexOf(array:ByteArray, term:ByteArray):int
		{
			var origPosBa:int = array.position;
			var origPosSearchTerm:int = term.position;

			var end:int = array.length - term.length
			for (var i:int = 0; i <= end; i++)
			{
				if (byteArrayEqualsAt(array, term, i))
				{
					array.position = origPosBa;
					term.position = origPosSearchTerm;
					return i;
				}
			}

			array.position = origPosBa;
			term.position = origPosSearchTerm;
			return -1;
		}

		/**
		 *
		 * @param array
		 * @param term
		 * @param pos
		 * @return
		 */
		public static function byteArrayEqualsAt(array:ByteArray, term:ByteArray, pos:int):Boolean
		{
			if (pos + term.length > array.length) return false;

			array.position = pos;
			term.position = 0;

			for (var i:int = 0; i < term.length; i++)
			{
				var valBa:int = array.readByte();
				var valSearch:int = term.readByte();
				if (valBa != valSearch) return false;
			}

			return true;
		}

		/**
		 * 轉utf-8
		 * @param hex
		 * @return
		 */
		public static function toUTF8String(hex:String):String
		{
			var a:ByteArray = toArray(hex);
			return a.readUTFBytes(a.length);
		}

		/**
		 * 字符串(十六進制)轉二進制(ByteArray)
		 * @param hex
		 * @return
		 */
		public static function toArray(hex:String):ByteArray
		{
			hex = hex.replace(/\s|:/gm, '');
			var a:ByteArray = new ByteArray;
			if ((hex.length & 1) == 1) hex = "0" + hex;
			for (var i:uint = 0; i < hex.length; i += 2)
			{
				a[i / 2] = parseInt(hex.substr(i, 2), 16);
			}
			return a;
		}

		/**
		 * 二進制(ByteArray)轉字符串(十六進制)
		 * @param array
		 * @param colons
		 * @return
		 */
		public static function fromArray(array:ByteArray, colons:Boolean = false):String
		{
			var s:String = "";
			var len:uint = array.length;
			for (var i:uint = 0; i < len; i++)
			{
				s += ("0" + array[i].toString(16)).substr(-2, 2);
				if (colons)
				{
					if (i < len - 1) s += ":";
				}
			}
			return s;
		}

	}
}

/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/8 16:36
 */
package cc.minos.codec.mp4.boxs {

	import cc.minos.codec.mp4.Mp4;
	import cc.minos.codec.utils.Hex;

	import flash.utils.ByteArray;

	/**
	 * base box
	 */
	public class Box {

		private var _type:uint = 0x0;
		private var _size:uint = 0;
		private var _position:uint = 0;
		private var _data:ByteArray;
		private var _children:Vector.<Box>;

		public function Box(type:uint)
		{
			this._type = type;
		}

		public function parse(byte:ByteArray):void
		{
			this.data = byte;
			this._children = new Vector.<Box>();

			var size:uint;
			var type:uint;
			var offset:uint;
			var end:uint;
			var box:Box;

			data.position = 0;
			while (data.bytesAvailable > 8)
			{
				offset = data.position;
				size = data.readUnsignedInt();
				type = data.readUnsignedInt();
				if (type === this.type)
				{
					this.size = size;
					decode();
					continue;
				}
				end = offset + size;
				box = Mp4.getBox(type);
				if (box)
				{
					if (size == 1)
					{
						size = data.readDouble();
						end = offset + size;
					}
					box.size = size;
					box.position = offset;
					var d:ByteArray = new ByteArray();
					d.writeBytes(data, offset, size);
					box.parse(d);
					_children.push(box);
				}else{
					break;
				}
				data.position = end;
			}
			init();
		}

		/** **/
		protected function decode():void
		{
		}

		/**  **/
		protected function init():void
		{
		}

		/**
		 *
		 * @param type : uint
		 * @return Vector.<Box>
		 */
		public function getBox(type:uint):Vector.<Box>
		{
			var boxs:Vector.<Box> = new Vector.<Box>();
			if (_children.length > 0)
			{
				for each(var b:Box in _children)
				{
					if (b.type === type)
						boxs.push(b);
					else if (boxs.length == 0 && b.children.length > 0)
					{
						boxs = b.getBox(type);
						if (boxs.length > 0)
						{
							return boxs;
						}
					}
				}
			}
			return boxs;
		}

		public function get size():uint
		{
			return _size;
		}

		public function set size(value:uint):void
		{
			_size = value;
		}

		public function get position():uint
		{
			return _position;
		}

		public function set position(value:uint):void
		{
			_position = value;
		}

		public function get data():ByteArray
		{
			return _data;
		}

		public function set data(value:ByteArray):void
		{
			_data = value;
		}

		public function get type():uint
		{
			return _type;
		}

		public function get children():Vector.<Box>
		{
			return _children;
		}

		public function toString():String
		{
			return '[ ' + Hex.toUTF8String(type.toString(16)) + ' Box, size: ' + size + ' ]';
		}

		/*public static function findBox( data:ByteArray, type:uint ):Box
		 {
		 var byte:ByteArray = new ByteArray();
		 byte.writeUnsignedInt(type);
		 var index:int = ByteArrayUtil.byteArrayIndexOf(data, byte);
		 if(index != -1)
		 {
		 byte.clear();
		 data.position = index - 4;
		 var size:int = data.readUnsignedInt();
		 byte.writeBytes(data, index - 4, size);
		 var box:Box = Mp4.getBox(type);
		 box.parse(byte);
		 box.position = index - 4;
		 return box;
		 }
		 return null;
		 }*/

	}
}
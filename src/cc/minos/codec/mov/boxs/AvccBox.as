/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/10 15:56
 */
package cc.minos.codec.mov.boxs {

	import cc.minos.codec.mov.Mp4;

	import flash.utils.ByteArray;

	/**
	 * h264 codec
	 */
	public class AvccBox extends Box {

		private var _configurationData:ByteArray;

		public function AvccBox()
		{
			super(Mp4.BOX_TYPE_AVCC);
		}

		override protected function init():void
		{
			trace('avcC box ============= ');
			data.position = 0;
			trace('size: ' + data.readUnsignedInt());
			trace('type: ' + data.readUnsignedInt().toString(16));
			//==============
			trace('version: ' + data.readByte());
			trace('profile: ' + data.readUnsignedByte());
			trace('compatible: ' + data.readByte());
			trace('level: ' + data.readUnsignedByte());
			trace('size: ' + (1 + ( data.readByte() & 0x3 )));
			trace('sps num: ' + (data.readByte() & 0x1F ));
			var l:uint = data.readUnsignedShort();
			trace('sps length: ' + l);
			data.position += l;
			trace('pps num: ' + data.readUnsignedByte());
			trace('pps length: ' + data.readUnsignedShort());

			_configurationData = new ByteArray();
			_configurationData.writeBytes(data, 8, data.length - 8);
		}

		public function get configurationData():ByteArray
		{
			return _configurationData;
		}
	}
}

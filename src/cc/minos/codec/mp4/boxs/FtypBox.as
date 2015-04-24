/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/8 16:41
 */
package cc.minos.codec.mp4.boxs {

	import cc.minos.codec.mp4.Mp4;

	CONFIG::LOGGING{
		import cc.minos.codec.utils.Log;
	}

	public class FtypBox extends Box {

		private var _majorBrand:String;
		private var _minorVersion:uint;
		private var _compatibleBrands:Array;

		public function FtypBox()
		{
			super(Mp4.BOX_TYPE_FTYP);
		}

		override protected function init():void
		{
			data.position = 8;
			_majorBrand = data.readUTFBytes(4);
			_minorVersion = data.readUnsignedInt();
			_compatibleBrands = [];
			while (data.bytesAvailable >= 4)
			{
				_compatibleBrands.push(data.readUTFBytes(4));
			}

			CONFIG::LOGGING{
				Log.info('[ftyp]');
				Log.info('majorBrand: ' + _majorBrand);
				Log.info('minorVersion: ' + _minorVersion);
				Log.info('brands: ' + _compatibleBrands);
			}
		}

		public function get majorBrand():String
		{
			return _majorBrand;
		}

		public function get minorVersion():uint
		{
			return _minorVersion;
		}
	}
}

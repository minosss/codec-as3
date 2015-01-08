/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/8 16:41
 */
package cc.minos.codec.mov.boxs {
    import cc.minos.codec.mov.Mp4;

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
            //
            trace( 'ftyp box ===== ');

            data.position = 8;
            _majorBrand = data.readUTFBytes(4);
            _minorVersion = data.readUnsignedInt();

            trace('majorBrand: ' + _majorBrand);
            trace('minorVersion: ' + _minorVersion );

            _compatibleBrands = [];
            while( data.bytesAvailable >= 4)
            {
                _compatibleBrands.push(data.readUTFBytes(4));
            }
            trace('brands: ' + _compatibleBrands );

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

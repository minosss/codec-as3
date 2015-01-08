/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/8 17:41
 */
package cc.minos.codec.mov.boxs {
    import cc.minos.codec.mov.Mp4;

    public class MvhdBox extends Box {

        private var _timescale:uint = 600;
        private var _duration:uint = 0;
        private var _version:uint = 0;

        public function MvhdBox()
        {
            super( Mp4.BOX_TYPE_MVHD );
        }

        override protected function init():void
        {
            data.position = 8; //size, type
            _version = data.readUnsignedByte(); //version
            data.position += 3; //flags
            if( _version == 0 )
            {
                //32
                data.readUnsignedInt(); //creation time
                data.readUnsignedInt(); //modification time
                _timescale = data.readUnsignedInt();
                _duration = data.readUnsignedInt();
            }
            else if( _version == 1 )
            {
                //64
            }
        }

        /**
         * second
         */
        public function get duration():Number
        {
            return _duration / _timescale;
        }

        /**
         * default: 600
         */
        public function get timescale():uint
        {
            return _timescale;
        }
    }
}

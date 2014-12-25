/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/10 14:16
 */
package cc.minos.codec.mp4.boxs {
    import cc.minos.codec.mp4.MP4Constants;

    public class HdlrBox extends Box {

        private var _hdType:uint;

        public function HdlrBox()
        {
            super(MP4Constants.BOX_TYPE_HDLR);
        }

        override protected function init():void
        {
            data.position = 16;
            _hdType = data.readUnsignedInt();
            if( _hdType === MP4Constants.TRAK_TYPE_VIDE )
            {
            }
            else if( _hdType === MP4Constants.TRAK_TYPE_SOUN )
            {
            }
        }

        public function get hdType():uint
        {
            return _hdType;
        }
    }
}

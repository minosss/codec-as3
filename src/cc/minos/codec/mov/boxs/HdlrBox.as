/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/10 14:16
 */
package cc.minos.codec.mov.boxs {
    import cc.minos.codec.mov.MovConstants;

    public class HdlrBox extends Box {

        private var _hdType:uint;

        public function HdlrBox()
        {
            super(MovConstants.BOX_TYPE_HDLR);
        }

        override protected function init():void
        {
            data.position = 16;
            _hdType = data.readUnsignedInt();
            if( _hdType === MovConstants.TRAK_TYPE_VIDE )
            {
            }
            else if( _hdType === MovConstants.TRAK_TYPE_SOUN )
            {
            }
        }

        public function get hdType():uint
        {
            return _hdType;
        }
    }
}

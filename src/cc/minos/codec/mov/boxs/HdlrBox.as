/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/10 14:16
 */
package cc.minos.codec.mov.boxs {
    import cc.minos.codec.mov.Mp4;

    public class HdlrBox extends Box {

        private var _hdType:uint;

        public function HdlrBox()
        {
            super(Mp4.BOX_TYPE_HDLR);
        }

        override protected function init():void
        {
            data.position = 16;
            _hdType = data.readUnsignedInt();
            if( _hdType === Mp4.TRAK_TYPE_VIDE )
            {
            }
            else if( _hdType === Mp4.TRAK_TYPE_SOUN )
            {
            }
        }

        public function get hdType():uint
        {
            return _hdType;
        }
    }
}

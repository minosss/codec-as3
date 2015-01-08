/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/8 17:31
 */
package cc.minos.codec.mov.boxs {
    import cc.minos.codec.mov.MovConstants;

    public class MoovBox extends Box {

        private var _mvhdBox:MvhdBox;
        private var _traks:Vector.<Box>;

        public function MoovBox()
        {
            super( MovConstants.BOX_TYPE_MOOV );
        }

        override protected function init():void
        {
            trace('moov ======' );
            _mvhdBox = getBox( MovConstants.BOX_TYPE_MVHD ).shift() as MvhdBox;
            _traks = getBox( MovConstants.BOX_TYPE_TRAK );

            trace('streams: ' + _traks.length );
        }

        public function get mvhdBox():MvhdBox
        {
            return _mvhdBox;
        }

        public function get traks():Vector.<Box>
        {
            return _traks;
        }
    }
}

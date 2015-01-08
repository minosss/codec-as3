/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/18 14:17
 */
package cc.minos.codec.mov.boxs {
    import cc.minos.codec.mov.Mp4;

    public class SttsBox extends Box {

        private var _count:uint;
        private var _delta:uint;

        public function SttsBox()
        {
            super(Mp4.BOX_TYPE_STTS);
        }

        override protected function init():void
        {
            data.position = 16;
            trace('stts =====' );
            //count
            _count = data.readUnsignedInt();
            //delta
            _delta = data.readUnsignedInt();
            trace('count: ' + _count, 'delta: ' + _delta );
        }

        public function get delta():uint
        {
            return _delta;
        }

        public function get count():uint
        {
            return _count;
        }
    }
}

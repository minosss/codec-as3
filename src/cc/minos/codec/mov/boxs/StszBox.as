/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/10 14:50
 */
package cc.minos.codec.mov.boxs {
    import cc.minos.codec.mov.Mp4;

    /**
     * sample size list
     */
    public class StszBox extends Box {

        private var _sizes:Vector.<uint> = new Vector.<uint>();
        private var _constantSize:uint;
        private var _count:uint;

        public function StszBox()
        {
            super(Mp4.BOX_TYPE_STSZ);
        }

        override protected function init():void
        {
            data.position = 12;
            _constantSize = data.readUnsignedInt();
            _count = data.readUnsignedInt();
            for(var i:int=0; i<_count; i++ )
            {
                _sizes.push(data.readUnsignedInt());
            }
        }

        public function get constantSize():uint
        {
            return _constantSize;
        }

        public function get count():uint
        {
            return _count;
        }

        public function get sizes():Vector.<uint>
        {
            return _sizes;
        }
    }
}

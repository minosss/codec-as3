/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/10 14:59
 */
package cc.minos.codec.mov.boxs {
    import cc.minos.codec.mov.Mp4;

    /**
     * chunk offset
     */
    public class StcoBox extends Box {

        private var _count:uint;
        private var _chunksOffset:Vector.<uint> = new Vector.<uint>();

        public function StcoBox()
        {
            super(Mp4.BOX_TYPE_STCO);
        }

        override protected function init():void
        {
            data.position = 12;
            _count = data.readUnsignedInt();
            for(var i:int =0;i<_count;i++)
            {
                _chunksOffset.push(data.readUnsignedInt());
            }
        }

        public function get chunksOffset():Vector.<uint>
        {
            return _chunksOffset;
        }

        public function get count():uint
        {
            return _count;
        }
    }
}

/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/10 14:55
 */
package cc.minos.codec.mov.boxs {
    import cc.minos.codec.mov.Mp4;

    /**
     * sample to chunk
     */
    public class StscBox extends Box {

        private var _count:uint;
        private var _entrys:Vector.<Object> = new Vector.<Object>();

        public function StscBox()
        {
            super(Mp4.BOX_TYPE_STSC);
        }

        override protected function init():void
        {
//            trace('stsc ======');
            data.position = 12;
            _count = data.readUnsignedInt();
            for(var i:int = 0; i < _count; i++)
            {
                _entrys.push({
                    'first_chk': data.readUnsignedInt(),
                    'sams_per_chk': data.readUnsignedInt(),
                    'sdi': data.readUnsignedInt()
                })
            }
//            trace('entrys: ' + entrys.length );
        }

        public function get entrys():Vector.<Object>
        {
            return _entrys;
        }

        public function get count():uint
        {
            return _count;
        }
    }
}

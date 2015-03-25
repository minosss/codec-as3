/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/30 17:32
 */
package cc.minos.codec.mkv.elements {
    import cc.minos.codec.mkv.Mkv;

    public class Cues extends Element {
        public function Cues()
        {
            super(Mkv.CUES);
        }

        override protected function getElement(type:uint):Element
        {
            switch (type)
            {
                case Mkv.CUES_CUE_POINT:
                    return new CuePoint();
            }
            return super.getElement(type);
        }

        override protected function init():void
        {
            trace('cues: ' + toString() );
            trace('children: ' + children.length );
//            trace((children[0].children[0].getInt()));
//            trace(toHex(children[0].children[1].children[0].data)); //track number
//            trace((children[0].children[1].children[1].getInt()));
        }
    }
}

/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/30 17:32
 */
package cc.minos.codec.matroska.elements {
    import cc.minos.codec.matroska.Matroska;

    public class Cues extends Element {
        public function Cues()
        {
            super(Matroska.CUES);
        }

        override protected function getElement(type:uint):Element
        {
            switch (type)
            {
                case Matroska.CUES_CUE_POINT:
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

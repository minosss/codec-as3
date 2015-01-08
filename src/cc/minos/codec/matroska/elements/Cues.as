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
            super(cc.minos.codec.matroska.Matroska.CUES);
        }

        override protected function getElement(type:uint):Element
        {
            switch (type)
            {
                case cc.minos.codec.matroska.Matroska.CUES_CUE_POINT:
                    return new CuePoint();
            }
            return super.getElement(type);
        }

        override protected function init():void
        {
            trace('cues: ' + toString() );
        }
    }
}

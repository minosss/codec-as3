/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/30 17:33
 */
package cc.minos.codec.matroska.elements {
    import cc.minos.codec.matroska.Matroska;

    public class CuePoint extends Element {

        public function CuePoint()
        {
            super(Matroska.CUES_CUE_POINT);
        }

        override protected function getElement(type:uint):Element
        {
            switch (type)
            {
                case Matroska.POINT_CUE_TIME:
                    return new VarElement(type);
                case Matroska.POINT_CUE_TRACK_POSITIONS:
                    return new CuePosition();
            }
            return super.getElement(type);
        }

    }
}

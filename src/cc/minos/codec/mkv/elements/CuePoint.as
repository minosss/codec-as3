/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/30 17:33
 */
package cc.minos.codec.mkv.elements {
    import cc.minos.codec.mkv.Mkv;

    public class CuePoint extends Element {

        public function CuePoint()
        {
            super(Mkv.CUES_CUE_POINT);
        }

        override protected function getElement(type:uint):Element
        {
            switch (type)
            {
                case Mkv.POINT_CUE_TIME:
                    return new VarElement(type);
                case Mkv.POINT_CUE_TRACK_POSITIONS:
                    return new CuePosition();
            }
            return super.getElement(type);
        }

    }
}

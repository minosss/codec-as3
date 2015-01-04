/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/30 17:33
 */
package cc.minos.codec.matroska.elements {
    import cc.minos.codec.matroska.MaConstans;

    public class CuePoint extends Element {
        public function CuePoint()
        {
            super(MaConstans.CUES_CUE_POINT);
        }

        override protected function getElement(type:uint):Element
        {
            switch (type)
            {
                case MaConstans.POINT_CUE_TIME:
                case MaConstans.POINT_CUE_TRACK_POSITIONS:
                    return new VarElement(type);
            }
            return super.getElement(type);
        }
    }
}

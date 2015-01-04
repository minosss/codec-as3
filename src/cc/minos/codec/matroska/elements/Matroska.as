/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/30 16:47
 */
package cc.minos.codec.matroska.elements {
    import cc.minos.codec.matroska.MaConstans;

    public class Matroska extends Element {

        public function Matroska()
        {
            super(0x528802);
        }

        override protected function getElement(type:uint):Element
        {
            switch (type)
            {
                case MaConstans.EBML_ID:
                    return new EbmlHeader();
                case MaConstans.SEGMENT_ID:
                    return new Segment();
            }
            return super.getElement(type);
        }
    }
}

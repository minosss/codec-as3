/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/30 16:47
 */
package cc.minos.codec.matroska.elements {
    import cc.minos.codec.matroska.Matroska;

    public class MatroskaElement extends Element {

        public function MatroskaElement()
        {
            super(0x528802);
        }

        override protected function getElement(type:uint):Element
        {
            switch (type)
            {
                case Matroska.EBML_ID:
                    return new EbmlHeader();
                case Matroska.SEGMENT_ID:
                    return new Segment();
            }
            return super.getElement(type);
        }
    }
}

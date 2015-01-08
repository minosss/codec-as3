/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/30 17:15
 */
package cc.minos.codec.matroska.elements {
    import cc.minos.codec.matroska.Matroska;

    public class ContentEncodings extends Element {
        public function ContentEncodings()
        {
            super(cc.minos.codec.matroska.Matroska.CONTENT_ENCODINGS);
        }

        override protected function getElement(type:uint):Element
        {
            switch (type)
            {
                case cc.minos.codec.matroska.Matroska.CONTENT_ENCODING:
                    return new ContentEncoding();
            }
            return super.getElement(type);
        }
    }
}

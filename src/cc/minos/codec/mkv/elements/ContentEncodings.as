/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/30 17:15
 */
package cc.minos.codec.mkv.elements {
    import cc.minos.codec.mkv.Mkv;

    public class ContentEncodings extends Element {
        public function ContentEncodings()
        {
            super(Mkv.CONTENT_ENCODINGS);
        }

        override protected function getElement(type:uint):Element
        {
            switch (type)
            {
                case Mkv.CONTENT_ENCODING:
                    return new ContentEncoding();
            }
            return super.getElement(type);
        }

    }
}

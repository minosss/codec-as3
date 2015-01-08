/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/30 17:18
 */
package cc.minos.codec.matroska.elements {
    import cc.minos.codec.matroska.Matroska;

    public class ContentEncoding extends Element {
        public function ContentEncoding()
        {
            super(cc.minos.codec.matroska.Matroska.CONTENT_ENCODING);
        }

        override protected function getElement(type:uint):Element
        {
            switch (type)
            {
                case cc.minos.codec.matroska.Matroska.CONTENT_ENCODING_ORDER:
                case cc.minos.codec.matroska.Matroska.CONTENT_ENCODING_SCOPE:
                case cc.minos.codec.matroska.Matroska.CONTENT_ENCODING_TYPE:
                case cc.minos.codec.matroska.Matroska.CONTENT_COMPRESSION:
                case cc.minos.codec.matroska.Matroska.CONTENT_ENCRYPTION:
                    return new VarElement(type);
            }
            return super.getElement(type);
        }
    }
}

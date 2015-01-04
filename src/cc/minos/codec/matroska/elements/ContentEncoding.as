/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/30 17:18
 */
package cc.minos.codec.matroska.elements {
    import cc.minos.codec.matroska.MaConstans;

    public class ContentEncoding extends Element {
        public function ContentEncoding()
        {
            super(MaConstans.CONTENT_ENCODING);
        }

        override protected function getElement(type:uint):Element
        {
            switch (type)
            {
                case MaConstans.CONTENT_ENCODING_ORDER:
                case MaConstans.CONTENT_ENCODING_SCOPE:
                case MaConstans.CONTENT_ENCODING_TYPE:
                case MaConstans.CONTENT_COMPRESSION:
                case MaConstans.CONTENT_ENCRYPTION:
                    return new VarElement(type);
            }
            return super.getElement(type);
        }
    }
}

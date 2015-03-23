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
            super(Matroska.CONTENT_ENCODING);
        }

        override protected function getElement(type:uint):Element
        {
            switch (type)
            {
                case Matroska.CONTENT_ENCODING_ORDER:
                case Matroska.CONTENT_ENCODING_SCOPE:
                case Matroska.CONTENT_ENCODING_TYPE:
                case Matroska.CONTENT_COMPRESSION:
                case Matroska.CONTENT_ENCRYPTION:
                    return new VarElement(type);
            }
            return super.getElement(type);
        }

        override protected function init():void
        {
            trace('content encoding <');
            trace('content encoding end. children: ' + children.length );
        }
    }
}

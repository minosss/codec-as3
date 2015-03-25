/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/30 17:18
 */
package cc.minos.codec.mkv.elements {
    import cc.minos.codec.mkv.Mkv;

    public class ContentEncoding extends Element {
        public function ContentEncoding()
        {
            super(Mkv.CONTENT_ENCODING);
        }

        override protected function getElement(type:uint):Element
        {
            switch (type)
            {
                case Mkv.CONTENT_ENCODING_ORDER:
                case Mkv.CONTENT_ENCODING_SCOPE:
                case Mkv.CONTENT_ENCODING_TYPE:
                case Mkv.CONTENT_COMPRESSION:
                case Mkv.CONTENT_ENCRYPTION:
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

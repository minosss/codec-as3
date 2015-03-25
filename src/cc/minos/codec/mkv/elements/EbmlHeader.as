/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/29 10:02
 */
package cc.minos.codec.mkv.elements {
    import cc.minos.codec.mkv.Mkv;
    import cc.minos.codec.mkv.Mkv;

    public class EbmlHeader extends Element {

        public function EbmlHeader()
        {
            super(Mkv.EBML_ID);
        }

        override protected function init():void
        {
            trace( 'ebml header', type.toString(16), size );

            //ebml version
            //ebml read version
            //ebml max id length
            //ebml max size length
            //doc type
            trace('doc type: ' + getChildByType(Mkv.EBML_DOC_TYPE)[0].getString() );
            //doc version
            //doc read version
            trace('ebml header end. children: ' + children.length);
        }

        override protected function getElement(type:uint):Element
        {
            switch (type)
            {
                case Mkv.EBML_VERSION:
                case Mkv.EBML_READ_VERSION:
                case Mkv.EBML_MAX_ID_LENGTH:
                case Mkv.EBML_MAX_SIZE_LENGTH:
                case Mkv.EBML_DOC_TYPE:
                case Mkv.EBML_DOC_TYPE_VERSION:
                case Mkv.EBML_DOC_TYPE_READ_VERSION:
                    return new VarElement(type);
                    break;
            }
            return super .getElement(type);
        }
    }
}

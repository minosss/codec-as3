/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/29 10:02
 */
package cc.minos.codec.matroska.elements {
    import cc.minos.codec.matroska.MaConstans;
    import cc.minos.codec.matroska.MaConstans;

    public class EbmlHeader extends Element {

        public function EbmlHeader()
        {
            super(MaConstans.EBML_ID);
        }

        override protected function init():void
        {
            trace( 'header ====== ', type.toString(16), size );

            //ebml version

            //ebml read version

            //ebml max id length

            //ebml max size length

            //doc type

            //doc version

            //doc read version
            trace('childs: ' + childs.length);
        }

        override protected function getElement(type:uint):Element
        {
            switch (type)
            {
                case MaConstans.EBML_VERSION:
                case MaConstans.EBML_READ_VERSION:
                case MaConstans.EBML_MAX_ID_LENGTH:
                case MaConstans.EBML_MAX_SIZE_LENGTH:
                case MaConstans.EBML_DOC_TYPE:
                case MaConstans.EBML_DOC_TYPE_VERSION:
                case MaConstans.EBML_DOC_TYPE_READ_VERSION:
                    return new VarElement(type);
                    break;
            }
            return super .getElement(type);
        }
    }
}

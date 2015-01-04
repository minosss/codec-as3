/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/30 17:05
 */
package cc.minos.codec.matroska.elements {
    import cc.minos.codec.matroska.MaConstans;

    public class SeekHead extends Element {

        public function SeekHead()
        {
            super(MaConstans.SEEK_HEAD);
        }

        override protected function getElement(type:uint):Element
        {
            switch (type)
            {
                case MaConstans.SEEK:
                    return new Seek();
            }
            return super.getElement(type);
        }
    }
}

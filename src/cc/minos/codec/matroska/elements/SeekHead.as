/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/30 17:05
 */
package cc.minos.codec.matroska.elements {
    import cc.minos.codec.matroska.Matroska;

    public class SeekHead extends Element {

        public function SeekHead()
        {
            super(cc.minos.codec.matroska.Matroska.SEEK_HEAD);
        }

        override protected function getElement(type:uint):Element
        {
            switch (type)
            {
                case cc.minos.codec.matroska.Matroska.SEEK:
                    return new Seek();
            }
            return super.getElement(type);
        }
    }
}

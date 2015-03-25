/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/30 17:05
 */
package cc.minos.codec.mkv.elements {
    import cc.minos.codec.mkv.Mkv;

    public class SeekHead extends Element {

        public function SeekHead()
        {
            super(Mkv.SEEK_HEAD);
        }

        override protected function getElement(type:uint):Element
        {
            switch (type)
            {
                case Mkv.SEEK:
                    return new Seek();
            }
            return super.getElement(type);
        }
    }
}

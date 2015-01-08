/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/9 10:10
 */
package cc.minos.codec.mov.boxs {
    import cc.minos.codec.mov.Mp4;

    public class MdatBox extends Box {

        public function MdatBox()
        {
            super(Mp4.BOX_TYPE_MDAT);
        }

        override protected function init():void
        {
        }
    }
}

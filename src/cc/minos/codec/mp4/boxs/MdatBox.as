/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/9 10:10
 */
package cc.minos.codec.mp4.boxs {
    import cc.minos.codec.mp4.MP4Constants;

    public class MdatBox extends Box {

        public function MdatBox()
        {
            super(MP4Constants.BOX_TYPE_MDAT);
        }

        override protected function init():void
        {
        }
    }
}

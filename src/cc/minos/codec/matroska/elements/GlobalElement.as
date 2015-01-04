/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/30 11:23
 */
package cc.minos.codec.matroska.elements {
    import flash.utils.ByteArray;

    public class GlobalElement extends Element {

        public function GlobalElement(type:uint)
        {
            super(type);
        }

        override public function parse(bytes:ByteArray):void
        {
        }
    }
}

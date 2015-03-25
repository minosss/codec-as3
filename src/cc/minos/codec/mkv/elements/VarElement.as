/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/30 16:30
 */
package cc.minos.codec.mkv.elements {
    import flash.utils.ByteArray;

    public class VarElement extends Element {

        public function VarElement(type:uint)
        {
            super(type);
        }

        override public function parse(bytes:ByteArray):void
        {
            _data = bytes;
            _children = new Vector.<Element>();
        }
    }
}

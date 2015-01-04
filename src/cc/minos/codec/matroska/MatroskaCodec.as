/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/29 11:05
 */
package cc.minos.codec.matroska {

    import cc.minos.codec.Codec;
    import cc.minos.codec.ICodec;
    import cc.minos.codec.matroska.elements.Matroska;
    import flash.utils.ByteArray;

    /**
     * ...
     * @link http://www.matroska.org/
     * @link http://www.matroska.org/files/matroska.pdf
     */
    public class MatroskaCodec extends Codec {

        public function MatroskaCodec()
        {
            super('matroska');
        }

        override public function decode(input:ByteArray):ICodec
        {
            //
            this._rawData = input;

            var m:Matroska = new Matroska();
            m.parse(_rawData);

            return this;
        }


    }
}

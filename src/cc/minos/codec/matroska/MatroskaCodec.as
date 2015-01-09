/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/29 11:05
 */
package cc.minos.codec.matroska {

    import cc.minos.codec.Codec;
    import cc.minos.codec.ICodec;
    import cc.minos.codec.matroska.elements.EbmlHeader;
    import cc.minos.codec.matroska.elements.Element;
    import cc.minos.codec.matroska.elements.Segment;

    import flash.utils.ByteArray;

    /**
     * ...
     * @link http://www.matroska.org/
     * @link http://www.matroska.org/files/matroska.pdf
     */
    public class MatroskaCodec extends Codec {

        private var ebml:EbmlHeader;
        private var segment:Segment;

        public function MatroskaCodec()
        {
            _name = "matroska,webm";
            _extensions = "mkv,mka,webm";
            _mimeType = "video/x-matroska,audio/x-matroska,video/webm,audio/webm";
        }

        override public function decode(input:ByteArray):ICodec
        {
            //
            this._rawData = input;

            _rawData.position = 0;

            var id:uint;
            var size:uint;
            var d:ByteArray;
            while(_rawData.bytesAvailable > 0)
            {
                id = Element.toHex(step());
                d = step();
                size = Element.getSize(d, d.length);
                d.length = 0;
                d.writeBytes( _rawData, _rawData.position, size );
                if( id == Matroska.EBML_ID )
                {
                    ebml = new EbmlHeader();
                    ebml.size = d.length;
                    ebml.parse(d);
                }
                else if( id == Matroska.SEGMENT_ID )
                {
                    segment = new Segment();
                    segment.size = d.length;
                    segment.parse(d);
                }
                _rawData.position += size;
            }

            return this;
        }

        private function step():ByteArray
        {
            var b:ByteArray = null;
            var l:uint;
            var p:uint;
            if( _rawData.bytesAvailable > 0 )
            {
                p = _rawData.position;
                l = Element.getLength(_rawData.readUnsignedByte());
                if( _rawData.bytesAvailable > (l-1) )
                {
                    b = new ByteArray();
                    b.writeBytes(_rawData, p, l);
                    _rawData.position = p + l;
                }
            }
            return b;
        }

    }
}

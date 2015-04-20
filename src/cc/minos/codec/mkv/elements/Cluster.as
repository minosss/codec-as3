/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/30 17:21
 */
package cc.minos.codec.mkv.elements {

    import cc.minos.codec.mkv.Mkv;
    import cc.minos.codec.mkv.MkvFrame;

    import flash.utils.ByteArray;

    public class Cluster extends Element {

        private var _timeCode:uint;
        private var _frames:Vector.<MkvFrame>;

        public function Cluster()
        {
            super(Mkv.CLUSTER);
        }

        override protected function getElement(type:uint):Element
        {
            switch (type)
            {
                case Mkv.CLUSTER_TIMECODE:
                case Mkv.CLUSTER_POSITION:
                case Mkv.CLUSTER_PREV_SIZE:
                case Mkv.CLUSTER_BLOCK_GROUP:
                case Mkv.CLUSTER_SIMPLE_BLOCK:
                    return new VarElement(type);
            }
            return super.getElement(type);
        }

        override protected function init():void
        {
//            trace('cluster: ' + toString() );
            _frames = new Vector.<MkvFrame>();
            for(var i:int =0;i<children.length;i++)
            {
                if( children[i].type == Mkv.CLUSTER_TIMECODE )
                {
                    _timeCode = children[i].getInt();
                }
                else if([children[i].type == Mkv.CLUSTER_SIMPLE_BLOCK])
                {
                    _frames.push(parseSimpleBlock(children[i], i));
                }
            }
        }

        private function parseSimpleBlock(element:Element, index:uint):MkvFrame
        {
            var f:MkvFrame = new MkvFrame();
            var d:ByteArray = element.data;
            d.position = 0;

            var track_number:uint = d.readByte() & 0xF;
            var time_code:uint = d.readShort(); //

            var flags:uint = d.readUnsignedByte();

            var frame_type:uint = flags >> 7;
            var lacing:uint = flags >> 1 & 0x3;

            if( lacing == 0 ) //no lacing
            {
                //no lacing
                f.timestamp = _timeCode + time_code; // ms
                f.index = index;
                f.dataType = track_number == 1 ? 0x09 : 0x08;
                f.frameType = frame_type == 1 ? (1<<4) : (2<<4);
                f.codecId = 7;
                var b:ByteArray = new ByteArray();
//                b.writeBytes( d, 4, d.length - 4 );
                f.data = b;
                f.size = f.data.length;

                if( track_number == 1)
                {
                    var k:uint = d.readByte();
                    trace('[VP8] ---- ');
                    trace('key: ' + !Boolean(k & ( 1<< 0)));
                    trace('show: ' + Boolean(k & (1 << 4)));
                    var part:ByteArray = new ByteArray();
                    part.writeBytes(d, 4, 3);
                    trace('pl: ' + (InterpretLittleEndian(part, 3) >> 5 ));
                }
            }
            return f;
        }

        private function InterpretLittleEndian(data:ByteArray, i:int):int
        {
            var tmp:int = 0;
            while(i)
            {
                tmp += data[i-1] << 8 * (i-1);
                i--;
            }
            return tmp;
        }

        public function get frames():Vector.<MkvFrame>
        {
            return _frames;
        }
    }
}

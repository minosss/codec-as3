/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/29 17:48
 */
package cc.minos.codec.mkv.elements {

    import cc.minos.codec.mkv.Mkv;

    public class Segment extends Element {

        private var _info:SegmentInfo;

        public function Segment()
        {
            super(Mkv.SEGMENT_ID);
        }

        override protected function init():void
        {
            trace('segment', 'id: ' + type.toString(16), 'size: ' + size);
            trace('segment end. children: ' + children.length);
        }

        override protected function getElement(type:uint):Element
        {
            switch(type)
            {
                case Mkv.SEEK_HEAD:
                    return new SeekHead();
                case Mkv.SEGMENT_INFO:
                    _info =new SegmentInfo();
                    return _info;
                case Mkv.TRACKS:
                    return new SegmentTracks();
                case Mkv.CLUSTER:
                    return new Cluster();
                case Mkv.CUES:
                    return new Cues();
            }
            return super .getElement(type);
        }

        public function get info():SegmentInfo
        {
            return _info;
        }
    }
}

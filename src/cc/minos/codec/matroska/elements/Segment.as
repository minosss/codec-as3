/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/29 17:48
 */
package cc.minos.codec.matroska.elements {
    import cc.minos.codec.matroska.Matroska;

    public class Segment extends Element {

        public function Segment()
        {
            super(Matroska.SEGMENT_ID);
        }

        override protected function init():void
        {
            trace('segment', 'id: ' + type.toString(16), 'size: ' + size);
            //
            trace('segment end. children: ' + children.length);
        }

        override protected function getElement(type:uint):Element
        {
            switch(type)
            {
                case Matroska.SEEK_HEAD:
                    return new SeekHead();
                case Matroska.SEGMENT_INFO:
                    return new SegmentInfo();
                case Matroska.TRACKS:
                    return new SegmentTracks();
                case Matroska.CLUSTER:
                    return new Cluster();
                case Matroska.CUES:
                    return new Cues();
            }
            return super .getElement(type);
        }
    }
}

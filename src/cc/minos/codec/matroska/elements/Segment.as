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
            super(cc.minos.codec.matroska.Matroska.SEGMENT_ID);
        }

        override protected function init():void
        {
            trace('segment===', type.toString(16), size);
            //
            trace('childs: ' + childs.length);
        }

        override protected function getElement(type:uint):Element
        {
            switch(type)
            {
                case cc.minos.codec.matroska.Matroska.SEEK_HEAD:
                    return new SeekHead();
                case cc.minos.codec.matroska.Matroska.SEGMENT_INFO:
                    return new SegmentInfo();
                case cc.minos.codec.matroska.Matroska.TRACKS:
                    return new SegmentTracks();
                case cc.minos.codec.matroska.Matroska.CLUSTER:
                    return new Cluster();
                case cc.minos.codec.matroska.Matroska.CUES:
                    return new Cues();
            }
            return super .getElement(type);
        }
    }
}

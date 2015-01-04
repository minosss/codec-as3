/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/29 17:48
 */
package cc.minos.codec.matroska.elements {
    import cc.minos.codec.matroska.MaConstans;

    public class Segment extends Element {

        public function Segment()
        {
            super(MaConstans.SEGMENT_ID);
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
                case MaConstans.SEEK_HEAD:
                    return new SeekHead();
                case MaConstans.SEGMENT_INFO:
                    return new SegmentInfo();
                case MaConstans.TRACKS:
                    return new SegmentTracks();
                case MaConstans.CLUSTER:
                    return new Cluster();
                case MaConstans.CUES:
                    return new Cues();
            }
            return super .getElement(type);
        }
    }
}

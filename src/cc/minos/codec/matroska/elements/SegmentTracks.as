/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/30 17:07
 */
package cc.minos.codec.matroska.elements {
    import cc.minos.codec.matroska.MaConstans;

    public class SegmentTracks extends Element {
        public function SegmentTracks()
        {
            super(MaConstans.TRACKS);
        }

        override protected function getElement(type:uint):Element
        {
            switch (type)
            {
                case MaConstans.TRACK_ENTRY:
                    return new TrackEntry();
            }
            return super.getElement(type);
        }

        override protected function init():void
        {
            trace('tracks: ' + toString() );

        }
    }
}

/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/30 17:07
 */
package cc.minos.codec.mkv.elements {
    import cc.minos.codec.mkv.Mkv;

    public class SegmentTracks extends Element {
        public function SegmentTracks()
        {
            super(Mkv.TRACKS);
        }

        override protected function getElement(type:uint):Element
        {
            switch (type)
            {
                case Mkv.TRACK_ENTRY:
                    return new TrackEntry();
            }
            return super.getElement(type);
        }

        override protected function init():void
        {
            trace('tracks id: ' + toString() , 'size: ' + size );
            trace('tracks end. children: ' + children.length );
        }
    }
}

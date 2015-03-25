/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/30 11:42
 */
package cc.minos.codec.mkv.elements {

    import cc.minos.codec.mkv.Mkv;

    public class SegmentInfo extends Element {

        private var _duration:Number;
        private var _timeCodeScale:uint;

        public function SegmentInfo()
        {
            super(Mkv.SEGMENT_INFO);
        }

        override protected function init():void
        {
            trace('segment information: ' + toString() );

            for(var i:int = 0; i < children.length; i++)
            {
                var e:Element = children[i];
                if(e.type == Mkv.SEGMENT_DURATION){
                    _duration = e.getNumber();
                }
                else if(e.type == Mkv.SEGMENT_TIME_CODE_SCALE)
                {
                    _timeCodeScale = e.getInt();
                }
            }

            trace('duration: ' + _duration + 'ms' );
            trace('time code scale: ' + _timeCodeScale );

            trace('information end. children: ' + children.length);

        }

        override protected function getElement(type:uint):Element
        {
            switch (type)
            {
                case Mkv.SEGMENT_UID:
                case Mkv.SEGMENT_FILE_NAME:
                case Mkv.SEGMENT_PREV_UID:
                case Mkv.SEGMENT_PREV_FILE_NAME:
                case Mkv.SEGMENT_NEXT_UID:
                case Mkv.SEGMENT_NEXT_FILE_NAME:
                case Mkv.SEGMENT_TIME_CODE_SCALE:
                case Mkv.SEGMENT_DURATION:
                case Mkv.SEGMENT_TITLE:
                case Mkv.SEGMENT_MUXINGAPP:
                case Mkv.SEGMENT_WRITINGAPP:
                case Mkv.SEGMENT_DATEUTC:
                    return new VarElement(type);
            }
            return super.getElement(type);
        }

        public function get duration():Number
        {
            return _duration;
        }

        public function get timeCodeScale():uint
        {
            return _timeCodeScale;
        }
    }
}

/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/30 11:42
 */
package cc.minos.codec.matroska.elements {

    import cc.minos.codec.matroska.Matroska;

    public class SegmentInfo extends Element {

        private var _duration:Number;
        private var _timeCodeScale:uint;

        public function SegmentInfo()
        {
            super(Matroska.SEGMENT_INFO);
        }

        override protected function init():void
        {
            trace('segment information: ' + toString() );

            for(var i:int = 0; i < children.length; i++)
            {
                var e:Element = children[i];
                if(e.type == Matroska.SEGMENT_DURATION){
                    _duration = e.getNumber();
                }
                else if(e.type == Matroska.SEGMENT_TIME_CODE_SCALE)
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
                case Matroska.SEGMENT_UID:
                case Matroska.SEGMENT_FILE_NAME:
                case Matroska.SEGMENT_PREV_UID:
                case Matroska.SEGMENT_PREV_FILE_NAME:
                case Matroska.SEGMENT_NEXT_UID:
                case Matroska.SEGMENT_NEXT_FILE_NAME:
                case Matroska.SEGMENT_TIME_CODE_SCALE:
                case Matroska.SEGMENT_DURATION:
                case Matroska.SEGMENT_TITLE:
                case Matroska.SEGMENT_MUXINGAPP:
                case Matroska.SEGMENT_WRITINGAPP:
                case Matroska.SEGMENT_DATEUTC:
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

/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/30 11:42
 */
package cc.minos.codec.matroska.elements {

    import cc.minos.codec.matroska.MaConstans;

    public class SegmentInfo extends Element {

        private var _duration:Number;
        private var _timeCodeScale:uint;

        public function SegmentInfo()
        {
            super(MaConstans.SEGMENT_INFO);
        }

        override protected function init():void
        {
            trace('segment information: ' + toString() );
            trace('childs: ' + childs.length);

            for(var i:int = 0; i < childs.length; i++)
            {
                var e:Element = childs[i];
                if(e.type == MaConstans.SEGMENT_DURATION){
                    _duration = e.getNumber();
                }
                else if(e.type == MaConstans.SEGMENT_TIME_CODE_SCALE)
                {
                    _timeCodeScale = e.getInt();
                }
            }

            trace('duration: ' + _duration + 'ms' );
            trace('time code scale: ' + _timeCodeScale );

        }

        override protected function getElement(type:uint):Element
        {
            switch (type)
            {
                case MaConstans.SEGMENT_UID:
                case MaConstans.SEGMENT_FILE_NAME:
                case MaConstans.SEGMENT_PREV_UID:
                case MaConstans.SEGMENT_PREV_FILE_NAME:
                case MaConstans.SEGMENT_NEXT_UID:
                case MaConstans.SEGMENT_NEXT_FILE_NAME:
                case MaConstans.SEGMENT_TIME_CODE_SCALE:
                case MaConstans.SEGMENT_DURATION:
                case MaConstans.SEGMENT_TITLE:
                case MaConstans.SEGMENT_MUXINGAPP:
                case MaConstans.SEGMENT_WRITINGAPP:
                case MaConstans.SEGMENT_DATEUTC:
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

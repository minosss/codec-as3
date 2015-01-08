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
            super(cc.minos.codec.matroska.Matroska.SEGMENT_INFO);
        }

        override protected function init():void
        {
            trace('segment information: ' + toString() );
            trace('childs: ' + childs.length);

            for(var i:int = 0; i < childs.length; i++)
            {
                var e:Element = childs[i];
                if(e.type == cc.minos.codec.matroska.Matroska.SEGMENT_DURATION){
                    _duration = e.getNumber();
                }
                else if(e.type == cc.minos.codec.matroska.Matroska.SEGMENT_TIME_CODE_SCALE)
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
                case cc.minos.codec.matroska.Matroska.SEGMENT_UID:
                case cc.minos.codec.matroska.Matroska.SEGMENT_FILE_NAME:
                case cc.minos.codec.matroska.Matroska.SEGMENT_PREV_UID:
                case cc.minos.codec.matroska.Matroska.SEGMENT_PREV_FILE_NAME:
                case cc.minos.codec.matroska.Matroska.SEGMENT_NEXT_UID:
                case cc.minos.codec.matroska.Matroska.SEGMENT_NEXT_FILE_NAME:
                case cc.minos.codec.matroska.Matroska.SEGMENT_TIME_CODE_SCALE:
                case cc.minos.codec.matroska.Matroska.SEGMENT_DURATION:
                case cc.minos.codec.matroska.Matroska.SEGMENT_TITLE:
                case cc.minos.codec.matroska.Matroska.SEGMENT_MUXINGAPP:
                case cc.minos.codec.matroska.Matroska.SEGMENT_WRITINGAPP:
                case cc.minos.codec.matroska.Matroska.SEGMENT_DATEUTC:
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

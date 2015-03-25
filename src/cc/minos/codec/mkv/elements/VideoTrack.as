/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/30 17:12
 */
package cc.minos.codec.mkv.elements {
    import cc.minos.codec.mkv.Mkv;

    public class VideoTrack extends Element {

        private var _width:uint;
        private var _height:uint;

        public function VideoTrack()
        {
            super(Mkv.TRACK_VIDEO);
        }

        override protected function getElement(type:uint):Element
        {
            switch(type)
            {
                case Mkv.VIDEO_PIXEL_WIDTH:
                case Mkv.VIDEO_PIXEL_HEIGHT:
                case Mkv.VIDEO_PIXEL_CROP_BOTTOM:
                case Mkv.VIDEO_PIXEL_CROP_TOP:
                case Mkv.VIDEO_PIXEL_CROP_LEFT:
                case Mkv.VIDEO_PIXEL_CROP_RIGHT:
                case Mkv.VIDEO_DISPLAY_WIDTH:
                case Mkv.VIDEO_DISPLAY_HEIGHT:
                case Mkv.VIDEO_DISPLAY_UINT:
                    return new VarElement(type);
            }
            return super.getElement(type);
        }

        override protected function init():void
        {
            trace('video track');
            _width = getChildByType(Mkv.VIDEO_DISPLAY_WIDTH)[0].getInt();
            _height = getChildByType(Mkv.VIDEO_DISPLAY_HEIGHT)[0].getInt();
            trace('width: ' + _width);
            trace('height: ' + _height);
            trace('children: ' + children.length);
        }

        public function get width():uint
        {
            return _width;
        }

        public function get height():uint
        {
            return _height;
        }
    }
}

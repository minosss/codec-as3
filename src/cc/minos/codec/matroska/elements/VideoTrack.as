/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/30 17:12
 */
package cc.minos.codec.matroska.elements {
    import cc.minos.codec.matroska.Matroska;

    public class VideoTrack extends Element {

        private var _width:uint;
        private var _height:uint;

        public function VideoTrack()
        {
            super(Matroska.TRACK_VIDEO);
        }

        override protected function getElement(type:uint):Element
        {
            switch(type)
            {
                case Matroska.VIDEO_PIXEL_WIDTH:
                case Matroska.VIDEO_PIXEL_HEIGHT:
                case Matroska.VIDEO_PIXEL_CROP_BOTTOM:
                case Matroska.VIDEO_PIXEL_CROP_TOP:
                case Matroska.VIDEO_PIXEL_CROP_LEFT:
                case Matroska.VIDEO_PIXEL_CROP_RIGHT:
                case Matroska.VIDEO_DISPLAY_WIDTH:
                case Matroska.VIDEO_DISPLAY_HEIGHT:
                case Matroska.VIDEO_DISPLAY_UINT:
                    return new VarElement(type);
            }
            return super.getElement(type);
        }

        override protected function init():void
        {
            trace('video track');
            _width = getChildByType(Matroska.VIDEO_DISPLAY_WIDTH)[0].getInt();
            _height = getChildByType(Matroska.VIDEO_DISPLAY_HEIGHT)[0].getInt();
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

/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/30 17:12
 */
package cc.minos.codec.matroska.elements {
    import cc.minos.codec.matroska.MaConstans;

    public class VideoTrack extends Element {
        public function VideoTrack()
        {
            super(MaConstans.TRACK_VIDEO);
        }

        override protected function getElement(type:uint):Element
        {
            switch(type)
            {
                case MaConstans.VIDEO_PIXEL_WIDTH:
                case MaConstans.VIDEO_PIXEL_HEIGHT:
                case MaConstans.VIDEO_PIXEL_CROP_BOTTOM:
                case MaConstans.VIDEO_PIXEL_CROP_TOP:
                case MaConstans.VIDEO_PIXEL_CROP_LEFT:
                case MaConstans.VIDEO_PIXEL_CROP_RIGHT:
                case MaConstans.VIDEO_DISPLAY_WIDTH:
                case MaConstans.VIDEO_DISPLAY_HEIGHT:
                case MaConstans.VIDEO_DISPLAY_UINT:
                    return new VarElement(type);
            }
            return super.getElement(type);
        }

        override protected function init():void
        {
            trace('video track');
            trace('width: ' + getChildByType(MaConstans.VIDEO_DISPLAY_WIDTH)[0].getInt());
            trace('height: ' + getChildByType(MaConstans.VIDEO_DISPLAY_HEIGHT)[0].getInt());
            trace('childs: ' + childs.length);
        }
    }
}

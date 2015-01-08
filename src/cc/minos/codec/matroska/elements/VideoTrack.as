/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/30 17:12
 */
package cc.minos.codec.matroska.elements {
    import cc.minos.codec.matroska.Matroska;

    public class VideoTrack extends Element {
        public function VideoTrack()
        {
            super(cc.minos.codec.matroska.Matroska.TRACK_VIDEO);
        }

        override protected function getElement(type:uint):Element
        {
            switch(type)
            {
                case cc.minos.codec.matroska.Matroska.VIDEO_PIXEL_WIDTH:
                case cc.minos.codec.matroska.Matroska.VIDEO_PIXEL_HEIGHT:
                case cc.minos.codec.matroska.Matroska.VIDEO_PIXEL_CROP_BOTTOM:
                case cc.minos.codec.matroska.Matroska.VIDEO_PIXEL_CROP_TOP:
                case cc.minos.codec.matroska.Matroska.VIDEO_PIXEL_CROP_LEFT:
                case cc.minos.codec.matroska.Matroska.VIDEO_PIXEL_CROP_RIGHT:
                case cc.minos.codec.matroska.Matroska.VIDEO_DISPLAY_WIDTH:
                case cc.minos.codec.matroska.Matroska.VIDEO_DISPLAY_HEIGHT:
                case cc.minos.codec.matroska.Matroska.VIDEO_DISPLAY_UINT:
                    return new VarElement(type);
            }
            return super.getElement(type);
        }

        override protected function init():void
        {
            trace('video track');
            trace('width: ' + getChildByType(cc.minos.codec.matroska.Matroska.VIDEO_DISPLAY_WIDTH)[0].getInt());
            trace('height: ' + getChildByType(cc.minos.codec.matroska.Matroska.VIDEO_DISPLAY_HEIGHT)[0].getInt());
            trace('childs: ' + childs.length);
        }
    }
}

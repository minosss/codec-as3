/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/30 17:08
 */
package cc.minos.codec.matroska.elements {
    import cc.minos.codec.matroska.MaConstans;

    import com.hurlant.util.Hex;

    public class TrackEntry extends Element {
        public function TrackEntry()
        {
            super(MaConstans.TRACK_ENTRY);
        }

        override protected function getElement(type:uint):Element
        {
            switch (type)
            {
                case MaConstans.TRACK_NUMBER:
                case MaConstans.TRACK_TYPE: //
                case MaConstans.TRACK_UID:
                case MaConstans.TRACK_FLAG_DEFAULT:
                case MaConstans.TRACK_FLAG_FORCED:
                case MaConstans.TRACK_FLAG_ENABLED:
                case MaConstans.TRACK_FLAG_LACING:
                case MaConstans.TRACK_MIN_CACHE:
                case MaConstans.TRACK_MAX_CACHE:
                case MaConstans.TRACK_DEFAULT_DURATION:
                case MaConstans.TRACK_TIMECODE_SCALE:
                case MaConstans.TRACK_NAME:
                case MaConstans.TRACK_LANGUAGE:
                case MaConstans.TRACK_CODEC_ID:
                case MaConstans.TRACK_CODEC_PRIVATE:
                case MaConstans.TRACK_CODEC_NAME:
                case MaConstans.TRACK_ATTACHMENT_LINK:
                    return new VarElement(type);
                // video track
                case MaConstans.TRACK_VIDEO:
                    return new VideoTrack();
                // audio track
                case MaConstans.TRACK_AUDIO:
                    return new AudioTrack();
                // information
                case MaConstans.CONTENT_ENCODINGS:
                    return new ContentEncodings();
            }
            return super.getElement(type);
        }

        override protected function init():void
        {
            //
            for(var i:int = 0; i < childs.length; i++)
            {
                var e:Element = childs[i];
                if( e.type == MaConstans.TRACK_CODEC_ID )
                {
                    trace('codec id: ' + e.getString()); //
                }
                else if( e.type == MaConstans.TRACK_TYPE )
                {
                    trace('type: ' + e.getInt().toString(16)); //
                }else if( e.type == MaConstans.TRACK_DEFAULT_DURATION )
                {
                    trace('timestamp: ' + e.getInt());
                }else if( e.type == MaConstans.TRACK_CODEC_PRIVATE )
                {
                    trace('codec private: ' + e.data.length );
                }
            }
        }
    }
}

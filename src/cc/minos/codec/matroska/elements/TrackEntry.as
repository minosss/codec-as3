/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/30 17:08
 */
package cc.minos.codec.matroska.elements {
    import cc.minos.codec.matroska.Matroska;

    import com.hurlant.util.Hex;

    public class TrackEntry extends Element {
        public function TrackEntry()
        {
            super(cc.minos.codec.matroska.Matroska.TRACK_ENTRY);
        }

        override protected function getElement(type:uint):Element
        {
            switch (type)
            {
                case cc.minos.codec.matroska.Matroska.TRACK_NUMBER:
                case cc.minos.codec.matroska.Matroska.TRACK_TYPE: //
                case cc.minos.codec.matroska.Matroska.TRACK_UID:
                case cc.minos.codec.matroska.Matroska.TRACK_FLAG_DEFAULT:
                case cc.minos.codec.matroska.Matroska.TRACK_FLAG_FORCED:
                case cc.minos.codec.matroska.Matroska.TRACK_FLAG_ENABLED:
                case cc.minos.codec.matroska.Matroska.TRACK_FLAG_LACING:
                case cc.minos.codec.matroska.Matroska.TRACK_MIN_CACHE:
                case cc.minos.codec.matroska.Matroska.TRACK_MAX_CACHE:
                case cc.minos.codec.matroska.Matroska.TRACK_DEFAULT_DURATION:
                case cc.minos.codec.matroska.Matroska.TRACK_TIMECODE_SCALE:
                case cc.minos.codec.matroska.Matroska.TRACK_NAME:
                case cc.minos.codec.matroska.Matroska.TRACK_LANGUAGE:
                case cc.minos.codec.matroska.Matroska.TRACK_CODEC_ID:
                case cc.minos.codec.matroska.Matroska.TRACK_CODEC_PRIVATE:
                case cc.minos.codec.matroska.Matroska.TRACK_CODEC_NAME:
                case cc.minos.codec.matroska.Matroska.TRACK_ATTACHMENT_LINK:
                    return new VarElement(type);
                // video track
                case cc.minos.codec.matroska.Matroska.TRACK_VIDEO:
                    return new VideoTrack();
                // audio track
                case cc.minos.codec.matroska.Matroska.TRACK_AUDIO:
                    return new AudioTrack();
                // information
                case cc.minos.codec.matroska.Matroska.CONTENT_ENCODINGS:
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
                if( e.type == cc.minos.codec.matroska.Matroska.TRACK_CODEC_ID )
                {
                    trace('codec id: ' + e.getString()); //
                }
                else if( e.type == cc.minos.codec.matroska.Matroska.TRACK_TYPE )
                {
                    trace('type: ' + e.getInt().toString(16)); //
                }else if( e.type == cc.minos.codec.matroska.Matroska.TRACK_DEFAULT_DURATION )
                {
                    trace('timestamp: ' + e.getInt());
                }else if( e.type == cc.minos.codec.matroska.Matroska.TRACK_CODEC_PRIVATE )
                {
                    trace('codec private: ' + e.data.length );
                }
            }
        }
    }
}

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
            super(Matroska.TRACK_ENTRY);
        }

        override protected function getElement(type:uint):Element
        {
            switch (type)
            {
                case Matroska.TRACK_NUMBER:
                case Matroska.TRACK_TYPE: //
                case Matroska.TRACK_UID:
                case Matroska.TRACK_FLAG_DEFAULT:
                case Matroska.TRACK_FLAG_FORCED:
                case Matroska.TRACK_FLAG_ENABLED:
                case Matroska.TRACK_FLAG_LACING:
                case Matroska.TRACK_MIN_CACHE:
                case Matroska.TRACK_MAX_CACHE:
                case Matroska.TRACK_DEFAULT_DURATION:
                case Matroska.TRACK_TIMECODE_SCALE:
                case Matroska.TRACK_NAME:
                case Matroska.TRACK_LANGUAGE:
                case Matroska.TRACK_CODEC_ID:
                case Matroska.TRACK_CODEC_PRIVATE:
                case Matroska.TRACK_CODEC_NAME:
                case Matroska.TRACK_ATTACHMENT_LINK:
                    return new VarElement(type);
                // video track
                case Matroska.TRACK_VIDEO:
                    return new VideoTrack();
                // audio track
                case Matroska.TRACK_AUDIO:
                    return new AudioTrack();
                // information
                case Matroska.CONTENT_ENCODINGS:
                    return new ContentEncodings();
            }
            return super.getElement(type);
        }

        override protected function init():void
        {
            //
            trace(' === track entry')
            for(var i:int = 0; i < children.length; i++)
            {
                var e:Element = children[i];
                if( e.type == Matroska.TRACK_CODEC_ID )
                {
                    trace('codec id: ' + e.getString()); //
                }
                else if( e.type == Matroska.TRACK_TYPE )
                {
                    trace('type: ' + e.getInt().toString(16)); //
                }else if( e.type == Matroska.TRACK_DEFAULT_DURATION )
                {
                    trace('timestamp: ' + e.getInt());
                }else if( e.type == Matroska.TRACK_CODEC_PRIVATE )
                {
                    trace('codec private: ' + e.data.length );
                }
                else if( e.type == Matroska.TRACK_CODEC_NAME )
                {
                    trace('codec name: ' + e.getString() );
                }
            }
            trace('track end. children: ' + children.length );
        }
    }
}

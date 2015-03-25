/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/30 17:08
 */
package cc.minos.codec.mkv.elements {
    import cc.minos.codec.mkv.Mkv;

    import com.hurlant.util.Hex;

    import flash.utils.ByteArray;

    public class TrackEntry extends Element {

        private var _trackType:uint;
        private var _configurationData:ByteArray;

        //video
        private var _videoWidth:uint;
        private var _videoHeight:uint;
        private var _videoCodecId:uint;
        //audio
        private var _audioChannels:uint;
        private var _audioSize:uint;
        private var _audioRate:Number;
        private var _audioCodecId:uint;

        public function TrackEntry()
        {
            super(Mkv.TRACK_ENTRY);
        }

        override protected function getElement(type:uint):Element
        {
            switch (type)
            {
                case Mkv.TRACK_NUMBER:
                case Mkv.TRACK_TYPE: //
                case Mkv.TRACK_UID:
                case Mkv.TRACK_FLAG_DEFAULT:
                case Mkv.TRACK_FLAG_FORCED:
                case Mkv.TRACK_FLAG_ENABLED:
                case Mkv.TRACK_FLAG_LACING:
                case Mkv.TRACK_MIN_CACHE:
                case Mkv.TRACK_MAX_CACHE:
                case Mkv.TRACK_DEFAULT_DURATION:
                case Mkv.TRACK_TIMECODE_SCALE:
                case Mkv.TRACK_NAME:
                case Mkv.TRACK_LANGUAGE:
                case Mkv.TRACK_CODEC_ID:
                case Mkv.TRACK_CODEC_PRIVATE:
                case Mkv.TRACK_CODEC_NAME:
                case Mkv.TRACK_ATTACHMENT_LINK:
                    return new VarElement(type);
                // video track
                case Mkv.TRACK_VIDEO:
                    return new VideoTrack();
                // audio track
                case Mkv.TRACK_AUDIO:
                    return new AudioTrack();
                // information
                case Mkv.CONTENT_ENCODINGS:
                    return new ContentEncodings();
            }
            return super.getElement(type);
        }

        override protected function init():void
        {
            //
            trace(' === track entry === ')
            for(var i:int = 0; i < children.length; i++)
            {
                var e:Element = children[i];
                if( e.type == Mkv.TRACK_CODEC_ID )
                {
                    trace('codec id: ' + e.getString()); //
                }
                else if( e.type == Mkv.TRACK_TYPE )
                {
                    trace('type: ' + e.getInt().toString(16)); //
                    _trackType = e.getInt();
                }else if( e.type == Mkv.TRACK_DEFAULT_DURATION )
                {
                    trace('timestamp: ' + e.getInt());
                }else if( e.type == Mkv.TRACK_CODEC_PRIVATE )
                {
                    trace('codec private: ' + e.data.length );
                    e.data.position = 0;
                    trace(e.data.readByte());
                    trace(e.data.readByte());
                    trace(e.data.readByte());
                    _configurationData = new ByteArray();
                    _configurationData.writeBytes( e.data, 3, e.data.bytesAvailable );
                }
                else if( e.type == Mkv.TRACK_CODEC_NAME )
                {
                    trace('codec name: ' + e.getString() );
                }
                else if( e.type == Mkv.TRACK_VIDEO )
                {
                    var v:VideoTrack = e as VideoTrack;
                    _videoWidth = v.width;
                    _videoHeight = v.height;
                }
                else if( e.type == Mkv.TRACK_AUDIO )
                {
                    var a:AudioTrack = e as AudioTrack;
                    //
                }
            }

            trace('track end. children: ' + children.length );
        }

        public function get configurationData():ByteArray
        {
            return _configurationData;
        }

        public function get trackType():uint
        {
            return _trackType;
        }

        public function get videoWidth():uint
        {
            return _videoWidth;
        }

        public function get videoHeight():uint
        {
            return _videoHeight;
        }

        public function get audioChannels():uint
        {
            return _audioChannels;
        }

        public function get audioSize():uint
        {
            return _audioSize;
        }

        public function get audioRate():Number
        {
            return _audioRate;
        }
    }
}

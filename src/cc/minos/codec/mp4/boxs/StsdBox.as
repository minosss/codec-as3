/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/15 10:43
 */
package cc.minos.codec.mp4.boxs {

    import cc.minos.codec.mp4.Mp4;
    import cc.minos.codec.utils.ByteArrayUtil;

    import flash.utils.ByteArray;

    CONFIG::LOGGING{
        import cc.minos.codec.utils.Log;
    }

    public class StsdBox extends Box {

        //video
        private var _videoWidth:uint;
        private var _videoHeight:uint;
        private var _videoCodecId:uint;
        //audio
        private var _audioChannels:uint;
        private var _audioSize:uint;
        private var _audioRate:Number;
        private var _audioCodecId:uint;
        //
        private var _configurationData:ByteArray;

        public function StsdBox()
        {
            super(Mp4.BOX_TYPE_STSD);
        }

        override protected function decode():void
        {
            CONFIG::LOGGING{
                Log.info('[stsd]');
            }
            data.position += 4;     //version flags
            data.readUnsignedInt(); //count 1

            var codecSize:uint = data.readUnsignedInt();
            var codecType:uint = data.readUnsignedInt();
            _configurationData = new ByteArray();
            var offset:uint;
            var len:uint;
            if( codecType == Mp4.BOX_TYPE_AVC1 )
            {
                //6 reserved
                data.position += 6;
                //2 data reference index
                data.position += 2;
                //2 video encoding version 0
                trace('encoding version: ' + data.readUnsignedShort());
                //2 video encoding revision level
                trace('encoding revision level: ' + data.readUnsignedShort());
                //4 video encoding vendor
                trace('encoding vendor: ' + data.readUnsignedInt());
                //4 video temporal quality (0-1024)
                trace('temporal quality: ' + data.readUnsignedInt());
                //4 video spatial quality (0-1024)
                trace('spatial quality: ' + data.readUnsignedInt());
                //4 video frame pixel size (width + height)
                _videoWidth = data.readUnsignedShort();
                _videoHeight = data.readUnsignedShort();
                //8 video resolution (horizontal + vertical)
                trace('resolution horizontal: ' + data.readUnsignedInt());
                trace('resolution vertical: ' + data.readUnsignedInt());
                //4 video data size
                trace('data size: ' + data.readInt());
                //2 video frame count
                trace('frame count: ' + data.readUnsignedShort());
                //1 video encoding name string length
                trace('encoding name string length: ' + data.readUnsignedByte());
                //31 video encoder name string
                data.position += 31;
                //2 video pixel depth
                trace('pixel depth: ' + data.readUnsignedShort());
                //2 video color table id
                trace('color table id: ' + data.readShort());

                // ===== AVC =====

                //size
                trace('size: ' + data.readUnsignedInt());
                //type
                trace('type: ' + ByteArrayUtil.toString(data.readUnsignedInt().toString(16)));
                offset = data.position;
                trace('version: ' + data.readByte());
                trace('profile: ' + data.readUnsignedByte());
                trace('compatible: ' + data.readByte());
                trace('level: ' + data.readUnsignedByte());
                trace('size: ' + (1 + ( data.readByte() & 0x3 )));
                trace('sps num: ' + (data.readByte() & 0x1F ));
                var l:uint = data.readUnsignedShort();
                trace('sps length: ' + l);
                data.position += l;
                trace('pps num: ' + data.readUnsignedByte());
                trace('pps length: ' + data.readUnsignedShort());

                //
                data.position = offset;
                _configurationData.writeBytes( data, offset, data.bytesAvailable );

                CONFIG::LOGGING{
                    Log.info('width', _videoWidth);
                    Log.info('height', _videoHeight);
                }
            }
            else if(codecType == Mp4.BOX_TYPE_MP4A )
            {
                //6 reserved
                data.position += 6;
                //2 data reference index
                data.position += 2;
                //2 audio encoding version 0
                data.readUnsignedShort();
                //2 audio encoding revision level 0
                data.readUnsignedShort();
                //4 audio encoding vendor 0
                data.readUnsignedInt();
                //2 audio channels  (mono = 1 ; stereo = 2)
                _audioChannels = data.readUnsignedShort();
//                trace('channels: ' + _audioChannels );
                //2 audio sample size (8 or 16)
                _audioSize = data.readUnsignedShort();
//                trace('sample size: ' + _audioSize );
                //2 audio compression id 0
                data.readShort();
                //2 audio packet size 0
                data.readShort();
                //4 audio sample rate
                _audioRate = data.readUnsignedInt() / Mp4.FIXED_POINT_16_16
//                trace('rate: ' + _audioRate );

                CONFIG::LOGGING{
                    Log.info('channels: ', _audioChannels);
                    Log.info('size: ', _audioSize);
                    Log.info('rate: ', _audioRate);
                }

                //========= ESDS | M4DS ==========
                var dsSize:uint = data.readUnsignedInt();
                var dsType:uint = data.readUnsignedInt();

                //0x03 0x04 0x05
                while( data.bytesAvailable > 0 )
                {
                    offset = data.position;
                    if( data.readByte() == 0x05 ){

                        if( data.readUnsignedByte() == 0x80 ){
                            data.position += 2;
                            offset += 3;
                        }
                        _configurationData.writeBytes( data, offset + 2, data.readUnsignedByte() ); //audio specific
                        break;
                    }
                }
            }
            //
            data.position = data.length;
        }

        public function get configurationData():ByteArray
        {
            return _configurationData;
        }

        public function get audioRate():Number
        {
            return _audioRate;
        }

        public function get audioSize():uint
        {
            return _audioSize;
        }

        public function get audioChannels():uint
        {
            return _audioChannels;
        }

        public function get videoHeight():uint
        {
            return _videoHeight;
        }

        public function get videoWidth():uint
        {
            return _videoWidth;
        }
    }
}

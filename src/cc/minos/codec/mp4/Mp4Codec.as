/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/24 15:36
 */
package cc.minos.codec.mp4 {

    import cc.minos.codec.*;
    import cc.minos.codec.mp4.boxs.*;

    import flash.utils.ByteArray;

    public class Mp4Codec extends Codec {

        protected var moovBox:MoovBox;
        protected var _videoSamples:Vector.<Sample>;
        protected var _audioSamples:Vector.<Sample>;

        public function Mp4Codec()
        {
            super('mp4');
        }

        private function sortBydelta(a:Object, b:Object, array:Array = null):int
        {
            if( a.timestamp < b.timestamp )
            {
                return -1;
            }
            else if( a.timestamp > b.timestamp )
            {
                return 1;
            }
            if( a.dataType == 0x09 ){
                return -1;
            }else if( b.dataType == 0x09 )
            {
                return 1;
            }
            return 0;
        }

        override public function decode( input:ByteArray ):ICodec
        {
            //
            trace( 'mp4 codec: ')
            _rawData = input;
            //find moov box
            var offset:uint;
            var size:uint;
            var type:uint;
            _rawData.position = 0;
            while(_rawData.bytesAvailable > 8 )
            {
                offset = _rawData.position;
                size = _rawData.readUnsignedInt();
                type = _rawData.readUnsignedInt();
                if( type == MP4Constants.BOX_TYPE_MOOV )
                {
                    var d:ByteArray = new ByteArray();
                    d.writeBytes(_rawData, offset, size);
                    moovBox = new MoovBox();
                    moovBox.size = size;
                    moovBox.position = offset;
                    moovBox.parse(d);
                    break;
                }
                _rawData.position = (offset + size);
            }
            //
            _duration = moovBox.mvhdBox.duration;
            //
            for(var i:int =0;i< moovBox.traks.length; i++)
            {
                var trak:TrakBox = moovBox.traks[i] as TrakBox;
                if( trak.trakType == MP4Constants.TRAK_TYPE_VIDE )
                {
                    _hasVideo = true;
                    _videoWidth = trak.stsdBox.videoWidth;
                    _videoHeight = trak.stsdBox.videoHeight;
                    _videoRate = trak.fps;
                    _videoSamples = trak.samples;
                    //-- video sps & pps
                    _videoConfig = trak.stsdBox.configurationData;
                }
                else if( trak.trakType == MP4Constants.TRAK_TYPE_SOUN )
                {
                    _hasAudio = true;
                    _audioChannels = trak.stsdBox.audioChannels;
                    _audioRate = trak.stsdBox.audioRate;
                    _audioSize = trak.stsdBox.audioSize;
                    _audioSamples = trak.samples;
                    //-- audio spec
                    _audioConfig = trak.stsdBox.configurationData;
                }
            }
            _frames = new Vector.<IFrame>();
            if(_videoSamples != null)
            {
                for each(var v:IFrame in _videoSamples)
                {
                    _frames.push(v);
                }
            }
            if(_audioSamples != null)
            {
                for each(var a:IFrame in _audioSamples)
                {
                    _frames.push(a);
                }
            }
            _frames.sort(sortBydelta);

            return this;
        }

        override public function encode( input:ICodec ):ByteArray
        {
            return null;
        }

        override public function getDataByFrame(frame:IFrame):ByteArray
        {
            var b:ByteArray = new ByteArray();
            /*if( frame.dataType == 0x09 )
            {
                b.writeByte(frame.frameType == 1 ? 0x17 : 0x27);
                b.writeByte(0x01);
                writeUI24(b, 0);

            }else if( frame.dataType == 0x08 )
            {
                b.writeByte(_soundPropertiesByte);
                b.writeByte(0x01);
            }*/
            b.writeBytes(_rawData, frame.offset, frame.size);
            return b;
        }

        override public function exportVideo():ByteArray
        {
            var ba:ByteArray = new ByteArray();
            return ba;
        }

        override public function exportAudio():ByteArray
        {
            var ba:ByteArray = new ByteArray();
            return ba;
        }
    }
}

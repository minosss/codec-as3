/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/23 13:38
 */
package cc.minos.codec.flv {
    import cc.minos.codec.*;

    import flash.utils.ByteArray;

    public class FlvCodec extends Codec {

        public static const AUDIO_TAG:int = 0x08;
        public static const VIDEO_TAG:int = 0x09;
        public static const SCRIPT_TAG:int = 0x12;
        public static const SIGNATURE:String = "FLV";

        public function FlvCodec()
        {
            super('flv');
        }

        protected function makeHeader(flv:*, hasVideo:Boolean = false, hasAudio:Boolean = false):void
        {
            var b:ByteArray = new ByteArray();
            b.writeByte(0x46);
            b.writeByte(0x4C);
            b.writeByte(0x56);
            b.writeByte(0x01);
            var u:uint = 0;
            if(hasVideo) u += 1;
            if(hasAudio) u += 4;
            b.writeByte(u);
            b.writeUnsignedInt(0x09);
            b.writeUnsignedInt(0);

            flv.writeBytes(b);
            b.length = 0, b = null;
        }

        protected function makeMateTag(flv:*, duration:Number, width:Number, height:Number, rate:Number):void
        {
            var data:ByteArray = new ByteArray();
            data.writeByte(2); //2 -> string
            writeUI16(data, 'onMetaData'.length);
            data.writeUTFBytes('onMetaData');
            data.writeByte(8); //8 -> array
            data.writeUnsignedInt(5); //elements
            writeNumber(data, 'duration', duration);
            writeNumber(data, 'width', width);
            writeNumber(data, 'height', height);
            writeNumber(data, 'framerate', rate);
            writeString(data, 'metadatacreator', 'codec-as3 by Minos<minoscc@gmail.com>');
            writeUI24(data, 9);

            makeDataTag(flv, data, 0x12, 0);

            data.length = 0, data = null;
        }

        protected function makeDataTag(flv:*, data:ByteArray, type:uint = 0x08, timestamp:uint = 0):void
        {
            var tag:ByteArray = new ByteArray();
            tag.writeByte(type); //8 9 18
            writeUI24(tag, data.length); //
            writeUI24(tag, timestamp); //
            tag.writeByte(0); //
            writeUI24(tag, 0); //stream id
            //
            tag.writeBytes(data);
            //
            flv.writeBytes(tag);
            flv.writeUnsignedInt(tag.length);

            tag.length = 0, tag = null;
        }

        protected function makeVideoTag(flv:*, data:ByteArray, timestamp:Number, frameType:uint, naluType:uint ):void
        {
            var tag:ByteArray = new ByteArray();
            tag.writeByte(FlvCodec.VIDEO_TAG);
            writeUI24(tag, data.length + 5);
            writeUI24(tag, timestamp);
            tag.writeByte(0);
            writeUI24(tag, 0);
            //
            tag.writeByte(frameType);
            tag.writeByte(naluType);
            writeUI24(tag, 0); //composition time
            tag.writeBytes(data);

            flv.writeBytes(tag);
            flv.writeUnsignedInt(tag.length);

        }

        protected function makeAudioTag(flv:*, data:ByteArray, timestamp:Number, prop:uint, packetType:uint):void
        {
            var tag:ByteArray = new ByteArray();
            tag.writeByte(FlvCodec.AUDIO_TAG);
            writeUI24(tag, data.length + 2);
            writeUI24(tag, timestamp);
            tag.writeByte(0);
            writeUI24(tag, 0);
            //
            tag.writeByte(prop);
            tag.writeByte(packetType);
            tag.writeBytes(data);

            flv.writeBytes(tag);
            flv.writeUnsignedInt(tag.length);

        }

        protected function makeAudioProperties(input:ICodec):uint
        {
            var _soundPropertiesByte:uint = 0;
            _soundPropertiesByte = (10 << 4); //aac
            _soundPropertiesByte += (3 << 2); //44100 -> 3 22
            _soundPropertiesByte += (1 << 1); //16bit
            _soundPropertiesByte += (1 << 0); //stereo (channels=2)
            return _soundPropertiesByte;
        }

        override public function encode( input:ICodec ):ByteArray
        {
            if( input.type === this.type ) return input.export();

            var ba:ByteArray = new ByteArray();
            makeHeader(ba, input.hasVideo, input.hasAudio);
            makeMateTag(ba, input.duration, input.videoWidth, input.videoHeight, input.videoRate);

            if(input.videoConfig){
                makeVideoTag(ba, input.videoConfig, 0, 0x17, 0);
            }

            var prop:uint = makeAudioProperties(input);
            if(input.audioConfig){
                makeAudioTag(ba, input.audioConfig, 0, prop, 0);
            }

            for each(var f:IFrame in input.frames)
            {
                if(f.dataType == VIDEO_TAG)
                    makeVideoTag(ba, input.getDataByFrame(f), f.timestamp, (f.frameType == 1) ? 0x17:0x27, 0x01);
                else
                    makeAudioTag(ba, input.getDataByFrame(f), f.timestamp, prop, 0x01);
            }
            return ba;
        }

        protected function writeString(stream:*, str:String, value:String):void
        {
            writeUI16(stream, str.length);
            stream.writeUTFBytes(str);
            stream.writeByte(2); //2 -> string
            writeUI16(stream, value.length);
            stream.writeUTFBytes(value);
        }

        protected function writeNumber(stream:*, str:String, value:Number):void
        {
            writeUI16(stream, str.length);
            stream.writeUTFBytes(str);
            stream.writeByte(0); //0 -> number
            stream.writeDouble(value);
        }

        override public function decode(input:ByteArray):ICodec
        {
            _rawData = input;
            _rawData.position = 0;
            if(_rawData.readUTFBytes(3) !== FlvCodec.SIGNATURE ) throw new Error('Not a valid FLV file!');

            _rawData.readByte(); //version
            var info:uint = _rawData.readByte(); //video & audio
            _rawData.position += 8; //size, pre size 0

            var offset:int;
            var end:int;
            var tagLength:int;
            var currentTag:int;
            var step:int;
            var bodyTagHeader:int;
            var time:int;
            var timestampExtended:int;
            var streamID:int;
            var frame:IFrame;

            _frames = new Vector.<IFrame>();
            while(_rawData.bytesAvailable > 0)
            {
                offset = _rawData.position;
                currentTag = _rawData.readByte();
                step = (_rawData.readUnsignedShort() << 8) | _rawData.readUnsignedByte();
                time = (_rawData.readUnsignedShort() << 8) | _rawData.readUnsignedByte();
                timestampExtended = _rawData.readUnsignedByte();
                streamID = ((_rawData.readUnsignedShort() << 8) | _rawData.readUnsignedByte());
                bodyTagHeader = _rawData.readByte();
                end = _rawData.position + step + 3;
                tagLength = end - offset;

                /*if( currentTag == 0x12 )
                 {
                 //trace(bodyTagHeader); //2
                 var l:uint = _rawData.readUnsignedShort();
                 trace(_rawData.readUTFBytes(l)); //onMetaData
                 var t:uint = _rawData.readUnsignedByte(); //array = 8
                 if( t == 0x08 )
                 {
                 var num:uint = _rawData.readUnsignedInt(); //array length
                 var n:String;
                 for(var i:int=0;i<num;i++)
                 {
                 l = _rawData.readUnsignedShort();
                 n = _rawData.readUTFBytes(l);
                 t = _rawData.readUnsignedByte();
                 if( t == 0x00 ) //number
                 {
                 _meta[n] = _rawData.readDouble();
                 }
                 else if( t == 0x01 ) //boolean
                 {
                 _meta[n] = _rawData.readBoolean();
                 }
                 else if( t == 0x02 ) //string
                 {
                 l = _rawData.readUnsignedShort();
                 _meta[n] = _rawData.readUTFBytes(l);
                 }
                 }
                 }
                 }*/

                if(currentTag == 0x12 || currentTag == 0x08 || currentTag == 0x09)
                {
                    frame = new FlvFrame();
                    frame.dataType = currentTag;
                    frame.offset = offset;
                    frame.size = tagLength;
                    _frames.push(frame);
                }
                _rawData.position = end;
            }

            trace('all frames: ' + _frames.length );
            return this;
        }

        override public function exportVideo():ByteArray
        {
            var ba:ByteArray = new ByteArray();
            makeHeader( ba, true );
            for(var i:int = 0; i < _frames.length; i++)
            {
                if(_frames[i].dataType == FlvCodec.SCRIPT_TAG || _frames[i].dataType == FlvCodec.VIDEO_TAG )
                {
                    ba.writeBytes(getDataByFrame(_frames[i]));
                }
            }
            return ba;
        }

        override public function exportAudio():ByteArray
        {
            var ba:ByteArray = new ByteArray();
            makeHeader(ba, false, true);
            for(var i:int = 0; i < _frames.length; i++)
            {
                if(_frames[i].dataType == FlvCodec.SCRIPT_TAG || _frames[i].dataType == FlvCodec.AUDIO_TAG )
                {
                    ba.writeBytes(getDataByFrame(_frames[i]));
                }
            }
            return ba;
        }

    }
}

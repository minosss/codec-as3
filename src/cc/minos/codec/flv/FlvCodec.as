/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/23 13:38
 */
package cc.minos.codec.flv {
import cc.minos.codec.*;

import flash.utils.ByteArray;

/**
 * ...
 * @link http://www.buraks.com/flvmdi/
 * @link http://www.adobe.com/content/dam/Adobe/en/devnet/flv/pdfs/video_file_format_spec_v10.pdf
 */
public class FlvCodec extends Codec {

    public function FlvCodec() {
        super( 'FLV' );
    }

    protected function byte_bytes( s:*, bytes:ByteArray ):void
    {
        s.writeBytes(bytes);
        byte_wb32(s, bytes.length);
    }

    protected function byte_string( s:*, str:String ):void
    {
        byte_wb16(s, str.length );
        s.writeUTFBytes(str);
    }

    protected function byte_boolean( s:*, bool:Boolean ):void
    {
        byte_w8(s, FLVConstants.AMF_DATA_TYPE_BOOLEAN );
        byte_w8(s, int(bool));
    }

    protected function byte_number( s:*, num:Number ):void
    {
        byte_w8(s, FLVConstants.AMF_DATA_TYPE_NUMBER );
        s.writeDouble(num);
    }

    protected function byte_header( s:*, input:ICodec ):void {

        var d:ByteArray = new ByteArray();
        byte_w8(d, 0x46); //F
        byte_w8(d, 0x4C); //L
        byte_w8(d, 0x56); //V
        byte_w8(d, 1);
        var u:uint = 0;
        if (input.hasVideo) u += 1;
        if (input.hasAudio) u += 4;
        byte_w8(d, u);
        byte_wb32(d, 9);
        byte_wb32(d, 0);
        //
        byte_w8(d, FLVConstants.TAG_TYPE_META );
        var metadataSizePos:uint = d.position;
        byte_wb24(d, 0);

        byte_wb24(d, 0); //ts
        byte_w8(d, 0);
        byte_wb24(d, 0); //stream id
        //
        byte_w8( d, FLVConstants.AMF_DATA_TYPE_STRING )
        byte_string(d, 'onMetaData' );
        byte_w8(d, FLVConstants.AMF_DATA_TYPE_MIXEDARRAY);

        var metadataCountPos:uint = d.position;
        var metadataCount:uint = 2;

        byte_wb32(d, metadataCount);

        byte_string( d, 'duration' );
        byte_number( d, input.duration );

        byte_string( d, 'metadatacreator' );
        byte_w8(d, FLVConstants.AMF_DATA_TYPE_STRING );
        byte_string( d, 'codec-as3 by SiuzukZan<minoscc@gmail.com>');

        if(input.hasAudio)
        {
            byte_string(d, 'sterro');
            byte_boolean(d, input.audioChannels == 2 );
            metadataCount ++;
        }

        if( input.hasVideo )
        {
            byte_string(d, 'width');
            byte_number(d, input.videoWidth);
            byte_string(d, 'height');
            byte_number(d, input.videoHeight);
            byte_string(d, 'framerate');
            byte_number(d, input.frameRate );

            metadataCount += 3;

            var _hasKey:Boolean = (input.keyframes != null);
            if( _hasKey )
            {
                byte_string(d, 'hasKeyframes' );
                byte_boolean( d, _hasKey );

                var _len:uint = input.keyframes.length;
                byte_string(d, 'keyframe');
                byte_w8(d, FLVConstants.AMF_DATA_TYPE_OBJECT);

                byte_string(d, 'filepositions');
                byte_w8(d, FLVConstants.AMF_DATA_TYPE_ARRAY);
                byte_wb32(d, _len); //count
                for(var i:int =0;i< _len;i++)
                {
                    byte_w8(d, FLVConstants.AMF_DATA_TYPE_NUMBER );
                    byte_wb32(d, 0.0);
                }

                byte_string(d, 'times');
                byte_w8(d, FLVConstants.AMF_DATA_TYPE_ARRAY);
                byte_wb32(d, _len); //count
                for(var i:int =0;i< _len;i++)
                {
                    byte_w8(d, FLVConstants.AMF_DATA_TYPE_NUMBER );
                    byte_wb32(d, 0.0);
                }
                //object end
                byte_wb24(d, FLVConstants.AMF_DATA_TYPE_OBJECT_END );

                metadataCount ++;
            }
        }

        byte_wb24(d, FLVConstants.AMF_END_OF_OBJECT );

        d.position = metadataCountPos;
        byte_wb32(d, metadataCount );

        d.position = metadataSizePos;
        byte_wb24(d, d.length - metadataSizePos - 10 );

        d.position = d.length;

        s.writeBytes(d);
        byte_wb32(s, d.length - 13);

        d.length = 0, d = null;
    }

    protected function byte_video( s:*, data:ByteArray, timestamp:Number, frameType:uint, naluType:uint):void {
        var tag:ByteArray = new ByteArray();
        byte_w8(tag, FLVConstants.TAG_TYPE_VIDEO); //tag type
        byte_wb24(tag, data.length + 5); //data size
        byte_wb24(tag, timestamp ); //ts
        byte_w8(tag, 0 ); //ts ext
        byte_wb24(tag, 0 ); //stream id
        //
        byte_w8(tag, frameType); //
        byte_w8(tag, naluType);
        byte_wb24(tag, 0); //ct
        tag.writeBytes(data);

        byte_bytes(s, tag);
    }

    protected function byte_audio(s:*, data:ByteArray, timestamp:Number, prop:uint, packetType:uint):void {
        var tag:ByteArray = new ByteArray();
        byte_w8(tag, FLVConstants.TAG_TYPE_AUDIO);
        byte_wb24(tag, data.length + 2);
        byte_wb24(tag, timestamp );
        byte_w8(tag, 0 );
        byte_wb24(tag, 0 );
        //
        byte_w8(tag, prop);
        byte_w8(tag, packetType);
        tag.writeBytes(data);

        byte_bytes(s, tag);
    }

    protected function getAudioFlags(input:ICodec):uint {
        var _soundPropertiesByte:uint = 0;
        _soundPropertiesByte = FLVConstants.AUDIO_CODECID_AAC;
        _soundPropertiesByte += FLVConstants.AUDIO_SAMPLERATE_44100HZ;
        _soundPropertiesByte += FLVConstants.AUDIO_SAMPLESSIZE_16BIT;
        _soundPropertiesByte += FLVConstants.AUDIO_CHANNEL_STEREO;
        return _soundPropertiesByte;
    }

    override public function encode(input:ICodec):ByteArray {

        if (input.type === this.type) return input.export();

        var ba:ByteArray = new ByteArray();

        byte_header(ba, input);

        if ( input.videoConfig ) {
            byte_video(ba, input.videoConfig, 0, 0x17, 0);
        }

        var flags:uint = getAudioFlags(input);
        if ( input.audioConfig ) {
            byte_audio(ba, input.audioConfig, 0, flags, 0);
        }

        for each(var f:IFrame in input.frames) {
            if (f.dataType == FLVConstants.TAG_TYPE_VIDEO )
                byte_video(ba, input.getDataByFrame(f), f.timestamp, (f.frameType == 1) ? 0x17 : 0x27, 0x01);
            else
                byte_audio(ba, input.getDataByFrame(f), f.timestamp, flags, 0x01);
        }
        return ba;
    }

    override public function decode(input:ByteArray):ICodec {
        _rawData = input;
        _rawData.position = 0;

        if (_rawData.readUTFBytes(3).toUpperCase() !== "FLV" ) throw new Error('Not a valid FLV file!');

        _rawData.readByte(); //version
        var info:uint = _rawData.readByte(); //flags
        _hasAudio = (info >> 2 & 0x1); //audio
        _hasVideo = (info >> 0 & 0x1); //video
        _rawData.position += 8; //data offset

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
        while (_rawData.bytesAvailable > 0 ) {
            offset = _rawData.position;
            currentTag = _rawData.readByte();
            step = (_rawData.readUnsignedShort() << 8) | _rawData.readUnsignedByte();
            time = (_rawData.readUnsignedShort() << 8) | _rawData.readUnsignedByte();
            timestampExtended = _rawData.readUnsignedByte();
            streamID = ((_rawData.readUnsignedShort() << 8) | _rawData.readUnsignedByte());
            bodyTagHeader = _rawData.readUnsignedByte();
            end = _rawData.position + step + 3;
            tagLength = end - offset;

            if ( currentTag == FLVConstants.TAG_TYPE_META || currentTag == FLVConstants.TAG_TYPE_AUDIO || currentTag == FLVConstants.TAG_TYPE_VIDEO ) {
                frame = new FlvFrame();
                frame.dataType = currentTag;
                frame.offset = offset;
                frame.size = tagLength;
                if( currentTag == FLVConstants.TAG_TYPE_VIDEO )
                {
                    frame.frameType = (bodyTagHeader >> 4); //key or inter ...
                    frame.codecId = (bodyTagHeader & 0xf);//avc... etc
                }
                else if( currentTag == FLVConstants.TAG_TYPE_AUDIO )
                {
                    frame.frameType = bodyTagHeader; //
                    frame.codecId = (bodyTagHeader >> 4); //aac... etc
//                    (bodyTagHeader >> 4); //sound format 0-15
//                    (bodyTagHeader >> 2 & 0x03 ); //sound rate 0/1/2/3(5.5/11/22/44-kHz)
//                    (bodyTagHeader >> 1 & 0x1 ); //sound size 0/1(8b/16b)
//                    (bodyTagHeader & 0x1 ); //sound type 0/1
                }
                _frames.push(frame);
            }
            _rawData.position = end;
        }

        trace('all frames: ' + _frames.length);
        return this;
    }

}
}

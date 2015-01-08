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

		private var _filepositionsPos:uint;
		private var _timesPos:uint;

		private var keyframesList:Array;

		public function FlvCodec()
		{
			_name = "flv";
			_extensions = "flv";
			_mimeType = "video/x-flv";
		}

		protected function byte_string(s:*, str:String):void
		{
			byte_wb16(s, str.length);
			s.writeUTFBytes(str);
		}

		protected function byte_boolean(s:*, bool:Boolean):void
		{
			byte_w8(s, Flv.AMF_DATA_TYPE_BOOLEAN);
			byte_w8(s, int(bool));
		}

		protected function byte_number(s:*, num:Number):void
		{
			byte_w8(s, Flv.AMF_DATA_TYPE_NUMBER);
			s.writeDouble(num);
		}

		protected function byte_header(s:*, input:ICodec):void
		{
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
			//meta tag
			byte_w8(d, Flv.TAG_TYPE_META);
			var metadataSizePos:uint = d.position;
			byte_wb24(d, 0);  //data size
			byte_wb24(d, 0); //ts
			byte_w8(d, 0); //ts ext
			byte_wb24(d, 0); //stream id
			//data
			byte_w8(d, Flv.AMF_DATA_TYPE_STRING)
			byte_string(d, 'onMetaData');
			byte_w8(d, Flv.AMF_DATA_TYPE_MIXEDARRAY);

			var metadataCountPos:uint = d.position;
			var metadataCount:uint = 2;
			byte_wb32(d, metadataCount);

			byte_string(d, 'duration');
			byte_number(d, input.duration);

			byte_string(d, 'metadatacreator');
			byte_w8(d, Flv.AMF_DATA_TYPE_STRING);
			byte_string(d, 'codec-as3 by SiuzukZan<minoscc@gmail.com>');

			if (input.hasAudio) {
				byte_string(d, 'sterro');
				byte_boolean(d, (input.audioChannels == 2));
				metadataCount += 1;
			}

			if (input.hasVideo) {
				byte_string(d, 'width');
				byte_number(d, input.videoWidth);
				byte_string(d, 'height');
				byte_number(d, input.videoHeight);
				byte_string(d, 'framerate');
				byte_number(d, input.frameRate);

				metadataCount += 3;

				var _hasKey:Boolean = (input.keyframes != null);
				if (_hasKey) {
					keyframesList = [];

					byte_string(d, 'hasKeyframes');
					byte_boolean(d, _hasKey);

					var _len:uint = input.keyframes.length+1;
					byte_string(d, 'keyframes');
					byte_w8(d, Flv.AMF_DATA_TYPE_OBJECT);

					byte_string(d, 'filepositions');
					byte_w8(d, Flv.AMF_DATA_TYPE_ARRAY);
					byte_wb32(d, _len); //count

					_filepositionsPos = d.position;
					for (var i:int = 0; i < _len; i++) {
						byte_number(d, 0.0);
					}

					byte_string(d, 'times');
					byte_w8(d, Flv.AMF_DATA_TYPE_ARRAY);
					byte_wb32(d, _len); //count

					_timesPos = d.position;
					for (var i:int = 0; i < _len; i++) {
						byte_number(d, 0.0);
					}
					//object end
					byte_wb24(d, Flv.AMF_DATA_TYPE_OBJECT_END);

					metadataCount++;
				}
			}
			byte_wb24(d, Flv.AMF_END_OF_OBJECT);

			//update
			d.position = metadataCountPos;
			byte_wb32(d, metadataCount);
			d.position = metadataSizePos;
			byte_wb24(d, d.length - metadataSizePos - 10);
			d.position = d.length;

			s.writeBytes(d);
			byte_wb32(s, d.length - 13);

			d.length = 0, d = null;
		}

		protected function byte_video(s:*, data:ByteArray, timestamp:Number, frameType:uint, codecId:uint, naluType:uint = 1, flagsSize:uint = 5 ):void
		{
			var tag:ByteArray = new ByteArray();
			byte_w8(tag, Flv.TAG_TYPE_VIDEO); //tag type
			byte_wb24(tag, data.length + flagsSize ); //data size
			byte_wb24(tag, timestamp); //ts
			byte_w8(tag, 0); //ts ext
			byte_wb24(tag, 0); //stream id
			//avc data
			byte_w8(tag, (frameType + codecId)); //
			byte_w8(tag, naluType);
			byte_wb24(tag, 0); //ct
			tag.writeBytes(data);
			//save the keyframe information
			if( frameType == Flv.VIDEO_FRAME_KEY )
			{
				keyframesList.push( { 'time': parseFloat((timestamp/1000).toFixed(2)) , 'position': s.position });
			}
			//add tag and pre tag size
			s.writeBytes(tag), byte_wb32(s, tag.length);

			tag.length = 0, tag = null;
		}

		protected function byte_audio(s:*, data:ByteArray, timestamp:Number, prop:uint, packetType:uint = 1, flagsSize:uint = 2):void
		{
			var tag:ByteArray = new ByteArray();
			byte_w8(tag, Flv.TAG_TYPE_AUDIO );
			byte_wb24(tag, data.length + flagsSize );
			byte_wb24(tag, timestamp); //ts
			byte_w8(tag, 0); //ts ext
			byte_wb24(tag, 0); //stream
			//aac data
			byte_w8(tag, prop);
			byte_w8(tag, packetType);
			tag.writeBytes(data);

			//add tag and pre tag size
			s.writeBytes(tag), byte_wb32(s, tag.length);

			tag.length = 0, tag = null;
		}

		protected function getAudioFlags(input:ICodec):uint
		{
			var _soundPropertiesByte:uint = 0;
			_soundPropertiesByte = Flv.AUDIO_CODECID_AAC;
			_soundPropertiesByte += Flv.AUDIO_SAMPLERATE_44100HZ;
			_soundPropertiesByte += Flv.AUDIO_SAMPLESSIZE_16BIT;
			_soundPropertiesByte += Flv.AUDIO_CHANNEL_STEREO;
			return _soundPropertiesByte;
		}

		override public function encode(input:ICodec):ByteArray
		{
			var ba:ByteArray = new ByteArray();

			byte_header(ba, input);

			if (input.videoConfig ) {
				byte_video(ba, input.videoConfig, 0, Flv.VIDEO_FRAME_KEY, Flv.VIDEO_CODECID_H264, 0);
			}

			var flags:uint = getAudioFlags(input);
			if (input.audioConfig ) {
				byte_audio(ba, input.audioConfig, 0, flags, 0);
			}

			for( var i:int=0; i<input.frames.length; i++ )
			{
				var f:IFrame = input.frames[i];
				if (f.dataType == Flv.TAG_TYPE_VIDEO)
					byte_video(ba, input.getDataByFrame(f), f.timestamp, f.frameType, Flv.VIDEO_CODECID_H264 );
				else
					byte_audio(ba, input.getDataByFrame(f), f.timestamp, flags);
			}
			//update meta's keyframes
			if( keyframesList && keyframesList.length > 0 )
			{
				ba.position = _timesPos;
				for(var k:uint = 0; k < keyframesList.length; k++ )
				{
					byte_number(ba, keyframesList[k].time );
				}
				ba.position = _filepositionsPos;
				for( k = 0; k <keyframesList.length; k++ )
				{
					byte_number( ba, keyframesList[k].position );
				}
				ba.position = 0;
			}
			return ba;
		}

		override public function decode(input:ByteArray):ICodec
		{
			if(!probe(input))
				throw new Error('Not a valid FLV file!');

			_rawData = input;
			_rawData.position = 0;

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
			while (_rawData.bytesAvailable > 0) {
				offset = _rawData.position;
				currentTag = _rawData.readByte();
				step = (_rawData.readUnsignedShort() << 8) | _rawData.readUnsignedByte();
				time = (_rawData.readUnsignedShort() << 8) | _rawData.readUnsignedByte();
				timestampExtended = _rawData.readUnsignedByte();
				streamID = ((_rawData.readUnsignedShort() << 8) | _rawData.readUnsignedByte());
				bodyTagHeader = _rawData.readUnsignedByte();
				end = _rawData.position + step + 3;
				tagLength = end - offset;

				if (currentTag == Flv.TAG_TYPE_META || currentTag == Flv.TAG_TYPE_AUDIO || currentTag == Flv.TAG_TYPE_VIDEO) {
					frame = new FlvFrame();
					frame.dataType = currentTag;
					frame.offset = offset;
					frame.size = tagLength;
					if (currentTag == Flv.TAG_TYPE_VIDEO) {
						frame.frameType = (bodyTagHeader >> 4); //key or inter ...
						frame.codecId = (bodyTagHeader & 0xf);//avc... etc
					}
					else if (currentTag == Flv.TAG_TYPE_AUDIO) {
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

		override public function probe(input:ByteArray):Boolean
		{
			if( input[0] == 0x46 && input[1] == 0x4C && input[2] == 0x56 && input[3] < 5 )
				return true;
			return false;
		}
	}
}

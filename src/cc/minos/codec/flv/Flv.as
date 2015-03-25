/**
 * ...
 * Created by SiuzukZan<minoscc@gmail.com> on 03/23/2015 22:58
 */
package cc.minos.codec.flv {

	import cc.minos.codec.Codec;
	import flash.utils.ByteArray;

	/**
	 * ...
	 * @link http://www.adobe.com/content/dam/Adobe/en/devnet/flv/pdfs/video_file_format_spec_v10.pdf
	 */
	public class Flv extends Codec {

		/* video */

		public static const VIDEO_FRAMETYPE_OFFSET:uint = 4;
		//codec id
		public static const VIDEO_CODECID_H263:uint = 2;
		public static const VIDEO_CODECID_SCREEN:uint = 3;
		public static const VIDEO_CODECID_VP6:uint = 4;
		public static const VIDEO_CODECID_VP6A:uint = 5;
		public static const VIDEO_CODECID_SCREEN2:uint = 6;
		public static const VIDEO_CODECID_H264:uint = 7;
		public static const VIDEO_CODECID_REALH263:uint = 8;
		public static const VIDEO_CODECID_MPEG4:uint = 9;
		//frame
		public static const VIDEO_FRAME_KEY:uint = 1 << VIDEO_FRAMETYPE_OFFSET; ///< key frame (for AVC, a seekable frame)
		public static const VIDEO_FRAME_INTER:uint = 2 << VIDEO_FRAMETYPE_OFFSET; ///< inter frame (for AVC, a non-seekable frame)
		public static const VIDEO_FRAME_DISP_INTER:uint = 3 << VIDEO_FRAMETYPE_OFFSET; ///< disposable inter frame (H.263 only)
		public static const VIDEO_FRAME_GENERATED_KEY:uint = 4 << VIDEO_FRAMETYPE_OFFSET; ///< generated key frame (reserved for server use only)
		public static const VIDEO_FRAME_VIDEO_INFO_CMD:uint = 5 << VIDEO_FRAMETYPE_OFFSET; ///< video info/command frame

		/* audio */

		public static const AUDIO_SAMPLESSIZE_OFFSET:uint = 1;
		public static const AUDIO_SAMPLERATE_OFFSET:uint = 2;
		public static const AUDIO_CODECID_OFFSET:uint = 4;
		//size
		public static const AUDIO_SAMPLESSIZE_8BIT:uint = 0;
		public static const AUDIO_SAMPLESSIZE_16BIT:uint = 1 << AUDIO_SAMPLESSIZE_OFFSET;
		//rate
		public static const AUDIO_SAMPLERATE_SPECIAL:uint = 0;
		public static const AUDIO_SAMPLERATE_11025HZ:uint = 1 << AUDIO_SAMPLERATE_OFFSET;
		public static const AUDIO_SAMPLERATE_22050HZ:uint = 2 << AUDIO_SAMPLERATE_OFFSET;
		public static const AUDIO_SAMPLERATE_44100HZ:uint = 3 << AUDIO_SAMPLERATE_OFFSET;
		//channel
		public static const AUDIO_CHANNEL_MONO:uint = 0;
		public static const AUDIO_CHANNEL_STEREO:uint = 1;
		//codec id
		public static const AUDIO_CODECID_PCM:uint = 0;
		public static const AUDIO_CODECID_ADPCM:uint = 1 << AUDIO_CODECID_OFFSET;
		public static const AUDIO_CODECID_MP3:uint = 2 << AUDIO_CODECID_OFFSET;
		public static const AUDIO_CODECID_PCM_LE:uint = 3 << AUDIO_CODECID_OFFSET;
		public static const AUDIO_CODECID_NELLYMOSER_16KHZ_MONO:uint = 4 << AUDIO_CODECID_OFFSET;
		public static const AUDIO_CODECID_NELLYMOSER_8KHZ_MONO:uint = 5 << AUDIO_CODECID_OFFSET;
		public static const AUDIO_CODECID_NELLYMOSER:uint = 6 << AUDIO_CODECID_OFFSET;
		public static const AUDIO_CODECID_PCM_ALAW:uint = 7 << AUDIO_CODECID_OFFSET;
		public static const AUDIO_CODECID_PCM_MULAW:uint = 8 << AUDIO_CODECID_OFFSET;
		public static const AUDIO_CODECID_AAC:uint = 10 << AUDIO_CODECID_OFFSET;
		public static const AUDIO_CODECID_SPEEX:uint = 11 << AUDIO_CODECID_OFFSET;

		/* TAG TYPE */

		public static const TAG_TYPE_AUDIO:uint = 0x08;
		public static const TAG_TYPE_VIDEO:uint = 0x09;
		public static const TAG_TYPE_META:uint = 0x12;

		/* AMF TYPE */

		public static const AMF_DATA_TYPE_NUMBER:uint = 0x00;
		public static const AMF_DATA_TYPE_BOOLEAN:uint = 0x01;
		public static const AMF_DATA_TYPE_STRING:uint = 0x02;
		public static const AMF_DATA_TYPE_OBJECT:uint = 0x03;
		public static const AMF_DATA_TYPE_NULL:uint = 0x05;
		public static const AMF_DATA_TYPE_UNDEFINED:uint = 0x06;
		public static const AMF_DATA_TYPE_REFERENCE:uint = 0x07;
		public static const AMF_DATA_TYPE_MIXEDARRAY:uint = 0x08;
		public static const AMF_DATA_TYPE_OBJECT_END:uint = 0x09;
		public static const AMF_DATA_TYPE_ARRAY:uint = 0x0a;
		public static const AMF_DATA_TYPE_DATE:uint = 0x0b;
		public static const AMF_DATA_TYPE_LONG_STRING:uint = 0x0c;
		public static const AMF_DATA_TYPE_UNSUPPORTED:uint = 0x0d;
		public static const AMF_END_OF_OBJECT:uint = 0x09;

		//记录meta关键帧数据位置
		private var filepositionsPos:uint;
		private var timesPos:uint;
		//关键帧列表（时间，位移）
//		private var keyframesList:Array;

		public function Flv()
		{
			_name = "flv";
			_extensions = "flv";
			_mimeType = "video/x-flv";
		}

		private function byte_string(s:*, str:String):void
		{
			byte_wb16(s, str.length);
			s.writeUTFBytes(str);
		}

		private function byte_boolean(s:*, bool:Boolean):void
		{
			byte_w8(s, AMF_DATA_TYPE_BOOLEAN);
			byte_w8(s, int(bool));
		}

		private function byte_number(s:*, num:Number):void
		{
			byte_w8(s, AMF_DATA_TYPE_NUMBER);
			s.writeDouble(num);
		}

		/**
		 *
		 * @param s
		 * @param input
		 */
		private function byte_header(s:*, input:Codec):void
		{
			var header:ByteArray = new ByteArray();
			//开头固定的3个字节
			byte_w8(header, 0x46); //F
			byte_w8(header, 0x4C); //L
			byte_w8(header, 0x56); //V
			byte_w8(header, 1);
			var u:uint = 0;
			if (input.hasVideo) u += 1;
			if (input.hasAudio) u += 4;
			byte_w8(header, u);
			byte_wb32(header, 9);
			byte_wb32(header, 0);
			//meta tag
			byte_w8(header, TAG_TYPE_META);
			//先记录数据大小的位置稍后更新
			var metadataSizePos:uint = header.position;
			byte_wb24(header, 0);  //data size
			byte_wb24(header, 0); //ts
			byte_w8(header, 0); //ts ext
			byte_wb24(header, 0); //stream id
			//data
			byte_w8(header, AMF_DATA_TYPE_STRING)
			byte_string(header, 'onMetaData');
			byte_w8(header, AMF_DATA_TYPE_MIXEDARRAY);

			//先记录参数个数的位置稍后更新
			var metadataCountPos:uint = header.position;
			var metadataCount:uint = 2;
			byte_wb32(header, metadataCount);

			byte_string(header, 'duration');
			byte_number(header, input.duration);

			byte_string(header, 'metadatacreator');
			byte_w8(header, AMF_DATA_TYPE_STRING);
			byte_string(header, 'codec-as3 by SiuzukZan<minoscc@gmail.com>');

			if (input.hasAudio)
			{
				byte_string(header, 'sterro');
				byte_boolean(header, (input.audioChannels == 2));
				metadataCount += 1;
			}

			if (input.hasVideo)
			{
				byte_string(header, 'width');
				byte_number(header, input.videoWidth);
				byte_string(header, 'height');
				byte_number(header, input.videoHeight);
				byte_string(header, 'framerate');
				byte_number(header, input.frameRate);

				metadataCount += 3;

				var _hasKey:Boolean = (input.keyframes != null);
				if (_hasKey)
				{
					/**
					 * 写入关键帧
					 * 关键帧数据是一个对象，其中包含2个数组（时间，位移）
					 * 这里都先用0占位，在加入完帧后更新
					 */
					_keyframes = [];

					byte_string(header, 'hasKeyframes');
					byte_boolean(header, _hasKey);

					var _len:uint = input.keyframes.length + 1;
					byte_string(header, 'keyframes');
					byte_w8(header, AMF_DATA_TYPE_OBJECT);

					byte_string(header, 'filepositions');
					byte_w8(header, AMF_DATA_TYPE_ARRAY);
					byte_wb32(header, _len); //count

					filepositionsPos = header.position;
					for (var i:int = 0; i < _len; i++)
					{
						byte_number(header, 0.0);
					}

					byte_string(header, 'times');
					byte_w8(header, AMF_DATA_TYPE_ARRAY);
					byte_wb32(header, _len); //count

					timesPos = header.position;
					for (var i:int = 0; i < _len; i++)
					{
						byte_number(header, 0.0);
					}
					//object end
					byte_wb24(header, AMF_DATA_TYPE_OBJECT_END);

					metadataCount++;
				}
			}
			byte_wb24(header, AMF_END_OF_OBJECT);

			//更新meta的数据
			header.position = metadataCountPos;
			byte_wb32(header, metadataCount);
			header.position = metadataSizePos;
			byte_wb24(header, header.length - metadataSizePos - 10);
			header.position = header.length;

			s.writeBytes(header);
			byte_wb32(s, header.length - 13);

			header.length = 0, header = null;
		}

		/**
		 * 写入视频节点
		 * @param s			:	目标流
		 * @param data		:	数据
		 * @param timestamp :	时间戳
		 * @param frameType :	帧类型，占4位（1是关键帧，2则不是）
		 * @param codecId	:	编码类型，占后4位（7则是avc）
		 * @param naluType	:	NALU类型，avc的数据开始需要NALU header 0后续都是1
		 * @param flagsSize	:	数据头标签占位
		 */
		private function byte_video(s:*, data:ByteArray, timestamp:Number, frameType:uint, codecId:uint, naluType:uint = 1, flagsSize:uint = 5):void
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
			//保存關鍵幀的信息
			if (frameType == VIDEO_FRAME_KEY && _keyframes )
			{
				_keyframes.push({'time': parseFloat((timestamp / 1000).toFixed(2)), 'position': s.position});
			}
			//add tag and pre tag size
			s.writeBytes(tag), byte_wb32(s, tag.length);

			tag.length = 0, tag = null;
		}

		/**
		 * 音频流节点
		 * @param s			:	目标流
		 * @param data		:	数据
		 * @param timestamp	:	时间戳
		 * @param prop		:	音频标识（类型，赫兹，声道等）
		 * @param packetType:	类型AAC一样需要分header0和body1
		 * @param flagsSize	:	标签头占位
		 */
		private function byte_audio(s:*, data:ByteArray, timestamp:Number, prop:uint, packetType:uint = 1, flagsSize:uint = 2):void
		{
			var tag:ByteArray = new ByteArray();
			byte_w8(tag, Flv.TAG_TYPE_AUDIO);
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

		/**
		 * 把其他流封裝成flv
		 * @param input	輸入流
		 * @return	返回flv封裝的二進制
		 */
		override public function encode(input:Codec):ByteArray
		{
			var flv:ByteArray = new ByteArray();

			//文件头
			byte_header(flv, input);
			//这里是pps和sps，avc重要的组成部分，在文件的开头meta的后面，一定是关键帧
			if (input.videoConfig)
			{
				byte_video(flv, input.videoConfig, 0, Flv.VIDEO_FRAME_KEY, Flv.VIDEO_CODECID_H264, 0);
			}
			//音频解析的部分，接着视频的解析数据
			var flags:uint = 0;
			flags = AUDIO_CODECID_AAC;
			flags += AUDIO_SAMPLERATE_44100HZ;
			flags += AUDIO_SAMPLESSIZE_16BIT;
			flags += AUDIO_CHANNEL_STEREO;
			if (input.audioConfig)
			{
				byte_audio(flv, input.audioConfig, 0, flags, 0);
			}
			//根据时间添加各个节点
			for (var i:int = 0; i < input.frames.length; i++)
			{
				var f:Frame = input.frames[i];
				if ( input.hasVideo && f.dataType == Flv.TAG_TYPE_VIDEO )
					byte_video(flv, input.getDataByFrame(f), f.timestamp, f.frameType, Flv.VIDEO_CODECID_H264);
				else if( input.hasAudio && f.dataType == Flv.TAG_TYPE_AUDIO )
					byte_audio(flv, input.getDataByFrame(f), f.timestamp, flags);
			}

			//根据获取到的关键帧数组，更新meta的数据
			if ( _keyframes && _keyframes.length > 0)
			{
				flv.position = timesPos;
				for (var k:uint = 0; k < _keyframes.length; k++)
				{
					byte_number(flv, _keyframes[k].time);
				}
				flv.position = filepositionsPos;
				for (k = 0; k < _keyframes.length; k++)
				{
					byte_number(flv, _keyframes[k].position);
				}
//				_keyframes.length = 0;
				flv.position = 0;
			}
			return flv;
		}

		/**
		 * 解析flv
		 * @param input
		 * @return
		 */
		override public function decode(input:ByteArray):Codec
		{
			if (!probe(input))
				throw new Error('Not a valid FLV file!');

			_rawData = input;
			_rawData.position = 0;

			_rawData.readUTFBytes(3); // FLV
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
			var frame:Frame;

			_frames = new Vector.<Frame>();
			while (_rawData.bytesAvailable > 0)
			{
				offset = _rawData.position;
				currentTag = _rawData.readByte();
				step = (_rawData.readUnsignedShort() << 8) | _rawData.readUnsignedByte();
				time = (_rawData.readUnsignedShort() << 8) | _rawData.readUnsignedByte();
				timestampExtended = _rawData.readUnsignedByte(); //
				streamID = ((_rawData.readUnsignedShort() << 8) | _rawData.readUnsignedByte());
				bodyTagHeader = _rawData.readUnsignedByte();
				end = _rawData.position + step + 3;
				tagLength = end - offset;

				if ( currentTag == TAG_TYPE_META || currentTag == TAG_TYPE_AUDIO || currentTag == TAG_TYPE_VIDEO)
				{
					frame = new Frame('flv');
					frame.dataType = currentTag;
					frame.offset = offset;
					frame.size = tagLength;
					frame.timestamp = time;
					if (currentTag == TAG_TYPE_VIDEO)
					{
						frame.frameType = (bodyTagHeader >> 4); //key or inter ...
						frame.codecId = (bodyTagHeader & 0xf);//avc... etc
						//if avc -> pps & sps
					}
					else if (currentTag == TAG_TYPE_AUDIO)
					{
						frame.frameType = bodyTagHeader; //
						frame.codecId = (bodyTagHeader >> 4); //aac... etc
						//if aac -> codec specs ...
//                    (bodyTagHeader >> 4); //sound format 0-15
//                    (bodyTagHeader >> 2 & 0x03 ); //sound rate 0/1/2/3(5.5/11/22/44-kHz)
//                    (bodyTagHeader >> 1 & 0x1 ); //sound size 0/1(8b/16b)
//                    (bodyTagHeader & 0x1 ); //sound type 0/1
					}
					else if ( currentTag == TAG_TYPE_META )
					{
						//parse meta data -> video params
					}
					_frames.push(frame);
				}
				_rawData.position = end;
			}

			trace('all frames: ' + _frames.length);
			return this;
		}

		/**
		 *
		 * @param input
		 * @return
		 */
		public static function probe(input:ByteArray):Boolean
		{
			if (input[0] == 0x46 && input[1] == 0x4C && input[2] == 0x56 && input[3] < 5)
				return true;
			return false;
		}
	}
}

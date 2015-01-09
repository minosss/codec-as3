/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/24 10:58
 */
package cc.minos.codec {

	import cc.minos.codec.flv.FlvCodec;
	import cc.minos.codec.matroska.MatroskaCodec;
	import cc.minos.codec.mp4.Mp4Codec;

	import flash.utils.ByteArray;

	public class Codec extends Object implements ICodec {

		protected var _name:String = ':)'
		protected var _extensions:String;
		protected var _mimeType:String;

		protected var _rawData:ByteArray = null;
		;

		//
		protected var _frames:Vector.<IFrame> = new Vector.<IFrame>();
		protected var _keyframes:Vector.<uint> = null;

		protected var _hasVideo:Boolean = false;
		protected var _videoConfig:ByteArray = null; //sps & pps
		protected var _videoCodec:uint;
		protected var _videoWidth:Number = 0.0;
		protected var _videoHeight:Number = 0.0;
		protected var _videoRate:Number;

		protected var _frameRate:Number = 0.0; //fps

		protected var _hasAudio:Boolean = false;
		protected var _audioConfig:ByteArray = null; //audio specs
		protected var _audioCodec:uint;
		protected var _audioType:uint = 10;
		protected var _audioRate:Number = 44100;
		protected var _audioSize:Number = 16;
		protected var _audioChannels:uint = 2;
		protected var _audioProperties:uint = 0;

		protected var _duration:Number = 0.0;

		public function Codec()
		{
		}

		/* byte handlers */

		protected function byte_r8(s:*):int
		{
			if (s.position < s.length)
				return s.readByte();
			return 0;
		}

		protected function byte_rb16(s:*):uint
		{
			var val:uint;
			val = byte_r8(s) << 8;
			val |= byte_r8(s);
			return val;
		}

		protected function byte_rb24(s:*):uint
		{
			var val:uint;
			val = byte_rb16(s) << 8;
			val |= byte_r8(s);
			return val;
		}

		protected function byte_rb32(s:*):uint
		{
			var val:uint;
			val = byte_rb16(s) << 16;
			val |= byte_rb16(s);
			return val;
		}

		protected function byte_w8(s:*, b:int):void
		{
			if (b >= -128 && b <= 255)
				s.writeByte(b);
		}

		protected function byte_wb16(s:*, b:uint):void
		{
			byte_w8(s, b >> 8)
			byte_w8(s, b & 0xff);
		}

		protected function byte_wb24(s:*, b:uint):void
		{
			byte_wb16(s, b >> 8);
			byte_w8(s, b & 0xff);
		}

		protected function byte_wb32(s:*, b:uint):void
		{
			byte_w8(s, b >> 24);
			byte_w8(s, b >> 16 & 0xff);
			byte_w8(s, b >> 8 & 0xff);
			byte_w8(s, b & 0xff);
		}

		/* byte handlers end */

		public function decode(input:ByteArray):ICodec
		{
			return this;
		}

		public function encode(input:ICodec):ByteArray
		{
			return null;
		}

		public function probe(input:ByteArray):Boolean
		{
			return false;
		}

		public function getDataByFrame(frame:IFrame):ByteArray
		{
			var b:ByteArray = new ByteArray();
			b.writeBytes(_rawData, frame.offset, frame.size);
			return b;
		}

		public function export():ByteArray
		{
			return _rawData;
		}

		public function exportVideo():ByteArray
		{
			return null;
		}

		public function exportAudio():ByteArray
		{
			return null;
		}

		public function get name():String
		{
			return _name;
		}

		public function get frames():Vector.<IFrame>
		{
			return _frames;
		}

		public function get keyframes():Vector.<uint>
		{
			return _keyframes;
		}

		public function get duration():Number
		{
			return _duration;
		}

		public function get frameRate():Number
		{
			return _frameRate;
		}

		public function get hasVideo():Boolean
		{
			return _hasVideo;
		}

		public function get hasAudio():Boolean
		{
			return _hasAudio;
		}

		public function get videoConfig():ByteArray
		{
			return _videoConfig;
		}

		public function get videoCodec():uint
		{
			return _videoCodec;
		}

		public function get videoWidth():Number
		{
			return _videoWidth;
		}

		public function get videoHeight():Number
		{
			return _videoHeight;
		}

		public function get videoRate():Number
		{
			return _videoRate;
		}

		public function get audioConfig():ByteArray
		{
			return _audioConfig;
		}

		public function get audioCodec():uint
		{
			return _audioCodec;
		}

		public function get audioType():uint
		{
			return _audioType;
		}

		public function get audioRate():Number
		{
			return _audioRate;
		}

		public function get audioSize():Number
		{
			return _audioSize;
		}

		public function get audioChannels():uint
		{
			return _audioChannels;
		}

		/**
		 *
		 * @param input : ByteArray. raw data
		 * @return
		 */
		public static function decode( input:ByteArray ):ICodec
		{
			var c:ICodec;
			if (input[4] == 0x66 && input[5] == 0x74 && input[6] == 0x79 && input[7] == 0x70) //FTYP
				c = new Mp4Codec();
			else if (input[0] == 0x1A && input[1] == 0x45 && input[2] == 0xDF && input[3] == 0xA3) //EBML
				c = new MatroskaCodec();
			else
				throw new Error('Not Supported!!!');
			return c.decode(input);
		}

	}
}

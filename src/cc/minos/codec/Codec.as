/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/24 10:58
 */
package cc.minos.codec {
    import flash.utils.ByteArray;

    public class Codec extends Object implements ICodec {

        private var _type:String = ':)'

        protected var _rawData:ByteArray = null;;

        protected var _frames:Vector.<IFrame> = new Vector.<IFrame>();
        protected var _hasVideo:Boolean = false;
        protected var _hasAudio:Boolean = false;
        protected var _videoConfig:ByteArray = null; //sps & pps
        protected var _audioConfig:ByteArray = null; //sound spec

        protected var _videoRate:Number = 0.0;
        protected var _videoWidth:Number = 0.0;
        protected var _videoHeight:Number = 0.0;

        protected var _audioType:uint = 10;
        protected var _audioRate:Number = 44100;
        protected var _audioSize:Number = 16;
        protected var _audioChannels:uint = 2;
        protected var _audioProperties:uint = 0;

        protected var _duration:Number = 0.0;

        public function Codec( type:String )
        {
            this._type = type;
        }

        protected static function writeUI24(stream:*, p:uint):void
        {
            var byte1:int = p >> 16;
            var byte2:int = p >> 8 & 0xff;
            var byte3:int = p & 0xff;
            stream.writeByte(byte1);
            stream.writeByte(byte2);
            stream.writeByte(byte3);
        }

        protected static function writeUI16(stream:*, p:uint):void
        {
            stream.writeByte( p >> 8 )
            stream.writeByte( p & 0xff );
        }

        protected static function writeUI4_12(stream:*, p1:uint, p2:uint):void
        {
            // writes a 4-bit value followed by a 12-bit value in a total of 2 bytes

            var byte1a:int = p1 << 4;
            var byte1b:int = p2 >> 8;
            var byte1:int = byte1a + byte1b;
            var byte2:int = p2 & 0xff;

            stream.writeByte(byte1);
            stream.writeByte(byte2);
        }

        public function get type():String
        {
            return _type;
        }

        public function get hasVideo():Boolean
        {
            return false;
        }

        public function get hasAudio():Boolean
        {
            return false;
        }

        public function decode(input:ByteArray):ICodec
        {
            return this;
        }

        public function encode(input:ICodec):ByteArray
        {
            return null;
        }

        public function getDataByFrame(frame:IFrame):ByteArray
        {
            var b:ByteArray = new ByteArray();
            b.writeBytes( _rawData, frame.offset, frame.size );
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

        public function get frames():Vector.<IFrame>
        {
            return _frames;
        }

        public function get duration():Number
        {
            return _duration;
        }

        public function set hasVideo(value:Boolean):void
        {
            _hasVideo = value;
        }

        public function set hasAudio(value:Boolean):void
        {
            _hasAudio = value;
        }

        public function get videoConfig():ByteArray
        {
            return _videoConfig;
        }

        public function get audioConfig():ByteArray
        {
            return _audioConfig;
        }

        public function get videoRate():Number
        {
            return _videoRate;
        }

        public function get videoWidth():Number
        {
            return _videoWidth;
        }

        public function get videoHeight():Number
        {
            return _videoHeight;
        }
    }
}

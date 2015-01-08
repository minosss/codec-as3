/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/10 15:21
 */
package cc.minos.codec.mov {
    import cc.minos.codec.IFrame;
    import cc.minos.codec.flv.Flv;

    public class Sample extends Object implements IFrame, IMp4Frame{

        private var _offset:uint = 0;

        //video or audio
        private var _dataType:uint = 0x00;
        //I or P/B
        private var _frameType:uint = 2;
        private var _codecId:uint;
        private var _size:uint = 0;

        private var _timestamp:Number = 0;
        //
        private var _index:uint = 0;
        //index in chunk
        private var _sampleIndex:uint;
        //chunk index
        private var _chunkIndex:uint;

        public function Sample()
        {
        }

        public function get offset():uint
        {
            return _offset;
        }

        public function set offset(value:uint):void
        {
            _offset = value;
        }

        public function get size():uint
        {
            return _size;
        }

        public function set size(value:uint):void
        {
            _size = value;
        }

        public function get index():uint
        {
            return _index;
        }

        public function set index(value:uint):void
        {
            _index = value;
        }

        public function get sampleIndex():uint
        {
            return _sampleIndex;
        }

        public function set sampleIndex(value:uint):void
        {
            _sampleIndex = value;
        }

        public function get chunkIndex():uint
        {
            return _chunkIndex;
        }

        public function set chunkIndex(value:uint):void
        {
            _chunkIndex = value;
        }

        public function get frameType():uint
        {
            return _frameType;
        }

        public function set frameType(value:uint):void
        {
            _frameType = value;
        }

        public function get codecId():uint
        {
            return _codecId;
        }

        public function set codecId(value:uint):void
        {
            _codecId = value;
        }

        public function get dataType():uint
        {
            return _dataType;
        }

        public function set dataType(value:uint):void
        {
            _dataType = value;
        }

        public function get timestamp():Number
        {
            return _timestamp;
        }

        public function set timestamp(value:Number):void
        {
            _timestamp = value;
        }
    }
}

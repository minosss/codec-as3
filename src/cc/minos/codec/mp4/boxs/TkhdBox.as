/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/11 16:19
 */
package cc.minos.codec.mp4.boxs {
    import cc.minos.codec.mp4.Mp4;
    import cc.minos.codec.utils.SimpleDateFormatter;

    public class TkhdBox extends Box {

        private var _version:int;
        private var _flags:uint;

        private var _id:uint;
        private var _duration:uint;
        private var _volume:uint;
        private var _width:uint;
        private var _height:uint;

        public function TkhdBox()
        {
            super(Mp4.BOX_TYPE_TKHD);
        }

        override protected function init():void
        {
            data.position = 8;
            _version = data.readUnsignedByte();
            _flags = ( (data.readUnsignedShort() << 8) | data.readUnsignedByte() );

            var creationTime:Date = new Date(Date.UTC(1904, 0, 1)); //from 1904
            creationTime.secondsUTC = data.readUnsignedInt();
//            trace('creation time: ' + SimpleDateFormatter.formatDate( creationTime, 'yyyy-MM-dd kk:mm:ss') );

            var modificationTime = new Date(Date.UTC(1904, 0, 1)); //from 1904
            modificationTime.secondsUTC = data.readUnsignedInt();
//            trace('modification time: ' + SimpleDateFormatter.formatDate( modificationTime, 'yyyy-MM-dd kk:mm:ss') );

            _id = data.readUnsignedInt();
//            trace('id: ' + data.readUnsignedInt());
//            trace('reserved: ' + data.readUnsignedInt() );
            data.readUnsignedInt();

            _duration = data.readUnsignedInt();
//            trace('duration: ' + _duration );

            data.position += 12;

//            trace('layer: ' + data.readShort() );
//            trace('group: ' + data.readShort() );

            _volume = data.readShort() / Mp4.FIXED_POINT_8_8;
//            trace('volume: ' + data.readShort() / 256.0 );
//            trace('reserved: ' + data.readShort() );

            data.position += 38;

            _width = data.readInt() / Mp4.FIXED_POINT_16_16;
            _height = data.readInt() / Mp4.FIXED_POINT_16_16;

//            trace('width: ' + _width );
//            trace('height: ' + _height );

        }

        public function get id():uint
        {
            return _id;
        }

        public function get duration():uint
        {
            return _duration;
        }

        public function get volume():uint
        {
            return _volume;
        }

        public function get width():uint
        {
            return _width;
        }

        public function get height():uint
        {
            return _height;
        }
    }
}

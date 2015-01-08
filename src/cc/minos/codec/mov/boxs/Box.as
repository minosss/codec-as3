/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/8 16:36
 */
package cc.minos.codec.mov.boxs {

    import cc.minos.codec.mov.Mp4;
    import cc.minos.codec.utils.ByteArrayUtil;
    import flash.utils.ByteArray;

    /**
     * base box
     */
    public class Box {

        private var _type:uint = 0x0;
        private var _size:uint = 0;
        private var _position:uint = 0;
        private var _data:ByteArray;
        private var _childs:Vector.<Box>;

        public function Box( type:uint )
        {
            this._type = type;
        }

        public function parse( byte:ByteArray ):void
        {
            this.data = byte;
            this._childs = new Vector.<Box>();

            var size:uint;
            var type:uint;
            var offset:uint;
            var end:uint;
            var box:Box;

            data.position = 0;
            while( data.bytesAvailable > 8 )
            {
                offset = data.position;
                size = data.readUnsignedInt();
                type = data.readUnsignedInt();
                if( type === this.type){
                    this.size = size;
                    decode();
                    continue;
                }
                end = offset + size;
                box = Mp4.getBox(type);
                if( box )
                {
                    box.size = size;
                    box.position = offset;
                    var d:ByteArray = new ByteArray();
                    d.writeBytes(data, offset, size);
                    box.parse(d);
                    _childs.push(box);
                }
                else
                {
                    break;
                }
                data.position = end;
            }
            init();
        }

        /** **/
        protected function decode():void
        {
        }

        /**  **/
        protected function init():void
        {
        }

        /**
         *
         * @param type : uint
         * @return Vector.<Box>
         */
        public function getBox(type:uint):Vector.<Box>
        {
            var boxs:Vector.<Box> = new Vector.<Box>();
            if(_childs.length > 0)
            {
                for each(var b:Box in _childs)
                {
                    if( b.type === type )
                        boxs.push(b);
                    else if( boxs.length == 0 && b.childs.length > 0 )
                    {
                        boxs = b.getBox(type);
                        if( boxs.length > 0 ){
                            return boxs;
                        }
                    }
                }
            }
            return boxs;
        }

        public function get size():uint
        {
            return _size;
        }

        public function set size(value:uint):void
        {
            _size = value;
        }

        public function get position():uint
        {
            return _position;
        }

        public function set position(value:uint):void
        {
            _position = value;
        }

        public function get data():ByteArray
        {
            return _data;
        }

        public function set data(value:ByteArray):void
        {
            _data = value;
        }

        public function get type():uint
        {
            return _type;
        }

        public function get childs():Vector.<Box>
        {
            return _childs;
        }

        public function toString():String
        {
            return '[ ' + Box.toString(type.toString(16)) + ' Box ' + size + ' ]';
        }

        public static function toString(hex:String):String {
            var a:ByteArray = toArray(hex);
            return a.readUTFBytes(a.length);
        }

        public static function toArray(hex:String):ByteArray {
            hex = hex.replace(/\s|:/gm,'');
            var a:ByteArray = new ByteArray;
            if ((hex.length&1)==1) hex="0"+hex;
            for (var i:uint=0;i<hex.length;i+=2) {
                a[i/2] = parseInt(hex.substr(i,2),16);
            }
            return a;
        }

        public static function findBox( data:ByteArray, type:uint ):Box
        {
            var byte:ByteArray = new ByteArray();
            byte.writeUnsignedInt(type);
            var index:int = ByteArrayUtil.byteArrayIndexOf(data, byte);
            if(index != -1)
            {
                byte.clear();
                data.position = index - 4;
                var size:int = data.readUnsignedInt();
                byte.writeBytes(data, index - 4, size);
                var box:Box = Mp4.getBox(type);
                box.parse(byte);
                box.position = index - 4;
                return box;
            }
            return null;
        }

    }
}
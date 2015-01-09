/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/29 09:51
 */
package cc.minos.codec.matroska.elements {

    import cc.minos.codec.matroska.Matroska;

    import com.hurlant.math.BigInteger;

    import flash.utils.ByteArray;

    public class Element extends Object {

        protected var _type:uint = 0x0;
        protected var _size:uint = 0;
        protected var _position:uint = 0;
        protected var _data:ByteArray;
        protected var _children:Vector.<Element>;

        //mask
        private static const SUBTR:Array = [
            new BigInteger('0x7F', 16, true),
            new BigInteger('0x3FFF', 16, true),
            new BigInteger('0x1FFFFF', 16, true),
            new BigInteger('0x0FFFFFFF', 16, true),
            new BigInteger('0x07FFFFFFFF', 16, true),
            new BigInteger('0x03FFFFFFFFFF', 16, true),
            new BigInteger('0x01FFFFFFFFFFFF', 16, true),
            new BigInteger('0x00FFFFFFFFFFFFFF', 16, true) ];

        public function Element(type:uint)
        {
            this._type = type;
        }

        /**
         *
         * @param bytes
         */
        public function parse(bytes:ByteArray):void
        {
            //
            this._data = bytes;
            _children = new Vector.<Element>();

            var byte:ByteArray;
            var start:uint;
            var len:uint;
            var size:uint;
            var id:uint;
            var element:Element;

            _data.position = 0;
            while(_data.bytesAvailable > 0)
            {
                start = _data.position;
                len = getLength(_data.readUnsignedByte());//

                if(len > _data.length) break;

                //id
                byte = new ByteArray();
                byte.writeBytes(_data, start, len);
                id = toHex(byte);
                //
                element = getElement(id);
                if(element)
                {
                    element.position = start;
                    _data.position = start + len;
                    start = _data.position;
                    //size
                    len = getLength(_data.readUnsignedByte());
                    byte.length = 0;
                    byte.writeBytes(_data, start, len);
                    size = getSize(byte, len);

                    //data
                    byte.length = 0;
                    byte.writeBytes(_data, (start + len), size);
                    element.size = size;
                    element.parse(byte);
                    _children.push(element);
                    _data.position = start + len + size;
                }
                else
                {
                    trace(id.toString(16), 'not found!');
                    break;
                }
            }
            init();
        }

        protected function init():void
        {
            //
        }

        /**
         * this element contains others elements.
         * default: void and crc32 are global element.
         * @param type
         * @return
         */
        protected function getElement(type:uint):Element
        {
            switch(type){
                case Matroska.VOID:
                case Matroska.CRC_32:
                    return new GlobalElement(type);
            }
            return null;
        }

        /**
         * search all child under this element (same level)
         * @param type
         * @return
         */
        public function getChildByType(type:uint):Vector.<Element>
        {
            var elements:Vector.<Element> = new Vector.<Element>();
            if( children.length > 0 )
            {
                for(var i:int = 0; i < children.length; i++)
                {
                    var e:Element = children[i];
                    if(e.type == type)
                    {
                        elements.push(e);
                    }else if( elements.length == 0 && e.children.length > 0 )
                    {
                        elements = e.getChildByType(type);
                        if(elements.length > 0)
                        {
                            return elements;
                        }
                    }

                }
            }
            return elements;
        }

        public function getString():String
        {
            _data.position = 0;
            return _data.readUTFBytes(_data.length);
        }

        public function getNumber():Number
        {
            _data.position = 0;
            return _data.readDouble();
        }

        public function getInt():int
        {
            _data.position = 0;
            return toHex(_data);
        }

        /**
         * print this element's information
         * @return
         */
        public function toString():String
        {
            return '[ Element: ' + type.toString(16) + ' at ' + position + ' size ' + size + ']';
        }

        /**
         * ByteArray to number
         * @param array : ByteArray(EBML-ID)
         * @return
         */
        public static function toHex(array:ByteArray):uint
        {
            var s:String = "";
            for(var i:uint = 0; i < array.length; i++)
            {
                s += ("0" + array[i].toString(16)).substr(-2, 2);
            }
            return parseInt(s, 16);
        }

        /**
         * number of heading zero bits. (+1 the first 1's position)
         * @param byte
         * @return
         */
        public static function getLength(byte:uint):uint
        {
            return (8 - byte.toString(2).length) + 1;
        }

        /**
         * get data size using big integer.
         * @param byte
         * @param len
         * @return
         */
        public static function getSize(byte:ByteArray, len:uint):int
        {
            var val:int = 0;
            byte.position = 0;
            var valu:BigInteger = new BigInteger(byte, 0, true);
            var mask:BigInteger = SUBTR[len - 1];
            val = valu.and(mask).intValue();
            return val;
        }

        //

        public function get type():uint
        {
            return _type;
        }

        public function get size():uint
        {
            return _size;
        }

        public function get position():uint
        {
            return _position;
        }

        public function get data():ByteArray
        {
            return _data;
        }

        public function get children():Vector.<Element>
        {
            return _children;
        }

        public function set position(value:uint):void
        {
            _position = value;
        }

        public function set size(value:uint):void
        {
            _size = value;
        }
    }
}

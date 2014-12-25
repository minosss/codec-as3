/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/10 16:17
 */
package cc.minos.codec.utils {

    import flash.utils.ByteArray;

    public class ByteArrayUtil {


        public static function byteArrayIndexOf($ba:ByteArray, $searchTerm:ByteArray):int
        {
            var origPosBa:int = $ba.position;
            var origPosSearchTerm:int = $searchTerm.position;

            var end:int = $ba.length - $searchTerm.length
            for (var i:int = 0; i <= end; i++)
            {
                if (byteArrayEqualsAt($ba, $searchTerm, i))
                {
                    $ba.position = origPosBa;
                    $searchTerm.position = origPosSearchTerm;
                    return i;
                }
            }

            $ba.position = origPosBa;
            $searchTerm.position = origPosSearchTerm;
            return -1;
        }

        public static function byteArrayEqualsAt($ba:ByteArray, $searchTerm:ByteArray, $position:int):Boolean
        {
            // NB, function will modify byteArrays' cursors

            if ($position + $searchTerm.length > $ba.length) return false;

            $ba.position = $position;
            $searchTerm.position = 0;

            for (var i:int = 0; i < $searchTerm.length; i++)
            {
                var valBa:int = $ba.readByte();
                var valSearch:int = $searchTerm.readByte();
                if (valBa != valSearch) return false;
            }

            return true;
        }

        /*public static function writeUI24(stream:*, p:uint):void
        {
            var byte1:int = p >> 16;
            var byte2:int = p >> 8 & 0xff;
            var byte3:int = p & 0xff;
            stream.writeByte(byte1);
            stream.writeByte(byte2);
            stream.writeByte(byte3);
        }
        public static function writeUI16(stream:*, p:uint):void
        {
            stream.writeByte( p >> 8 )
            stream.writeByte( p & 0xff );
        }
        public static function writeUI4_12(stream:*, p1:uint, p2:uint):void
        {
            // writes a 4-bit value followed by a 12-bit value in a total of 2 bytes

            var byte1a:int = p1 << 4;
            var byte1b:int = p2 >> 8;
            var byte1:int = byte1a + byte1b;
            var byte2:int = p2 & 0xff;

            stream.writeByte(byte1);
            stream.writeByte(byte2);
        }*/

    }
}

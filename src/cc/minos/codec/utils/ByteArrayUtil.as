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

        public static function toString( hex:String ):String {
            var a:ByteArray = toArray(hex);
            return a.readUTFBytes(a.length);
        }

        public static function toArray( hex:String ):ByteArray {
            hex = hex.replace(/\s|:/gm,'');
            var a:ByteArray = new ByteArray;
            if ((hex.length&1)==1) hex="0"+hex;
            for (var i:uint=0;i<hex.length;i+=2) {
                a[i/2] = parseInt(hex.substr(i,2),16);
            }
            return a;
        }

    }
}

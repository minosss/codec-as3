/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/10 15:56
 */
package cc.minos.codec.mov.boxs {
    import cc.minos.codec.mov.Mp4;

    import flash.utils.ByteArray;

    public class EsdsBox extends Box {

        private var _configurationData:ByteArray;

        public function EsdsBox()
        {
            super(Mp4.BOX_TYPE_ESDS);
        }

        override protected function init():void
        {
            //sound
            trace('esds ======');

            data.position = 8;

            var tag:uint;
            while(data.bytesAvailable > 0)
            {
                tag = data.readByte();
                if( tag == 0x04 ){
                    //codec
                }
                else if( tag == 0x05 )
                {
                    if( data.readByte() == 0x80 )
                    {
                        data.position +=2;
                    }
                    else{
                        data.position -=1;
                    }
                    _configurationData = new ByteArray();
                    _configurationData.writeBytes( data, data.position, data.readUnsignedByte() );
                    break;
                }
            }

        }

        public function get configurationData():ByteArray
        {
            return _configurationData;
        }
    }
}

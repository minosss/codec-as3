/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/8 16:30
 */
package cc.minos.codec.mov {
    import cc.minos.codec.mov.boxs.*;

    public class Mp4 {

        /** audio codec **/

        public static const CODEC_ID_MOV_TEXT:uint = 0x08;
        public static const CODEC_ID_MPEG4:uint = 0x20;
        public static const CODEC_ID_H264:uint = 0x21;
        public static const CODEC_ID_AAC:uint = 0x40;
        public static const CODEC_ID_MP3:uint = 0x69;
        public static const CODEC_ID_AC3:uint = 0xA5;

        public static const CODEC_ID_MPEG2_AAC:uint = 0x66;
        public static const CODEC_ID_MPEG2_AAC_LOW:uint = 0x67;
        public static const CODEC_ID_MPEG2_AAC_SSR:uint = 0x68;

        /**  **/

        public static const FIXED_POINT_16_16:Number = 65536.0;
        public static const FIXED_POINT_8_8:Number = 256.0;

        /** trak type **/

        public static const TRAK_TYPE_VIDE:uint = 0x76696465;
        public static const TRAK_TYPE_SOUN:uint = 0x736F756E;

        /** mp4 box type **/

        //file type
        public static const BOX_TYPE_FTYP:uint = 0x66747970;
        //metadata container
        public static const BOX_TYPE_MOOV:uint = 0x6D6F6F76;
        //media data container
        public static const BOX_TYPE_MDAT:uint = 0x6D646174;
        //movie header
        public static const BOX_TYPE_MVHD:uint = 0x6D766864;
        public static const BOX_TYPE_IODS:uint = 0x696F6473;
        //track or stream container
        public static const BOX_TYPE_TRAK:uint = 0x7472616B;
        public static const BOX_TYPE_UDTA:uint = 0x75647461;
        //track header
        public static const BOX_TYPE_TKHD:uint = 0x746B6864;
        public static const BOX_TYPE_EDTS:uint = 0x65647473;
        //track media information container
        public static const BOX_TYPE_MDIA:uint = 0x6D646961;
        //media header
        public static const BOX_TYPE_MDHD:uint = 0x6D646864;
        //handler
        public static const BOX_TYPE_HDLR:uint = 0x68646C72;
        //media information container
        public static const BOX_TYPE_MINF:uint = 0x6D696E66;

        public static const BOX_TYPE_VMHD:uint = 0x766D6864;
        public static const BOX_TYPE_SMHD:uint = 0x736D6864;
        public static const BOX_TYPE_DINF:uint = 0x64696E66;
        public static const BOX_TYPE_DREF:uint = 0x64726566;
        //sample table box
        public static const BOX_TYPE_STBL:uint = 0x7374626C;
        //sample descriptions
        public static const BOX_TYPE_STSD:uint = 0x73747364;
        //time to sample
        public static const BOX_TYPE_STTS:uint = 0x73747473;
        //sample to chunk
        public static const BOX_TYPE_STSC:uint = 0x73747363;
        //sample size
        public static const BOX_TYPE_STSZ:uint = 0x7374737A;
        //sync sample table
        public static const BOX_TYPE_STSS:uint = 0x73747373;
        //chunk offset
        public static const BOX_TYPE_STCO:uint = 0x7374636F;
        public static const BOX_TYPE_CO64:uint = 0x636F0604;

        public static const BOX_TYPE_MP4A:uint = 0x6D703461;
        public static const BOX_TYPE_ESDS:uint = 0x65736473;

        public static const BOX_TYPE_MP4S:uint = 0x6D703473;

        public static const BOX_TYPE_AVC1:uint = 0x61766331;
        public static const BOX_TYPE_AVCC:uint = 0x61766343;
        public static const BOX_TYPE_BTRT:uint = 0x62747274;

        public static const BOX_TYPE_FREE:uint = 0x66726565;


        /**
         *
         * @param type
         * @return Box
         */
        public static function getBox(type:uint):Box
        {
            var box:Box = null;
            switch(type)
            {
                case BOX_TYPE_FTYP:
                    box = new FtypBox();
                    break;
                case BOX_TYPE_MOOV:
                    box = new MoovBox();
                    break;
                case BOX_TYPE_MDAT:
                    box = new MdatBox();
                    break;
                //
                case BOX_TYPE_MVHD:
                    box = new MvhdBox();
                    break;
                case BOX_TYPE_TRAK:
                    box = new TrakBox();
                    break;
                case BOX_TYPE_STBL:
                    box = new StblBox();
                    break;
                case BOX_TYPE_HDLR:
                    box = new HdlrBox();
                    break;
                //sample table
                case BOX_TYPE_STSS:
                    box = new StssBox();
                    break;
                case BOX_TYPE_STSC:
                    box = new StscBox();
                    break;
                case BOX_TYPE_STCO:
                    box = new StcoBox();
                    break;
                case BOX_TYPE_STSZ:
                    box = new StszBox();
                    break;
                /*case BOX_TYPE_AVCC:
                    box = new AvccBox();
                    break;
                case BOX_TYPE_ESDS:
                    box = new EsdsBox();
                    break;*/
                case BOX_TYPE_TKHD:
                    box = new TkhdBox();
                    break;
                case BOX_TYPE_STSD:
                    box = new StsdBox();
                    break;
                case BOX_TYPE_STTS:
                    box = new SttsBox();
                    break;
                case BOX_TYPE_MDHD:
                    box = new MdhdBox();
                    break;
                //others
                case BOX_TYPE_MDIA:
                case BOX_TYPE_MINF:
                case BOX_TYPE_UDTA:
                case BOX_TYPE_IODS:
                case BOX_TYPE_EDTS:
                case BOX_TYPE_VMHD:
                case BOX_TYPE_SMHD:
                case BOX_TYPE_DINF:
                case BOX_TYPE_DREF:
                case BOX_TYPE_FREE:
                    box = new Box(type);
                    break;
                default :
                    trace('[MP4::getBox] 0x' + type.toString(16) + ' not defined.');
            }
            return box;
        }
    }
}

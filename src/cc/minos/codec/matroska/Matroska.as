/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/25 18:00
 */
package cc.minos.codec.matroska {

    public class Matroska {

        //
        public static const VOID:uint = 0xEC;
        public static const CRC_32:uint = 0xBF;

        //
        public static const EBML_ID:uint = 0x1A45DFA3;
        public static const EBML_VERSION:uint = 0x4286;
        public static const EBML_READ_VERSION:uint = 0x42F7;
        public static const EBML_MAX_ID_LENGTH:uint = 0x42F2;
        public static const EBML_MAX_SIZE_LENGTH:uint = 0x42F3;
        public static const EBML_DOC_TYPE:uint = 0x4282;
        public static const EBML_DOC_TYPE_VERSION:uint = 0x4287;
        public static const EBML_DOC_TYPE_READ_VERSION:uint = 0x4285;

        //
        public static const SEGMENT_ID:uint = 0x18538067;

        /**
         * segment info contains general information about a segment.
         */
        public static const SEGMENT_INFO:uint = 0x1549A966;
        public static const SEGMENT_UID:uint = 0x73A4;
        public static const SEGMENT_FILE_NAME:uint = 0x7384;
        public static const SEGMENT_PREV_UID:uint = 0x3CB923;
        public static const SEGMENT_PREV_FILE_NAME:uint = 0x3C83AB;
        public static const SEGMENT_NEXT_UID:uint = 0x3EB923;
        public static const SEGMENT_NEXT_FILE_NAME:uint = 0x3E83BB;
        public static const SEGMENT_TIME_CODE_SCALE:uint = 0x2AD7B1;
        public static const SEGMENT_DURATION:uint = 0x4489;
        public static const SEGMENT_TITLE:uint = 0x7BA9;
        public static const SEGMENT_MUXINGAPP:uint = 0x4D80;
        public static const SEGMENT_WRITINGAPP:uint = 0x5741;
        public static const SEGMENT_DATEUTC:uint = 0x4461;   //2001.1.1 0:00:00

        /**
         * a seek head is an index of elements that are children of segment.
         */
        public static const SEEK_HEAD:uint = 0x114D9B74;
        //one seek element contains an EBML-ID and the position within the segment at which an element with this id can be found.
        public static const SEEK:uint = 0x4DBB;
        public static const SEEK_ID:uint = 0x53AB;
        public static const SEEK_POSITION:uint = 0x53AC;

        /**
         * a tracks element contains the description of some or all tracks(preferably all).
         */
        public static const TRACKS:uint = 0x1654AE6B;

        public static const TRACK_ENTRY:uint = 0xAE;
        public static const TRACK_NUMBER:uint = 0xD7;
        public static const TRACK_UID:uint = 0x73C5;
        //0x01 > video, 0x02 > audio, 0x03 > complex, 0x10 > logo, 0x11 > subtitle, 0x12 > button, 0x20 > control
        public static const TRACK_TYPE:uint = 0x83;
        public static const TRACK_FLAG_ENABLED:uint = 0xB9;
        public static const TRACK_FLAG_DEFAULT:uint = 0x88;
        public static const TRACK_FLAG_FORCED:uint = 0x55AA;
        public static const TRACK_FLAG_LACING:uint = 0x9C;
        public static const TRACK_MIN_CACHE:uint = 0x6DE7;
        public static const TRACK_MAX_CACHE:uint = 0x6DF8;
        public static const TRACK_DEFAULT_DURATION:uint = 0x23E383;
        public static const TRACK_TIMECODE_SCALE:uint = 0x23314F;
        public static const TRACK_NAME:uint = 0x536E;
        public static const TRACK_LANGUAGE:uint = 0x22B59C;
        public static const TRACK_CODEC_ID:uint = 0x86;
        public static const TRACK_CODEC_PRIVATE:uint = 0x63A2;
        public static const TRACK_CODEC_NAME:uint = 0x258688;
        public static const TRACK_ATTACHMENT_LINK:uint = 0x7446;
        //video track
        public static const TRACK_VIDEO:uint = 0xE0;
        public static const VIDEO_PIXEL_WIDTH:uint = 0xB0;
        public static const VIDEO_PIXEL_HEIGHT:uint = 0xBA;
        public static const VIDEO_PIXEL_CROP_BOTTOM:uint = 0x54AA;
        public static const VIDEO_PIXEL_CROP_TOP:uint = 0x54BB;
        public static const VIDEO_PIXEL_CROP_LEFT:uint = 0x54CC;
        public static const VIDEO_PIXEL_CROP_RIGHT:uint = 0x54DD;
        public static const VIDEO_DISPLAY_WIDTH:uint = 0x54B0;
        public static const VIDEO_DISPLAY_HEIGHT:uint = 0x54BA;
        public static const VIDEO_DISPLAY_UINT:uint = 0x54B2;
        //audio track
        public static const TRACK_AUDIO:uint = 0xE1;
        public static const AUDIO_SAMPLING_FREQUENCY:uint = 0xB5;
        public static const AUDIO_OUTPUT_SAMPLING_FREQUENCY:uint = 0x78B5;
        public static const AUDIO_CHANNELS:uint = 0x9F;
        public static const AUDIO_BIT_DEPTH:uint = 0x6264;
        //information
        public static const CONTENT_ENCODINGS:uint = 0x6D80;
        public static const CONTENT_ENCODING:uint = 0x6240;
        public static const CONTENT_ENCODING_ORDER:uint = 0x5031;
        public static const CONTENT_ENCODING_SCOPE:uint = 0x5032;
        public static const CONTENT_ENCODING_TYPE:uint = 0x5033;
        public static const CONTENT_COMPRESSION:uint = 0x5034;
        //value of content comp a lgo zlib: 0, bzlib: 1, lzo1x: 2, header striping: 3
        public static const CONTENT_COMPALGO:uint = 0x4254;
        public static const CONTENT_COMPSETTINGS:uint = 0x4255;
        public static const CONTENT_ENCRYPTION:uint = 0x5035;

        /**
         * a cluster contains video, audio and subtitle data.
         */
        public static const CLUSTER:uint = 0x1F43B675;
        public static const CLUSTER_TIMECODE:uint = 0xE7;
        public static const CLUSTER_POSITION:uint = 0xA7;
        public static const CLUSTER_PREV_SIZE:uint = 0xAB;
        public static const CLUSTER_BLOCK_GROUP:uint = 0xA0;
        public static const CLUSTER_SIMPLE_BLOCK:uint = 0xA3;

        public static const BLOCK_GROUP_BLOCK:uint = 0xA1;
        public static const GROUP_REFERENCE_BLOCK:uint = 0xFB;
        public static const GROUP_BLOCK_DURATION:uint = 0x9B;

        /**
         * the cues elements contains a timestamp-wise index to clusters, thus it's helpful for easy and quick seeking.
         */
        public static const CUES:uint = 0x1C53BB6B;
        public static const CUES_CUE_POINT:uint = 0xBB;
        public static const POINT_CUE_TIME:uint = 0xB3;
        public static const POINT_CUE_TRACK_POSITIONS:uint = 0xB7;

        /**
         * the attachments elements contains all files attached to this segment.
         */
        public static const ATTACHMENTS:uint = 0x1941A469;
        /**
         * the chapters elements contains the definition of all chapters and editions of this segment.
         */
        public static const CHAPTERS:uint = 0x1043A770;
        /**
         * the tags elements contains further information about the segment or elements inside the segment that is not ready required for playback.
         */
        public static const TAGS:uint = 0x1254C367;

        /** **/

    }
}

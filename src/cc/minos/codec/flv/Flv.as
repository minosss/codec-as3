/**
 * Created by minos on 15/1/6.
 */
package cc.minos.codec.flv {

    /**
     *
     */
    public class Flv {

        //offset
        public static const AUDIO_SAMPLESSIZE_OFFSET:uint = 1;
        public static const AUDIO_SAMPLERATE_OFFSET:uint = 2;
        public static const AUDIO_CODECID_OFFSET:uint = 4;
        public static const VIDEO_FRAMETYPE_OFFSET:uint = 4;

        /* data */

        //type
        public static const AMF_DATA_TYPE_NUMBER:uint = 0x00;
        public static const AMF_DATA_TYPE_BOOLEAN:uint = 0x01;
        public static const AMF_DATA_TYPE_STRING:uint = 0x02;
        public static const AMF_DATA_TYPE_OBJECT:uint = 0x03;
        public static const AMF_DATA_TYPE_NULL:uint = 0x05;
        public static const AMF_DATA_TYPE_UNDEFINED:uint = 0x06;
        public static const AMF_DATA_TYPE_REFERENCE:uint = 0x07;
        public static const AMF_DATA_TYPE_MIXEDARRAY:uint = 0x08;
        public static const AMF_DATA_TYPE_OBJECT_END:uint = 0x09;
        public static const AMF_DATA_TYPE_ARRAY:uint = 0x0a;
        public static const AMF_DATA_TYPE_DATE:uint = 0x0b;
        public static const AMF_DATA_TYPE_LONG_STRING:uint = 0x0c;
        public static const AMF_DATA_TYPE_UNSUPPORTED:uint = 0x0d;
        public static const AMF_END_OF_OBJECT:uint = 0x09;

        /* video */

        //codec id
        public static const VIDEO_CODECID_H263:uint = 2;
        public static const VIDEO_CODECID_SCREEN:uint = 3;
        public static const VIDEO_CODECID_VP6:uint = 4;
        public static const VIDEO_CODECID_VP6A:uint = 5;
        public static const VIDEO_CODECID_SCREEN2:uint = 6;
        public static const VIDEO_CODECID_H264:uint = 7;
        public static const VIDEO_CODECID_REALH263:uint = 8;
        public static const VIDEO_CODECID_MPEG4:uint = 9;
        //frame
        public static const VIDEO_FRAME_KEY:uint = 1 << VIDEO_FRAMETYPE_OFFSET; ///< key frame (for AVC, a seekable frame)
        public static const VIDEO_FRAME_INTER:uint = 2 << VIDEO_FRAMETYPE_OFFSET; ///< inter frame (for AVC, a non-seekable frame)
        public static const VIDEO_FRAME_DISP_INTER:uint = 3 << VIDEO_FRAMETYPE_OFFSET; ///< disposable inter frame (H.263 only)
        public static const VIDEO_FRAME_GENERATED_KEY:uint = 4 << VIDEO_FRAMETYPE_OFFSET; ///< generated key frame (reserved for server use only)
        public static const VIDEO_FRAME_VIDEO_INFO_CMD:uint = 5 << VIDEO_FRAMETYPE_OFFSET; ///< video info/command frame

        /* audio */

        //size
        public static const AUDIO_SAMPLESSIZE_8BIT:uint = 0;
        public static const AUDIO_SAMPLESSIZE_16BIT:uint = 1 << AUDIO_SAMPLESSIZE_OFFSET;
        //rate
        public static const AUDIO_SAMPLERATE_SPECIAL:uint = 0;
        public static const AUDIO_SAMPLERATE_11025HZ:uint = 1 << AUDIO_SAMPLERATE_OFFSET;
        public static const AUDIO_SAMPLERATE_22050HZ:uint = 2 << AUDIO_SAMPLERATE_OFFSET;
        public static const AUDIO_SAMPLERATE_44100HZ:uint = 3 << AUDIO_SAMPLERATE_OFFSET;
        //channel
        public static const AUDIO_CHANNEL_MONO:uint = 0;
        public static const AUDIO_CHANNEL_STEREO:uint = 1;
        //codec id
        public static const AUDIO_CODECID_PCM:uint = 0;
        public static const AUDIO_CODECID_ADPCM:uint = 1 << AUDIO_CODECID_OFFSET;
        public static const AUDIO_CODECID_MP3:uint = 2 << AUDIO_CODECID_OFFSET;
        public static const AUDIO_CODECID_PCM_LE:uint = 3 << AUDIO_CODECID_OFFSET;
        public static const AUDIO_CODECID_NELLYMOSER_16KHZ_MONO:uint = 4 << AUDIO_CODECID_OFFSET;
        public static const AUDIO_CODECID_NELLYMOSER_8KHZ_MONO:uint = 5 << AUDIO_CODECID_OFFSET;
        public static const AUDIO_CODECID_NELLYMOSER:uint = 6 << AUDIO_CODECID_OFFSET;
        public static const AUDIO_CODECID_PCM_ALAW:uint = 7 << AUDIO_CODECID_OFFSET;
        public static const AUDIO_CODECID_PCM_MULAW:uint = 8 << AUDIO_CODECID_OFFSET;
        public static const AUDIO_CODECID_AAC:uint = 10 << AUDIO_CODECID_OFFSET;
        public static const AUDIO_CODECID_SPEEX:uint = 11 << AUDIO_CODECID_OFFSET;

        /* tag */
        public static const TAG_TYPE_AUDIO:uint = 0x08;
        public static const TAG_TYPE_VIDEO:uint = 0x09;
        public static const TAG_TYPE_META:uint = 0x12;

        //

    }
}

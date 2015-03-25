/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/30 17:13
 */
package cc.minos.codec.mkv.elements {
    import cc.minos.codec.mkv.Mkv;

    public class AudioTrack extends Element {

        public function AudioTrack()
        {
            super(Mkv.TRACK_AUDIO);
        }

        override protected function getElement(type:uint):Element
        {
            switch (type)
            {
                case Mkv.AUDIO_SAMPLING_FREQUENCY:   //Hz
                case Mkv.AUDIO_OUTPUT_SAMPLING_FREQUENCY:
                case Mkv.AUDIO_CHANNELS:  //
                case Mkv.AUDIO_BIT_DEPTH: //
                    return new VarElement(type);
            }
            return super.getElement(type);
        }

        override protected function init():void
        {
            trace('audio track');
            trace('sampling frequency: ' + getChildByType(Mkv.AUDIO_SAMPLING_FREQUENCY)[0].getNumber() + 'kHz')
            trace('channels: ' + getChildByType(Mkv.AUDIO_CHANNELS)[0].getInt());
            trace('bit depth: ' + getChildByType(Mkv.AUDIO_BIT_DEPTH)[0].getInt() + 'bit' );
            trace('childs: ' + children.length);
        }
    }
}

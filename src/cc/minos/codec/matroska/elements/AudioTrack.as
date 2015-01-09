/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/30 17:13
 */
package cc.minos.codec.matroska.elements {
    import cc.minos.codec.matroska.Matroska;

    public class AudioTrack extends Element {
        public function AudioTrack()
        {
            super(Matroska.TRACK_AUDIO);
        }

        override protected function getElement(type:uint):Element
        {
            switch (type)
            {
                case Matroska.AUDIO_SAMPLING_FREQUENCY:   //Hz
                case Matroska.AUDIO_OUTPUT_SAMPLING_FREQUENCY:
                case Matroska.AUDIO_CHANNELS:  //
                case Matroska.AUDIO_BIT_DEPTH: //
                    return new VarElement(type);
            }
            return super.getElement(type);
        }

        override protected function init():void
        {
            trace('audio track');
            trace('sampling frequency: ' + getChildByType(Matroska.AUDIO_SAMPLING_FREQUENCY)[0].getNumber() + 'kHz')
            trace('channels: ' + getChildByType(Matroska.AUDIO_CHANNELS)[0].getInt());
            trace('bit depth: ' + getChildByType(Matroska.AUDIO_BIT_DEPTH)[0].getInt() + 'bit' );
            trace('childs: ' + children.length);
        }
    }
}

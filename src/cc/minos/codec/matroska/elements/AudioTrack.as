/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/30 17:13
 */
package cc.minos.codec.matroska.elements {
    import cc.minos.codec.matroska.MaConstans;

    public class AudioTrack extends Element {
        public function AudioTrack()
        {
            super(MaConstans.TRACK_AUDIO);
        }

        override protected function getElement(type:uint):Element
        {
            switch (type)
            {
                case MaConstans.AUDIO_SAMPLING_FREQUENCY:   //Hz
                case MaConstans.AUDIO_OUTPUT_SAMPLING_FREQUENCY:
                case MaConstans.AUDIO_CHANNELS:  //
                case MaConstans.AUDIO_BIT_DEPTH: //
                    return new VarElement(type);
            }
            return super.getElement(type);
        }

        override protected function init():void
        {
            trace('audio track');
            trace('sampling frequency: ' + getChildByType(MaConstans.AUDIO_SAMPLING_FREQUENCY)[0].getNumber() + 'kHz')
            trace('channels: ' + getChildByType(MaConstans.AUDIO_CHANNELS)[0].getInt());
            trace('bit depth: ' + getChildByType(MaConstans.AUDIO_BIT_DEPTH)[0].getInt() + 'bit' );
            trace('childs: ' + childs.length);
        }
    }
}

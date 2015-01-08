/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/16 14:06
 */
package cc.minos.codec.mov.boxs {
    import cc.minos.codec.mov.Mp4;
    import cc.minos.codec.mov.Sample;

    import flash.utils.ByteArray;

    public class F4vBox extends Box {

        protected var _moovBox:MoovBox;
        protected var _ftypBox:FtypBox;

        //media info
        protected var _hasVideo:Boolean = false;
        protected var _videoWidth:int;
        protected var _videoHeight:int;

        protected var _videoConfig:ByteArray;
        private var _videoSamples:Vector.<Sample>;

        protected var _hasAudio:Boolean = false;
        private var _audioConfig:ByteArray;

        protected var _videoFps:Number;
        protected var _frameTotal:uint;
        protected var _duration:Number = 0.0;
        protected var _audioSamples:Vector.<Sample>;

        private var _audioChannels:uint;
        private var _audioRate:Number;
        private var _audioSize:uint;
        //mp4

        private var _samples:Vector.<Sample>;

        public function F4vBox()
        {
            super(0x528801);
        }

        override protected function decode():void
        {
        }

        override protected function init():void
        {
            //
            _ftypBox = getBox(Mp4.BOX_TYPE_FTYP).shift() as FtypBox;
            _moovBox = getBox(Mp4.BOX_TYPE_MOOV).shift() as MoovBox;

            _duration = _moovBox.mvhdBox.duration;


            for(var i:int =0;i< _moovBox.traks.length; i++ )
            {
                var trak:TrakBox = _moovBox.traks[i] as TrakBox;
                if(trak)
                {
                    if( trak.trakType == Mp4.TRAK_TYPE_VIDE )
                    {
                        _hasVideo = true;
                        _videoSamples = trak.samples;
                        _videoWidth = trak.stsdBox.videoWidth;
                        _videoHeight = trak.stsdBox.videoHeight;
                        _videoConfig = trak.stsdBox.configurationData;
                        _videoFps = trak.framerate;
                    }
                    else if( trak.trakType == Mp4.TRAK_TYPE_SOUN )
                    {
                        _hasAudio = true;
                        _audioSamples = trak.samples;
                        _audioChannels = trak.stsdBox.audioChannels;
                        _audioRate = trak.stsdBox.audioRate;
                        _audioSize = trak.stsdBox.audioSize;
                        _audioConfig = trak.stsdBox.configurationData;
                    }
                }
            }

            _samples = new Vector.<Sample>();
            if(_videoSamples)
            {
                for(var v:* in _videoSamples)
                {
                    _samples.push(_videoSamples[v]);
                }
            }
            if(_audioSamples)
            {
                for(var a:* in _audioSamples)
                {
                    _samples.push(_audioSamples[a]);
                }
            }
            _samples.sort(sortBydelta);

        }

        private function sortBydelta(a:Object, b:Object, array:Array = null):int
        {
            if( a.delta < b.delta )
            {
                return -1;
            }
            else if( a.delta > b.delta )
            {
                return 1;
            }
            if( a.type == 0x09 ){
                return -1;
            }else if( b.type == 0x09 )
            {
                return 1;
            }
            return 0;
        }

        public function get hasAudio():Boolean
        {
            return _hasAudio;
        }

        public function get hasVideo():Boolean
        {
            return _hasVideo;
        }

        public function get duration():Number
        {
            return _duration;
        }

        public function get videoFps():Number
        {
            return _videoFps;
        }

        public function get videoWidth():int
        {
            return _videoWidth;
        }

        public function get videoHeight():int
        {
            return _videoHeight;
        }

        public function get videoConfig():ByteArray
        {
            return _videoConfig;
        }

        public function get videoSamples():Vector.<Sample>
        {
            return _videoSamples;
        }

        public function get audioSamples():Vector.<Sample>
        {
            return _audioSamples;
        }

        public function get audioConfig():ByteArray
        {
            return _audioConfig;
        }

        public function get samples():Vector.<Sample>
        {
            return _samples;
        }
    }
}

/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/10 15:21
 */
package cc.minos.codec.mp4 {

    import cc.minos.codec.*;
    import cc.minos.codec.flv.Frame;

    public class Sample extends Frame {

        //index in chunk
        protected var _sampleIndex:uint;
        //chunk index
        protected var _chunkIndex:uint;

        public function Sample()
        {
            super("mp4");
        }

        public function get sampleIndex():uint
        {
            return _sampleIndex;
        }

        public function set sampleIndex(value:uint):void
        {
            _sampleIndex = value;
        }

        public function get chunkIndex():uint
        {
            return _chunkIndex;
        }

        public function set chunkIndex(value:uint):void
        {
            _chunkIndex = value;
        }

    }
}

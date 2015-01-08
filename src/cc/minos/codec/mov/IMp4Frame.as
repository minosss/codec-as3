/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/25 09:39
 */
package cc.minos.codec.mov {
    public interface IMp4Frame {

        function get sampleIndex():uint;
        function set sampleIndex(value:uint):void;

        function get chunkIndex():uint;
        function set chunkIndex(value:uint):void;

    }
}

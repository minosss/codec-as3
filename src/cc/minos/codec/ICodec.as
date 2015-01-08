/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/23 13:40
 */
package cc.minos.codec {
    import flash.utils.ByteArray;

    public interface ICodec {

        function get name():String;

        function get hasVideo():Boolean;
        function get hasAudio():Boolean;

        function get duration():Number;

        //video
        function get videoConfig():ByteArray;
        function get videoCodec():uint;
        function get videoWidth():Number;
        function get videoHeight():Number;
        function get videoRate():Number;

        function get frameRate():Number;
        //audio
        function get audioConfig():ByteArray;
        function get audioCodec():uint;
        function get audioType():uint;
        function get audioRate():Number;
        function get audioSize():Number;
        function get audioChannels():uint;

        //video & audio frames
        function get frames():Vector.<IFrame>
        function get keyframes():Vector.<uint>;

        /** **/
        function decode( input:ByteArray ):ICodec;
        function encode( input:ICodec ):ByteArray;
        function probe( input:ByteArray ):Boolean;

        function getDataByFrame(frame:IFrame):ByteArray

        /** **/
        function export():ByteArray;
        function exportVideo():ByteArray;
        function exportAudio():ByteArray;

    }
}

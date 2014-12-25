/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/23 13:40
 */
package cc.minos.codec {
    import flash.utils.ByteArray;

    public interface ICodec {

        function get type():String;

        function get hasVideo():Boolean;
        function get hasAudio():Boolean;

        function get duration():Number;
        function get videoWidth():Number;
        function get videoHeight():Number;
        function get videoRate():Number;

        function get videoConfig():ByteArray;
        function get audioConfig():ByteArray;

        function get frames():Vector.<IFrame>

        /** **/
        function decode( input:ByteArray ):ICodec;
        function encode( input:ICodec ):ByteArray;

        function getDataByFrame(frame:IFrame):ByteArray

        /** **/
        function export():ByteArray;
        function exportVideo():ByteArray;
        function exportAudio():ByteArray;

    }
}

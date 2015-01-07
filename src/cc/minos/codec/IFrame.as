/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/23 11:57
 */
package cc.minos.codec {
    public interface IFrame {

        function get offset():uint;
        function set offset(value:uint):void;

        function get dataType():uint;
        function set dataType(value:uint):void;

        function get frameType():uint;
        function set frameType(value:uint):void;

        function get codecId():uint;
        function set codecId(value:uint):void;

        function get size():uint;
        function set size(value:uint):void;

        function get timestamp():Number;
        function set timestamp(value:Number):void;

        function get index():uint;
        function set index(value:uint):void;

    }
}

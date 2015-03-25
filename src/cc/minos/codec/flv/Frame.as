/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/23 15:01
 */
package cc.minos.codec.flv {

	public class Frame extends Object {

		protected var _offset:uint;
		protected var _dataType:uint;
		protected var _frameType:uint;
		protected var _size:uint;
		protected var _timestamp:Number;
		protected var _index:uint;
		protected var _codecId:uint;
		protected var _codecType:String;

		public function Frame(type:String)
		{
			this.codecType = type;
		}

		public function get offset():uint
		{
			return _offset;
		}

		public function set offset(value:uint):void
		{
			_offset = value;
		}

		public function get dataType():uint
		{
			return _dataType;
		}

		public function set dataType(value:uint):void
		{
			_dataType = value;
		}

		public function get frameType():uint
		{
			return _frameType;
		}

		public function set frameType(value:uint):void
		{
			_frameType = value;
		}

		public function get size():uint
		{
			return _size;
		}

		public function set size(value:uint):void
		{
			_size = value;
		}

		public function get timestamp():Number
		{
			return _timestamp;
		}

		public function set timestamp(value:Number):void
		{
			_timestamp = value;
		}

		public function get index():uint
		{
			return _index;
		}

		public function set index(value:uint):void
		{
			_index = value;
		}

		public function get codecId():uint
		{
			return _codecId;
		}

		public function set codecId(value:uint):void
		{
			_codecId = value;
		}

		public function get codecType():String
		{
			return _codecType;
		}

		public function set codecType(value:String):void
		{
			_codecType = value;
		}
	}
}

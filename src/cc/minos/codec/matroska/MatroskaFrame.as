/**
 * ...
 * Created by SiuzukZan<minoscc@gmail.com> on 01/12/2015 17:20
 */
package cc.minos.codec.matroska {

	import cc.minos.codec.IFrame;

	import flash.utils.ByteArray;

	public class MatroskaFrame extends Object implements IFrame{

		private var _offset:uint;
		private var _dataType:uint;
		private var _frameType:uint;
		private var _size:uint;
		private var _timestamp:Number;
		private var _index:uint;
		private var _codecId:uint;

		private var _data:ByteArray;

		public function MatroskaFrame()
		{
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

		public function get codecId():uint
		{
			return _codecId;
		}

		public function set codecId(value:uint):void
		{
			_codecId = value;
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

		public function get data():ByteArray
		{
			return _data;
		}

		public function set data(value:ByteArray):void
		{
			_data = value;
		}
	}
}

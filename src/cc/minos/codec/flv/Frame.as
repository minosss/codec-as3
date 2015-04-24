/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/23 15:01
 */
package cc.minos.codec.flv {

	public class Frame extends Object {

		public var offset:uint;
		public var dataType:uint;
		public var frameType:uint;
		public var size:uint;
		public var timestamp:Number;
		public var index:uint;
		public var codecId:uint;
		public var codecType:String;

		public function Frame(type:String = 'flv')
		{
			codecType = type;
		}

	}
}

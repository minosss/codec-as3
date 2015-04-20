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
		public var sampleIndex:uint;
		//chunk index
		public var chunkIndex:uint;

		public function Sample()
		{
			super("mp4");
		}

	}
}

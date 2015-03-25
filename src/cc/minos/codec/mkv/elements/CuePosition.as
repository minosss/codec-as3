/**
 * ...
 * Created by SiuzukZan<minoscc@gmail.com> on 01/12/2015 14:12
 */
package cc.minos.codec.mkv.elements {

	import cc.minos.codec.mkv.Mkv;

	public class CuePosition extends Element {
		public function CuePosition()
		{
			super(Mkv.POINT_CUE_TRACK_POSITIONS);
		}

		override protected function getElement(type:uint):Element
		{
			switch (type)
			{
				case Mkv.CUE_TRACK:
				case Mkv.CUE_CLUSTER_POSITION:
				case Mkv.CUE_BLOCK_NUMBER:
					return new VarElement(type);
			}
			return super.getElement(type);
		}
	}
}

/**
 * ...
 * Created by SiuzukZan<minoscc@gmail.com> on 01/12/2015 14:12
 */
package cc.minos.codec.matroska.elements {

	import cc.minos.codec.matroska.Matroska;

	public class CuePosition extends Element {
		public function CuePosition()
		{
			super(Matroska.POINT_CUE_TRACK_POSITIONS);
		}

		override protected function getElement(type:uint):Element
		{
			switch (type)
			{
				case Matroska.CUE_TRACK:
				case Matroska.CUE_CLUSTER_POSITION:
				case Matroska.CUE_BLOCK_NUMBER:
					return new VarElement(type);
			}
			return super.getElement(type);
		}
	}
}

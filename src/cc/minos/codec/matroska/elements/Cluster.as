/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/30 17:21
 */
package cc.minos.codec.matroska.elements {
    import cc.minos.codec.matroska.Matroska;

    public class Cluster extends Element {
        public function Cluster()
        {
            super(Matroska.CLUSTER);
        }

        override protected function getElement(type:uint):Element
        {
            switch (type)
            {
                case Matroska.CLUSTER_TIMECODE:
                case Matroska.CLUSTER_POSITION:
                case Matroska.CLUSTER_PREV_SIZE:
                case Matroska.CLUSTER_BLOCK_GROUP:
                case Matroska.CLUSTER_SIMPLE_BLOCK:
                    return new VarElement(type);
            }
            return super.getElement(type);
        }
    }
}

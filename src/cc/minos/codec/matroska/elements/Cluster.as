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
            super(cc.minos.codec.matroska.Matroska.CLUSTER);
        }

        override protected function getElement(type:uint):Element
        {
            switch (type)
            {
                case cc.minos.codec.matroska.Matroska.CLUSTER_TIMECODE:
                case cc.minos.codec.matroska.Matroska.CLUSTER_POSITION:
                case cc.minos.codec.matroska.Matroska.CLUSTER_PREV_SIZE:
                case cc.minos.codec.matroska.Matroska.CLUSTER_BLOCK_GROUP:
                case cc.minos.codec.matroska.Matroska.CLUSTER_SIMPLE_BLOCK:
                    return new VarElement(type);
            }
            return super.getElement(type);
        }
    }
}

/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/30 17:21
 */
package cc.minos.codec.matroska.elements {
    import cc.minos.codec.matroska.MaConstans;

    public class Cluster extends Element {
        public function Cluster()
        {
            super(MaConstans.CLUSTER);
        }

        override protected function getElement(type:uint):Element
        {
            switch (type)
            {
                case MaConstans.CLUSTER_TIMECODE:
                case MaConstans.CLUSTER_POSITION:
                case MaConstans.CLUSTER_PREV_SIZE:
                case MaConstans.CLUSTER_BLOCK_GROUP:
                case MaConstans.CLUSTER_SIMPLE_BLOCK:
                    return new VarElement(type);
            }
            return super.getElement(type);
        }
    }
}

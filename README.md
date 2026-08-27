# TUMCR
The code for the SIGKDD2024 work  Tensorized unaligned multi-view clustering with multi-scale representation learning (TUMCR).

# Dataset & Limitation
For this work, the central view is typically arranged according to the ideal class structure before constructing the tensor. This ordering strategy was used as a practical trick to obtain more favorable tensor representations, since tensor-based multi-view clustering methods can be sensitive to the arrangement of samples.

We later systematically investigated this phenomenon in our work **“Breaking the Periodicity Assumption: Robust Tensorial Multi-View Clustering via Graph-Spectral Low-Rank Learning”**, where we show that the sample order can substantially affect the spectral structure induced by conventional tensor transforms.


# Citation
If you find our repository useful, please consider citing "Anchors Bring Stability and Efficiency: Fast Tensorial Multi-view Clustering on Shuffled Datasets"
``` js
@inproceedings{ji2024tensorized,
  title={Tensorized unaligned multi-view clustering with multi-scale representation learning},
  author={Ji, Jintian and Feng, Songhe and Li, Yidong},
  booktitle={Proceedings of the 30th ACM SIGKDD Conference on Knowledge Discovery and Data Mining},
  pages={1246--1256},
  year={2024}
}

```

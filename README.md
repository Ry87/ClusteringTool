# ClusteringTool
気軽にいろんなクラスタリング手法が試せるツールを作りました。

- 対応しているクラスタリング手法
  - 最近隣法(Single)
  - 最遠隣法(Complete)
  - 群平均法(Average)
  - 重心法(Centroid)
  - メディアン法(Median)
  - ウォード法(ward)
  - McQuitty法(mcquitty)
  - k-means法(k-means)

- 使い方
1. データ(csv)を読み込む
1. クラスタリングに用いるパラメータ、クラスタ数、手法を選ぶ
1. 散布図とデンドログラムで結果確認(※k-means法に関しては非階層なのでデンドログラムは出ません)

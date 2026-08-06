# HandDrum

指先のハンドトラッキングでドラムコーパスを演奏する Max パッチ。使い方・構成は README.md を参照。

- ブランチ運用: Git Flow(`main` = 配布 / `develop` = 統合・デフォルト / `feature/<issue>-<slug>`)。`main`・`develop` へは PR 経由のみ
- `.maxpat` は JSON。Max で開いて保存するとレイアウト差分が膨らむため、意味のある変更だけをコミットする
- `sampleloop/` の音源(Loopcloud ライセンス素材)と `corpus.*` は git 管理外。公開リポに音源を絶対に入れない
- 解析窓・オンセット設定を変えるときは trainer/classifier 系と同様、関連箇所を全て揃える(README の調整表参照)

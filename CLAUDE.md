# HandDrum

指先のハンドトラッキングでドラムコーパスを演奏する Max パッチ。使い方・構成は README.md を参照。

- ブランチ運用: Git Flow(`main` = 配布 / `develop` = 統合・デフォルト / `feature/<issue>-<slug>`)。`main`・`develop` へは PR 経由のみ
- `.maxpat` は JSON。Max で開いて保存するとレイアウト差分が膨らむため、意味のある変更だけをコミットする
- `sampleloop/` の音源(Loopcloud ライセンス素材)と `corpus.*` は git 管理外。公開リポに音源を絶対に入れない
- 解析窓・オンセット設定を変えるときは trainer/classifier 系と同様、関連箇所を全て揃える(README の調整表参照)

## リリース手順(main への反映)

線形履歴保護と GitHub の仕様(rebase/squash マージはコミットハッシュを複製し main/develop が乖離して見える)を踏まえ、リリースは **fast-forward 直接反映**で行う:

1. `gh api -X DELETE repos/dsgarage/HandDrum/branches/main/protection` で main 保護を一時解除
2. `git push origin origin/develop:main`(develop が main の子孫なら FF、履歴は単一のまま)
3. 保護を再適用(設定 JSON は git-flow ルール準拠: レビュー0・線形・enforce_admins)
4. `git tag vX.Y.Z origin/develop && git push origin vX.Y.Z`
5. `git archive --format=zip --prefix=HandDrum/ -o HandDrum-vX.Y.Z.zip vX.Y.Z` で配布 Zip を生成し `gh release create` に添付

develop→main の PR は使わない(rebase マージで両ブランチに同内容・別ハッシュのコミットが複製され「ahead/behind」が膨らむため。v1.0.0 で実際に発生し、main を develop 履歴へ揃え直して解消した)。

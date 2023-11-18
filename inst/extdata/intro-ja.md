---
title: イントロダクション
teaching: 10
exercises: 2
---

:::::::::::::::::::::::::::::::::::::: questions 

- `{sandpaper}`とR Markdownを使ったレッスンはどのように書くことができますか？

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- 新しいレッスンテンプレートでマークダウンを使用する方法を説明しましょう
- コード、図、ネストされた課題ブロックの使い方を説明しましょう

::::::::::::::::::::::::::::::::::::::::::::::::

## はじめに

これはThe Carpentries Workbenchによって作成されたレッスンです。内容の変わらないファイル（`.md`拡張を持つファイル）は[Pandoc風Markdown][pandoc]によって書かれて、コードによって内容が出力されるファイル（`.Rmd`拡張を持つファイル）は[R Markdown][r-markdown]によって書かれています。
完全な説明を読みたい場合は[Introduction to The Carpentries Workbench][carpentries-workbench]を参照してください。

The Carpentries Workbenchによるレッスン作成には以下の3つのセクションが必要です：

1. `questions`は、エピソードの冒頭に参加者がこれから学ぶ内容について表示されます。
2. `objectives`は、上記の質問と一緒に表示されるエピソードの学習目標です。
3. `keypoints`は、エピソードの最後に学習目標を強調するために表示されます。

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: instructor

インラインのインストラクターノートは、インストラクターに課題のタイミングを知らせるのに役立ちます。

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: challenge

## チャレンジ1：できますか？

このコマンドの出力は？

```r
paste("This", "new", "lesson", "looks", "good")
```

:::::::::::::::::::::::: solution 

## 出力

```output
[1] "This new lesson looks good"
```

:::::::::::::::::::::::::::::::::

## 課題2：課題ブロックの中に解決策を入れ子にする方法は？

:::::::::::::::::::::::: solution 

少なくとも3つのコロンと `solution` タグを追加します。

:::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::

## 図表

以下の構文で、静的な図にpandocマークダウンを使うことができます：

`![optional caption that appears below the figure](figure url){alt='alt text for accessibility purposes'}`

![The Carpentriesはどなたでも大歓迎です](https://raw.githubusercontent.com/carpentries/logo/master/Badge_Carpentries.svg){alt='Blue Carpentries hex person logo with no text.'}

## 数学

$\LaTeX$方程式を使うことができます：

`$\alpha = \dfrac{1}{(1 - \beta)^2}$` はこのようになります： $\alpha = \dfrac{1}{(1 - \beta)^2}$

悪くないでしょ？

::::::::::::::::::::::::::::::::::::: keypoints

- 内容が変わらないエピソードには `.md` ファイルを使用します。
- コードによって内容を計算する場合は `.Rmd` ファイルを使用します。
- `sandpaper::check_lesson()` を実行することによってでレッスンの問題を特定します。
- `sandpaper::build_lesson()` を実行することによってレッスンをローカルでプレビューできます。

::::::::::::::::::::::::::::::::::::::::::::::::



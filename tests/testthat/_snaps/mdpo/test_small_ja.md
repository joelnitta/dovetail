# テスト用のファイル

これはマークダウンのパーサーを試すためのファイルです。[https://spec.commonmark.org/](CommonMark)というマークダウン形式に合っています。

以下の文書は[Mozilla Public License v2.0](https://www.mozilla.org/en-US/MPL/2.0/)によりhttps://raw.githubusercontent.com/rust-lang/mdBook/97b6a35afc1f40c505c42dbef5d306b43430955a/guide/src/format/markdown.mdを改作されたものです。

## ヘッダー

```markdown
### A heading 

Some text.

#### A smaller heading 

More text.
```

### これはヘッダーです

これは文章です

#### もっと小さなヘッダー

文章の続き

## リスト

```markdown
* milk
* eggs
* butter

1. carrots
1. celery
1. radishes
```

* 牛乳

* 卵

* バター

1. 人参

1. セロリ

1. 大根


## リンク

URL、あるいは自分のパソコンにあるファイルへのリンクを作るのは簡単にできます。

```markdown
Use [mdBook](https://github.com/rust-lang/mdBook). 

Read about [mdBook](mdBook.md).

A bare url: <https://www.rust-lang.org>.
```

[mdBook](https://github.com/rust-lang/mdBook)を使いましょう。

[mdBook](mdBook.md)について読みましょう。

飾りのないurl: <https://www.rust-lang.org>。



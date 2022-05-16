# Test file

This is a document for testing parsing of markdown. It is compatible with [https://spec.commonmark.org/](CommonMark) markdown specification.

The text below is copied from 
https://raw.githubusercontent.com/rust-lang/mdBook/97b6a35afc1f40c505c42dbef5d306b43430955a/guide/src/format/markdown.md

under the [Mozilla Public License v2.0](https://www.mozilla.org/en-US/MPL/2.0/)

# Markdown

mdBook's [parser](https://github.com/raphlinus/pulldown-cmark) adheres to the [CommonMark](https://commonmark.org/) specification with some extensions described below.
You can take a quick [tutorial](https://commonmark.org/help/tutorial/),
or [try out](https://spec.commonmark.org/dingus/) CommonMark in real time. A complete Markdown overview is out of scope for 
this documentation, but below is a high level overview of some of the basics. For a more in-depth experience, check out the
[Markdown Guide](https://www.markdownguide.org).

## Text and Paragraphs

Text is rendered relatively predictably: 

```markdown
Here is a line of text.

This is a new line.
```

Will look like you might expect:

Here is a line of text.

This is a new line.

## Headings

Headings use the `#` marker and should be on a line by themselves. More `#` mean smaller headings:

```markdown
### A heading 

Some text.

#### A smaller heading 

More text.
```

### A heading 

Some text.

#### A smaller heading 

More text.

## Lists

Lists can be unordered or ordered. Ordered lists will order automatically:

```markdown
* milk
* eggs
* butter

1. carrots
1. celery
1. radishes
```

* milk
* eggs
* butter

1. carrots
1. celery
1. radishes

## Links

Linking to a URL or local file is easy:

```markdown
Use [mdBook](https://github.com/rust-lang/mdBook). 

Read about [mdBook](mdBook.md).

A bare url: <https://www.rust-lang.org>.
```

Use [mdBook](https://github.com/rust-lang/mdBook). 

Read about [mdBook](mdBook.md).

A bare url: <https://www.rust-lang.org>.

----

Relative links that end with `.md` will be converted to the `.html` extension.
It is recommended to use `.md` links when possible.
This is useful when viewing the Markdown file outside of mdBook, for example on GitHub or GitLab which render Markdown automatically.

Links to `README.md` will be converted to `index.html`.
This is done since some services like GitHub render README files automatically, but web servers typically expect the root file to be called `index.html`.

You can link to individual headings with `#` fragments.
For example, `mdbook.md#text-and-paragraphs` would link to the [Text and Paragraphs](#text-and-paragraphs) section above.
The ID is created by transforming the heading such as converting to lowercase and replacing spaces with dashes.
You can click on any heading and look at the URL in your browser to see what the fragment looks like.

## Images

Including images is simply a matter of including a link to them, much like in the _Links_ section above. The following markdown
includes the Rust logo SVG image found in the `images` directory at the same level as this file:

```markdown
![The Rust Logo](images/rust-logo-blk.svg)
```

Produces the following HTML when built with mdBook:

```html
<p><img src="images/rust-logo-blk.svg" alt="The Rust Logo" /></p>
```

Which, of course displays the image like so:

![The Rust Logo](images/rust-logo-blk.svg)

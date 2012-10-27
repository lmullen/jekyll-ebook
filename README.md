# EPUB Generator for Jekyll

A [Ruby][] script to create [EPUB][] books from [Jekyll][] posts and
pages using [Pandoc][].

Lincoln Mullen | lincoln@lincolnmullen.com | http://lincolnmullen.com

## Usage

The script `epub-jekyll.rb` should go in the root of your Jekyll site.
You'll want to make it executable with the command
`chmod +x  epub-jekyll.rb`. You will also have to install the gem
[pandoc-ruby][] with the command `gem install pandoc-ruby`, and you will
need to have the [Pandoc][] executable in your path.

You can run the script from the command line. It takes one argument, the
name of a [YAML][] manifest file. To run the script:

    ./epub-jekyll.rb manifest.yml

## The Manifest

The manifest is a [YAML][] file that sets some options tells the script
which posts and pages should be part of the [EPUB][]. (If you're using
[Jekyll][], you're already familiar with [YAML][].)

The following fields should be in the manifest.

### Publication Information

    title: The Journal of Southern Religion
    author: Volume 14
    date: October 2012

The `title`, `author`, and `date` of your EPUB are set in the manifest.

### EPUB Options

    epub-filename: out.epub
    epub-cover-image: cover.jpg
    epub-stylesheet: stylesheet.css
    epub-metadata: metadata.xml
    epub-dir: /Users/username/project/

The `epub-filename` is the path to the EPUB file that the script will
output. (NB: For now, if the directories in the path do not exist, the
script will fail.)

Besides the body content, a proper, well-formatted EPUB requires a 
stylesheet, a cover image, and a rights file. This script uses 
`pandoc-ruby` to call for three files. `epub-cover-image`, 
`epub-stylesheet`, and `epub-metadata` are paths to an image, a CSS 
file, and an XML file respectively. These paths are relative to 
`epub-dir`, so that you can specify the directory that holds these files 
one time. To see what belongs in each of those files, see John 
MacFarlane's [guide to creating an e-book with Pandoc][]. 

### Header Items

    header-items:
    - title
    - author
    - author-note
    - citation

The YAML metadata for your posts and pages contains information that you
probably don't want in your e-book, such as the categories or permalink.
Your YAML metadata might also include custom fields that you do want to
include. In my case, I often have a field `book-reviewed` that should be
included.

Your manifest should specify an array of `header-items` that you want to
include in the order that you want to include them. The `title` is
always included as the first item, whether or not you specify it. The
other items are included only if they exist for a given post or page.
The items are each wrapped in a `<p>` tag with a class named after the
metadata item (e.g., `<p class='book-reviewed'>`), so you can change the
styles with your stylesheet.

### Body Content

    content-dir: ./
    contents: 
      - section-title: Articles
        files:
        - article1.markdown
        - article2.markdown
      - section-title: Reviews
        files:
        - review.markdown

This script loops through the files you want included in the EPUB in the
order you specify, formatting them properly.

The `content-dir` option sets the path to your Jekyll posts and pages. You
might set `content-dir` to the path to your `_posts` directory.

The `contents` option lists the files you want to include, organized by
section. The `section-title`s will create header pages separating the
main parts of your book. The `files` arrays list paths relative to
`indir` that should be included. These are your Jekyll posts or pages.

You can have as many sections and included files as you wish.

## Caveats

This code is alpha. If you find bugs or ways to improve the code, please
let me know in the GitHub issues tracker or by e-mail.

I wrote this script for the [*Journal of Southern Religion*][], which
[runs on Jekyll][]. There may be items in this script which are specific
to my intended purpose, but I have tried make the script generally
useful.

  [Ruby]: http://www.ruby-lang.org/
  [EPUB]: http://idpf.org/epub
  [Jekyll]: http://jekyllrb.com/
  [Pandoc]: http://johnmacfarlane.net/pandoc/
  [pandoc-ruby]: https://github.com/alphabetum/pandoc-ruby
  [YAML]: http://www.yaml.org/
  [guide to creating an e-book with Pandoc]: http://johnmacfarlane.net/pandoc/epub.html
  [*Journal of Southern Religion*]: http://jsr.fsu.edu
  [runs on Jekyll]: https://github.com/lmullen/jsr

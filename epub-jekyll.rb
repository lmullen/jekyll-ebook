#!/usr/bin/env ruby

# Name::          EPUB Generator for Jekyll
# Author::        Lincoln Mullen | lincoln@lincolnmullen.com
# Copyright::     Copyright (c) 2012 Lincoln Mullen 
# License::       MIT License | http://lmullen.mit-license.org/

# A Ruby script to create EPUB books from Jekyll posts and pages using 
# Pandoc. 

require 'yaml'
require 'pandoc-ruby'

# The Article class loads a file that is formatted as a Jekyll post or 
# page with metadata in a YAML block at the top and the content in 
# Markdown or HTML. It has a method to export the metadata in a format 
# suitable for conversion to EPUB using Pandoc.

class Article

  attr_accessor :filename, :metadata, :content

  # Retrieve the filename then call the method to read its data
  def initialize( filename )
    @filename = filename
    self.read_file
  end

  # Read the metadata and content from the post or page
  def read_file

    # Load the Jekyll post or page
    self.content = File.read(@filename)

    begin

      # define a regular expression to find the YAML header 
      if /^(---\s*\n.*?\n?)^(---\s*$\n?)/m.match(self.content)

        # Use the back reference to load the metadata and the postmatch 
        # to load the content
        self.metadata = YAML.load($1)
        self.content = $'

      end
    rescue => e
      puts "YAML exception reading #{filename}: #{e.message}"
    end
  end

  # Print the relevant metadata in a block with CSS selectors for 
  # formatting in the e-book, then print the content
  def format_article

    # TODO only print the metadata items specifically named in the 
    # manifest (probably passed to this class as an array)

    # an array to hold all our output
    out = Array.new

    out.push "# " + self.metadata['title'] + "\n\n"

    # Only print these metadata fields if they exist
    out.push "<p class='author'>" + self.metadata['author'] + "</p>\n\n" unless self.metadata['author'].nil?
    out.push "<p class='author-note'>" + self.metadata['author-note'] + "</p>\n\n" unless self.metadata['author-note'].nil?
    out.push "<p class='book-reviewed'>" + self.metadata['book-reviewed'] + "</p>\n\n" unless self.metadata['book-reviewed'].nil?

    out.push self.content

    # Return the contents of the array
    return out.join("\n")
  end

end

# The Ebook class reads a YAML manifest file that contains a list of 
# Jekyll posts and pages to be included in the EPUB book. It then 
# creates an article object for each file, writing the metadata to both 
# a table of contents and a body file.

class Ebook

  attr_accessor :manifest

  # Initialize the object with the filename of the manifest
  def initialize( manifest )

    begin
      @manifest = YAML.load(File.read(manifest))
    rescue => e
      puts "YAML exception reading #{manifest}: #{e.message}"
    end

    # TODO check manifest and create sensible defaults if they don't exist

  end

  # Loop through the contents in the manifest to generate the body 
  # content and the table of contents
  def generate_content

    # an array to hold all our output
    out = Array.new

    # Generate front matter as Pandoc title block
    out.push "% " + self.manifest['title']
    out.push "% " + self.manifest['author']
    out.push "% " + self.manifest['date'] + "\n" unless self.manifest['date'].nil?

    # Loop through the sections in the manifest's list of contents
    self.manifest['contents'].each do |section|

      out.push "# " + section['section-title'] + "\n\n"

      # Loop through the files in this section
      section['files'].each do |filename|

        # Create an Article object for each file and format it
        article = Article.new( self.manifest['indir'] + filename )
        out.push article.format_article

      end

    end

    # Return the contents of the array
    return out.join("\n")

  end

  # Use PandocRuby to take the output of the `generate_content` method 
  # and create an EPUB file from it, using the settings in the manifest.
  def generate_epub

    PandocRuby.new( self.generate_content ,
                   {:f => :markdown, :to => :epub},
                   'smart', 'o' => self.manifest['epub-filename'],
                   'epub-cover-image' => self.manifest['epub-cover-image'],
                   'epub-metadata' => self.manifest['epub-metadata'], 
                   'epub-stylesheet' => self.manifest['epub-stylesheet'],).convert

  end

end

# Generate an EPUB from the manifest passed as a command line argument
Ebook.new(ARGV[0]).generate_epub

#!/usr/bin/env ruby

# Name::          EPUB Generator for Jekyll
# Author::        Lincoln Mullen | lincoln@lincolnmullen.com
# Copyright::     Copyright (c) 2012 Lincoln Mullen 
# License::       MIT License

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
      puts "YAML Exception reading #{filename}: #{e.message}"
    end
  end

  # Print the filename and metadata as a string representation of an 
  # Article object
  def to_s
    self.filename + "\n" + self.metadata.to_s
  end

  # Print the relevant metadata in a block with CSS selectors for 
  # formatting in the e-book, then print the content
  def format

    puts "# " + self.metadata['title'] + "\n\n"
    puts "<p class='author'>" + self.metadata['author'] + "</p>" +"\n\n"
    puts "<p class='author-note'>" + self.metadata['author-note'] + "</p>" +"\n\n"

    # Only print the book reviewed if this is indeed a review
    if self.metadata['book-reviewed']
      puts "<p class='book-reviewed'>" + self.metadata['book-reviewed'] + "</p>" +"\n\n"
    end

    puts self.content

  end

end

# The Ebook class reads a YAML file that contains a list of Jekyll posts 
# and pages to be included in the EPUB book. It then creates an article 
# object for each file, writing the metadata to both a table of contents 
# and a body file.

class Ebook


end

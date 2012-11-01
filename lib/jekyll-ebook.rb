
# Name::          EPUB Generator for Jekyll
# Author::        Lincoln Mullen | lincoln@lincolnmullen.com
# Copyright::     Copyright (c) 2012 Lincoln Mullen 
# License::       MIT License | http://lmullen.mit-license.org/

# A Ruby script to create EPUB books from Jekyll posts and pages using 
# Pandoc. 

$:.unshift File.dirname(__FILE__) # For use/testing when no gem is installed

# load the required files
require 'yaml'
require 'pandoc-ruby'
require 'jekyll-ebook/article'
require 'jekyll-ebook/ebook'



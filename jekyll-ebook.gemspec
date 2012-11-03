Gem::Specification.new do |s|
  s.name          = 'jekyll-ebook'
  s.version       = '0.0.2'
  s.date          = '2012-11-03'
  s.summary       = 'EPUB generator for Jekyll'
  s.description   = 'A gem to generate an EPUB e-book from Jekyll posts and pages'
  s.author        = 'Lincoln A. Mullen'
  s.email         = 'lincoln@lincolnmullen.com'
  s.homepage      = 'https://github.com/lmullen/jekyll-ebook'
  s.files         = ['lib/jekyll-ebook.rb',
                     'lib/jekyll-ebook/article.rb',
                     'lib/jekyll-ebook/ebook.rb']
  s.bindir        = 'bin'
  s.executables   << 'jekyll-ebook'
  s.license       = 'MIT'
  s.add_runtime_dependency('pandoc-ruby', ['~>0.6.0'])
end

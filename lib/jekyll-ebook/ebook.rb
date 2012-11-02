# The Ebook class reads a YAML manifest file that contains a list of 
# Jekyll posts and pages to be included in the EPUB book. It then 
# creates an article object for each file, writing the metadata to both 
# a table of contents and a body file.

class Ebook

  # +manifest+ is the filename of the YAML manifest 
  attr_accessor :manifest

  # Initialize the object with the filename of the manifest
  def initialize( manifest )

    begin
      @manifest = YAML.load(File.read(manifest))
    rescue => e
      puts "YAML exception reading #{manifest}: #{e.message}"
    end

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

      # Loop through the files in this section. Create an Article object 
      # for each file, to which we pass the directory plus filename and 
      # the list of required metadata items.
      section['files'].each do |filename|
        out.push Article.new( self.manifest['content-dir'] + filename , self.manifest['header-items'] ).format_article
      end

    end

    # Return the contents of the array
    return out.join("\n")

  end

  # Use PandocRuby to take the output of the `generate_content` method 
  # and create an EPUB file from it, using the settings in the manifest.
  def generate_epub

    Dir.chdir(self.manifest['epub-dir'])
    PandocRuby.new( self.generate_content ,
                   {:f => :markdown, :to => :epub},
                   'smart', 'o' => self.manifest['epub-filename'],
                   'epub-cover-image' => self.manifest['epub-cover-image'],
                   'epub-metadata' => self.manifest['epub-metadata'], 
                   'epub-stylesheet' => self.manifest['epub-stylesheet'],).convert

  end

end

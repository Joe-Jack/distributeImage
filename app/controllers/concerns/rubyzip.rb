require 'zip'
require 'nkf'

# This is a simple example which uses rubyzip to
# recursively generate a zip file from the contents of
# a specified directory. The directory itself is not
# included in the archive, rather just its contents.
#
# Usage:
#   directoryToZip = "/tmp/input"
#   outputFile = "/tmp/out.zip"
#   zf = ZipFileGenerator.new(directoryToZip, outputFile)
#   zf.write()
class ZipFileGenerator

  # Initialize with the directory to zip and the location of the output archive.
  def initialize(inputDir, outputFile)
    @inputDir = inputDir
    @outputFile = outputFile
  end

  # Zip the input directory.
  def write()
    if File.directory?(@inputDir)
      entries = Dir.entries(@inputDir); entries.delete("."); entries.delete("..")
    # elsif File.file?(@inputDir)
    #   alert("画像がない")
    #   return
    else
      # alert("画像がない")
      return
    end
    io = Zip::File.open(@outputFile, Zip::File::CREATE);
    writeEntries(entries, "", io)
    io.close();
  end

   
  

  # A helper method to make the recursion work.
  private
  def writeEntries(entries, path, io)

    entries.each { |e|
      zipFilePath = path == "" ? e : File.join(path, e)
      diskFilePath = File.join(@inputDir, zipFilePath)
      puts "Deflating " + diskFilePath
      # downloads以下のファイルがディレクトリの場合、downloads.zipにディレクトリを作成
      if File.directory?(diskFilePath)
        # mkdir_pはないしfind_entryではそもそもディレクトリ内部を更新できない？=>出来る（４時間かかった）
        io.mkdir(zipFilePath) unless io.find_entry(zipFilePath)
        subdir =Dir.entries(diskFilePath); subdir.delete("."); subdir.delete("..")
        writeEntries(subdir, zipFilePath, io)
      else
        io.get_output_stream(NKF::nkf("-s", zipFilePath)) { |f| f.puts(File.open(diskFilePath, "rb").read())}
      end
    }
  end

end
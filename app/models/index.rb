class Index < ActiveRecord::Base
    has_many :pictures
    belongs_to :user
    
    # coding: utf-8
    def self.import(file)
        # spreadsheet = open_spreadsheet(file)
        # header = spreadsheet.row(1)
        # (2..spreadsheet.last_row).each do |i|
        #   # {カラム名 => 値, ...} のハッシュを作成する
        #   row = Hash[[header, spreadsheet.row(i)].transpose]
    
        #   # IDが見つかれば、レコードを呼び出し、見つかれなければ、新しく作成
        #   CSV.foreach(file.path, headers: true, encoding: "SJIS:UTF-8") do |row|
        #   csv = Csv.new
        #   # CSVからデータを取得し、設定する
        #   product.attributes = row.to_hash.slice(*updatable_attributes)
        #   # 保存する
        #   product.save!
        # 以下csvファイルのみインポートする追加 20190125
        CSV.foreach(file.path, headers: true, encoding: "SJIS:UTF-8") do |row|
          csv = Index.new
          # puts csv
          csv.attributes = row.to_hash.slice(*updatable_attributes)
          csv.save!
        end
    end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when '.csv'  then Roo::Csv.new(file.path,    nil, :ignore)
    when '.xls'  then Roo::Excel.new(file.path,  nil, :ignore)
    when '.xlsx' then Roo::Excelx.new(file.path, nil, :ignore)
    when '.ods'  then Roo::OpenOffice.new(file.path, nil, :ignore)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end
  
  # import関数に関して追加 20190125
  def self.updatable_attributes
    ["parkname", "playground", "explanation", "judge", "remark"]
  end
end

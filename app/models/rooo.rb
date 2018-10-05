class Rooo
  
  def self.get_name
    xlsx = Roo::Excelx.new("./test_roo.xlsx")

    # puts xlsx.sheets
    sheet = xlsx.sheet(0)
    sheet.each(num: 'num', name: 'name') do |hash|
      # puts hash.inspect
      Index.create(hash)
    end

    
  end 
  
  
end
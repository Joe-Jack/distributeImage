class Picture < ActiveRecord::Base
    belongs_to :index, counter_cache: true
    
end

class Uik < ActiveRecord::Base
  attr_accessible :num, :tik_id
  
  has_many :results
  belongs_to :tik
end

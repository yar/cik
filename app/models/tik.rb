class Tik < ActiveRecord::Base
  attr_accessible :name, :num
  
  has_many :results
  has_many :uiks
end

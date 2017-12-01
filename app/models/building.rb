#:nodoc:
class Building < ActiveRecord::Base
  has_many :room
end

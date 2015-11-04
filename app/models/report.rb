class Report < ActiveRecord::Base
  belongs_to :account
  has_many :report_lines
end

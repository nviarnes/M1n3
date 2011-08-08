class Post < ActiveRecord::Base
  attr_accessible :title, :body
  
  belongs_to :user
  
  validates :title, :presence => true,
                    :length   => { :maximum => 50 }
  validates :body,  :presence => true
  
  
  default_scope :order => 'posts.created_at DESC'                  
  
end

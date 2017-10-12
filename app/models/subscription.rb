class Subscription < ApplicationRecord

  belongs_to :post
  belongs_to :user
  belongs_to :post, :counter_cache => true #或 belongs_to :post, :count_cache => "subscription_count"
end

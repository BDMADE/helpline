require 'rails_helper'

RSpec.describe User, type: :model do  

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :password }  
  it { should validate_length_of(:name).is_at_most(50) } 

 # invalid email check
 invalid_logins = ['b lah','bälah','bülah','bßlah','b!lah','b%lah','b)lah'] 

 invalid_logins.each do |email|
   it { should_not allow_value(email).for(:email) }
 end
  
end

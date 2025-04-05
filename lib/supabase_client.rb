require 'singleton'
require 'supabase'

class SupabaseClient
    def self.client
      @client ||= Supabase::Client.new(
        supabase_url: ENV['SUPABASE_URL'],
        supabase_key: ENV['SUPABASE_KEY']
      )
    end
  
    # Storage 기능이 필요하면 별도 모듈 추가
    def self.storage
      raise "Not Implemented" # Storage API 구현 필요
    end
  end
  
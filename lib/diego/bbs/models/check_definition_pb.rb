# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: check_definition.proto

require 'google/protobuf'

Google::Protobuf::DescriptorPool.generated_pool.build do
  add_message "diego.bbs.models.CheckDefinition" do
    repeated :checks, :message, 1, "diego.bbs.models.Check"
    optional :log_source, :string, 2
  end
  add_message "diego.bbs.models.Check" do
    optional :tcp_check, :message, 1, "diego.bbs.models.TCPCheck"
    optional :http_check, :message, 2, "diego.bbs.models.HTTPCheck"
  end
  add_message "diego.bbs.models.TCPCheck" do
    optional :port, :uint32, 1
    optional :connect_timeout_ms, :uint64, 2
  end
  add_message "diego.bbs.models.HTTPCheck" do
    optional :port, :uint32, 1
    optional :request_timeout_ms, :uint64, 2
    optional :path, :string, 3
  end
end

module Diego
  module Bbs
    module Models
      CheckDefinition = Google::Protobuf::DescriptorPool.generated_pool.lookup("diego.bbs.models.CheckDefinition").msgclass
      Check = Google::Protobuf::DescriptorPool.generated_pool.lookup("diego.bbs.models.Check").msgclass
      TCPCheck = Google::Protobuf::DescriptorPool.generated_pool.lookup("diego.bbs.models.TCPCheck").msgclass
      HTTPCheck = Google::Protobuf::DescriptorPool.generated_pool.lookup("diego.bbs.models.HTTPCheck").msgclass
    end
  end
end

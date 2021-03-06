module VCAP::CloudController
  class ProcessDeleteFetcher
    def fetch(process_guid)
      process = ProcessModel.where(guid: process_guid).eager(:space).first
      return nil if process.nil?

      org = process.space ? process.space.organization : nil
      [process, process.space, org]
    end
  end
end

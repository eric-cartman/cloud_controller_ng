require 'spec_helper'
require 'securerandom'

module VCAP::Services::ServiceBrokers::V2
  RSpec.describe CatalogPlan do
    let(:plan) { CatalogPlan.new(catalog_service, plan_attrs) }
    let(:plan_attrs) do
      {
        'id'          => opts[:id] || 'broker-provided-plan-id',
        'metadata'    => opts[:metadata] || {},
        'name'        => opts[:name] || 'service-plan-name',
        'description' => opts[:description] || 'The description of the service plan',
        'free'        => opts.fetch(:free, true),
        'bindable'    => opts[:bindable],
        'schemas'     => opts[:schemas] || {},
        'plan_updateable' => opts[:plan_updateable],
        'maximum_polling_duration' => opts[:maximum_polling_duration],
        'maintenance_info' => opts[:maintenance_info] || {}
      }
    end
    let(:catalog_service) { instance_double(VCAP::Services::ServiceBrokers::V2::CatalogService) }
    let(:opts) { {} }

    describe 'initializing' do
      let(:opts) { { free: false, bindable: true, plan_updateable: true, maximum_polling_duration: 3600 } }

      it 'should assign attributes' do
        expect(plan.broker_provided_id).to eq 'broker-provided-plan-id'
        expect(plan.name).to eq 'service-plan-name'
        expect(plan.description).to eq 'The description of the service plan'
        expect(plan.metadata).to eq({})
        expect(plan.catalog_service).to eq catalog_service
        expect(plan.free).to be false
        expect(plan.bindable).to be true
        expect(plan.plan_updateable).to be true
        expect(plan.maximum_polling_duration).to be 3600
        expect(plan.maintenance_info).to eq({})
        expect(plan.errors).to be_empty
      end

      it 'defaults free field to true' do
        plan_attrs.delete('free')

        expect(plan.free).to be true
      end

      it 'defaults schemas to an empty hash' do
        expect(plan.schemas).to be {}
      end
    end

    describe 'validations' do
      it 'validates that @broker_provided_id is a string' do
        plan_attrs['id'] = 123

        expect(plan).to_not be_valid
        expect(plan.errors.messages).to include 'Plan id must be a string, but has value 123'
      end

      it 'validates that @broker_provided_id is present' do
        plan_attrs['id'] = nil

        expect(plan).to_not be_valid
        expect(plan.errors.messages).to include 'Plan id is required'
      end

      it 'validates that @name is a string' do
        plan_attrs['name'] = 123

        expect(plan).to_not be_valid
        expect(plan.errors.messages).to include 'Plan name must be a string, but has value 123'
      end

      it 'validates that @name is present' do
        plan_attrs['name'] = nil

        expect(plan).to_not be_valid
        expect(plan.errors.messages).to include 'Plan name is required'
      end

      it 'validates that @description is a string' do
        plan_attrs['description'] = 123

        expect(plan).to_not be_valid
        expect(plan.errors.messages).to include 'Plan description must be a string, but has value 123'
      end

      it 'validates that @description is present' do
        plan_attrs['description'] = nil

        expect(plan).to_not be_valid
        expect(plan.errors.messages).to include 'Plan description is required'
      end

      it 'validates that @description is less than 10_001 characters' do
        plan_attrs['description'] = 'A' * 10_001

        expect(plan).to_not be_valid
        expect(plan.errors.messages).to include 'Plan description may not have more than 10000 characters'
      end

      it 'is valid if @description is 10_000 characters' do
        plan_attrs['description'] = 'A' * 10_000

        expect(plan).to be_valid
        expect(plan.errors.messages).to be_empty
      end

      it 'validates that @metadata is a hash' do
        plan_attrs['metadata'] = ['list', 'of', 'strings']

        expect(plan).to_not be_valid
        expect(plan.errors.messages).to include 'Plan metadata must be a hash, but has value ["list", "of", "strings"]'
      end

      it 'validates that @free is a boolean' do
        plan_attrs['free'] = 'true'

        expect(plan).to_not be_valid
        expect(plan.errors.messages).to include 'Plan free must be a boolean, but has value "true"'
      end

      it 'validates that @bindable is a boolean' do
        plan_attrs['bindable'] = 'true'

        expect(plan).to_not be_valid
        expect(plan.errors.messages).to include 'Plan bindable must be a boolean, but has value "true"'
      end

      it 'validates that @plan_updateable is a boolean' do
        plan_attrs['plan_updateable'] = 'true'

        expect(plan).to_not be_valid
        expect(plan.errors.messages).to include 'Plan updateable must be a boolean, but has value "true"'
      end

      it 'validates that @schemas is a hash' do
        plan_attrs['schemas'] = 'true'

        expect(plan).to_not be_valid
        expect(plan.errors.messages.first).to include 'Plan schemas must be a hash, but has value "true"'
      end

      it 'validates that @maintenance_info is a hash' do
        plan_attrs['maintenance_info'] = 'true'

        expect(plan).to_not be_valid
        expect(plan.errors.messages.first).to include 'Maintenance info must be a hash, but has value "true"'
      end

      it 'validates that @maximum_polling_duration is an integer' do
        plan_attrs['maximum_polling_duration'] = 'true'

        expect(plan).to_not be_valid
        expect(plan.errors.messages).to include 'Maximum polling duration must be an integer, but has value "true"'
      end

      describe '#valid?' do
        it 'is false if plan has errors' do
          plan_attrs['metadata'] = 'totes not valid'
          expect(plan.valid?).to be false
        end

        it 'is false if plan schemas has errors' do
          plan_attrs['schemas'] = { 'service_instance' => 1 }
          expect(plan.valid?).to be false
        end
      end
    end
  end
end

require 'swagger_helper'

describe 'Insurances API' do

  path '/insurances' do

    post 'Creates an insurance' do
      tags 'Insurances'
      consumes 'application/json'
      parameter name: :insurance, in: :body, schema: {
        type: :object,
        properties: {
          age: { type: :integer },
          sex: { type: :string },
          bmi: { type: :decimal },
          children: { type: :integer },
          smoker: { type: :string },
          region: { type: :string },
          charges: { type: :decimal }
        },
        required: [ 'age', 'sex', 'bmi', 'children', 'smoker', 'region', 'charges' ]
      }

      response '201', 'insurance created' do
        let(:insurance) { { age: 19, sex: 'female', bmi: "27.9", children: 0, smoker: "yes", region: "southwest", charges: "16884.924" } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:insurance) { { age: 'foo' } }
        run_test!
      end
    end
  end

end
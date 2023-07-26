RSpec.describe PasskeysRails::PasskeysController do
  let(:call_api) { post '/passkeys_rails/passkeys/refresh', params:, headers: }

  include_context 'with api params'

  it_behaves_like 'an api that requires some params'

  context 'with required params' do
    let(:required_params) { { auth_token: "123" } }

    # rubocop:disable RSpec/VerifiedDoubles
    context 'with valid parameters and a successfull call to RefreshToken' do
      let(:agent) { create(:agent) }

      it 'Succeeds and reutrns instance credentails' do
        allow(PasskeysRails::RefreshToken)
          .to receive(:call!)
          .and_return(double(Interactor::Context, username: "name", auth_token: "123"))

        call_api

        expect_success
        expect(PasskeysRails::RefreshToken).to have_received(:call!).exactly(1).time
        expect(json.keys).to match_array %w[username auth_token]
        expect(json).to include(username: "name", auth_token: "123")
      end
    end
    # rubocop:enable RSpec/VerifiedDoubles
  end
end

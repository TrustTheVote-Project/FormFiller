RSpec.describe Formfiller do
  it "has a version number" do
    expect(Formfiller::VERSION).not_to be nil
  end
end


RSpec.describe Formfiller::Form do
  subject(:form) { described_class.new(template: form_pdf) }
  let(:form_pdf) { File.dirname(__FILE__) +"/fixtures/files/ga.pdf" }
  
  it "has fields" do
    expect(form.fields.size).to eq(37)
  end
end

RSpec.describe Formfiller::Signer do
  subject(:signer) { described_class.new(form: form, signature: signature, signature_field_name: signature_field) }
  let(:form) { Formfiller::Form.new(template: template_pdf) }
  let(:template_pdf) { File.dirname(__FILE__) +"/fixtures/files/ga.pdf" }
  let(:signature) { File.dirname(__FILE__) +"/fixtures/files/signature.png"  }
  let(:signature_field) { "voter_signature" }

  it "can find the signature on the form" do
    expect(signer.signature_position).to eq([311.323, 409.297])
  end
                                         
end

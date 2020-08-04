RSpec.describe FormFiller do
  it "has a version number" do
    expect(FormFiller::VERSION).not_to be nil
  end
end


RSpec.describe FormFiller::Form do
  subject(:form) { described_class.new(template: form_pdf) }
  let(:form_pdf) { File.dirname(__FILE__) +"/fixtures/files/ga.pdf" }
  
  it "has fields" do
    expect(form.fields.size).to eq(37)
  end

  it "can determine the bounding box for a field" do
    expect(form.bbox(:voter_signature_af_image).left).to eq(311.323)
  end

end

RSpec.describe FormFiller::Signer do
  subject(:signer) { described_class.new(form: form, signature: signature, signature_field_name: signature_field) }
  let(:form) { FormFiller::Form.new(template: template_pdf) }
  let(:template_pdf) { File.dirname(__FILE__) +"/fixtures/files/ga.pdf" }
  let(:signature) { File.dirname(__FILE__) +"/fixtures/files/signature.png"  }
  let(:signature_field) { "voter_signature" }

  it "can find the signature on the form" do
    expect(signer.signature_position.left).to eq(311.323)
    signer.signature_position = FormFiller::BoundingBox.new(0,0, 300, 300)
    expect(signer.signature_position.left).to eq(0)
  end

end

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

class Itext
end
t = Thread.new {
  require 'rjb'

  Rjb.load(Dir.glob(File.expand_path('../../ext/*.jar', __dir__)).join(':'))
  
  Itext::ByteStream = Rjb.import 'com.itextpdf.io.source.ByteArrayOutputStream'
  Itext::PdfReader = Rjb.import 'com.itextpdf.kernel.pdf.PdfReader'
  Itext::PdfWriter = Rjb.import 'com.itextpdf.kernel.pdf.PdfWriter'
  Itext::PdfDocument = Rjb.import 'com.itextpdf.kernel.pdf.PdfDocument'
  Itext::PdfAcroForm = Rjb.import 'com.itextpdf.forms.PdfAcroForm'
  Itext::PdfFormField = Rjb.import 'com.itextpdf.forms.fields.PdfFormField'
  Itext::ImageDataFactory = Rjb.import 'com.itextpdf.io.image.ImageDataFactory'
  Itext::Image = Rjb.import 'com.itextpdf.layout.element.Image'
  Itext::Document = Rjb.import 'com.itextpdf.layout.Document'
  Itext::XfdfObject = Rjb.import 'com.itextpdf.forms.xfdf.XfdfObject'
  Itext::XfdfObjectFactory = Rjb.import 'com.itextpdf.forms.xfdf.XfdfObjectFactory'
}
t.join

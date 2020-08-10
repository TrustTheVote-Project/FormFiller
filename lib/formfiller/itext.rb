require 'rjb'

Rjb.load(Dir.glob(File.expand_path('../../ext/*.jar', __dir__)).join(':'))

class Itext
    ByteStream = Rjb.import 'com.itextpdf.io.source.ByteArrayOutputStream'
    PdfReader = Rjb.import 'com.itextpdf.kernel.pdf.PdfReader'
    PdfWriter = Rjb.import 'com.itextpdf.kernel.pdf.PdfWriter'
    PdfDocument = Rjb.import 'com.itextpdf.kernel.pdf.PdfDocument'
    PdfAcroForm = Rjb.import 'com.itextpdf.forms.PdfAcroForm'
    PdfFormField = Rjb.import 'com.itextpdf.forms.fields.PdfFormField'
    ImageDataFactory = Rjb.import 'com.itextpdf.io.image.ImageDataFactory'
    Image = Rjb.import 'com.itextpdf.layout.element.Image'
    Document = Rjb.import 'com.itextpdf.layout.Document'
    XfdfObject = Rjb.import 'com.itextpdf.forms.xfdf.XfdfObject'
    XfdfObjectFactory = Rjb.import 'com.itextpdf.forms.xfdf.XfdfObjectFactory'
end

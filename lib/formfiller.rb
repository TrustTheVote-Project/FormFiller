require "formfiller/version"
require "formfiller/itext"

module Formfiller
  class Error < StandardError; end
  
  class Form
    attr_accessor :pdf_doc, :pdf_form, :document, :template
    # required Java imports
    BYTE_STREAM = Rjb.import 'com.itextpdf.io.source.ByteArrayOutputStream'
    PDF_READER = Rjb.import 'com.itextpdf.kernel.pdf.PdfReader'
    PDF_WRITER = Rjb.import 'com.itextpdf.kernel.pdf.PdfWriter'
    PDF_DOCUMENT = Rjb.import 'com.itextpdf.kernel.pdf.PdfDocument'
    PDF_ACRO_FORM = Rjb.import 'com.itextpdf.forms.PdfAcroForm'
    PDF_FORM_FIELD = Rjb.import 'com.itextpdf.forms.fields.PdfFormField'
    IMAGE_DATA_FACTORY = Rjb.import 'com.itextpdf.io.image.ImageDataFactory'
    IMAGE = Rjb.import 'com.itextpdf.layout.element.Image'
    DOCUMENT = Rjb.import 'com.itextpdf.layout.Document'
    Itext_Image = Rjb.import 'com.itextpdf.layout.element.Image'
    ##
    # Opens a given fillable-pdf PDF file and prepares it for modification.
    #
    def initialize(args)
      
      raise IOError, "File at `#{args[:template]}' is not found" unless File.exist?(args[:template])
      @template = args[:template]
      begin
        @byte_stream = BYTE_STREAM.new
        @pdf_reader = PDF_READER.new @template
        @pdf_writer = PDF_WRITER.new @byte_stream
        @pdf_doc = PDF_DOCUMENT.new @pdf_reader, @pdf_writer
        @pdf_form = PDF_ACRO_FORM.getAcroForm(@pdf_doc, true)
        @form_fields = @pdf_form.getFormFields
        @document = DOCUMENT.new(@pdf_doc)
      rescue StandardError => ex
        raise "#{ex.message} (input file may be corrupt, incompatible, or may not have any forms)"
      end
    end

    def fields
      @form_fields
    end

    def field(key)
      field = fields.get(key.to_s)
      raise "unknown key name `#{key}'" if field.nil?
    end
  end

  class Signer
    attr_reader :form, :signature
    IMAGE_DATA_FACTORY = Rjb.import 'com.itextpdf.io.image.ImageDataFactory'
    IMAGE = Rjb.import 'com.itextpdf.layout.element.Image'
    DOCUMENT = Rjb.import 'com.itextpdf.layout.Document'
    Itext_Image = Rjb.import 'com.itextpdf.layout.element.Image'
    
    def initialize(args)
      @form = args[:form]
      signature_file = args[:signature]
      @signature = Itext_Image.new(IMAGE_DATA_FACTORY.create(signature_file))
      @document = DOCUMENT.new(form.pdf_doc)
      @sig_field_name = "voter_signature_af_image"
    end    
  end
end

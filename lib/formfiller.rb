require_relative "formfiller/version"
require_relative "formfiller/itext"
require_relative "field"

module FormFiller
  class Error < StandardError; end
  
  class Form
    attr_accessor :byte_stream, :pdf_reader, :pdf_writer, :pdf_doc, :pdf_form, :document, :template

    # Opens a given PDF file and prepares it for modification.
    #
    def initialize(args)
      
      raise IOError, "File at `#{args[:template]}' is not found" unless File.exist?(args[:template])
      @template = args[:template]
      begin
        @byte_stream = Itext::ByteStream.new
        @pdf_reader = Itext::PdfReader.new template
        @pdf_writer = Itext::PdfWriter.new byte_stream
        @pdf_doc = Itext::PdfDocument.new pdf_reader, pdf_writer
        @pdf_form = Itext::PdfAcroForm.getAcroForm(pdf_doc, true)
        @form_fields = pdf_form.getFormFields
        @document = Itext::Document.new(pdf_doc)
      rescue StandardError => ex
        raise "#{ex.message} (input file may be corrupt, incompatible, or may not have any forms)"
      end
    end

  ##
  # get dimensions of a form field
  ##
  def field_dimensions(key)
    position = pdf_field(key).getWidgets().get(0).getRectangle()
    width =  position.getAsNumber(2).getValue() - position.getAsNumber(0).getValue();
    height = position.getAsNumber(3).getValue() - position.getAsNumber(1).getValue();
    return width, height
  end

  def field_position(key)
    position = pdf_field(key).getWidgets().get(0).getRectangle()
    return position.getAsNumber(0).getValue(), position.getAsNumber(1).getValue()
  end

  ##
  # Determines whether the form has any fields.
  #
  #   @return true if form has fields, false otherwise
  #
  def any_fields?
    num_fields.positive?
  end

  ##
  # Returns the total number of fillable form fields.
  #
  #   @return the number of fields
  #
  def num_fields
    @form_fields.size
  end

  ##
  # Retrieves the value of a field given its unique field name.
  #
  #   @param [String|Symbol] key the field name
  #
  #   @return the value of the field
  #
  def field(key)
    pdf_field(key).getValueAsString
  rescue NoMethodError
    raise "unknown key name `#{key}'"
  end

  ##
  # Retrieves the numeric type of a field given its unique field name.
  #
  #   @param [String|Symbol] key the field name
  #
  #   @return the type of the field
  #
  def field_type(key)
    pdf_field(key).getFormType.toString
  end

  ##
  # Retrieves a hash of all fields and their values.
  #
  #   @return the hash of field keys and values
  #
  def fields
    iterator = @form_fields.keySet.iterator
    map = {}
    while iterator.hasNext
      key = iterator.next.toString
      map[key.to_sym] = field(key)
    end
    map
  end

  ##
  # Sets the value of a field given its unique field name and value.
  #
  #   @param [String|Symbol] key the field name
  #   @param [String|Symbol] value the field value
  #
  def set_field(key, value)
    pdf_field(key).setValue(value.to_s)
  end

  ##
  # Sets the values of multiple fields given a set of unique field names and values.
  #
  #   @param [Hash] fields the set of field names and values
  #
  def set_fields(fields)
    fields.each { |key, value| set_field key, value }
  end

  ##
  # Renames a field given its unique field name and the new field name.
  #
  #   @param [String|Symbol] old_key the field name
  #   @param [String|Symbol] new_key the field name
  #
  def rename_field(old_key, new_key)
    pdf_field(old_key).setFieldName(new_key.to_s)
  end

  ##
  # Removes a field from the document given its unique field name.
  #
  #   @param [String|Symbol] key the field name
  #
  def remove_field(key)
    @pdf_form.removeField(key.to_s)
  end

  ##
  # Returns a list of all field keys used in the document.
  #
  #   @return array of field names
  #
  def names
    iterator = @form_fields.keySet.iterator
    set = []
    set << iterator.next.toString.to_sym while iterator.hasNext
    set
  end

  ##
  # Returns a list of all field values used in the document.
  #
  #   @return array of field values
  #
  def values
    iterator = @form_fields.keySet.iterator
    set = []
    set << field(iterator.next.toString) while iterator.hasNext
    set
  end

  ##
  # Overwrites the previously opened PDF document and flattens it if requested.
  #
  #   @param [bool] flatten true if PDF should be flattened, false otherwise
  #
  def save(flatten: false)
    tmp_file = SecureRandom.uuid
    save_as(tmp_file, flatten: flatten)
    File.rename tmp_file, @file_path
  end

  ##
  # Saves the filled out PDF document in a given path and flattens it if requested.
  #
  #   @param [String] file_path the name of the PDF file or file path
  #   @param [Hash] flatten: true if PDF should be flattened, false otherwise
  #
  def save_as(file_path, flatten: false)
    if @file_path == file_path
      save(flatten: flatten)
    else
      File.open(file_path, 'wb') { |f| f.write(finalize(flatten: flatten)) && f.close }
    end
  end

  ##
  # Closes the PDF document discarding all unsaved changes.
  #
  # @return [Boolean] true if document is closed, false otherwise
  #
  def close
    @pdf_doc.close
    @pdf_doc.isClosed
  end

  
  private

  ##
  # Writes the contents of the modified fields to the previously opened PDF file.
  #
  #   @param [Hash] flatten: true if PDF should be flattened, false otherwise
  #
  def finalize(flatten: false)
    @pdf_form.flattenFields if flatten
    close
    @byte_stream.toByteArray
  end

  def pdf_field(key)
    field = @form_fields.get(key.to_s)
    raise "unknown key name `#{key}'" if field.nil?
    field
  end

  end

  class Signer
    attr_reader :form, :signature, :document, :signature_field_name
    def initialize(args)
      @form = args[:form]
      signature_file = args[:signature]
      @signature = Itext::Image.new(Itext::ImageDataFactory.create(signature_file))
      @document = Itext::Document.new(form.pdf_doc)
      @signature_field_name = args[:sigfield] || "voter_signature_af_image"
    end    
    
    def signature_position
      form.field_position(signature_field_name)
    end
    
    def sign
      pos = signature_position
      signature.setFixedPosition(pos[0], pos[1])
      form.remove_field(signature_field_name)
      document.add(signature)
    end
  end
end

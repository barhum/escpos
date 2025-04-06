module Escpos
  module Helpers
    extend self

    # Encodes UTF-8 string to encoding acceptable for the printer
    # @param data [String] The text to encode
    # @param encoding [Encoding] The target encoding
    # @param invalid [Symbol] How to handle invalid characters (:replace, :ignore)
    # @param undef [Symbol] How to handle undefined characters (:replace, :ignore)
    # @param replace [String] Replacement character for invalid/undefined chars
    # @return [String] Encoded string
    def encode(data, encoding:)
      data.encode(encoding)
    end

    # Set printer encoding
    # @param encoding [Integer] The encoding code to set
    # @return [String] The encoding sequence
    def set_encoding(encoding)
      [
        Escpos.sequence(Escpos::CP_SET),
        Escpos.sequence(encoding)
      ].join
    end
    alias :encoding :set_encoding
    alias :set_printer_encoding :set_encoding

    # Format text with specified style
    # @param data [String] The text to format
    # @param style [Symbol] The style to apply
    # @return [String] Formatted text
    def format_text(data, style)
      raise ArgumentError, "data must be a String" unless data.is_a?(String)
      
      [
        Escpos.sequence(style),
        data,
        Escpos.sequence(Escpos::TXT_NORMAL)
      ].join
    end

    # Text formatting methods
    def text(data) = format_text(data, Escpos::TXT_NORMAL)
    def double_height(data) = format_text(data, Escpos::TXT_2HEIGHT)
    def double_width(data) = format_text(data, Escpos::TXT_2WIDTH)
    def quad_text(data) = format_text(data, Escpos::TXT_4SQUARE)
    def underline(data) = format_text(data, Escpos::TXT_UNDERL_ON)
    def underline2(data) = format_text(data, Escpos::TXT_UNDERL2_ON)
    def bold(data) = format_text(data, Escpos::TXT_BOLD_ON)
    def inverted(data) = format_text(data, Escpos::TXT_INVERT_ON)

    # Aliases for text formatting
    alias :big :quad_text
    alias :title :quad_text
    alias :header :quad_text
    alias :double_width_double_height :quad_text
    alias :double_height_double_width :quad_text
    alias :u :underline
    alias :u2 :underline2
    alias :b :bold
    alias :invert :inverted

    # Text alignment methods
    def align_text(data, alignment)
      raise ArgumentError, "data must be a String" unless data.is_a?(String)
      
      [
        Escpos.sequence(alignment),
        data,
        Escpos.sequence(Escpos::TXT_ALIGN_LT)
      ].join
    end

    def left(data = '') = align_text(data, Escpos::TXT_ALIGN_LT)
    def right(data = '') = align_text(data, Escpos::TXT_ALIGN_RT)
    def center(data = '') = align_text(data, Escpos::TXT_ALIGN_CT)

    # Color methods
    def color_text(data, color)
      raise ArgumentError, "data must be a String" unless data.is_a?(String)
      
      [
        Escpos.sequence(color),
        data,
        Escpos.sequence(Escpos::TXT_COLOR_BLACK)
      ].join
    end

    def black(data) = color_text(data, Escpos::TXT_COLOR_BLACK)
    def red(data) = color_text(data, Escpos::TXT_COLOR_RED)

    # Color aliases
    alias :default_color :black
    alias :black_color :black
    alias :color_black :black
    alias :alt_color :red
    alias :alternative_color :red
    alias :red_color :red
    alias :color_red :red

    # Barcode generation
    # @param data [String] The barcode data
    # @param format [Integer] The barcode format
    # @param height [Integer] Barcode height (1-255)
    # @param width [Integer] Barcode width (2-6)
    # @param text_position [Integer] Text position relative to barcode
    # @return [String] Barcode sequence
    def barcode(data, format: Escpos::BARCODE_EAN13, height: 50, width: 3, text_position: Escpos::BARCODE_TXT_OFF)
      raise ArgumentError, "data must be a String" unless data.is_a?(String)
      raise ArgumentError, "height must be between 1 and 255" unless (1..255).cover?(height)
      raise ArgumentError, "width must be between 2 and 6" unless (2..6).cover?(width)
      
      valid_text_positions = [
        Escpos::BARCODE_TXT_OFF,
        Escpos::BARCODE_TXT_ABV,
        Escpos::BARCODE_TXT_BLW,
        Escpos::BARCODE_TXT_BTH
      ]
      raise ArgumentError, "invalid text position" unless valid_text_positions.include?(text_position)

      [
        Escpos.sequence(text_position),
        Escpos.sequence(Escpos::BARCODE_WIDTH),
        Escpos.sequence([width]),
        Escpos.sequence(Escpos::BARCODE_HEIGHT),
        Escpos.sequence([height]),
        Escpos.sequence(format),
        data
      ].join
    end

    # Paper cutting methods
    def partial_cut = Escpos.sequence(Escpos::PAPER_PARTIAL_CUT)
    def cut = Escpos.sequence(Escpos::PAPER_FULL_CUT)
  end
end

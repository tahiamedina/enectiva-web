require 'i18n'

# Create folder "_locales" and put some locale file from https://github.com/svenfuchs/rails-i18n/tree/master/rails/locale
module Jekyll
  module I18nFilter

    I18n.enforce_available_locales = true

    def translate(input, locale = nil)
      load_translations
      set_locale(locale)
      I18n.t input
    end

    # Example:
    #   {{ post.date | localize: "%d.%m.%Y" }}
    #   {{ post.date | localize: ":short" }}
    def localize(input, format=nil, locale=nil)
      load_translations
      format = (format =~ /^:(\w+)/) ? $1.to_sym : format
      set_locale(locale)
      I18n.l input, :format => format
    end

    def load_translations
      unless I18n::backend.instance_variable_get(:@translations)
        I18n.backend.load_translations Dir[File.join(File.dirname(__FILE__),'../_locales/*.yml')]
      end
    end

    def set_locale(locale)
      locale = @context.registers[:site].config['default_locale'] unless locale
      I18n.locale = locale
    end
  end
end

Liquid::Template.register_filter(Jekyll::I18nFilter)
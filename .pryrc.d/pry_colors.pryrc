### COLORS #####################################################################
# See all colors with PryColorize.list
module PryColorize
  module_function

  def black(str);          "\e[30m#{str}\e[0m" end
  def red(str);            "\e[31m#{str}\e[0m" end
  def green(str);          "\e[32m#{str}\e[0m" end
  def brown(str);          "\e[33m#{str}\e[0m" end
  def blue(str);           "\e[34m#{str}\e[0m" end
  def magenta(str);        "\e[35m#{str}\e[0m" end
  def cyan(str);           "\e[36m#{str}\e[0m" end
  def gray(str);           "\e[37m#{str}\e[0m" end

  def bg_black(str);       "\e[40m#{str}\e[0m" end
  def bg_red(str);         "\e[41m#{str}\e[0m" end
  def bg_green(str);       "\e[42m#{str}\e[0m" end
  def bg_brown(str);       "\e[43m#{str}\e[0m" end
  def bg_blue(str);        "\e[44m#{str}\e[0m" end
  def bg_magenta(str);     "\e[45m#{str}\e[0m" end
  def bg_cyan(str);        "\e[46m#{str}\e[0m" end
  def bg_gray(str);        "\e[47m#{str}\e[0m" end

  def bold(str);           "\e[1m#{str}\e[22m" end
  def italic(str);         "\e[3m#{str}\e[23m" end
  def underline(str);      "\e[4m#{str}\e[24m" end
  def blink(str);          "\e[5m#{str}\e[25m" end
  def reverse_color(str);  "\e[7m#{str}\e[27m" end

  def list
    methods = singleton_methods(false) - [:list]
    methods.each { |m| puts send(m, format('%-20s', m)) }
  end
end
Pry::Commands.block_command('cheat', 'Display Cheatsheet') do
  ppc = -> str { output.puts PryColorize.brown(str) }

  ppc.call 'Cheatsheet:'
  ppc.call 'pbjson(user)                            : convert user to pretty printed json and copy to clipboard'
  ppc.call 'hist --save 39..42 refresh_qbo_token.rb : take lines 39 - 42 of the history and write to file'
  ppc.call 'Object.send(:remove_const, :Foo)        : remove constant'
  ppc.call 'start-macro                             : begin recording a macro'
  ppc.call 'stop-macro                              : stop recording a macro'
  ppc.call 'save-macro <name>                       : append to .pryrc'
  ppc.call 'sqlon                                   : log ActiveRecord sql'
  ppc.call 'sqloff                                  : turn off logging of ActiveRecord sql'
  ppc.call 'tp Qbo::Entity.take(5), markdown: true  : table print array w/markdown'
  ppc.call 'Sidekiq::Queue.new.clear                : To clear sidekiq'
  ppc.call 'ActiveSupport::Dependencies.autoload_paths : Show autoload paths'
  ppc.call 'Rails.application.assets.paths          : Show asset paths'
  ppc.call 'wtf-args <op>                           : Print Dev.wtf? snippet>'
  ppc.call 'break --condition <bp#> foo == nil      : conditional breakpoint on existing'
end

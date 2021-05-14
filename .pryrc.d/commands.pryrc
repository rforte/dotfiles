Pry::Commands.block_command "noconflict", "Rename step to sstep and next to nnext" do
  Pry::Commands.rename_command("nnext", "next")
  Pry::Commands.rename_command("bbreak", "break")
end

Pry::Commands.block_command "unnoconflict", "Revert to normal next and break" do
  Pry::Commands.rename_command("next", "nnext")
  Pry::Commands.rename_command("break", "bbreak")
end

Pry.config.commands.command 'hash-html', 'Write a pretty hash to an html file and open it' do |input|
  input = input ? target.eval(input) : pry_instance.last_result

  hash = input.ai(html: false, plain: true, object_id: false, index: false).gsub(/#<[^>]+>\s+/, '')

  require 'tempfile'
  file = Tempfile.new(['pry-result', '.html'])
  begin
    file.write("<pre>#{hash}</pre>")
    file.rewind
    `open #{file.path}`
  ensure
    # file.unlink
  end
end

Pry.config.commands.command 'html-view', 'Write input to an html file and open it' do |input|
  input = input ? target.eval(input) : pry_instance.last_result

  require 'tempfile'
  file = Tempfile.new(['pry-result', '.html'])
  begin
    file.write(input)
    file.rewind
    `open #{file.path}`
  ensure
    # file.unlink
  end
end

Pry.config.commands.alias_command '.clr', '.clear'

if defined?(PryByebug)
  Pry.commands.alias_command 'c', 'continue'
  Pry.commands.alias_command 's', 'step'
  Pry.commands.alias_command 'n', 'next'
  Pry.commands.alias_command 'f', 'finish'
  Pry.commands.alias_command 'w', 'whereami'
end

# Hit Enter to repeat last command
Pry::Commands.command(%r{^$}, 'repeat last command') do
  pry_instance.run_command Pry.history.to_a.last
end

###
# Pry output
###
Pry::Commands.block_command 'pager-on', 'Turn pager on' do
  pry_instance.pager = true
end

Pry::Commands.block_command 'pager-off', 'Turn pager on' do
  pry_instance.pager = false
end

###
# Text helpers
###
Pry.config.commands.command 'pbcopy', 'Copy input to clipboard' do |input|
  input = input ? target.eval(input) : pry_instance.last_result
  IO.popen('pbcopy', 'w') { |io| io << input }
end

Pry::Commands.block_command 'paste-eval', "Pastes from the clipboard then evals it in the context of Pry" do
  pry_instance.input = StringIO.new(pbpaste)
end

###
# Development commands
###
Pry::Commands.block_command "remove-const", "Clear ruby constant", group: 'Debug' do |args|
  Object.send(:remove_const, :"#{args[0]}")
end.group 'development'

Pry::Commands.block_command "reset-password", "Reset a user password via email" do |email, password|
  User.find_by_email(email).update!(password: password, password_confirmation: password)
end.group 'development'

Pry::Commands.block_command "bt-gems", "Generate a backtrace and filter .gems" do
  output.puts caller.reject { |l| l.match?(/(\.rbenv)|(\.gems\/gems\/pry)/) }.join("\n")
end.group 'development'

Pry::Commands.block_command "wtf-args", "Trace TRB Operation", keep_retval: true do |*args|
  if args.first.nil?
    if op = target.eval("#{target_self.described_class rescue nil}")
    else
      controller_name_segments = target_self.params[:controller].split('/')
      controller_name_segments.pop
      controller_namespace = controller_name_segments.join('/').camelize

      op = target.eval("\"#{controller_namespace}::#{target_self.controller_name.classify.pluralize}::Operation::#{target_self.action_name.capitalize}\"") unless op
    end
  else
    op = args[0]
  end

  "Dev.wtf?(#{op}, [\n" +
  "  Trailblazer::Context(params: _run_params, **_run_options({})), \n" +
  "  {}\n" +
  "]) ; nil\n"
end.group 'development'

# class Pry
#   class Command::Whereami < Pry::ClassCommand
#     def location
#       "#{@file}:#{@line} #{@method && @method.name_with_owner}"
#     end
#   end
# end

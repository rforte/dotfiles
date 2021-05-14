# frozen_string_literal: true

begin
  require 'amazing_print'
rescue
  puts "You should gem install amazing_print"
end

Pry.config.pager  = true
Pry.config.editor = proc { |file, line| "code --goto #{file}:#{line}:1" }
Pry.config.theme = 'zenburn'

Pry.config.ls.heading_color = :magenta
Pry.config.ls.public_method_color = :green
Pry.config.ls.protected_method_color = :yellow
Pry.config.ls.private_method_color = :red

Pry.config.collision_warning = true

Dir[File.join(__dir__, '.pryrc.d', '*.pryrc')].sort.each { |file| str = "Loading #{file}" ; puts "\e[35m#{str}\e[0m" ; load file }

# Pry.debundle!
# Run just after a binding.pry, before you get dumped in the REPL.
# This handles the case where Bundler is loaded before Pry.
# NOTE: This hook happens *before* :before_session
# Pry.config.hooks.add_hook(:when_started, :debundle){ Pry.debundle! }

# Run after every line of code typed.
# This handles the case where you load something that loads bundler
# into your Pry.
# Pry.config.hooks.add_hook(:after_eval, :debundle){ Pry.debundle! }

# def signin(type)
#   ApplicationController.allow_forgery_protection = false
#   app.post('/users/sign_in', {"user"=>{"email"=>"foo@example.com", "password"=>"testtest"}})
# end

add_dir_hook = Pry::Hooks.new.add_hook(:before_session, :add_dirs_to_load_path) do
  # adds the directories /spec and /test directories to the path if they exist and not already included
  dir = `pwd`.chomp
  dirs_added = []
  %w(spec test presenters lib).map{ |d| "#{dir}/#{d}" }.each do |p|
    if File.exist?(p) && !$:.include?(p)
      $: << p
      dirs_added << p
    end
  end

  if dirs_added.present?
    puts PryColorize.bold(PryColorize.green "Adding directories specified in ~/.pryrc" )
    dirs_added.map { |d| PryColorize.green(d) }
  end
end

helper_hook = Pry::Hooks.new.add_hook(:before_session, :load_helpers) do
  begin
    puts Dir[File.join(__dir__, '.pryrc.d', '*.rb')].sort
    Dir[File.join(__dir__, '.pryrc.d', '*.rb')].sort.each do |file|
      puts PryColorize.bold(PryColorize.cyan "Loading helper #{file}")
      load file
    end
  rescue => ex
    puts PryColorize.bold(PryColorize.red(ex.message))
  end
end

add_dir_hook.exec_hook(:before_session)
helper_hook.exec_hook(:before_session)


require "open3"

class BuildpackInstaller < Struct.new(:path, :app_dir)

  def detect
    @detect_output, status = Open3.capture2 command('detect')
    status == 0
  end

  def name
    @detect_output ? @detect_output.strip : nil
  end

  def compile
    puts "Installing #{path.basename}."
    ok = system "#{command('compile')} /tmp/bundler_cache"
    raise "Buildpack compilation step failed:\n" unless ok
  end

  def release_info
    output, status = Open3.capture2 command("release")
    raise "Release info failed:\n#{output}" unless status == 0
    YAML.load(output)
  end

  private

  def command(command_name)
    "#{path}/bin/#{command_name} #{app_dir}"
  end
end
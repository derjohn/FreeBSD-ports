--- tool/rbinstall.rb.orig	2016-10-17 07:17:07.000000000 +0000
+++ tool/rbinstall.rb	2016-12-13 14:55:27.945769000 +0000
@@ -324,6 +324,7 @@
 libdir = CONFIG[CONFIG.fetch("libdirname", "libdir"), true]
 rubyhdrdir = CONFIG["rubyhdrdir", true]
 archhdrdir = CONFIG["rubyarchhdrdir"] || (rubyhdrdir + "/" + CONFIG['arch'])
+libdatadir = CONFIG["prefix", true] + "/" + "libdata"
 rubylibdir = CONFIG["rubylibdir", true]
 archlibdir = CONFIG["rubyarchdir", true]
 sitelibdir = CONFIG["sitelibdir"]
@@ -378,7 +379,7 @@
 install?(:local, :arch, :data) do
   pc = CONFIG["ruby_pc"]
   if pc and File.file?(pc) and File.size?(pc)
-    prepare "pkgconfig data", pkgconfigdir = File.join(libdir, "pkgconfig")
+    prepare "pkgconfig data", pkgconfigdir = File.join(libdatadir, "pkgconfig")
     install pc, pkgconfigdir, :mode => $data_mode
   end
 end
@@ -694,110 +695,6 @@
 
 # :startdoc:
 
-install?(:ext, :comm, :gem) do
-  gem_dir = Gem.default_dir
-  directories = Gem.ensure_gem_subdirectories(gem_dir, :mode => $dir_mode)
-  prepare "default gems", gem_dir, directories
-
-  spec_dir = File.join(gem_dir, directories.grep(/^spec/)[0])
-  default_spec_dir = "#{spec_dir}/default"
-  makedirs(default_spec_dir)
-
-  gems = Dir.glob(srcdir+"/{lib,ext}/**/*.gemspec").map {|src|
-    spec = Gem::Specification.load(src) || raise("invalid spec in #{src}")
-    file_collector = RbInstall::Specs::FileCollector.new(File.dirname(src))
-    files = file_collector.collect
-    next if files.empty?
-    spec.files = files
-    spec
-  }
-  gems.compact.sort_by(&:name).each do |gemspec|
-    full_name = "#{gemspec.name}-#{gemspec.version}"
-
-    puts "#{" "*30}#{gemspec.name} #{gemspec.version}"
-    gemspec_path = File.join(default_spec_dir, "#{full_name}.gemspec")
-    open_for_install(gemspec_path, $data_mode) do
-      gemspec.to_ruby
-    end
-
-    unless gemspec.executables.empty? then
-      bin_dir = File.join(gem_dir, 'gems', full_name, gemspec.bindir)
-      makedirs(bin_dir)
-
-      execs = gemspec.executables.map {|exec| File.join(srcdir, 'bin', exec)}
-      install(execs, bin_dir, :mode => $script_mode)
-    end
-  end
-end
-
-install?(:ext, :comm, :gem) do
-  gem_dir = Gem.default_dir
-  directories = Gem.ensure_gem_subdirectories(gem_dir, :mode => $dir_mode)
-  prepare "bundle gems", gem_dir, directories
-  install_dir = with_destdir(gem_dir)
-  installed_gems = {}
-  options = {
-    :install_dir => install_dir,
-    :bin_dir => with_destdir(bindir),
-    :domain => :local,
-    :ignore_dependencies => true,
-    :dir_mode => $dir_mode,
-    :data_mode => $data_mode,
-    :prog_mode => $prog_mode,
-    :wrappers => true,
-    :format_executable => true,
-  }
-  gem_ext_dir = "#$extout/gems/#{CONFIG['arch']}"
-  extensions_dir = Gem::StubSpecification.gemspec_stub("", gem_dir, gem_dir).extensions_dir
-  Gem::Specification.each_gemspec([srcdir+'/gems/*']) do |path|
-    dir = File.dirname(path)
-    spec = Dir.chdir(dir) {
-      Gem::Specification.load(File.basename(path))
-    }
-    next unless spec.platform == Gem::Platform::RUBY
-    next unless spec.full_name == path[srcdir.size..-1][/\A\/gems\/([^\/]+)/, 1]
-    spec.extension_dir = "#{extensions_dir}/#{spec.full_name}"
-    if File.directory?(ext = "#{gem_ext_dir}/#{spec.full_name}")
-      spec.extensions[0] ||= "-"
-    end
-    ins = RbInstall::UnpackedInstaller.new(spec, options)
-    puts "#{" "*30}#{spec.name} #{spec.version}"
-    ins.install
-    File.chmod($data_mode, File.join(install_dir, "specifications", "#{spec.full_name}.gemspec"))
-    unless spec.extensions.empty?
-      install_recursive(ext, spec.extension_dir)
-    end
-    installed_gems[spec.full_name] = true
-  end
-  installed_gems, gems = Dir.glob(srcdir+'/gems/*.gem').partition {|gem| installed_gems.key?(File.basename(gem, '.gem'))}
-  unless installed_gems.empty?
-    install installed_gems, gem_dir+"/cache"
-  end
-  next if gems.empty?
-  if defined?(Zlib)
-    Gem.instance_variable_set(:@ruby, with_destdir(File.join(bindir, ruby_install_name)))
-    silent = Gem::SilentUI.new
-    gems.each do |gem|
-      inst = Gem::Installer.new(gem, options)
-      inst.spec.extension_dir = with_destdir(inst.spec.extension_dir)
-      begin
-        Gem::DefaultUserInteraction.use_ui(silent) {inst.install}
-      rescue Gem::InstallError => e
-        next
-      end
-      gemname = File.basename(gem)
-      puts "#{" "*30}#{gemname}"
-    end
-    # fix directory permissions
-    # TODO: Gem.install should accept :dir_mode option or something
-    File.chmod($dir_mode, *Dir.glob(install_dir+"/**/"))
-    # fix .gemspec permissions
-    File.chmod($data_mode, *Dir.glob(install_dir+"/specifications/*.gemspec"))
-  else
-    puts "skip installing bundle gems because of lacking zlib"
-  end
-end
-
 parse_args()
 
 include FileUtils

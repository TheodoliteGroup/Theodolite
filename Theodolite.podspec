Pod::Spec.new do |spec|
  spec.name = "Theodolite"
  spec.version = "0.1.1"
  spec.summary = "A React-Inspired view framework in Swift."
  spec.homepage = "http://theodolite.org"
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { "Oliver Rickard" => 'ocrickard@gmail.com' }
  spec.social_media_url = "http://twitter.com/ocrickard"

  spec.platform = :ios, "10.0"
  spec.requires_arc = true
  spec.source = { git: "https://github.com/TheodoliteGroup/Theodolite.git", tag: "v#{spec.version}", submodules: true }
  spec.source_files = "Theodolite/**/*.{h,m,mm,swift}"

  spec.dependency 'Flexbox'
end

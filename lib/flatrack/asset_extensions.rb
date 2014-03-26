class Flatrack
  # Provides asset helpers to various parts of a flatrack site.
  module AssetExtensions
    def asset_path(path, options = {})
      File.join('/assets', path.to_s)
    end
  end
end

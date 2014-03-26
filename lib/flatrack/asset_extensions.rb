class Flatrack
  # Provides asset helpers to various parts of a flatrack site.
  module AssetExtensions
    # The path to a given asset
    # @param path [String] the asset name or path
    # @return [String]
    def asset_path(path, _ = {})
      File.join('/assets', path.to_s)
    end
  end
end

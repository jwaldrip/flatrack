class Flatrack
  # Provides asset helpers to various parts of a flatrack site.
  module AssetExtensions
    # The path to a given asset
    # @param path [String] the asset name or path
    # @return [String]
    def asset_path(path, _ = {})
      File.join('/', mount_path, 'assets', path.to_s)
    end

    def mount_path
      method(__method__).super_method ? super : '/'
    end
  end
end

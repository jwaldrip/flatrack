module Flatrack
  module AssetExtensions
    def asset_path(path, options = {})
      File.join('/assets', path.to_s)
    end
  end
end

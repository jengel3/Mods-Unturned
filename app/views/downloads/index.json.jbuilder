json.array!(@downloads) do |download|
  json.extract! download, :id, :downloads, :game_version, :version, :changelog, :notes, :type
  json.url download_url(download, format: :json)
end

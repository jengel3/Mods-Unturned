db.submissions.update( { }, { $rename: { 'download_count': 'old_downloads'} } )
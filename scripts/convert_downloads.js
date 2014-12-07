db.submissions.update( {}, { $rename: { 'download_count': 'old_downloads'} }, { multi: true } );
db.downloads.renameCollection("uploads");
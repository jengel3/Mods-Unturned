db.downloads.aggregate({ "$group": { "_id": "$ip", "count" : { "$sum" : 1 } }},{ "$sort" : { count: -1 } })


db.downloads.aggregate({ "$match" : { submission_id: new ObjectId("54c64d4576707326e51b0000") } }, { "$group": { "_id": "$ip", "count" : { "$sum" : 1 } }},{ "$sort" : { count: -1 } })

db.downloads.aggregate({ "$match" : { "created_at" : {"$gte": new Date(Date.UTC(2015, 2, 1)) } } }, { "$group": { "_id": "$ip", "count" : { "$sum" : 1 } }},{ "$sort" : { count: -1 } })

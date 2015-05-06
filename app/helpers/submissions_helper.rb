module SubmissionsHelper
  def search_submissions
    submissions = Kaminari.paginate_array(Submission.es.search({
      body: {
        query: {
          match: {
            name: {
              query: params[:search][:search],
              fuzziness: 2,
              prefix_length: 1
            }
          }
        },
        filter: {
          exists: { field: "approved_at" }
        }
      }
    },
    page: params[:page], wrapper: :load).results).page(params[:page]).per(20)
    return submissions
  end

  def waiting(submission)
    count = submission.uploads.where(:denied => false).where(:approved => false).count
    if count == 0
      t('submissions.no_files')
    else
      plural = pluralize(count, "file")
      "You have #{plural} awaiting approval."
    end
  end

  def group_by(clazz, field, format = 'day')
    key_op = [['year', '$year'], ['month', '$month'], ['day', '$dayOfMonth']]
    key_op = key_op.take(1 + key_op.find_index { |key, op| format == key })
    date_fields = Hash[*key_op.collect { |key, op| [key, {op => "$#{field}"}] }.flatten]
    group_id_fields = Hash[*key_op.collect { |key, op| [key, "$#{key}"] }.flatten]
    pipeline = [
        {"$project" => {"name" => 1, field => 1}.merge(date_fields)},
        {"$group" => {"_id" => group_id_fields, "count" => {"$sum" => 1}}},
        {"$sort" => {"count" => -1}}
    ]
    clazz.collection.aggregate(pipeline)
  end
end

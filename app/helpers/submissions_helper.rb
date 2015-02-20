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
      "No files awaiting approval."
    else
      plural = pluralize(count, "file")
      "You have #{plural} awaiting approval."
    end
  end
end

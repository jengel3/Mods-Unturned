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
end

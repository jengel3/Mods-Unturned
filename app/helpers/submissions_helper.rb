module SubmissionsHelper
  def search_submissions
    submissions = Kaminari.paginate_array(Submission.es.search({
      body: {
        query: {
          query_string: {
            query: params[:search][:search]
          }
        },
        filter: {
          exists: { field: "approved_at" }
        },
        sort: { 
          approved_at: { order: "desc" } 
        }
      }
    },
    page: params[:page], wrapper: :load).results).page(params[:page]).per(20)
    return submissions
  end

  def search_suggestions
    # completion = Submission.es.completion('te', pa)
  end
end

module CommentsHelper
  def comment_timestamp(comment)
    if comment.deleted_at
      'Deleted ' + time_ago_in_words(comment.deleted_at) + ' ago'
    elsif comment.created_at
      'Created ' + time_ago_in_words(comment.created_at) + ' ago'
    else
      t('comments.created_before')
    end
  end
end

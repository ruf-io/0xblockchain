class CommentStoryNotFoundError < StandardError; end
class CommentAlreadyPostedError < StandardError; end
class CommentParentNotFoundError < StandardError; end
class CommentInvalidError < StandardError; end

class CommentsController < ApplicationController
  COMMENTS_PER_PAGE = 20

  caches_page :index, :threads, if: CACHE_PAGE

  # for rss feeds, load the user's tag filters if a token is passed
  before_action :find_user_from_rss_token, :only => [:index]
  before_action :require_logged_in_user,
                :only => [:create, :preview, :upvote, :downvote, :unvote]

  # for rss feeds, load the user's tag filters if a token is passed
  before_action :find_user_from_rss_token, :only => [:index]

  # Create new comment
  def create
    # Get the story
    story_short_id = params[:comment][:story_short_id]
    parent_id = params[:comment][:parent_id]
    is_error = false
    html_data = nil
    parent_short_id = nil
    # Initialize root comment, if parent_id exists
    # we will re-initialize it as child comment (reply)
    comment = Comment.new

    begin
      # Fint the story first
      story = Story.find_by(:short_id => story_short_id)
      if story.nil? || story.is_gone?
        raise CommentStoryNotFoundError
      end

      # If parent id present, then check the parent
      # comment first and re-initialize comment as
      # child comment
      if parent_id.present?
        parent_comment = Comment.find_by(
          :story_id => story.id,
          :short_id => parent_id
        )
        if parent_comment.nil?
          raise CommentParentNotFoundError
        end
        # Re-initialize the comment as a child comment
        comment = Comment.new(:parent => parent_comment)
        # We use this ID to render the reply via javascript
        # on the correct location
        parent_short_id = parent_comment.short_id
      end

      # Burst spam protection
      # Get the last user comment and get the created at
      last_comment_or_reply = nil
      if comment.has_parent?
        last_comment_or_reply = comment
          .siblings
          .order(:created_at => :desc)
          .find_by(:user_id => @user.id, :story_id => story.id)
      else
        last_comment_or_reply = Comment
          .order(:created_at => :desc)
          .find_by(:user_id => @user.id, :story_id => story.id)
      end
      # Raise an error if she create the comment in less than
      # 5 minutes on different thread
      if last_comment_or_reply.present? &&
         (Time.now.utc - last_comment_or_reply.created_at) < 5.minutes
        raise CommentAlreadyPostedError
      end

      # Setup comment data
      comment.comment = params[:comment][:comment].to_s
      comment.user = @user
      comment.story = story

      # Save the comment or raise an error
      if comment.valid? && comment.save
        comment.current_vote = { :vote => 1 }
      else
        raise CommentInvalidError
      end

    rescue CommentStoryNotFoundError
      comment.errors.add(:comment, "We can't find the story that you comment")
      is_error = true
    rescue CommentAlreadyPostedError
      comment.errors.add(:comment, "You have already posted a comment/reply here recently.")
      is_error = true
    rescue CommentParentNotFoundError
      comment.errors.add(:comment, "Parent comment not found")
      is_error = true
    rescue CommentInvalidError
      is_error = true
    end

    # If error, render the form again.
    # Otherwise render the comment
    if is_error
      html_data = render_to_string :partial => "comments/comment_form",
        :layout => false,
        :content_type => "text/html",
        :locals => {
          :comment => comment,
          :story_short_id => story_short_id,
        }
      is_error = true
    else
      html_data = render_to_string :partial => "comments/comment",
        :layout => false,
        :content_type => "text/html",
        :locals => {
          :comment => comment,
        }
      is_error = false
    end

    respond_to do |format|
      # Response to JSON request
      # TODO(pyk): Disable other request format here
      format.json do
        return render :json => {
          :is_error => is_error,
          :html_data => html_data,
          :parent_short_id => parent_short_id,
        }
      end
    end
  end

  # Show comments
  def show
    @comment = Comment
      .includes(:story, :user)
      .find_by(:short_id => params[:id])

    # TODO: cek apakah comment hilang/diremove
    if @comment.nil?
      flash[:error] = "Comment is not available"
      return redirect_to root_path
    end
    # Get the replies
    @replies = @comment.descendants

    render :action => "show"
  end

  def show_short_id
    if !(comment = find_comment)
      return render :plain => "can't find comment", :status => 400
    end

    render :json => comment.as_json
  end

  def redirect_from_short_id
    if (comment = find_comment)
      return redirect_to comment.path
    else
      return render :plain => "can't find comment", :status => 400
    end
  end

  def edit
    if !((comment = find_comment) && comment.is_editable_by_user?(@user))
      return render :plain => "can't find comment", :status => 400
    end

    # render :partial => "commentbox", :layout => false,
    #   :content_type => "text/html", :locals => { :comment => comment }

    @comment = find_comment
    render :action => "edit"
  end

  def reply
    if !(parent_comment = find_comment)
      return render :plain => "can't find comment", :status => 400
    end

    comment = Comment.new
    comment.story = parent_comment.story
    comment.parent_comment = parent_comment

    render :partial => "commentbox", :layout => false,
      :content_type => "text/html", :locals => { :comment => comment }
  end

  def delete
    if !((comment = find_comment) && comment.is_deletable_by_user?(@user))
      return render :plain => "can't find comment", :status => 400
    end

    comment.delete_for_user(@user, params[:reason])

    render :partial => "comment", :layout => false,
      :content_type => "text/html", :locals => { :comment => comment }
  end

  def undelete
    if !((comment = find_comment) && comment.is_undeletable_by_user?(@user))
      return render :plain => "can't find comment", :status => 400
    end

    comment.undelete_for_user(@user)

    render :partial => "comment", :layout => false,
      :content_type => "text/html", :locals => { :comment => comment }
  end

  def disown
    if !((comment = find_comment) && comment.is_disownable_by_user?(@user))
      return render :plain => "can't find comment", :status => 400
    end

    InactiveUser.disown! comment
    comment = find_comment

    render :partial => "comment", :layout => false,
      :content_type => "text/html", :locals => { :comment => comment }
  end

  # Update comment
  def update
    # if !((comment = find_comment) && comment.is_editable_by_user?(@user))
    #   return render :plain => "can't find comment", :status => 400
    # end

    # comment.comment = params[:comment][:comment]
    # comment.hat_id = nil
    # if params[:hat_id] && @user.wearable_hats.where(:id => params[:hat_id])
    #   comment.hat_id = params[:hat_id]
    # end

    @comment = find_comment
    @comment.comment = params[:comment][:comment]
    if @comment.save
      redirect_to comment_path(@comment)
    end

    # if params[:preview].blank? && comment.save
    #   votes = Vote.comment_votes_by_user_for_comment_ids_hash(@user.id, [comment.id])
    #   comment.current_vote = votes[comment.id]

    #   # render :partial => "comments/comment",
    #   #        :layout => false,
    #   #        :content_type => "text/html",
    #   #        :locals => { :comment => comment, :show_tree_lines => params[:show_tree_lines] }
    #   render
    # else
    #   comment.current_vote = { :vote => 1 }

    #   preview comment
    # end
  end

  def unvote
    if !(comment = find_comment)
      return render :plain => "can't find comment", :status => 400
    end

    Vote.vote_thusly_on_story_or_comment_for_user_because(
      0, comment.story_id, comment.id, @user.id, nil
    )

    render :plain => "ok"
  end

  def upvote
    if !(comment = find_comment)
      return render :plain => "can't find comment", :status => 400
    end

    Vote.vote_thusly_on_story_or_comment_for_user_because(
      1, comment.story_id, comment.id, @user.id, params[:reason]
    )

    render :plain => "ok"
  end

  def downvote
    if !(comment = find_comment)
      return render :plain => "can't find comment", :status => 400
    end

    if !Vote::COMMENT_REASONS[params[:reason]]
      return render :plain => "invalid reason", :status => 400
    end

    if !@user.can_downvote?(comment)
      return render :plain => "not permitted to downvote", :status => 400
    end

    Vote.vote_thusly_on_story_or_comment_for_user_because(
      -1, comment.story_id, comment.id, @user.id, params[:reason]
    )

    render :plain => "ok"
  end

  def index
    @rss_link ||= {
      :title => "RSS 2.0 - Newest Comments",
      :href => "/comments.rss" + (@user ? "?token=#{@user.rss_token}" : ""),
    }

    @heading = @title = "Newest Comments"
    @cur_url = "/comments"

    @page = params[:page].to_i
    if @page == 0
      @page = 1
    elsif @page < 0 || @page > (2 ** 32)
      raise ActionController::RoutingError.new("page out of bounds")
    end

    @comments = Comment.where(
      :is_deleted => false, :is_moderated => false
    ).order(
      "id DESC"
    ).offset(
      (@page - 1) * COMMENTS_PER_PAGE
    ).limit(
      COMMENTS_PER_PAGE
    ).includes(
      :user, :story
    )

    if @user
      @comments = @comments.where("NOT EXISTS (SELECT 1 FROM " <<
        "hidden_stories WHERE user_id = ? AND " <<
        "hidden_stories.story_id = comments.story_id)", @user.id)

      @votes = Vote.comment_votes_by_user_for_comment_ids_hash(@user.id, @comments.map(&:id))

      @comments.each do |c|
        if @votes[c.id]
          c.current_vote = @votes[c.id]
        end
      end
    end

    respond_to do |format|
      format.html { render :action => "index" }
      format.rss {
        if @user && params[:token].present?
          @title = "Private comments feed for #{@user.username}"
        end

        render :action => "index.rss", :layout => false
      }
    end
  end

  def threads
    if params[:user]
      @showing_user = User.where(:username => params[:user]).first!
      @heading = @title = "Threads for #{@showing_user.username}"
      @cur_url = "/threads/#{@showing_user.username}"
    elsif !@user
      # TODO: show all recent threads
      return redirect_to "/login"
    else
      @showing_user = @user
      @heading = @title = "Your Threads"
      @cur_url = "/threads"
    end

    thread_ids = @showing_user.recent_threads(20, !!(@user && @user.id == @showing_user.id))

    comments = Comment.where(
      :thread_id => thread_ids
    ).includes(
      :user, :story, :hat, :votes => :user
    ).arrange_for_user(
      @user
    )

    comments_by_thread_id = comments.group_by(&:thread_id)
    @threads = comments_by_thread_id.values_at(*thread_ids).compact

    if @user
      @votes = Vote.comment_votes_by_user_for_story_hash(@user.id, comments.map(&:story_id).uniq)

      comments.each do |c|
        if @votes[c.id]
          c.current_vote = @votes[c.id]
        end
      end
    end
  end

private

  def preview(comment)
    comment.previewing = true
    comment.is_deleted = false # show normal preview for deleted comments

    render :partial => "comments/commentbox",
           :layout => false,
           :content_type => "text/html",
           :locals => {
             :comment => comment,
             :show_comment => comment,
             :show_tree_lines => params[:show_tree_lines],
           }
  end

  def find_comment
    comment = Comment.where(:short_id => params[:id]).first
    if @user && comment
      comment.current_vote = Vote.where(:user_id => @user.id,
        :story_id => comment.story_id, :comment_id => comment.id).first
    end

    comment
  end
end

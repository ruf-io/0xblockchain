// Import all dependencies
//= require jquery
//= require jquery_ujs
//= require selectize

$(document).ready(function() {
  $("#story_tag_names").selectize({
    plugins: ["remove_button"],
    persist: false,
    maxItems: 5,
    valueField: "name",
    labelField: "description",
    searchField: ["name", "description"],
    copyClassesToDropdown: false,
    items: [],
    render: {
      item: function(tag, escape) {
        return (
          '<div class="">' +
          (tag.name
            ? '<span class="name">' + escape(tag.name) + "</span>"
            : "") +
          "</div>"
        );
      },
      option: function(tag, escape) {
        var name = tag.name || tag.description;
        var description = tag.name ? tag.description : null;
        return (
          '<div class="ph2 pv2">' +
          '<span class="b mb0">' +
          escape(name) +
          "</span>" +
          (description
            ? '<span class="ml2 caption gray">' +
              escape(description) +
              "</span>"
            : "") +
          "</div>"
        );
      }
    }
  });

  // Handle post new comment or reply via ajax
  $(document)
    .on("ajax:success", ".new_comment_or_reply", function(
      event,
      data,
      status,
      xhr
    ) {
      var currentForm = this;
      var serverResponse = JSON.parse(data);
      var html_data = serverResponse.html_data;
      var parent_id = serverResponse.parent_comment_id;

      if (serverResponse.is_error) {
        $(currentForm).replaceWith(html_data);
      } else {
        // Comment or reply is successfully added
        if (parent_id) {
          // Add new reply to the list of replies
          var parentCommentReplies = $("#replies_" + parent_id);
          var successMessage =
            '<li class="success-color mb3 ml3">Reply added</li>';
          parentCommentReplies.prepend(html_data);
          parentCommentReplies.prepend(successMessage);
          currentForm.style.display = "none";
        } else {
          var storyComments = $("#comments");
          var successMessage =
            '<li class="success-color mb3 ml3">Comment added</li>';
          storyComments.prepend(html_data);
          storyComments.prepend(successMessage);
        }
        // Set form to empty
        $(currentForm)
          .children("textarea[name='comment[comment]']")
          .val("");
      }
    })
    .on("ajax:error", function(event, data, status, message) {
      var currentForm = this;
      var errorMessage = '<p class="error-color">';
      errorMessage += message;
      errorMessage += "</p>";
      $(currentForm).prepend(errorMessage);
      console.debug("Create new comment or reply is error");
    });
});

// Function to toggle reply form
function toggleReplyForm(formId) {
  var replyForm = document.getElementById(formId);
  // class "dn" is utility from tachyons
  // https://tachyons.io/docs/layout/display/
  if (
    replyForm.style.display === "none" ||
    replyForm.classList.contains("dn")
  ) {
    replyForm.style.display = "block";
    if (replyForm.classList.contains("dn")) {
      replyForm.classList.remove("dn");
    }
  } else {
    replyForm.style.display = "none";
  }
}

// Function to expand or collapse comment
function expandOrCollapseComment(button, commentDataId) {
  var commentData = document.getElementById(commentDataId);
  // class "dn" is utility from tachyons
  // https://tachyons.io/docs/layout/display/
  if (
    commentData.style.display === "none" ||
    commentData.classList.contains("dn")
  ) {
    commentData.style.display = "block";
    button.text = "[ - ]";
    if (commentData.classList.contains("dn")) {
      commentData.classList.remove("dn");
    }
  } else {
    commentData.style.display = "none";
    button.text = "[ + ]";
  }
}

// Import all dependencies
//= require jquery
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
});

// Function to toggle reply form
function toggleReplyForm(formId) {
  var replyForm = document.getElementById(formId);
  if (replyForm.style.display === "none") {
    replyForm.style.display = "block";
  } else {
    replyForm.style.display = "none";
  }
}

// Function to expand or collapse comment
function expandOrCollapseComment(button, commentDataId) {
  var commentData = document.getElementById(commentDataId);
  if (commentData.style.display === "none") {
    commentData.style.display = "block";
    button.text = "[ - ]";
  } else {
    commentData.style.display = "none";
    button.text = "[ + ]";
  }
}

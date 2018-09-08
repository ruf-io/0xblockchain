function onSaveStorySuccess(event) {
  // Get the JSON response from server and parse it as
  // javascript object
  var serverResponse = JSON.parse(event.detail[2].responseText);
  // Get the error status
  var isError = serverResponse.is_error;
  // Get the error message
  var errorMessage = serverResponse.error_msg;
  // Get the story short id
  var storyShortId = serverResponse.story_short_id;
  // Get the save and unsave link
  // We use this to swtich the state
  var saveStoryLink = document.getElementById("save_story_" + storyShortId);
  var unsaveStoryLink = document.getElementById("unsave_story_" + storyShortId);

  // Handle the response
  if (isError) {
    // Display error
    // Get message placeholder
    var errorPlaceholder = document.getElementById("ajax-messages-placeholder");
    var message = '<p class="error-color">' + errorMessage + "</p>";
    errorPlaceholder.insertAdjacentHTML("afterbegin", message);
  } else {
    // Otherwise change the state to unsave link
    saveStoryLink.className += " dn";
    unsaveStoryLink.classList.remove("dn");
  }
}

// Handle error when upvote
function onSaveStoryError(event) {
  // Display error
  // Get message placeholder
  var errorPlaceholder = document.getElementById("ajax-messages-placeholder");
  var message = '<p class="error-color">Failed to save the story.</p>';
  errorPlaceholder.insertAdjacentHTML("afterbegin", message);
}

function onUnsaveStorySuccess(event) {
  // Get the JSON response from server and parse it as
  // javascript object
  var serverResponse = JSON.parse(event.detail[2].responseText);
  // Get the error status
  var isError = serverResponse.is_error;
  // Get the error message
  var errorMessage = serverResponse.error_msg;
  // Get the story short id
  var storyShortId = serverResponse.story_short_id;
  // Get the save and unsave link
  // We use this to swtich the state
  var saveStoryLink = document.getElementById("save_story_" + storyShortId);
  var unsaveStoryLink = document.getElementById("unsave_story_" + storyShortId);
  // Handle the response
  if (isError) {
    // Display error
    // Get message placeholder
    var errorPlaceholder = document.getElementById("ajax-messages-placeholder");
    var message = '<p class="error-color">' + errorMessage + "</p>";
    errorPlaceholder.insertAdjacentHTML("afterbegin", message);
  } else {
    // Otherwise change the state to unvote button
    unsaveStoryLink.className += " dn";
    saveStoryLink.classList.remove("dn");
  }
}

// Handle error when unsave
function onUnsaveStoryError(event) {
  // Display error
  // Get message placeholder
  var errorPlaceholder = document.getElementById("ajax-messages-placeholder");
  var message = '<p class="error-color">Failed to unsave the story.</p>';
  errorPlaceholder.insertAdjacentHTML("afterbegin", message);
}

document.addEventListener("DOMContentLoaded", function() {
  // Install upvote mechanism
  var saveStoryLinks = document.getElementsByClassName("save_story");
  for (var i = 0; i < saveStoryLinks.length; i++) {
    var saveStoryLink = saveStoryLinks[i];
    saveStoryLink.addEventListener("ajax:success", onSaveStorySuccess);
    saveStoryLink.addEventListener("ajax:error", onSaveStoryError);
  }
  // Install unvote mechanism
  var unsaveStoryLinks = document.getElementsByClassName("unsave_story");
  for (var i = 0; i < unsaveStoryLinks.length; i++) {
    var unsaveStoryLink = unsaveStoryLinks[i];
    unsaveStoryLink.addEventListener("ajax:success", onUnsaveStorySuccess);
    unsaveStoryLink.addEventListener("ajax:error", onUnsaveStoryError);
  }
});

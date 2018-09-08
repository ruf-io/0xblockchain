function onUpvoteSuccess(event) {
  // Get the JSON response from server and parse it as
  // javascript object
  var serverResponse = JSON.parse(event.detail[2].responseText);
  // Get the error status
  var isError = serverResponse.is_error;
  // Get the error message
  var errorMessage = serverResponse.error_msg;
  // Get the story short id
  var storyShortId = serverResponse.story_short_id;
  // Get the upvote and unvote button
  // We use this to swtich the state
  var upvoteButton = document.getElementById("upvote_story_" + storyShortId);
  var unvoteButton = document.getElementById("unvote_story_" + storyShortId);
  // Get the points
  var spanStoryPoint = document.getElementById(
    "current_story_point_" + storyShortId
  );
  var currentPoint = Number(spanStoryPoint.getAttribute("data-value"));

  // Handle the response
  if (isError) {
    // Display error
    // Get message placeholder
    var errorPlaceholder = document.getElementById("ajax-messages-placeholder");
    var message = '<p class="error-color">' + errorMessage + "</p>";
    errorPlaceholder.insertAdjacentHTML("afterbegin", message);
  } else {
    // Otherwise change the state to unvote button
    upvoteButton.className += " dn";
    unvoteButton.classList.remove("dn");

    // Then update the point
    currentPoint += 1;
    spanStoryPoint.setAttribute("data-value", currentPoint);
    if (currentPoint >= 2) {
      spanStoryPoint.innerText = currentPoint + " points";
    } else {
      spanStoryPoint.innerText = currentPoint + " point";
    }
  }
}

// Handle error when upvote
function onUpvoteError(event) {
  // Display error
  // Get message placeholder
  var errorPlaceholder = document.getElementById("ajax-messages-placeholder");
  var message = '<p class="error-color">Failed to upvote the story.</p>';
  errorPlaceholder.insertAdjacentHTML("afterbegin", message);
}

function onUnvoteSuccess(event) {
  // Get the JSON response from server and parse it as
  // javascript object
  var serverResponse = JSON.parse(event.detail[2].responseText);
  // Get the error status
  var isError = serverResponse.is_error;
  // Get the error message
  var errorMessage = serverResponse.error_msg;
  // Get the story short id
  var storyShortId = serverResponse.story_short_id;
  // Get the upvote and unvote button
  // We use this to swtich the state
  var upvoteButton = document.getElementById("upvote_story_" + storyShortId);
  var unvoteButton = document.getElementById("unvote_story_" + storyShortId);
  // Get the points
  var spanStoryPoint = document.getElementById(
    "current_story_point_" + storyShortId
  );
  var currentPoint = Number(spanStoryPoint.getAttribute("data-value"));

  // Handle the response
  if (isError) {
    // Display error
    // Get message placeholder
    var errorPlaceholder = document.getElementById("ajax-messages-placeholder");
    var message = '<p class="error-color">' + errorMessage + "</p>";
    errorPlaceholder.insertAdjacentHTML("afterbegin", message);
  } else {
    // Otherwise change the state to unvote button
    unvoteButton.className += " dn";
    upvoteButton.classList.remove("dn");

    // Then update the point
    currentPoint -= 1;
    spanStoryPoint.setAttribute("data-value", currentPoint);
    if (currentPoint >= 2) {
      spanStoryPoint.innerText = currentPoint + " points";
      console.log(spanStoryPoint);
    } else {
      spanStoryPoint.innerText = currentPoint + " point";
    }
  }
}

// Handle error when unvote
function onUnvoteError(event) {
  // Display error
  // Get message placeholder
  var errorPlaceholder = document.getElementById("ajax-messages-placeholder");
  var message = '<p class="error-color">Failed to unvote the story.</p>';
  errorPlaceholder.insertAdjacentHTML("afterbegin", message);
}

document.addEventListener("DOMContentLoaded", function() {
  // Install upvote mechanism
  var upvoteButtons = document.getElementsByClassName("upvote_story");
  for (var i = 0; i < upvoteButtons.length; i++) {
    var upvoteButton = upvoteButtons[i];
    upvoteButton.addEventListener("ajax:success", onUpvoteSuccess);
    upvoteButton.addEventListener("ajax:error", onUpvoteError);
  }
  // Install unvote mechanism
  var unvoteButtons = document.getElementsByClassName("unvote_story");
  for (var i = 0; i < unvoteButtons.length; i++) {
    var unvoteButton = unvoteButtons[i];
    unvoteButton.addEventListener("ajax:success", onUnvoteSuccess);
    unvoteButton.addEventListener("ajax:error", onUnvoteError);
  }
});

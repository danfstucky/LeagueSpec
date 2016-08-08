function validateSummonerField() {
  //var id = 'summoner_name'
  $(".email").hide();
  return fieldValidation('#summoner_name');
};
function validateEmailField() {
  //var id = '#summoner_email'
  return fieldValidation('#summoner_email');
};
function fieldValidation(id) {
  clearFeedback()
  var fieldText = $(id).val();
  if (fieldText.length <3 || fieldText.length > 24){
    $(id+"_feedback").text("Required field, character length between 3 and 24.");
    $(id+"_feedback").show();
    return false;
  }
  if (id === '#summoner_email' ) {
    VALID_EMAIL_REGEX = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
    if( !VALID_EMAIL_REGEX.test(fieldText) ) {
      $(id+"_feedback").text("Invalid email pattern, correct input and try again.");
      $(id+"_feedback").show();
      return false;
    }
    if ($('#summoner_name').val() < 3 || $('#summoner_name').val() > 24){
      $('#summoner_name_feedback').text("Required field, character length between 3 and 24.");
      $('#summoner_name_feedback').show();
      $("#send-btn").hide();
      return false;
    }
  }
  $(id+"_feedback").text("Looking good...Click button below to search when ready.");
    $(id+"_feedback").css("color","green");
    $(id+"_feedback").show();
    if (id === '#summoner_name') {
      $("#sbmt-btn").show();
    }
    else {
      $("#send-btn").show();
    }
  return true;
}

function clearFeedback() {
  $("#summoner_name_feedback").text("");
  $("#summoner_email_feedback").text("");
  $("#sbmt-btn").hide();
  $("#send-btn").hide();
}

function resetPlaceHolders() {
  $('#summoner_email').val('');
  $('#summoner_email').attr('placeholder', 'Summoner Email');
}

var get_search_feedback = function() {
  $('#search-summoner-form').on('ajax:success', function(event, data, status) {
    $('#search-to-invite').replaceWith(data);
    if (gon.summoner) {
      $("#summoner_name_feedback"). css("color","green");
      $(".email").show();
      $("#send-btn").hide();
    }
    if (gon.registeredUser) {
      $(".email").hide();
    }
    $("#summoner_name_feedback").show();
  });
  $('#search-summoner-form').on('ajax:error', function(event, xhr, status, error) {
    $("#sbmt-btn").hide();
    $('#summoner_name_feedback').text('No record found. Verify Summoner name and try again.');
    $("#summoner_name_feedback").show();
  });
}

var prevent_bad_submit = function() {
  $('#search-summoner-form').submit(function(event) { 
    if ( $(".email").css('display') == 'none' ) {
      if (validateSummonerField() === false) {
        event.preventDefault();
        return false;
      }
    }
    else if (validateSummonerField() === false || validateEmailField() === false ) {
      event.preventDefault();
      return false;
    }
    resetPlaceHolders();
  })
  
  $('#email-summoner-form').submit(function(event) { 
    if (validateSummonerField() === false || validateEmailField() === false ) {
      $(".email").show();
      event.preventDefault();
      return false;
    }
    $(".email").show();
  })
}

var validateSummonerFields = function() {
  $('#summoner_name').focus(validateSummonerField);
  $('#summoner_name').keyup(validateSummonerField);
  $('#summoner_email').focus(validateEmailField);
  $('#summoner_email').keyup(validateEmailField);
}

var invite_user_setup = function() {
  $("#sbmt-btn").hide();
  validateSummonerFields();
  prevent_bad_submit();
  get_search_feedback();
}

$(document).ready(function(e) {
  invite_user_setup();
})

$(document).ajaxComplete(function () {
  invite_user_setup();
});
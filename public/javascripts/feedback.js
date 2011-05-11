function feedbackLinkCenter () {
  // Центрируем ссылку по центру высоты экрана
  var windowHeight = $(window).height();
  var linkWidth = $("#feedback-link").width();
  var top = ((windowHeight - linkWidth) / 2 >> 0) + 80;
  $("#feedback-link").css("top", top.toString().concat("px"));
}

function feedbackCenter () {
  // Центрируем ссылку по центру высоты экрана
  var windowHeight = $(window).height();
  var feedbackHeight = $("#feedback").height();
  var windowWidth = $(window).width();
  var feedbackWidth = $("#feedback").width();
  var top = (windowHeight - feedbackHeight) / 2 >> 0;
  var left = (windowWidth - feedbackWidth) / 2 >> 0;
  $("#feedback").css("top", top.toString().concat("px"));
  $("#feedback").css("left", left.toString().concat("px"));
}

function feedbackInit () {
  feedbackLinkCenter();
  feedbackCenter()
  $(window).resize(feedbackLinkCenter);
  $(window).resize(feedbackCenter);
  $("#feedback-link").click(function () {
    $("#shield").show();
    $("#feedback").show();
  });
  $("#feedback-link").mouseover(function () {
    $("#feedback-link").css("left", "-50px");
  });
  $("#feedback-link").mouseout(function () {
    $("#feedback-link").css("left", "-65px");
  });
  $("#feedback-close").click(function () {
    $("#shield").hide();
    $("#feedback").hide();
  });
}

$(document).ready(function () {
  feedbackInit();
});
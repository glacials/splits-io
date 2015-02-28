$(function () {
  window.delete_run = function (run) {
    $("#run_" + run.id).fadeOut(300, function () { $(this).remove(); });
    $.ajax({
      url: "/api/v3/runs/" + run.id,
      type: "DELETE",
      error: function (response) {
        console.log("Run deletion failed with response: " + JSON.stringify(response.responseJSON));
      }
    });
  };
});


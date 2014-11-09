$(function () {
  if (!$("#follows").length) {
    return false;
  }
  $.get("/users/" + gon.user.name + "/follows", function (data, status) {
    if (status == "success") {
      $("#follows").append(data);
    }
  });
});

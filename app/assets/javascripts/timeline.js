$(function () {
  $.each(gon.run.splits, function (i, split) {
    $('#' + gon.run.id + '-split-' + i).each(function (j, el) {
      el.style["z-index"] = i;
      el.style.width = gon.run.splits[i].duration / gon.scale_to * 100 + '%';
    });
  });
  $.each(gon.comparison_run.splits, function (i, split) {
    $('#' + gon.comparison_run.id + '-split-' + i).each(function (j, el) {
      el.style["z-index"] = i;
      el.style.width = gon.comparison_run.splits[i].duration / gon.scale_to * 100 + '%';
    });
  });
});
